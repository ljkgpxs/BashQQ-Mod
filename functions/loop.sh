# Main message loop
function messageLoop
{
	freq=0
	echo -e "\e[93mRefresh every $sleep seconds\e[0m"
	echo -e "\e[92m$(date '+%Y-%m-%d %H:%M:%S') Entered message loop.\e[0m"

	while :; do
		lastdata="$data"
		data=$(getData "$refresh" "$cookies")
		if [ "$(getFieldArg "$data" card id)" == "forward" ]; then
			#echo -e "\e[37mWebsite: QQ jump\e[0m"
			url="$(getLinkAddr "$data" "这里")"
			data=$(getData "$url" "$cookies")
			#echo -e "$lastdata\n$data" > "$debugfile"
		fi
		if [ ! -z "$(echo "$data" | fgrep "sid已经过期")" ]; then
			echo -e "\e[97m$(date '+%Y-%m-%d %H:%M:%S') \e[91mSID expired, retry: $failed...\e[0m"
			echo -e "$lastdata\n__NEW__\n$data" > "$debugfile"
			if ((failed++ < retry)); then relogin > /dev/null; continue; fi
			if ! login; then exit 1; fi
		elif [ "$(getFieldArg "$data" card title)" == "服务器错误" ]; then
			echo -e "\e[97m$(date '+%Y-%m-%d %H:%M:%S') \e[91mServer error, retry: $failed...\e[0m"
			echo -e "$lastdata\n__NEW__\n$data" > "$debugfile"
			if ((failed++ < retry)); then continue; fi
			exit 1
		elif [ -z "$data" ]; then
			echo -e "\e[97m$(date '+%Y-%m-%d %H:%M:%S') \e[91mEmpty data, retry: $failed...\e[0m"
			echo -e "$lastdata\n__NEW__\n$data" > "$debugfile"
			if ((failed++ < retry)); then continue; fi
			exit 1
		elif [ -z "$(echo "$data" | fgrep "$pattern")" ]; then
			echo -e "\e[97m$(date '+%Y-%m-%d %H:%M:%S') \e[91mConnection failed, retry: $failed...\e[0m"
			echo -e "$lastdata\n__NEW__\n$data" > "$debugfile"
			if ((failed++ < retry)); then relogin > /dev/null; continue; fi
			exit 1
		fi
		if ((failed)); then
			echo -e "\e[92m$(date '+%Y-%m-%d %H:%M:%S') Back to message loop.\e[0m"
			failed=0
		fi

		. "$cmdfile"
		: > "$cmdfile"

		if [ "$(getFieldArg "$data" card title)" == "3GQQ聊天-手机腾讯网" ]; then
			refresh=$(getLinkAddr "$data" "$pattern")
			echo -n "$refresh" > "$urlfile"
			sleep "$sleep"
			if [ `cat ./freq_blank.txt` -le 1 ]; then
				freq=$(($freq + 1))
				echo $freq >./freq_blank.txt
			fi
			continue	# No message, return
		fi

		msgdata=$(echo -n "$data" | sed -n "/${patternA}/,/${patternB}/{
			s/${patternA}//; t
			s/${patternB}//; t
			s/^<br\/>\s*\$//; t
			p
		}")
		if [ -z "$msgdata" ]; then
			sleep "$sleep"
			if [ `cat freq_blank.txt` -le 1 ]; then
				freq=$(($freq + 1))
				echo $freq >./freq_blank.txt
			fi
			continue	# No message, return
			echo "$data" > "$debugfile"
		fi

		if [ `cat ./freq_blank.txt` -ge 2 ] 
		then
			msgHandle
		else
			msgHandle_print
			continue	# Ignore the frist message when It login
		fi
		
	done
}
