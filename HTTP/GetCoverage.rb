require 'rest-client'
require 'yaml'

# This is a very simple example to check if a destination (Mobile number) is supported currently by Clickatell
#
# @see https://www.clickatell.com/downloads/http/Clickatell_HTTP.pdf for more information

begin
    # Clickatell Settings
    settings = YAML.load_file 'config.yml'

    # Number to check routing coverage for
    mobile_number = '27999123456'

    # Build query string
    params = {
        :user => settings['clickatell']['username'],
        :password => settings['clickatell']['password'],
        :api_id => settings['clickatell']['api_id'],
        :msisdn => mobile_number
    }

    # Get the response
    response = RestClient.get settings['clickatell']['url'] + 'utils/routeCoverage', :params => params

    # Check for error from API
    if response.split(':').first == 'ERR'
        puts response
    else
        routable = 'No'
        if response.body[0,2] == 'OK'
            routable = 'Yes'
        end

        charge = response.body.split(': ').last

        puts "Routable: #{routable}. Minimum Charge: #{charge}."
    end

rescue
    puts 'Could not get coverage, double check your settings and internet connection'
end
