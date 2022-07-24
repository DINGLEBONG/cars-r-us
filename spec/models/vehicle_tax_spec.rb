require 'rails_helper'

RSpec.describe VehicleTax, type: :model do
  petrol_vehicle_tax = VehicleTax.new(stock_type: :new, fuel_type: :petrol, co2: 123, commercial_vehicle: false)
  electric_vehicle_tax = VehicleTax.new(stock_type: :new, fuel_type: :electric, co2: 80, commercial_vehicle: false)
  commercial_vehicle_tax = VehicleTax.new(stock_type: :new, fuel_type: :petrol, co2: 999, commercial_vehicle: true)
  used_vehicle_tax = VehicleTax.new(stock_type: :used, fuel_type: :petrol, co2: 999, commercial_vehicle: true)
  another_used_vehicle_tax = VehicleTax.new(stock_type: :used, fuel_type: :petrol, co2: 999, commercial_vehicle: true)

  describe '#amount' do
    it 'calculates vehicle tax for petrol_or_diesel vehicles' do
      expect(petrol_vehicle_tax.amount).to eq(245)
    end

    it 'calculates vehicle tax for alternative_fuel vehicles' do
      expect(electric_vehicle_tax.amount).to eq(165)
    end

    it 'calculates vehicle tax for commercial vehicles' do
      expect(commercial_vehicle_tax.amount).to eq(345)
    end

    it 'returns no vehicle tax for used vehicles' do
      expect(used_vehicle_tax.amount).to eq(0)
    end
  end

  describe '#to_s' do
    it 'returns the vehicle tax prefixed with a pound sign' do
      expect(petrol_vehicle_tax.to_s).to eq('£245')
    end
  end

  describe '#==' do
    it 'identifies equal vehicle taxes' do
      expect(used_vehicle_tax == another_used_vehicle_tax).to eq(true)
    end

    it 'identifies differing vehicle taxes' do
      expect(used_vehicle_tax == petrol_vehicle_tax).to eq(false)
    end
  end

  describe '#eql?' do
    it 'identifies equal vehicle taxes' do
      expect(used_vehicle_tax.eql?(another_used_vehicle_tax)).to eq(true)
    end

    it 'identifies differing vehicle taxes' do
      expect(used_vehicle_tax.eql?(petrol_vehicle_tax)).to eq(false)
    end
  end
end
