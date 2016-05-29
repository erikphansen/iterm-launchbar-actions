-- LaunchBar Action Script
-- Opens a folder/directory/path in a new tab in iTerm

on handle_string(_string)
	set command to "cd " & escapeSpaces(_string)
	runCommand(command)
end handle_string

on open (_path)
	set _path to POSIX path of _path
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
		set newWindow to (create window with default profile)
		tell current session of first window
			write text command
		end tell
	end tell
end runCommand
