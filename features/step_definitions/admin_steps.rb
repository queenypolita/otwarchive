Given /^I have an AdminSetting$/ do
  unless AdminSetting.first
    settings = AdminSetting.new(
      :invite_from_queue_enabled => ArchiveConfig.INVITE_FROM_QUEUE_ENABLED,
      :invite_from_queue_number => ArchiveConfig.INVITE_FROM_QUEUE_NUMBER,
      :invite_from_queue_frequency => ArchiveConfig.INVITE_FROM_QUEUE_FREQUENCY,
      :account_creation_enabled => ArchiveConfig.ACCOUNT_CREATION_ENABLED,
      :days_to_purge_unactivated => ArchiveConfig.DAYS_TO_PURGE_UNACTIVATED)
    settings.save(:validate => false)
  end
end

When /^the invite_from_queue_at is yesterday$/ do
  AdminSetting.first.update_attribute(:invite_from_queue_at, Time.now - 1.day)
end

When /^the check_queue rake task is run$/ do
  AdminSetting.check_queue
end

Given /the following admins? exists?/ do |table|
  table.hashes.each do |hash|
    admin = Factory.create(:admin, hash)
  end
end

Given /^I am logged in as an admin$/ do
  Given "I am logged out"
  admin = Admin.find_by_login("testadmin")
  if admin.blank?
    admin = Factory.create(:admin, :login => "testadmin", :password => "testadmin", :email => "testadmin@example.org")
  end
  visit admin_login_path
  fill_in "Admin user name", :with => "testadmin"
  fill_in "Admin password", :with => "testadmin"
  click_button "Log in as admin"
  Then "I should see \"Successfully logged in\""
end

Given /^I am logged out as an admin$/ do
  visit admin_logout_path
  assert !AdminSession.find
end

Given /^basic languages$/ do
  Language.default
  Language.find_or_create_by_short_and_name("DE", "Deutsch")
end

Given /^advanced languages$/ do
  Language.find_or_create_by_short_and_name("FR", "Francais")
end

Given /^guest downloading is off$/ do
  Given "I am logged in as an admin"
  And "I follow \"settings\""
  And "I check \"Turn off downloading for guests\""
  And "I press \"Update\""
end

Given /^guest downloading is on$/ do
  Given "I am logged in as an admin"
  And "I follow \"settings\""
  And "I uncheck \"Turn off downloading for guests\""
  And "I press \"Update\""
end

Given /^tag wrangling is off$/ do
  Given "I am logged in as an admin"
  And "I follow \"settings\""
  And "I check \"Turn off tag wrangling for non-admins\""
  And "I press \"Update\""
  And "I am logged out as an admin"
end

Given /^tag wrangling is on$/ do
  Given "I am logged in as an admin"
  And "I follow \"settings\""
  And "I uncheck \"Turn off tag wrangling for non-admins\""
  And "I press \"Update\""
  And "I am logged out as an admin"
end

When /^I make an admin post$/ do
  visit new_admin_post_path
  fill_in("Title", :with => "Default Admin Post")
  fill_in("content", :with => "Content of the admin post.")
  click_button("Post")
  Then %{I should see "AdminPost was successfully created."}
end
