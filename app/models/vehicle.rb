class Vehicle < ApplicationRecord

  enum stock_type: { new: 'new', used: 'used' }, _prefix: true
  enum fuel_type: { electric: 'electric', hybrid: 'hybrid', petrol: 'petrol', diesel: 'diesel' }

  validates :stock_type, presence: true
  validates :fuel_type, presence: true
  validates :commercial_vehicle, inclusion: [true, false]
  validates :vehicle_tax, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  before_validation :set_vehicle_tax

  private

  def set_vehicle_tax
    # Note this will recalculate vehicle_tax every time a vehicle is created/updated. 
    # This would be redundant most of the time. It's only necessary to calculate on creation or when the tax rates have been changed.
    # I have used '=' in place of '||=' because the task description is explicit about this.
    # In real life you might instead use '||=' and have a separate job to recalculate vehicle_tax which a dev could trigger whenever they modify the rates.
    self.vehicle_tax = VehicleTax.new(stock_type: stock_type, fuel_type: fuel_type, co2: co2, commercial_vehicle: commercial_vehicle).amount
  end

  # ...
  # 100s of lines of code deleted, as they are not relevant to this task
  # but if they were included this would be a big model
  # ...

end
