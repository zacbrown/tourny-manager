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
  url '/first_name', :first_name
  url '/last_name', :last_name
  url '/cnumber', :cnumber
  url '/sex_choose', :sex_choose
  url '/review', :review

  def submit_registration(first_name, last_name, c_number, sex)

  end

  def index
    register
  end

  def review
    background white
    stack :margin => 10, :margin_left => 120, :margin_top => 20 do
      banner "In Review"
    end
    stack :margin => 10, :margin_left => 110, :margin_top => 10 do
      subtitle "You seem to think..."
    end
    stack :margin_left => 90, :width => 550, :margin => 10, :margin_top => 20 do
      flow do
        @conf_first = para "* your first name is \'#{$first_name_txt}\'. "
        button "change" do
          $first_name_txt = ask("What\'s your first name, for realz?")
          @conf_first.text = "* your first name is \'#{$first_name_txt}\'. "
        end
      end
      flow do
        @conf_last = para "* your last name is \'#{$last_name_txt}\'. "
        button "change" do
          $last_name_txt = ask("What\'s your last name, for realz?")
          @conf_last.text = para "* your last name is \'#{$last_name_txt}\'. "
        end
      end
      flow do
        @conf_num = para "* your C-number or DL number is \'#{$c_number_txt}\'. "
        button "change" do
          $c_number_txt = ask("What\'s your C-number or DL number, for realz?")
          @conf_num.text = para "* your C-number or DL number is \'#{$c_number_txt}\'. "
        end
      end
      flow do
        @conf_sex = para "* you\'re a: "
        @check_m_review = check do
          @check_f_review.checked = false
          $sex = true
        end
        para "male | "
        @check_f_review = check do
          @check_m_review.checked = false
          $sex = false
        end
        para "female"
        if $sex
          @check_m_review.checked = true
          @check_f_review.checked = false
        else
          @check_f_review.checked = true
          @check_m_review.checked = false
        end
      end
    end
    stack :margin_left => 240, :margin => 10, :margin_top => 75 do
      button "submit" do
        submit_registration($first_name_txt, $last_name_txt, $c_number_txt, $sex)
        visit "/success"
      end
    end
  end

  def success
    background white
    stack :margin => 10, :margin_left => 150, :margin_top => 20 do
      banner "Success!", :margin => 4
    end
    stack :margin => 75, :margin_top => 20 do
      subtitle "Successfully registered, thanks " + $first_name_txt + "!", :align => "center"
      timer 5 do
        visit "/"
      end
      para link("go back", :click => "/"), :align => "center"
      inscription "(this page will go back to registration in 5 seconds)", :align => "center"
    end
  end

  def first_name
    background white
    stack :margin => 10, :margin_left => 150, :margin_top => 20 do
      banner "First Name"
    end
    stack :margin => 10, :margin_left => 130 do
      subtitle "Whats yo\' name shawty?"
    end
    stack :margin_left => 130, :margin => 10, :margin_top => 20 do
      tagline "First name, or at least something you\'ll answer to?"
      $first_name = edit_line :width => 300
      if $first_name_txt != ""
        para "You entered \'#{$first_name_txt}\' last time, just fyi."
      end
    end
    stack :margin_left => 240, :margin => 10, :margin_top => 75 do
      flow :margin => 20 do
        button "back" do
          if confirm("If you go back from here you\'ll lose the info you\'ve entered. Are you sure?")
            visit "/"
          end
        end
        button "next" do
          ready = true
          if $first_name_txt == ""
            if $first_name.text == "" or $first_name.text.length < 2
              alert "Please enter a first name of at least 2 characters."
              ready = false
            end
            if $first_name.text == "  "
              alert "Please enter something other than spaces for a first name."
              ready = false
            end
          end
          if ready
            $first_name_txt = $first_name.text
            visit "/last_name"
          end
        end
      end
    end
  end

  def last_name
    background white
    stack :margin => 10, :margin_left => 150, :margin_top => 20 do
      banner "Last Name"
      subtitle "From which clan doth thou hail?"
    end
    stack :margin_left => 130, :margin => 10, :margin_top => 20 do
      tagline "Last name, \'cause what if there\'s another #{$first_name.text}?"
      $last_name = edit_line :width => 300
      if $last_name_txt != ""
        para "You entered \'#{$last_name_txt}\' last time, just fyi."
      end
    end
    stack :margin_left => 240, :margin => 10, :margin_top => 75 do
      flow :margin => 20 do
        button "back" do
          visit "/first_name"
        end
        button "next" do
          ready = true
          if $last_name_txt == ""
            if $last_name.text == "" or $last_name.text.length < 2
              alert "Please enter a last name of at least 2 characters."
              ready = false
            end
            if $last_name.text == "  "
              alert "Please enter something other than spaces for a last name."
              ready = false
            end
          end
          if ready
            $last_name_txt = $last_name.text
            visit "/cnumber"
          end
        end
      end
    end
  end

  def cnumber
    background white
    stack :margin => 10, :margin_left => 150, :margin_top => 20 do
      banner "C Number"
      subtitle "Lemme get yo digits, son."
    end
    stack :margin_left => 130, :margin => 10, :margin_top => 20 do
      tagline "C number, or if you don't have one, your DL number."
      $c_number = edit_line :width => 300
      if $c_number_txt != ""
        para "(You entered \'#{$c_number_txt}\' last time, just fyi.)"
      end
    end
    stack :margin_left => 240, :margin => 10, :margin_top => 75 do
      flow :margin => 20 do
        button "back" do
          visit "/last_name"
        end
        button "next" do
          ready = true
          if $c_number_txt == ""
            if $c_number.text.length < 8 or $c_number.text.length > 10
              alert "Please enter a valid C-number of DL number."
              ready = false
            end
          end
          if ready
            $c_number_txt = $c_number.text
            visit "/sex_choose"
          end
        end
      end
    end
  end

  def sex_choose
    background white
    stack :margin => 10, :margin_left => 120, :margin_top => 20 do
      banner "Pick your Sex"
    end
    stack :margin => 10, :margin_left => 30 do
      @my_sub = tagline "You can't be both (without proof),\n so choose wisely."
      @my_sub.align = "center"
    end
    stack :margin_left => 185, :margin => 10, :margin_top => 20 do
      flow do
        image("../imgs/male.png") do
          @male_check = true
          @female_check = false
          @sex_text.text = "You\'re a boy, don't dry hump the girls."
        end
        subtitle " or "
        image("../imgs/female.png") do
          @female_check = true
          @male_check = false
          @sex_text.text = "You\'re a girl, make sure you have pepper spray."
        end
      end
    end
    stack :margin_left => 30, :margin => 10, :margin_top => 30 do
      @sex_text = caption "You're asexual. (click your sex)"
      @sex_text.align = "center"
    end
    stack :margin_left => 220, :margin => 10, :margin_top => 30 do
      flow :margin => 20 do
        button "back" do
          visit "/cnumber"
        end
        button "next" do
          ready = true
          if not @male_check and not @female_check
            alert "No asexual beings permitted without proof, pick a sex."
            ready = false
          end
          if ready
            $sex = if @male_check then true else false end
            visit "/review"
          end
        end
      end
    end
  end

  def register
    $c_number_txt = ""; $first_name_txt = ""; $last_name_txt = "";
    background white
    stack :margin => 10, :margin_left => 150, :margin_top => 20 do
      banner "Welcome"
    end
    stack :margin_left => 90, :width => 550, :margin => 10, margin_top => 20 do
      caption "So here's our guidelines/disclaimer and stuff:"
      inscription "1. If you break it, you buy it, in its most updated/expensive version. This isn't up for discussion. Items covered under this clause include but are not limited to: any game console, TV, computer, network router, controller, speaker system or other peripheral involved in this tournament. We reserve the right to hold you to the price of anything else you may break that is not your property."
      inscription "2. You're responsible for your things. If you lose something, thats your problem not the UM IEEE's."
      inscription "3. Exercise self control and respect. If you can't keep your hands to yourself or you can't say anything nice, we'll just ask you to leave. And by ask, we mean you will leave."
      inscription "4. If you have a problem with someone, take it up with a referee, let him beat the snot out of the other kid... erm I mean handle the problem."
      inscription "5. All match outcomes are final. No do-overs unless the referee deems a rematch necessary due to hardware problems, heart attacks or acts of God/Allah/Yahweh/$DEITY."
    end
    flow :margin_left => 100, :width => 500, :margin => 10, :margin_top => 20 do
      @agree = check;
      inscription "I agree to these guidelines and any others that may spontaneously arise during the duration of this event. (Though we will try not to make absurd rules.)"
    end
    stack :margin_left => 240, :margin => 10, :margin_top => 10 do
      button "next" do
        if @agree.checked?
          visit "/first_name"
        else
          alert "You'll need to agree to this before you can register, srsly, kthxbai!"
        end
      end
    end
  end
end

Shoes.app :width => 640, :height => 700,
:title => "Tourny Manager. Ya, we doin' it real big son."
