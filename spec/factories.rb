FactoryGirl.define do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email     = Faker::Internet.email "#{first_name} #{last_name}"
  user_name = Faker::Internet.user_name "#{first_name} #{last_name}"
  factory :user do
    first_name            first_name
    last_name             last_name
    user_name             user_name
    email                 email
    password              "foobar"
    #incase we pass in custom password
    password_confirmation { |u| u.password }
  end

  first_name = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  email      = Faker::Internet.email "#{first_name} #{last_name}" 
  factory :volunteer do
    first_name  first_name
    last_name   last_name
    email       email
  end

  last_name  = Faker::Name.last_name
  group_name = "#{last_name}'s Group"
  email      = Faker::Internet.email "#{last_name} Group"
  factory :group do
    name   group_name 
    email  "greeters@example.com"
  end
end
