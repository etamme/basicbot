#!/usr/local/bin/ruby

require 'cinch'

class Slap
  include Cinch::Plugin
  @help="!slap"
  match(/slap (.+)/)#,{:use_prefix => false})
  def execute(m,user)
      m.reply "*#{m.bot.nick} slaps #{user}"
  end
end
