class Router
  def initialize(meals_controller, customers_controller, sessions_controller, orders_controller)
    @meals_controller = meals_controller
    @customers_controller = customers_controller
    @sessions_controller = sessions_controller
    @orders_controller = orders_controller
    @running = true
  end

  def run
    while @running
      @current_user = @sessions_controller.login

      while @current_user
        if @current_user.manager?
          route_manager_action()
        else
          route_delivery_guy_action()
        end
      end
    end
  end

  def route_manager_action
    print_manager_menu()
    choice = gets.chomp.to_i
    print `clear`
    manager_action(choice)
  end

  def route_delivery_guy_action
    print_delivery_guy_menu()
    choice = gets.chomp.to_i
    print `clear`
    delivery_guy_action(choice)
  end

  private

  def print_manager_menu
    puts "--------------------"
    puts "------- MENU -------"
    puts "--------------------"
    puts "1. Add new meal"
    puts "2. List all meals"
    puts "3. Add new customer"
    puts "4. List all customers"
    puts "5. Add new order"
    puts "6. List all undelivered orders"
    general_options
  end

  def print_delivery_guy_menu
    puts "--------------------"
    puts "------- MENU -------"
    puts "--------------------"
    puts "1. List my undelivered orders"
    puts "2. Mark order as delivered"
    general_options
  end

  def general_options
    puts "8. Exit"
    puts "9. Logout"
    print "> "
  end

  def manager_action(choice)
    case choice
    when 1 then @meals_controller.add
    when 2 then @meals_controller.list
    when 3 then @customers_controller.add
    when 4 then @customers_controller.list
    when 5 then @orders_controller.add
    when 6 then @orders_controller.list_undeliverd_orders
    when 8 then stop!
    when 9 then logout!
    else puts "Try again..."
    end
  end

  def delivery_guy_action(choice)
    case choice
    when 1 then @orders_controller.list_my_orders(@current_user)
    when 2 then @orders_controller.mark_as_delivered(@current_user)
    when 8 then stop!
    when 9 then logout!
    else puts "Try again..."
    end
  end

  def stop!
    @running = false
  end

  def logout!
    @current_user = nil
  end
end
