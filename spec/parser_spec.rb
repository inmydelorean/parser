require 'parser'
require 'rspec'
require 'selenium-webdriver'

RSpec.describe Parser do
  include Capybara::DSL

  before(:all) do
    @parser = Parser.new
  end

  it 'should return true if login is successful' do
    expect(@parser.logged_in?).to eq(true)
  end

  it 'should return false if login is not successful' do
    expect(@parser.logged_in?("wrong_login", "wrong_password")).to eq(false)
  end

  it 'should raise an error if login is not successful' do
    expect { @parser.get_names(false) }.to raise_error('Login failed')
  end

  it 'should return array of strings' do
    array = @parser.get_names(@parser.logged_in?)
    array.each do |element|
      expect(element).to be_a(String)
    end
  end

  it "should return the required number of names" do
    array = @parser.get_names(@parser.logged_in?)
    expect(array.length).to be == Parser::NAMES_TO_GET
  end
end
