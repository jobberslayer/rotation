namespace :email do
  namespace :send do
    desc 'Send out all group emails for next Sunday.'
    task :groups => :environment do
      groups = Group.where(rotation: true)
      groups.each do |g|
        RotationMailer.group_email(g).deliver
      end 
    end

    desc 'Send out reminder email to admins to check changes if need be.'
    task :changes => :environment do
      changes_made = false
      groups = Group.all
      groups.each do |g|
        if !g.volunteers_changed_since(LastSync.get.utc).empty?
          puts "changes to #{g.name}"
          changes_made = true
          break
        end
      end

      if changes_made
        RotationMailer.changes_email.deliver
      end
    end
  end
end
