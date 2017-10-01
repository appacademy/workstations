on run argv
	set userPassword to item 1 of argv
	set termPass to quoted form of userPassword

	tell application "Finder"
		set asrDir to POSIX path of (container of (path to me) as alias)
	end tell

	tell application "Terminal"
		do script cd "sudo " & asrDir & "copy_and_restore && " & asrDir & "set_startup_disk " & termPass & " &&" "\n" & userPassword
	end tell
end run
