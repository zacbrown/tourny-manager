#!/usr/bin/env ruby -rubygems
# Author: Zac Brown
# Date:   02.11.2009
# File:   eliminate.rb
# Desc:   Takes a directory of databases and builds a master database from them.

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
require 'sqlite3'
require 'mysql'
require 'yaml'

db_load_dir = ""
table_name = "registration"

if ARGV.size > 0
  $master_db_config = YAML::load(File.open(ARGV[0]))["default"]
else
  puts "ERROR: not enough arguments!"
  exit -1
end

begin
  master_db_h = Mysql.real_connect($master_db_config["server"],
                                   $master_db_config["user"],
                                   $master_db_config["pass"],
                                   $master_db_config["db"])

  # get everyone thats not eliminated yet
  query = "SELECT id, first, last, kills, eliminated FROM registration
           WHERE eliminated = 0 ORDER BY kills DESC"
  results = master_db_h.query(query)

  count = results.num_rows / 2

  i = 0
  puts "thar..."
  results.each do |result|
    puts "here... #{count}"
    if i >= count
      master_db_h.query("UPDATE registration SET eliminated = 1
                         WHERE id=\'#{result[0]}\'")
      puts "eliminated: #{result[1]} #{result[2]}"
    end
    i += 1
  end
rescue Mysql::Error => e
  puts "Error code: #{e.errno}"
  puts "Error message: #{e.error}"
ensure
  master_db_h.close if master_db_h
end
