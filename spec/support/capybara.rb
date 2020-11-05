require 'capybara'

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu])
	Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)  #trvis ci 設定
  # Capybara::Selenium::Driver.new(app, browser: :chrome) #本地測試時自動開瀏覽器
end

Capybara.javascript_driver = :chrome
