require_relative "../views/sessions_view"

class SessionsController
  def initialize(employee_repository)
    @sessions_view = SessionsView.new
    @employee_repository = employee_repository
  end

  def login
    username = @sessions_view.ask_for(:username)
    password = @sessions_view.ask_for(:password)
    employee = @employee_repository.find_by_username(username)

    if employee && employee.password == password 
      employee
    else
      @sessions_view.print_wrong_credentials
      login()
    end
  end
end
