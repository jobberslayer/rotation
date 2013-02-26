FactoryGirl.define do
  factory :user do
    first_name            "Me"
    last_name             "User"
    user_name             "me"
    email                 "me@example.com"
    password              "foobar"
    password_confirmation "foobar"
  end

  factory :volunteer do
    first_name  "Joe"
    last_name   "Volunteer"
    email       "joe_vol@example.com"
  end

  factory :group do
    name   "Greeters" 
    email  "greeters@example.com"
  end
end