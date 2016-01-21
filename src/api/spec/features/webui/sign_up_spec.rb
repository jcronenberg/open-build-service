require "browser_helper"

RSpec.feature "Sign up", :type => :feature do
  let!(:user) { build(:user) }

  scenario "User" do
    visit root_path

    fill_in 'login', with: user.login
    fill_in 'email', with: user.email
    fill_in 'pwd', with: 'alemao'
    click_button('Sign Up')

    expect(page).to have_text("The account '#{user.login}' is now active.")
    assert User.find_by(login: user.login).is_active?
  end

  scenario "User with confirmation" do
    # Configure confirmation for signups
    ::Configuration.stubs(:registration).returns("confirmation")

    visit root_path

    fill_in 'login', with: user.login
    fill_in 'email', with: user.email
    fill_in 'pwd', with: 'alemao'
    click_button('Sign Up')

    expect(page).to have_text("Thank you for signing up! An admin has to confirm your account now. Please be patient.")
  end

  scenario "User is denied" do
    # Deny signups
    ::Configuration.stubs(:registration).returns("deny")

    visit user_register_user_path

    expect(page).to have_text("Sorry, sign up is disabled")
  end
end
