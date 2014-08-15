#! /bin/bash
while ./main.sh; do
	echo -e "\e[94mKilling Timer Killer...\e[0m"
#	killall timer_killer.sh
	killall sleep 2>/dev/null >/dev/null
	echo -e "\e[95mRestart after 5 seconds...\e[0m"
	sleep 5
done
exit
