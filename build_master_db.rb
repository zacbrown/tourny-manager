#!/usr/bin/env ruby
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

db_load_dir = ""
master_db_name = ""
table_name = "registration"

if ARGV.size > 1
  db_load_dir = ARGV[0]
  master_db_name = ARGV[1]
else
  puts "ERROR: not enough arguments!"
  exit -1
end

create = if FileTest.exists?(master_db_name) then false else true end

master_db_h = SQLite3::Database.new(master_db_name)
if create
  master_db_h.transaction
  master_db_h.execute("CREATE TABLE registration
                       (num INTEGER PRIMARY KEY, first TEXT, last TEXT,
                        cnumber TEXT, sex INTEGER, girl INTEGER,
                        special INTEGER, team INTEGER)")
  master_db_h.commit
end

Dir.new(db_load_dir).entries.each do |cur_file|
  next if cur_file == "." or cur_file == ".."

  puts "STATUS: processing \'#{cur_file}\'"
  db_h = SQLite3::Database.new(db_load_dir + cur_file)

  db_h.execute("SELECT * from #{table_name}") do |row|
    master_db_h.transaction
    master_db_h.execute("INSERT INTO registration
                        (first, last, cnumber, sex, girl, special, team)
                        VALUES
                        (?, ?, ?, ?, ?, ? ,?)", *row)
    master_db_h.commit
  end
end
