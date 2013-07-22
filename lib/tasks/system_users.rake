require 'highline'
namespace :db do
  namespace :setup do
    # desc "create default admin user"
    # task :admin => :environment do
    #   admin = User.create(
    #     uname: "admin", 
    #     fname: "Admin",
    #     lname: "User",
    #     email: "kevin@e-kevin.com", 
    #     password: "adminadmin", 
    #     password_confirmation: "adminadmin"
    #   )
    #   if admin.save 
    #     puts "Admin account created"
    #   else
    #     puts
    #     puts "Problem creating admin account:"
    #     puts admin.errors.full_messages
    #   end
    # end  
    
    desc "Create user accounts with rake, prompting for user name and password."
    task :user => :environment do
      ui = HighLine.new
      fname     = ui.ask("First name: ")
      lname     = ui.ask("Last name: ")
      uname     = ui.ask("User name:")
      email     = ui.ask("Email: ")
      password  = ui.ask("Enter password: ") { |q| q.echo = false }
      confirm   = ui.ask("Confirm password: ") { |q| q.echo = false }
      
      user = User.new(
          first_name: fname, 
          last_name: lname, 
          email: email, 
          user_name: uname, 
          password: password, 
          password_confirmation: confirm
      )
      if user.save 
        puts "User account '#{uname}' created."
      else
        puts
        puts "Problem creating user account:"
        puts user.errors.full_messages
      end
    end
		desc "Reset user password"
    task :reset => :environment do
      ui = HighLine.new
      username = ui.ask("User name:")
      password  = ui.ask("Enter password: ") { |q| q.echo = false }
      confirm   = ui.ask("Confirm password: ") { |q| q.echo = false }
      
      user = User.find_by_user_name(username)
      user.password = password
      user.password_confirmation = confirm
      user.save
		end

  end
end
