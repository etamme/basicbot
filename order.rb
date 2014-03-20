#!/usr/local/bin/ruby
require 'cinch'
require 'date'
require 'time'
require 'yaml'

class Order
  include Cinch::Plugin
  @help="!order"
  match(/(.+)/,{:use_prefix => false})
  
  def initialize(*args)
    super
    @open=false
    @orders={}
  end


  def time_in_words(minutes)
    case
      when minutes < 1
        "less than a minute"
      when minutes < 50
        if minutes > 1
          "#{minutes} minutes"
        else
          "#{minutes} minute"
        end
      when minutes < 90
        "about one hour"
      when minutes < 1080
      "#{(minutes / 60).round} hours"
      when minutes < 1440
        "one day"
      when minutes < 2880
        "about one day"
      else
       "#{(minutes / 1440).round} days"
    end
  end


  def execute(m,arg)
     if( arg =~ /^!order (.+)$/ )
       if($1=="help")
         m.reply("!order [open|close|what you want to order]")
         return
       elsif($1=="open")
         @open=true
         File.open('order.html','w')  {|f| f.write("") }
         m.reply("ordering is now open, order with: !order foo with a shot of bar please")
         return
       elsif($1=="close")
         @open=false
         m.reply("this order has been closed")
         File.open( 'order.html', 'w' ) do |f|
           f.puts "<html><head><title>coffeebot order</title></head><body>"
           @orders.each do |nick,order|
             f.puts "#{nick}: #{order}<br>"
           end
           f.puts "</body></html>"
         end
         m.reply("view at http://www.hydra.uphreak.com/order.html")
         return
       elsif(@open!=true)
         m.reply("sorry, there is no open order")
         return
       elsif($1=="")
         m.reply("you can't ask to order nothing")
         return
       else
         @orders[m.user.nick.downcase]="#{$1}<br>"
       end
     end
  end
end
