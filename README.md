# Aslate

Automation tool for timecard processing for the Intuit QuickBooks Time software web interface.

###### Stage 1 (Login Screen)
* Load the timesheet url: https://tsheets.intuit.com/page/login_oii
* Provide user email to the field 
    - Email field
    ```
    <input id="ius-identifier" class="ius-text-input ius-input-error ius-text-input-status-active" aria-required="true" required="required" type="text" name="Email" autofocus="" tabindex="2">
    ```
* Ensure the "remember me" box is unchecked so this process is repeatable
    - "Remember me" checkbox
    ```
    <label id="ius-signin-label-checkbox" class="ius-checkbox-label" tabindex="-1"></label>
    ```
* Submit the email text to proceed to the next stage

###### Stage 1.5 
* Potential CAPTCHA 
* Using firefox with Selenium will trigger the captcha stage, but testing with chromium at the
    moment will not trigger the CAPTCHA stage

###### Stage 2 (Password Screen)
* Provide the password to the password field
    - Password field
    ```
    <input id="ius-sign-in-mfa-password-collection-current-password" class="ius-text-input ius-input-error" autocomplete="current-password" type="password" maxlength="35" name="Password"> 
    ```
* Submit the password to proceed to the next stage

###### Stage 3 (Timecard Screen)
* Select the "Time Entries" section 
    - Time entry shortcut
    ```
    <a href="#" id="timesheets_v2_shortcut" class="ts-jss-133 ts-jss-2 rebranding-main-menu-restyle" role="link"><svg class="ts-icon" aria-hidden="true"><use xlink:href="#ic_time_entries"></use></svg><span class="ts-jss-140">Time Entries </span></a>
    ```

* Select a Project
    - First project entry
    ```
    <div id="weekly_timecard_row_name_0" class="job-code-cell onboarding-tour-element select-job-code-button" title="(no project)" style="max-width: 200px;" tabindex="0" role="button" onkeydown="accessibilityHandlers.clickButton(event)" onclick="el('weekly_timecard').show_jc_dropdown('0', event);"> (no project)</div>
    ```
    - Iterates in the leftmost column starting with "weekly_timecard_row_name_0" and incrementing
    every row down 

    - Prompts a searchbar to select the project based off the project name as the search key
    - Inner project search bar
    ```
    <input type="text" class="jobcode-search ui-autocomplete-input" id="jobcode_select_search_input" value="" autocomplete="off" role="combobox" aria-expanded="false" aria-autocomplete="list" aria-controls="jobcode_select_search_results" aria-haspopup="listbox">
    ```
    - Search results will exist below the search bar to be selected
    ```
    <li id="jobcode_select_search_results_option_0" class="search-result-item selectable"
    role="option" aria-selected="false">Morpheus (010)</li>k
    ```

* Input Time
    - First row, column hour entry
    ```
    <input autocomplete="off" class="grid current_row
    current_cell" style="font-size:14px; " type="text" name="weekly[0][0]" value="" data-seconds="0"
    id="weekly_timecard_weekly_0_0" size="4">
    ```
    - Iterates using the following pattern:
    ```
        [0, 0], [0, 1], [0, 2], [0, 3], [0, 4]
        [1, 0], [1, 1], [1, 2], [1, 3], [1, 4]
        ...
        [N, 0], [N, 1], [N, 2], [N, 3], [N, 4]
    ```
* Save the time card
    - Save button
    ```
    <button id="weekly_timecard_submit_button" class="flat primary action onboarding-tour-element">Save</button>
    ```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aslate'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install aslate

## Usage

* Configuration Structure
```
{
    "email": "<email>",
    "projects": {
        "Project_Name_0: {
            "Monday": <#Hours>,
            "Tuesday": <#Hours>,
            "Wednesday": <#Hours>,
            "Thursday": <#Hours>,
            "Friday": <#Hours>,
        },
        "Project_Name_1: {
            "Monday": <#Hours>,
            "Tuesday": <#Hours>,
            "Wednesday": <#Hours>,
            "Thursday": <#Hours>,
            "Friday": <#Hours>,
        },
        ...
        "Project_Name_N: {
            "Monday": <#Hours>,
            "Tuesday": <#Hours>,
            "Wednesday": <#Hours>,
            "Thursday": <#Hours>,
            "Friday": <#Hours>,
        }
    }
}
```

###### Standard call
> ```ruby aslate.rb -c <config_file> ```

###### Dry-Run (Will not save timecard entry)
> ```ruby aslate.rb -c <config_file> --dry-run```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

