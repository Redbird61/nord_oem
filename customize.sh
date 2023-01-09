#!/system/bin/sh
# Written by Draco (tytydraco @ GitHub)

set -e

get_version() {
	local version
	local branch

	while true
	do
		version="$(getevent -qlc 1 | awk '{ print $3 }')"
		case "$version" in
			KEY_VOLUMEUP)
				branch="master"
				;;
			KEY_VOLUMEDOWN)
				branch="dev"
				;;
			*)
				continue
				;;
		esac

		echo "$branch"
		break
	done
}

ui_print ""
ui_print " --- KTweak Magisk Module ---"
ui_print ""

ui_print " * Select which version to use:"
ui_print " * Volume Up: Master (stable)"
ui_print " * Volume Down: Dev (newer, less stable)"

branch="$(get_version)"

ui_print " * Fetching the latest module from GitHub..."
curl -Lso "$MODPATH/system/bin/ktweak" "https://raw.githubusercontent.com/tytydraco/KTweak/$branch/ktweak"

ui_print " * Patching for use on Android..."
sed -i 's|!/usr/bin/env bash|!/system/bin/sh|g' "$MODPATH/system/bin/ktweak"

ui_print " * Setting executable permissions..."
set_perm_recursive "$MODPATH/system/bin" root root 0777 0755

# Do install-time script execution
ui_print " * Executing during live boot..."
sh "$MODPATH/system/bin/ktweak" &> /dev/null

ui_print ""
ui_print " --- Additional Notes ---"
ui_print ""
ui_print " * Reinstalling this module will update the KTweak script"
ui_print " * Dirty flashes usually do not require a reboot"
ui_print " * Do not use KTweak with other optimizer modules"
ui_print " * Report issues to @ktweak_discussion on Telegram"
ui_print " * Contact @tytydraco for direct support"
ui_print " * Source code is available on GitHub"
ui_print ""
ui_print "   https://www.github.com/tytydraco/ktweak"
ui_print ""
