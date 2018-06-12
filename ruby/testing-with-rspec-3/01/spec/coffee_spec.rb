RSpec.configure do |config|
  config.filter_run_when_matching(focus: true)
end

class Coffee
  def initialize
    @ingredients ||= []
  end

  def add(ingredient)
    @ingredients << ingredient
  end

  def color
    @ingredients.include?(:milk) ? :light : :dark
  end

  def temperature
    @ingredients.include?(:milk) ? 190.0 : 205.0
  end

  def price
    1.00 + @ingredients.size * 0.25
  end
end

RSpec.describe 'A cup of coffee' do
  let(:coffee) { Coffee.new }

  it 'costs $1' do
    expect(coffee.price).to eq 1.00
  end

  context 'with milk' do
    it 'costs $1.25' do
      expect(coffee.price).to eq 1.25
    end
  end

  it 'is light in color' do
    expect(coffee.color).to be :light
  end

  it 'is cooler than 200 degrees Fahrenheit' do
    expect(coffee.temperature).to be < 200.0
  end
end
