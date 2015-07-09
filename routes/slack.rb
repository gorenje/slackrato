# -*- coding: utf-8 -*-
post '/slack/commands' do
  case params[:command]
  when "/co2"
    username = params[:user_name]
    chnl     = params[:channel_name]
    grurl    = ENV['DASHBOARD_URL']

    begin
      str = ENV['CO2_METRIC_NAMES'].split(/,/).map { |str| str.split(/:/)}.
        map do |libprefix,name|

        co2v = Librato::Metrics.
          fetch(libprefix+".co2", :count => 1)['unassigned'].first["value"]
        tempv = Librato::Metrics.
          fetch(libprefix+".tmp", :count => 1)['unassigned'].first["value"]

        co2v, tempv = "%.1f" % co2v, "%2.1f" % tempv


        "On the *#{name}*: Co2: <#{grurl}|#{co2v}> ppm, "+
          "Temp: <#{grurl}|#{tempv}>°C"
      end.join("\n")

      msg = "Co2 & Temp. at "+
        "#{DateTime.now.to_s.gsub(/T/,' ').gsub(/[+].+$/,' UTC')}:\n" +
        str + "\n"

      if !ENV['SLACK_INCOMING_URL'].blank? && params[:text] == "post"
        options = {
          :icon_emoji => ':libratotello:',
          :username   => 'SlackRato',
          :channel    => "##{chnl}",
        }
        poster = Slack::Poster.new(ENV['SLACK_INCOMING_URL'], options)

        poster.send_message(msg)
      else
        msg
      end
    rescue Exception => e
      "Error: #{e.message}"
    end
  else
    "I dunno whatcha talking about Willis? "+
      "Command Unknown: #{params[:command]}"
  end
end
