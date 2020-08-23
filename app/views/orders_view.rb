class OrdersView
  def display(orders)
    orders.each_with_index do |order, index|
      puts "#{index + 1} - #{order.employee.username} must deliver #{order.meal.name} to #{order.customer.name}"
    end
  end

  def ask_user_for_index
    puts "Wich index?"
    print "> "
    gets.chomp.to_i - 1
  end
end