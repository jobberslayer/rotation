require 'highline'

namespace :rotation do
  namespace :emails do
    namespace :smtp do
      desc "Set up smtp configuration and from email information."
      task :setup => :environment do
        ui = HighLine.new
        
        host = ui.ask("SMTP Host: ")
        port = ui.ask("SMTP Port: ") 
        uname = ui.ask("User Name: ")
        password  = ui.ask("Enter password: ") { |q| q.echo = false }

        Configuration.set_smtp_host(host)
        Configuration.set_smtp_port(port)
        Configuration.set_smtp_user_name(uname)
        Configuration.set_smtp_password(password)
      end
    end

    namespace :from do
      desc "Set up from address information."
      task :setup => :environment do
        ui = HighLine.new
        
        name = ui.ask("From Name: ")
        address = ui.ask("From Address: ") 

        Configuration.set_from_name(name)
        Configuration.set_from_email(address)
      end
    end

    desc "Send out all group emails for the next Sunday."
    task :send => :environment do
    end
  end
end
