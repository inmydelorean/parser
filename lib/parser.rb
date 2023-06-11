require_relative '../modules/capybara_config'

class Parser
  include CapybaraConfig
  NAMES_TO_GET = 100

  def logged_in?(username="ctrl_p", password="Password12345678")
    visit('https://www.chess.com/login_and_go/')
    fill_in 'username', with: username
    fill_in 'password', with: password
    click_button 'Log In'
    has_button?('Log In') ? false : true
  end

  def get_names(logged_in)
    if logged_in
      visit('https://www.chess.com/players/')
      names = []
      until names.length == NAMES_TO_GET do
        all(:xpath, "//*[@id='view-master-players']/div/div[2]/div/div/h2/a[1]/span[2]").each do |user|
          names << user.text
        end
        first(:xpath, "//*[@id='view-master-players']/div/div[1]/div[2]/nav/a[6]").click
      end
      names
    else
      raise 'Login failed'
    end
  end
end

# parser = Parser.new
# # parser.logged_in?
# parser.get_names(parser.logged_in?)