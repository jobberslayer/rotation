FactoryGirl.define do
  factory :user do
    first_name            "Me"
    last_name             "User"
    user_name             "me"
    email                 "me@example.com"
    password              "foobar"
    password_confirmation "foobar"
  end
end