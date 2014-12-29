require 'rest-client'
require 'yaml'

# This is a very simple example to get the credit balance for the Clickatell account
#
# @see https://www.clickatell.com/help/apidocs/#account-balance.htm for more information

begin
    # Clickatell Settings
    settings = YAML.load_file 'config.yml'

    # Set up REST resource
    clickatell = RestClient::Resource.new(
        settings['clickatell']['url'] + 'account/balance',
        :headers => {
            :authorization => 'Bearer ' + settings['clickatell']['auth_token'],
            :content_type => 'application/json',
            :accept => 'application/json',
            :x_version => 1,
        }
    )

    # Get resource
    response = JSON.parse clickatell.get

    puts 'Balance is: ' + response['data']['balance']

rescue StandardError=>e
    puts 'Could not execure action, double check settings and internet connection.'
    puts e
end
