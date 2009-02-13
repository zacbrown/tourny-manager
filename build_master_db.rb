#!/usr/bin/env ruby -rubygems
# Author: Zac Brown
# Date:   02.11.2009
# File:   build_master_db.rb
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

if ARGV.size > 1
  db_load_dir = ARGV[0]
  $master_db_config = YAML::load(File.open(ARGV[1]))["default"]
else
  puts "ERROR: not enough arguments!"
  exit -1
end

Dir.new(db_load_dir).entries.each do |cur_file|
  next if cur_file == "." or cur_file == ".."

  puts "STATUS: processing \'#{cur_file}\'"
  db_h = SQLite3::Database.new(db_load_dir + cur_file)

  db_h.execute("SELECT * from #{table_name}") do |row|
    begin
      master_db_h = Mysql.real_connect($master_db_config["server"],
                                       $master_db_config["user"],
                                       $master_db_config["pass"],
                                       $master_db_config["db"])
      row.shift

      query = "INSERT INTO registration
                 (first, last, cnumber, sex)
               VALUES
                 (\'#{row[0]}\', \'#{row[1]}\', \'#{row[2]}\', #{row[3]})"

      master_db_h.query(query)
    rescue Mysql::Error => e
      puts "Error code: #{e.errno}"
      puts "Error message: #{e.error}"
    ensure
      master_db_h.close if master_db_h
    end
  end
end
