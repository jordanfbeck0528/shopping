class Market

  attr_reader :name, :vendors

  def initialize(name)
    @name    = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors.push(vendor)
  end

  def vendor_names
    @vendors.map(&:name)
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor if vendor.inventory.keys.include?(item)
    end
  end
end
