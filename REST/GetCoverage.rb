require 'rest-client'
require 'yaml'

# This is a very simple example to check if a destination (Mobile number) is supported currently by Clickatell
#
# @see https://www.clickatell.com/help/apidocs/ for more information

begin
    # Clickatell Settings
    settings = YAML.load_file 'config.yml'

    # Number to check routing coverage for
    mobile_number = '27999123456'

    # Set up REST resource
    clickatell = RestClient::Resource.new(
        settings['clickatell']['url'] + 'coverage/' + mobile_number,
        :headers => {
            :authorization => 'Bearer ' + settings['clickatell']['auth_token'],
            :content_type => 'application/json',
            :accept => 'application/json',
            :x_version => 1,
        }
    )

    # Get resource
    response = JSON.parse clickatell.get

    routable = 'No'
    if response['data']['routable']
        routable = 'Yes'
    end

    puts "Routable: #{routable}. Minimum Charge: #{response['data']['minimumCharge']}."

rescue StandardError=>e
    puts 'Could not execure action, double check settings and internet connection.'
    puts e
end


