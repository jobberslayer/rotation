FactoryGirl.define do
  factory :user do
    first_name            "A."
    last_name             "User"
    sequence(:user_name)  { |n| "user#{n}" }
    sequence(:email)      { |n| "user#{n}@example.com" }
    password              "foobar"
    #incase we pass in custom password
    password_confirmation { |u| u.password }
  end

  factory :volunteer do
    sequence(:first_name)  { |n| "fname#{n}" }
    sequence(:last_name)   { |n| "lname#{n}" }
    sequence(:email)       { |n| "volunteer#{n}@example.com" }
  end

  factory :group do
    sequence(:name)   { |n| "Group #{n}" } 
    sequence(:email)  { |n| "group#{n}@example.com" }
  end
end
