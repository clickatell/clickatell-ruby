require 'rest-client'
require 'yaml'

# This is a very simple example to send a text message (MT) to a single destination (mobile number)
# and query the status of the sent message
#
# @see https://www.clickatell.com/downloads/http/Clickatell_HTTP.pdf for more information

begin
    # Clickatell Settings
    settings = YAML.load_file 'config.yml'

    # The Message
    mobile_number = '27999123456'       # Use comma separated numbers to send the same text message to multiple numbers.
    sms_text = 'Hello World'            # 160 characters per message part

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

        if response.code == 200
            if response.body[0,3] == 'ID:'
                message_id = response.body.split(' ').last
                puts 'Checking ' + message_id + ' status...'

                params = {
                    :user => settings['clickatell']['username'],
                    :password => settings['clickatell']['password'],
                    :api_id => settings['clickatell']['api_id'],
                    :apimsgid => message_id
                }

                # Get the response
                response = RestClient.get settings['clickatell']['url'] + 'http/querymsg', :params => params

                # Check for error from API
                if response.split(':').first == 'ERR'
                    puts response
                else
                    data = response.body.split(' ')
                    puts 'status: ' + data[-1]
                end
            end
        end
    end

rescue
    puts 'Could not get message status, double check your settings and internet connection'
end



