def valid_signin(user)
  fill_in "User name",    with: user.user_name
  fill_in "Password",     with: user.password
  click_button "Sign in"
end

def sign_in(user)
  visit signin_path
  fill_in "User name",    with: user.user_name
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :redirect_to_signin do
  match do |page|
    current_path.should eq signin_path
    page.should have_notice_message "Please sign in."
  end

  failure_message_for_should do |obj|
    "should redirect to sign in screen, not #{current_path}"
  end

  failure_message_for_should_not do |obj|
    "should not redirect to sign in screen"
  end
end
  
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_notice_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-notice', text: message)
  end
end
