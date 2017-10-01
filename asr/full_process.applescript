on run argv
	set userPassword to item 1 of argv

	tell application "Finder"
		set asrDir to POSIX path of (container of (path to me) as alias)
	end tell

	tell application "Terminal"
		do script "sudo " & asrDir & "/full_process " ¬
			& quoted form of userPassword & "\n" & userPassword
	end tell
end run
