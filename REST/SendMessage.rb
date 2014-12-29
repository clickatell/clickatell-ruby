require 'rest-client'
require 'yaml'

# This is a very simple example to send a text message (MT) to a single destination (mobile number)
#
# @see https://www.clickatell.com/help/apidocs/#Message.htm#SendMessage for more information

begin
    # Clickatell Settings
    settings = YAML.load_file 'config.yml'

    # Set up REST resource
    clickatell = RestClient::Resource.new(
        settings['clickatell']['url'] + 'message',
        :headers => {
            :authorization => 'Bearer ' + settings['clickatell']['auth_token'],
            :content_type => 'application/json',
            :accept => 'application/json',
            :x_version => 1,
        }
    )

    # The message (POST Data)
    post = {
        :to => ['27999123456'],                            # Add numbers to array to send to more than 1 number
        :text => 'Hello from Clickatell Rest'
    }.to_json

    # Get resource
    response = JSON.parse clickatell.post post

    puts 'Message ID is: ' + response['data']['message'][0]['apiMessageId']

rescue StandardError=>e
    puts 'Could not execure action, double check settings and internet connection.'
    puts e
end