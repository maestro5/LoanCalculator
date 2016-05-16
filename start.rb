require_relative './app/app'

app = App.new ARGV

unless app.method_valid?
  if app.bad_command?
    puts app.available_methods + app.command_example
    abort
  else
    app.receive_valid_method
  end
end

app.loan_create!
app.loan.count!
app.loan.show
