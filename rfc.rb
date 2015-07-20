#!/usr/local/bin/ruby

require 'cinch'

class Rfc
  include Cinch::Plugin
  @help="!rfcXXXX"
  match(/(rfc[0-9]+)/)#,{:use_prefix => false})
  def execute(m,rfc)
      rfc.downcase!
      m.reply " https://tools.ietf.org/html/#{rfc}"
  end
end
