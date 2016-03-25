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
    @slack=false
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
       original_order = $1
       if($1=="help")
         m.reply("!order [open|close|check|what you want to order]")
         return
       elsif($1=="open")
         if(@open==true)
           m.reply("there is already an order open")
         else
           @open=true
           @orders={}
           File.open('index.html','w')  {|f| f.write("") }
           if(@slack)
             m.reply("ordering is now open <!here>, order with: !order foo with a shot of bar please")
           else
             m.reply("ordering is now open, order with: !order foo with a shot of bar please")
           end
         end
         return
       elsif($1=="close")
         @open=false
         m.reply("this order has been closed")
         File.open('index.html', 'w' ) do |f|
           f.puts "<html><head><title>coffeebot order</title></head><body>"
           @orders.each do |nick,order|
             f.puts "#{nick}: #{order}<br>"
           end
           f.puts "</body></html>"
         end
         m.reply("view at http://coffeebot.uphreak.com/")
         helper_threshold=8
         if(@orders.length>helper_threshold)
           if(@slack)
             m.reply("There are more than #{helper_threshold} orders, would anyone <!here> like to help carry them?")
           else
             m.reply("There are more than #{helper_threshold} orders, would anyone here like to help carry them?")
           end
         end
         return
       elsif(@open!=true)
         m.reply("sorry, there is no open order")
         return
       elsif($1=="check")
         nick=m.user.nick.downcase
         if (@orders[nick]!=nil)
           order=@orders[nick][0..-5] #trim <br>
           m.reply("#{nick}, I have you down for '#{order}'.")
         else
           m.reply("#{nick}, you have not ordered anything yet.")
         end
       elsif($1=="")
         m.reply("you can't ask to order nothing")
         return
       elsif($1 =~ /^for=([^ ]+) (.+)$/)
         @orders[$1.downcase]="#{$2}<br>"
       else
         @orders[m.user.nick.downcase]="#{original_order}<br>"
       end
     elsif( arg =~/^!order$/)
       if(@open==true)
         m.reply("there is an open order, use !order something, to place yours")
       else
         m.reply("there is no order, open one with !order open")
       end
     end

  end
end
