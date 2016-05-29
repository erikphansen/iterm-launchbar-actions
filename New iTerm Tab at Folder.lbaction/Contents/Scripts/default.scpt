-- LaunchBar Action Script
-- Opens a folder/directory/path in a new tab in iTerm
-- TODO: if iTerm is not running, the app starts but then immediately kills the session

-- when you pass in an arbitrary string from LaunchBar
on handle_string(_string)
	-- prepend spaces with backslashes
	--	set _string to (do shell script "echo \"" & _string & "\" | sed 's/ /\\\\ /g'")
	-- sed does not support lookbehind, so replace double backslashes with single backslashes
	-- you might end up with double backslashes if the user already escaped spaces with a backslash
	--	set _string to (do shell script "echo \"" & _string & "\" | sed 's/(\\\\)+/\\\\/g'")
	set command to "cd " & escapeSpaces(_string)
	runCommand(command)
end handle_string

-- when you pass in a folder reference from LaunchBar
on open (_path)
	-- we get the quoted form of _string to handle spaces in paths
	set _path to POSIX path of _path
	--	set _path to (do shell script "echo \"" & _path & "\" | sed 's/ /\\\\ /g'")
	set command to "cd " & escapeSpaces(_path)
	runCommand(command)
end open

on escapeSpaces(_string)
	-- insert backslashes in front of all spaces
	set _string to (do shell script "echo \"" & _string & "\" | sed 's/ /\\\\ /g'")
	-- sed does not support lookbehind, so replace double backslashes with single backslashes
	-- (you might end up with double backslashes if the user already escaped spaces with a backslash)
	set _string to (do shell script "echo \"" & _string & "\" | sed 's/(\\\\)+/\\\\/g'")
	return _string
end escapeSpaces

on runCommand(command)
	tell application "iTerm"
		-- If iTerm already has a window, then make a new tab
		-- otherwise we need to make a new window to run the command
		if exists (current window) then
			tell current window
				set newTab to (create tab with default profile)
				tell current session
					write text command
				end tell
			end tell
		else
			set newWindow to (create window with default profile)
			tell current session of newWindow
				write text command
			end tell
		end if
		activate
	end tell
end runCommand
