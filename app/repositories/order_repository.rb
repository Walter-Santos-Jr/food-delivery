require "csv"
require_relative "../models/order"

class OrderRepository
  def initialize(csv_file, meal_repository, customer_repository, employee_repository)
    @csv_file = csv_file
    @employee_repository = employee_repository
    @customer_repository = customer_repository
    @meal_repository = meal_repository
    @orders = []
    @next_id = 1
    load_csv if File.exist?(@csv_file) 
  end

  def create(order)
    order.id = @next_id
    @orders << order
    @next_id += 1
    save_to_csv
  end

  def undelivered_orders
    @orders.reject { |order| order.delivered? }
  end

  def my_undelivered_orders(employee)
    @orders.select { |order| !order.delivered? && order.employee == employee }
  end

  def deliver_order(order)
    order.deliver!
    save_to_csv
  end

  private

  def load_csv
    csv_options = {headers: :first_row, header_converters: :symbol}

    CSV.foreach(@csv_file, csv_options) do |row|
      row[:id] = row[:id].to_i
      row[:delivered] = row[:delivered] == "true"
      row[:meal] = @meal_repository.find(row[:meal_id].to_i)
      row[:customer] = @customer_repository.find(row[:customer_id].to_i)
      row[:employee] = @employee_repository.find(row[:employee_id].to_i)
      @orders << Order.new(row)
    end

    @next_id = @orders.last.id + 1 unless @orders.empty?
  end

  def save_to_csv
    CSV.open(@csv_file, "wb") do |csv| 
      csv << %w[id delivered meal_id customer_id employee_id]
      @orders.each do |order|
        csv << [order.id, order.delivered?, order.meal.id, order.customer.id, order.employee.id]
      end
    end
  end
end