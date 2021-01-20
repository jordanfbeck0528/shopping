class Market

  attr_reader :name, :vendors, :date

  def initialize(name)
    @name    = name
    @vendors = []
    @date    = Date.today
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

  def all_items
    @vendors.flat_map do |vendor|
      vendor.inventory.keys
    end.uniq
  end

  def quantity_of_item(item)
    @vendors.sum do |vendor|
      vendor.inventory[item]
    end
  end

  def total_inventory
    total_hash = {}
    all_items.each do |item|
      total_hash[item] = {
        quantity: quantity_of_item(item),
        vendors: vendors_that_sell(item)
      }
    end
    total_hash
  end

  def overstocked_items
    all_items.find_all do |item|
      item if quantity_of_item(item) > 50 && vendors_that_sell(item).count > 1
    end
  end

  def sorted_item_list
    all_items.map(&:name).sort
  end

  def sell(item, quantity)
    left_to_sell = []
    vendors_that_sell(item).each do |vendor|
      vendor.inventory.each do |inventory, vendor_quantity|
        false if quantity - quantity_of_item(item) < 0
        true if (vendor_quantity - quantity) > 0
        if (quantity - vendor_quantity) < 0
          left_to_sell << (quantity - vendor_quantity).abs
          vendor_quantity = 0
        elsif (left_to_sell.last.nil? && left_to_sell.last - vendor_quantity) > 0
          vendor_quantity - left_to_sell.last
          vendor_quantity -= left_to_sell.last
        end
      end
    end
  end
end
