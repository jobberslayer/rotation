MASTER_DUMP = "#{Rails.root}/tmp/master_list.txt"
COMPARE_DUMP = "#{Rails.root}/tmp/compare_list.txt"
DIFF_DUMP = "#{Rails.root}/tmp/diff_list.txt"

namespace :rotation do
  namespace :email do
    namespace :send do
      desc 'Send out all group emails for next Sunday.'
      task :groups => :environment do
        groups = Group.where(rotation: true)
        groups.each do |g|
          RotationMailer.group_email(g).deliver
        end 
      end
    end
  end

  namespace :changes do
    namespace :master do
      desc 'Create master.'
      task :create => :environment do
        create_dump(MASTER_DUMP)
      end

      desc 'Check to see if changes have been made and email if so.'
      task :diff => :environment do
        create_dump(COMPARE_DUMP)
        %x(diff -y #{MASTER_DUMP} #{COMPARE_DUMP} > #{DIFF_DUMP})

        if File.size(DIFF_DUMP) > 0
          RotationMailer.changes_email(DIFF_DUMP).deliver          
        end
      end
    end
  end

  def create_dump(file_name)
    File.open(file_name, "w") do |f|
      groups = Group.all
      groups.each do |g|
        #f.write "-"*60 + "\n"  
        f.write(g.name + "\n")
        #f.write "-"*60 + "\n"  
        g.volunteers.each do |v|
          f.write(v.full_name)
          f.write(" <" + v.email + ">\n")
        end
      end
    end
  end
end
