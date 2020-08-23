require_relative "../views/orders_view"
require_relative "../views/meals_view"
require_relative "../views/customers_view"
require_relative "../views/sessions_view"

class OrdersController
  def initialize(order_repo, meal_repo, customer_repo, employee_repo)
    @order_repo = order_repo

    @meal_repo = meal_repo
    @meals_view = MealsView.new

    @customer_repo = customer_repo
    @customers_view = CustomersView.new

    @employee_repo = employee_repo
    @sessions_view = SessionsView.new

    @orders_view = OrdersView.new
  end

  def add
    meal = select_meal()
    customer = select_customer()
    employee = select_employee()

    order = Order.new(meal: meal, customer: customer, employee: employee)
    @order_repo.create(order)
  end

  def list_undeliverd_orders
    undelivered_orders = @order_repo.undelivered_orders  
    @orders_view.display(undelivered_orders)
  end

  def list_my_orders(current_user)
    list_my_undelivered_orders(current_user)
  end

  def mark_as_delivered(current_user)
    list_my_undelivered_orders(current_user)
    index = @orders_view.ask_user_for_index
    my_orders =  @order_repo.my_undelivered_orders(current_user)
    order = my_orders[index]
    @order_repo.deliver_order(order)
  end

  private

  def list_my_undelivered_orders(current_user)
    my_undelivered_orders = @order_repo.my_undelivered_orders(current_user)  
    @orders_view.display(my_undelivered_orders)
  end

  def select_meal
    meals = @meal_repo.all
    @meals_view.display(meals)
    index = @orders_view.ask_user_for_index
    return meals[index]
  end

  def select_customer
    customers = @customer_repo.all
    @customers_view.display(customers)
    index = @orders_view.ask_user_for_index
    return customers[index]
  end

  def select_employee
    employees = @employee_repo.all_delivery_guys
    @sessions_view.display(employees)
    index = @orders_view.ask_user_for_index
    return employees[index]
  end
end