# Author: Zac Brown
# Date:   02.07.2009
# File:   main.rb
# Desc:   Main interface file for Tourny Manager

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

require 'yaml'

class TournyMgr < Shoes
  url '/', :index
  url '/register', :register
  url '/success', :success

  def submit_registration(first_name, last_name, c_number, sex)

  end

  def index
    register
  end

  def success
    stack :margin_left => 130, :margin => 10, :margin_top => 20 do
      banner "Successfully registered, thanks " + $first_name.text
      para link("go back", :click => "/")
    end
  end

  def register
    stack :margin => 10, :margin_left => 150, :margin_top => 20 do
      banner "Registration", :margin => 4
    end
    stack :margin_left => 130, :margin => 10, :margin_top => 20 do
      para "lets register nigga"
      flow do
        para "First Name: "
        $first_name = edit_line :width => 300
      end
      flow do
        para "Last Name:  "
        @last_name = edit_line :width => 300
      end
      flow do
        para "C Number:   "
        @c_number = edit_line :width => 300
      end
      flow do
        para "Male ";
        @male_check = check do
          @female_check.checked = false if @male_check.checked?
        end
        para "  or  Female ";
        @female_check = check do
          @male_check.checked = false if @female_check.checked?
        end
      end
      @b1 = button "register" do
        ready = true
        if $first_name.text.length < 2 or $first_name.text == ""
          alert "Please enter a first name of at least 2 characters."
          ready = false
        else
        end
        if $first_name.text == "  "
          alert "Please enter something other than spaces for a first name."
          ready = false
        end
        if @last_name.text.length < 2 or @last_name.text == ""
          alert "Please enter a last name of at least 2 characters."
          ready = false
        end
        if @last_name.text == "  "
          alert "Please enter something other than spaces for a last name."
          ready = false
        end
        if @c_number.text.length < 8
          alert "Please enter a valid C number."
          ready = false
        end
        if not @male_check.checked? and not @female_check.checked?
          alert "No asexual beings permitted without proof, pick a sex."
          ready = false
        end

        if ready
          sex = if @male_check.checked? then true else false end
          submit_registration($first_name, @last_name, @c_number, sex)
          #alert "Successfully registered, thanks."
          visit "/success"
        end
      end
    end
  end
end

Shoes.app :width => 640, :height => 450,
:title => "Tourny Manager. Ya, we doin' it real big son."
