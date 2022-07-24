require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  petrol_vehicle = Vehicle.new(stock_type: :new, fuel_type: :petrol, co2: 123, commercial_vehicle: false)
  electric_vehicle = Vehicle.new(stock_type: :new, fuel_type: :electric, co2: 80, commercial_vehicle: false)
  commercial_vehicle = Vehicle.new(stock_type: :new, fuel_type: :petrol, co2: 999, commercial_vehicle: true)
  used_vehicle = Vehicle.new(stock_type: :used, fuel_type: :petrol, co2: 200, commercial_vehicle: false)

  it 'works' do
    expect(electric_vehicle.stock_type_new?).to be true
  end

  describe '#set_vehicle_tax' do
    # More thoroughly covered in vehicle_tax_spec.rb.
    # Testing private method? TODO: Consider removing
    it 'calculates vehicle tax' do
      expect(petrol_vehicle.send(:set_vehicle_tax)).to eq(245)
      expect(electric_vehicle.send(:set_vehicle_tax)).to eq(165)
      expect(commercial_vehicle.send(:set_vehicle_tax)).to eq(345)
      expect(used_vehicle.send(:set_vehicle_tax)).to eq(0)
    end    
  end
end
