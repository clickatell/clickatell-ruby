require 'rest-client'
require 'yaml'

# This is a very simple example to get the credit balance for the Clickatell account
#
# @see https://www.clickatell.com/downloads/http/Clickatell_HTTP.pdf for more information

begin
    # Clickatell Settings
    settings = YAML.load_file 'config.yml'

    # Build query string
    params = {
        :user => settings['clickatell']['username'],
        :password => settings['clickatell']['password'],
        :api_id => settings['clickatell']['api_id'],
    }

    # Get the response
    response = RestClient.get settings['clickatell']['url'] + 'http/getbalance', :params => params

    # Check for error from API
    if response.split(':').first == 'ERR'
        puts response
    else
        balance = response.body.split(' ').last
        puts 'Balance is: ' + balance
    end

rescue
    puts 'Could not fetch balance, double check your settings and internet connection'
end



