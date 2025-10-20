class Ingredient
  attr_reader :name, :unit, :calories_per_unit

  def initialize(name, unit, calories_per_unit)
    @name = name
    @unit = unit
    @calories_per_unit = calories_per_unit
  end
end

class Recipe
  attr_reader :name, :items

  def initialize(name, items)
    @name = name
    @items = items
  end

  def need
    @items.map do |item|
      qty_base = UnitConverter.to_base(item[:qty], item[:unit])
      {
        name: item[:ingredient].name,
        qty: qty_base,
        unit: UnitConverter.base_unit(item[:unit]),
        calories: qty_base * item[:ingredient].calories_per_unit
      }
    end
  end

  def total_calories
    need.sum { |i| i[:calories] }
  end
end

class Pantry
  def initialize
    @stock = {}
  end

  def add(name, qty, unit)
    qty_base = UnitConverter.to_base(qty, unit)
    unit_base = UnitConverter.base_unit(unit)
    @stock[name] ? @stock[name][:qty] += qty_base : @stock[name] = {qty: qty_base, unit: unit_base}
  end

  def available(name)
    @stock[name] ? @stock[name][:qty] : 0
  end
end

module UnitConverter
  def self.to_base(qty, unit)
    case unit
    when :kg then qty * 1000
    when :g then qty
    when :l then qty * 1000
    when :ml then qty
    when :pcs then qty
    else raise "Unknown unit #{unit}"
    end
  end

  def self.base_unit(unit)
    case unit
    when :kg, :g then :g
    when :l, :ml then :ml
    when :pcs then :pcs
    else raise "Unknown unit #{unit}"
    end
  end
end

class Planner
  def self.plan(recipes, pantry, prices)
    recipes.each do |recipe|
      puts "Recipe: #{recipe.name}"
      total_cal = 0
      total_cost = 0

      recipe.need.each do |item|
        have = pantry.available(item[:name])
        deficit = [item[:qty] - have, 0].max
        total_cal += item[:calories]
        total_cost += deficit * prices[item[:name]]
        puts "#{item[:name]}: need #{item[:qty]}#{item[:unit]} / have #{have}#{item[:unit]} / deficit #{deficit}#{item[:unit]}"
      end

      puts "Recipe calories: #{total_cal.round(2)}, Recipe cost: #{total_cost.round(2)}"
      puts "-" * 30
    end
  end
end

flour = Ingredient.new("flour", :g, 3.64)
milk = Ingredient.new("milk", :ml, 0.06)
egg = Ingredient.new("egg", :pcs, 72)
pasta = Ingredient.new("pasta", :g, 3.5)
sauce = Ingredient.new("sauce", :ml, 0.2)
cheese = Ingredient.new("cheese", :g, 4.0)

pantry = Pantry.new
pantry.add("flour", 1, :kg)
pantry.add("milk", 0.5, :l)
pantry.add("egg", 6, :pcs)
pantry.add("pasta", 300, :g)
pantry.add("cheese", 150, :g)

prices = {
  "flour" => 0.02,
  "milk" => 0.015,
  "egg" => 6.0,
  "pasta" => 0.03,
  "sauce" => 0.025,
  "cheese" => 0.08
}

omelet = Recipe.new("Omelet", [
  {ingredient: egg, qty: 3, unit: :pcs},
  {ingredient: milk, qty: 100, unit: :ml},
  {ingredient: flour, qty: 20, unit: :g}
])

pasta_recipe = Recipe.new("Pasta", [
  {ingredient: pasta, qty: 200, unit: :g},
  {ingredient: sauce, qty: 150, unit: :ml},
  {ingredient: cheese, qty: 50, unit: :g}
])

Planner.plan([omelet, pasta_recipe], pantry, prices)
