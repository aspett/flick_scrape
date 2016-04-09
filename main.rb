# coding: utf-8
require "selenium-webdriver"
require "csv"

class FlickScrape
  EMAIL = ""
  PASSWORD = ""

  def initialize
    @data_array = []
  end

  def main
    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to "http://myflick.flickelectric.co.nz"

    login

    @driver.navigate.to "http://myflick.flickelectric.co.nz/dashboard/week"

    add_data

    while back_button
      back_button.click
      add_data
    end

    write_to_file
  ensure
    @driver.quit
  end

  def login
    @driver.find_element(:name, 'user[email]').send_keys(EMAIL)
    password = @driver.find_element(:name, 'user[password]')
    password.send_keys(PASSWORD)
    password.submit
  end

  def write_to_file
    CSV.open("flick_usage.csv", "w") do |csv|
      csv << ["Date", "Consumption (kWH)"]

      @data_array.sort_by{ |date_value| date_value[0] }.each do |date, value| 
        csv << [date.strftime("%Y-%m-%d"), value]
      end
    end
  end

  def add_data
    data = @driver.execute_script("return FLICK.CHARTS.data")

    consumption = data["consumption"].map{ |consumption| [parse_date(consumption["date"]), consumption["value"]] }

    @data_array += consumption
  end

  def back_button
    @driver.find_element(:xpath, "//span[@class='date-navigation']/a[text()='◀']") rescue nil
  end

  def parse_date(date)
    Date.parse(date) rescue nil
  end
end

FlickScrape.new.main
