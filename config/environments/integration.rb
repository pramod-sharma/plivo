# inherit the test.rb config values
load(Rails.root.join("config", "environments", "test.rb"))

YourApp::Application.configure do
  # integration-specific overrides can go here
end