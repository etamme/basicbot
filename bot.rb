#!/usr/bin/env ruby
require 'cinch'
require './nick.rb'
require './ping.rb'
require './slap.rb'
require './tinyurl.rb'
require './seen.rb'
require './order.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#somechan"]
    c.nick = "botnick"
    c.plugins.plugins = [Ping,Slap,Tinyurl,Nick,Seen,Order]
  end

  on :message, "!help" do |m|
    @help=[]
    @bot.plugins.each do |plugin|
      help = plugin.class.instance_variable_get(:@help)
      if help!=' '
       @help.push(help)
      end
    end
      m.reply @help.join(', ')
  end

end

bot.start

