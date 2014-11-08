#!/usr/bin/osascript
----
-- Author: Florian Mayer
-- Date: Late November 2013
-- License: GPLv3
-- Summary: A little applescript script that
--   creates a multiplexed terminal session using
--   ssh and iTerm
-- Platforms: Obviously only Mac OS X
--   (Tested on Mac OS X 10.9)
--
-- Known limitations:
--   As you may have noticed, the script does not
--   provide a method for putting your
--   computernames in by using stdin.
--   This is because osascript unfortunately 
--   aggressively closes this filedescriptor. 
--   (see: https://groups.google.com/forum/#!msg/alt.comp.lang.applescript/1v0s0Tkn1bM/UBdqNBNoulwJ
--   and http://stackoverflow.com/questions/13973347/how-applescript-can-get-stdin-inside-the-code)
----

on logger(x)
	log x
end logger

on usage()
	logger("usage: <Skriptname> -u <user> -p <port> -c <cols> -w <width> -h <height> <computernames>")
end logger

on run argv
	----
	-- parse arguments
	set cn to {}

	if count of argv is not greater than 10 then
		my logger("Not enough arguments!")
		usage()
		return
		-- stops the script
	else
		if item 1 of argv is not "-u" then
			my logger("First argument has to be -u")
			usage()
			return
		else if item 3 of argv is not "-p" then
			my logger("Second argument has to be -p")
			usage()
			return
		else if item 5 of argv is not "-c" then
			my logger("Third argument has to be -c")
			usage()
			return
		else if item 7 of argv is not "-w" then
			my logger("Fourth argument has to be -w")
			usage()
			return
		else if item 9 of argv is not "-h" then
			my logger("Fifth argument has to be -h")
			usage()
			return
		else
			set user to item 2 of argv
			set sshport to item 4 of argv
			set cols to item 6 of argv
			set width to item 8 of argv
			set height to item 10 of argv
		end if
	end if

	----
	-- loads the computernames
	repeat with n from 11 to count of argv
		copy item n of argv to the end of cn
	end	
	set cs to (count of cn)

	----
	-- simple method of splitting up the iTerm window
	-- in cols and rows
	if (count of cn) mod cols is 0 then
		set rows to (count of cn) div cols
	else
		set rows to (count of cn) div cols + 1
	end if

	----
	-- fancy outputs
	logger("running with")
	logger("port: " & sshport)
	logger("user: " & user)
	logger("cols: " & cols)
	logger("rows: " & rows)
	logger("Window: " & width & "x" & height)

	----
	-- create terminal session
	tell application "iTerm"
		activate
		
		tell (make new terminal)
			set number of columns to width
			set number of rows to height
			(launch session "Default")
			
			----
			-- setup panes
			my logger("create rows")
			repeat rows - 1 times
				tell i term application "System Events" to keystroke "d" using {command down, shift down}
			end repeat

			my logger("create columns")
			repeat rows times
				repeat cols - 1 times
					tell i term application "System Events" to keystroke "d" using {command down}
				end repeat
				tell i term application "System Events" to key code 126 using {command down, option down}
			end repeat

			-- terminate unused sessions
			repeat (rows * cols - cs) times
				my logger("remove unused")
				terminate last item of sessions
			end repeat

			-- open sessions
			repeat with k from 1 to cs
				set temps to item k of cn
				my logger("open session " & k & " -> ssh " & user & "@" & temps)
				tell item k of sessions to write text "ssh " & user & "@" & temps
			end repeat
			
	
			-- start broadcast mode
			delay 1 
			tell i term application "System Events" to keystroke "I" using {command down, shift down}
		end tell
	end tell
end run
