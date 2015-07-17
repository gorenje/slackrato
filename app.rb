require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require "sinatra/multi_route"
require 'json'

require 'slack-poster'
require 'librato/metrics'
require 'active_support'
require 'active_support/core_ext/object/blank'

ENV['environment'] = ENV['RACK_ENV'] || 'development'

require_relative 'routes/slack.rb'

Librato::Metrics.
  authenticate(ENV['LIBRATO_USERNAME'], ENV['LIBRATO_PASSWORD'])

before do
  halt(404) unless ENV['SLACK_TOKENS'].split(/,/).include?(params[:token])
end

get '/' do
  ""
end
