class SessionsView
  def display(employees)
    employees.each_with_index do |employee, index|
      puts "#{index + 1}. #{employee.username}"
    end
  end

  def ask_for(stuff)
    puts "#{stuff}?"
    print "> "
    return gets.chomp
  end

  def print_wrong_credentials
    puts "Wrong credentials... Try again"
  end
end
