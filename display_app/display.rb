# Author: Zac Brown
# Date:   02.07.2009
# File:   display.rb
# Desc:   Sinatra app to display high scores and current heat

# Copyright (C) 2009  Zac Brown <http://zacbrown.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

require 'rubygems'
require 'sequel'
require 'yaml'
require 'sinatra'

db_config = YAML::load(File.open('config.yml'))["default"]

$my_db = Sequel.mysql(db_config["db"], :user => db_config["user"],
                  :password => db_config["pass"], :host => db_config["server"])

get '/' do

end

get '/style.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :style
end

get '/highscores' do
  @players = highscore.all.collect
  haml :highscores
end

helpers do
  def highscore
    $my_db["SELECT first, last, cnumber, kills FROM registration
            ORDER BY kills DESC LIMIT 10"]
  end
end
