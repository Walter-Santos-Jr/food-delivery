class Order
  attr_accessor :id, :employee
  attr_reader :meal, :customer, :delivered

  def initialize(attrs = {})
    @id = attrs[:id]
    @meal = attrs[:meal]
    @customer = attrs[:customer]
    @employee = attrs[:employee]
    @delivered = attrs[:delivered] || false
  end

  def delivered?
    @delivered
  end

  def deliver!
    @delivered = true
  end
end