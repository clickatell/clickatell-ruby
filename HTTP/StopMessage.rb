require 'rest-client'
require 'yaml'

# This is a very simple example to send a text message (MT) to a single destination (mobile number)
# and stop the message. This command can only stop messages which
# may be queued within our router, and not messages which have already been delivered to a SMSC. This
# command is therefore only really useful for messages with deferred delivery times.
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
      :text => sms_text,
      :deliv_time => 15                                  # 15 min from now
  }

  # Get the response
  response = RestClient.get settings['clickatell']['url'] + 'http/sendmsg', :params => params

  if response.code == 200

      # Check for error from API
      if response.split(':').first == 'ERR'
          puts response
      else
          if response.body[0,3] == 'ID:'
              message_id = response.body.split(' ').last
              puts 'Stopping ' + message_id + ' status...'

              params = {
                  :user => settings['clickatell']['username'],
                  :password => settings['clickatell']['password'],
                  :api_id => settings['clickatell']['api_id'],
                  :apimsgid => message_id
              }

              # Get the response
              response = RestClient.get settings['clickatell']['url'] + 'http/delmsg', :params => params

              # Check for error from API
              if response.split(':').first == 'ERR'
                  puts response
              else
                  data = response.body.split(' ')

                  if data[-1] == '006'
                      puts 'Message was stopped.'
                  else
                      puts 'Message could not be stopped.'
                  end
              end
          end
      end
  end
rescue
    puts 'Could not stop message, double check your settings and internet connection'
end




