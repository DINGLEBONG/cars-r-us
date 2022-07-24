class VehicleTax
  # SOURCE: https://www.gov.uk/vehicle-tax-rate-tables 24/07/2022.
  NON_COMMERCIAL_TAX_RATES = { # Data for first payments only
    '0':            { petrol_or_diesel: 0,    alternative_fuel: 0 },
    '1_to_50':      { petrol_or_diesel: 10,   alternative_fuel: 0 },
    '51_to_75':     { petrol_or_diesel: 25,   alternative_fuel: 15 },
    '76_to_90':     { petrol_or_diesel: 120,  alternative_fuel: 110 },
    '91_to_100':    { petrol_or_diesel: 150,  alternative_fuel: 140 },
    '101_to_110':   { petrol_or_diesel: 170,  alternative_fuel: 160 },
    '111_to_130':   { petrol_or_diesel: 190,  alternative_fuel: 180 },
    '131_to_150':   { petrol_or_diesel: 230,  alternative_fuel: 220 },
    '151_to_170':   { petrol_or_diesel: 585,  alternative_fuel: 575 },
    '171_to_190':   { petrol_or_diesel: 945,  alternative_fuel: 935 },
    '191_to_225':   { petrol_or_diesel: 1420, alternative_fuel: 1410 },
    '226_to_255':   { petrol_or_diesel: 2015, alternative_fuel: 2005 },
    '255_and_over': { petrol_or_diesel: 2365, alternative_fuel: 2355 }
  }

  # SOURCE: https://www.gov.uk/vehicle-tax-rate-tables/other-vehicle-tax-rates 24/07/2022.
  COMMERCIAL_LGV_TAX = 290 # Assuming single annual payment
  COMMERCIAL_ELEC_HYBRID_TAX = 0

  attr_reader :stock_type, :fuel_type, :co2, :commercial_vehicle

  def initialize(stock_type:, fuel_type:, co2:, commercial_vehicle:)
    @stock_type = stock_type.to_sym
    @fuel_type = fuel_type.to_sym
    @co2 = co2
    @commercial_vehicle = commercial_vehicle
  end

  def ==(other_vehicle_tax)
    stock_type == other_vehicle_tax.stock_type &&
    fuel_type == other_vehicle_tax.fuel_type &&
    co2 == other_vehicle_tax.co2 &&
    commercial_vehicle == other_vehicle_tax.commercial_vehicle
  end

  alias eql? ==

  def to_s
    "£#{amount}"
  end

  def amount
    @amount ||= calculate_tax_amount
  end

  private

  def calculate_tax_amount
    return 0 if stock_type == :used # Used vehicles are sold without any tax

    amount = 55 # All new vehicles are subject to a £55 registration fee which must also be included.
    if commercial_vehicle && fuel_type.in?(['hybrid', 'electric'])
      amount += COMMERCIAL_ELEC_HYBRID_TAX
    elsif commercial_vehicle
      amount += COMMERCIAL_LGV_TAX      
    else
      amount += NON_COMMERCIAL_TAX_RATES[tax_key][fuel_key]
    end
    amount
  end

  def tax_key
    return nil if commercial_vehicle # TODO: Raise error instead

    # NON_COMMERCIAL_TAX_RATE keys deliberately structured so the tax rate lower bound can be easily extracted in key_lower_bound below
    key_lower_bound = proc { |key| [key.to_s.split(/_/, 2).first.to_i, key] }
    tax_keys_by_lower_bound = NON_COMMERCIAL_TAX_RATES.keys.map(&key_lower_bound).to_h
    # find the highest key_lower_bound <= c02
    lower_bound_for_car = tax_keys_by_lower_bound.keys.reject { |k| k > co2 }.last
    tax_keys_by_lower_bound[lower_bound_for_car]
  end

  def fuel_key
    fuel_type.in?([:petrol, :diesel]) ? :petrol_or_diesel : :alternative_fuel
  end
end
