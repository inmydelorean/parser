class Parser
  require 'capybara'
  require 'selenium-webdriver'
  require 'csv'

  def initialize
    config
    log_in
    get_names
    write_to_csv
  end

  def config
    Capybara.register_driver(:selenium_chrome_headless) do |app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    end

    Capybara.app_host = 'https://www.chess.com/'
    @session = Capybara::Session.new(:selenium_chrome_headless)
  end

  def log_in
    @session.visit('/login_and_go/')
    @session.fill_in 'username', with: credentials[:username]
    @session.fill_in 'password', with: credentials[:password]
    @session.click_button 'Log In'
  end

  def get_names
    @session.visit('/players/')
    @names = []
    until @names.length >= 25 do
      @session.all(page_elements[:player_card]).each do |user|
        @names << [
          user.find(page_elements[:name]).text,
          user.find(page_elements[:country]).text
        ]
      end
      puts @names.length
      @session.first(page_elements[:next_page]).click
    end
    @names
  end

  def write_to_csv
    csv_file = "names.csv"
    CSV.open(csv_file, 'w', write_headers: true, headers: %w[Name Country]) do |csv|
      @names.each do |row|
        csv_row = []
        row.each do |element|
          csv_row << element
        end
        csv << csv_row
      end
    end
  end

  private

  def page_elements
    {
      player_card: '.post-author-component',
      name: '.post-author-name',
      country: '.post-author-meta',
      next_page: '.pagination-next'
    }
  end

  def credentials
    {
      username: 'ctrl_p',
      password: 'Password12345678'
    }
  end
end