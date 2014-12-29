require 'rest-client'
require 'yaml'

# This is a very simple example to send a text message (MT) to a single destination (mobile number)
#
# @see https://www.clickatell.com/downloads/http/Clickatell_HTTP.pdf for more information

begin
    # Clickatell Settings
    settings = YAML.load_file 'config.yml'

    # The Message
    mobile_number = '27999123456'            # Use comma separated numbers to send to more than 1 number
    sms_text = 'Hello from Clickatell HTTP'  # 160 characters per message part

    # Build query string
    params = {
        :user => settings['clickatell']['username'],
        :password => settings['clickatell']['password'],
        :api_id => settings['clickatell']['api_id'],
        :to => mobile_number,
        :text => sms_text
    }

    # Get the response
    response = RestClient.get settings['clickatell']['url'] + 'http/sendmsg', :params => params

    # Check for error from API
    if response.split(':').first == 'ERR'
        puts response
    else
        data = response.body.split(' ')
        puts 'ID: ' + data[-1]
    end

rescue
    puts 'Could not send message, double check your settings and internet connection'
end

