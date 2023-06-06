require 'parser'
require 'rspec'
require 'selenium-webdriver'

RSpec.describe Parser do
  before(:all) do
    @parser = Parser.new
  end

  after(:all) do
    if File.exist?("names.csv")
      File.delete("names.csv")
    end
  end

  it 'should return multidimensional array of strings' do
    expect(@parser.get_names).to be_a(Array)
    @parser.get_names.each do |subarray|
      expect(subarray).to be_a(Array)
      subarray.each do |element|
        expect(element).to be_a(String)
      end
    end
  end

  it 'should save the names to csv file' do
    expect(File.exist?("names.csv")).to be true
  end

  it 'should save correct number of records to csv' do
    csv_file = CSV.read("names.csv")
    expect(csv_file.length - 1).to eq(@parser.get_names.length)
  end

  it 'should save all records to csv' do
    names = @parser.get_names
    @parser.write_to_csv
    csv_file = CSV.read('names.csv')
    expect(names[0]).to eq(csv_file[1])
    expect(names[-1]).to eq(csv_file[-1])
  end
end