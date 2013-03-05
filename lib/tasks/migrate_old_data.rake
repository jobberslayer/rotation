require 'sqlite3'
require 'highline'

namespace :db do
  namespace :migrate do
    namespace :old do
      desc "Migrate in volunteers from old system."
      task :volunteers => :environment do
        db = SQLite3::Database.new( "db/mydata.rdb" )
        rows = db.execute( "select name, email from volunteers" )
        rows.each do |vol|
          v = Volunteer.new()
          if vol[0] =~ /(.*)\@/
            vol[0] = "Unknown Zzzz"
          end
          v.full_name = vol[0]
          v.email = vol[1]
          if v.save
            puts "imported #{vol[0]} <#{vol[1]}>"
          else
            puts
            puts "Problem importing volunteer #{vol[0]} <#{vol[1]}>"
            puts v.errors.full_messages
          end
        end
      end

      desc "Nuke Voluteer data."
      task :nuke_volunteers => :environment do
        nukeem(Volunteer)
      end

      desc "Migrate in volunteers from old system."
      task :groups => :environment do
        db = SQLite3::Database.new( "db/mydata.rdb" )
        rows = db.execute( "select name, email, has_rotation from rotations" )
        rows.each do |rot|
          g = Group.new()          
          g.name = rot[0]
          g.email = rot[1]
          g.rotation = rot[2]
          if g.save
            puts "imported #{rot[0]} <#{rot[1]}>"
          else
            puts
            puts "Problem importing group #{rot[0]} <#{rot[1]}>"
            puts g.errors.full_messages
          end
        end
      end

      desc "Nuke Group data."
      task :nuke_groups => :environment do
        nukeem(Group)
      end

      desc "Migrate in relationships betwee volunteers and groups from old system."
      task :vol_group_relations => :environment do
        db = SQLite3::Database.new( "db/mydata.rdb" )
        rows = db.execute(" 
          select v.email, r.name from volunteers v 
          join rotation_vols rv on v.id = volunteer_id 
          join rotations r on r.id = rv.rotation_id 
          where on_rotation = 1
        ")

        rows.each do |row|
          vol = Volunteer.find_by_email(row[0].downcase)
          group = Group.find_by_name(row[1])
          puts "Trying #{row[0].downcase} into #{row[1]}"
          vol.joined!(group)
          if vol.save
            puts "imported #{row[0].downcase} to group #{row[1]}"
          else
            puts
            puts "Problem adding vol #{row[0].downcase} group #{row[1]}"
            puts vol.errors.full_messages
          end
        end
      end

      desc "Nuke Volunteer/Group relationship data."
      task :nuke_vol_group_relations => :environment do
        nukeem(VolGroupRelationship)
      end

      def nukeem(obj)
        ui = HighLine.new
        ask = ui.ask("You sure you want to nuke all data in the #{obj} table? (y/n): ")
        if (ask == 'y')
          obj.delete_all()
          puts "NUKED'EM!!!!"
        else
          puts "Ok, did NOT nuke the table"
        end
      end
    end
  end
end