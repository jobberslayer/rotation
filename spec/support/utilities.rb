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
  failure_message_for_should do |obj|
    alert_fail_message(obj, message, 'error', false)
  end

  failure_message_for_should_not do |obj|
    alert_fail_message(obj, message, 'error', true)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
  failure_message_for_should do |obj|
    alert_fail_message(obj, message, 'success', false)
  end

  failure_message_for_should_not do |obj|
    alert_fail_message(obj, message, 'success', true)
  end
end

RSpec::Matchers.define :have_notice_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-notice', text: message)
  end
  failure_message_for_should do |obj|
    alert_fail_message(obj, message, 'notice', false)
  end

  failure_message_for_should_not do |obj|
    alert_fail_message(obj, message, 'notice', true)
  end
end

def alert_fail_message(page, message, type, yes_not)
  if page.has_selector?(".alert.alert-#{type}")
    alert_div = page.find(".alert.alert-#{type}")
    "Should#{' not' if yes_not} have #{type} message [#{message}] in  [#{alert_div.text}]"
  else
    "Should#{' not' if yes_not} have #{type} message [#{message}], but it is empty."
  end  
end
