# frozen_string_literal: true

# !/usr/bin/env ruby

require_relative 'aslate/version'
require 'io/console'
require 'json'
require 'net/http'
require 'optparse'
require 'ostruct'

require 'selenium-webdriver'

def automate_timecard(args)
  config_file = File.open(args[:config])
  config_data = JSON.parse(config_file)

  driver = Selenium::WebDriver.for :chrome
  wait = Selenium::WebDriver::Wait.new(timeout: 20)

  login_page = 'https://tsheets.intuit.com/page/login_oii'
  driver.get login_page

  email_text_id = 'ius-identifier'
  email_form = wait.until { driver.find_element(:id, email_text_id) }

  application_email = config_data['email']
  email_form.send_keys application_email

  signin_checkbox_id = 'ius-signin-label-checkbox'
  signin_checkbox = wait.until { driver.find_element(:id, signin_checkbox_id) }
  signin_checkbox.click

  random_sleep_time = (5 * rand) + 5 # [5, 10]
  print "Waiting #{random_sleep_time} before passing email ...\n"
  sleep(random_sleep_time)
  email_form.submit

  password_container_id = 'ius-sign-in-mfa-password-collection-current-password'
  password_container = wait.until { driver.find_element(:id, password_container_id) }

  application_passwd = IO.console.getpass('Provide Quickbooks Application Password: ')
  password_container.send_keys application_passwd
  password_container.submit

  timesheets_menu_id = 'timesheets_v2_shortcut'
  timesheets_menu = wait.until { driver.find_element(:id, timesheets_menu_id) }
  timesheets_menu.click

  manual_time_card_tab_id = 'ui-id-3'
  manual_time_card_tab = wait.until { driver.find_element(:id, manual_time_card_tab_id) }
  manual_time_card_tab.click

  timecard_row_name_base = 'weekly_timecard_row_name_'
  timecard_entry_base = 'weekly_timecard_weekly_'

  jobcode_search_id = 'jobcode_select_search_input'
  jobcode_search_first_result_id = 'jobcode_select_search_results_option_0'

  project_data = config_data['projects']
  project_data.each_with_index do |(proj_name, proj_entry), proj_index|
    timecard_row_name = "#{timecard_row_name_base}#{proj_index}"
    timecard_row = wait.until { driver.find_element(:id, timecard_row_name) }
    timecard_row.click

    jobcode_search = wait.until { driver.find_element(:id, jobcode_search_id) }
    jobcode_search.send_keys proj_name

    jobcode_result = wait.until { driver.find_element(:id, jobcode_search_first_result_id) }
    jobcode_result.click

    proj_entry.each_with_index do |(_day_str, hour_val), day_index|
      timecard_entry_id = "#{timecard_entry_base}#{proj_index}_#{day_index}"
      timecard_entry = wait.until { driver.find_element(:id, timecard_entry_id) }
      timecard_entry.send_keys hour_val
    end
  end

  return if args[:dry_run]

  timesheet_save_button_id = 'weekly_timecard_submit_button'
  timesheet_save_button = wait.until { driver.find_element(:id, timesheet_save_button_id) }
  timesheet_save_button.click
end

options = {
  dry_run: false
}
OptionParser.new do |parser|
  parser.on('-c', '--config CFG', 'JSON config file representing the timecard') do |cfg|
    options[:config] = cfg
  end

  parser.on('-d', '--dry-run', 'Dry-run of the time-card automation, will not save changes') do |_dr|
    options[:dry_run] = true
  end
end.parse!

automate_timecard(options)
