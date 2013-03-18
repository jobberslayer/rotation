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
