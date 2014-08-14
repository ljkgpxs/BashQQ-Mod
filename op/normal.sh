same="./question/same"
errfile="./question/err.lst"
lognum=0

function check_err
{
#	echo "Start $PWD $1"
	$same "$1" $errfile
	ret=$?
#	echo "Return code $ret"
	if [ $ret != 0 ]
	then
		echo "不要说脏话哦！"
	fi
}


function emohandle
{
	str=${context:45}
	str=`echo $str | cut -d '.' -f 1`
	str=$(($str + 1))
	str=`echo "$str"p`
	str=`sed -n $str ./question/emoreply.txt`
	if [ -z $str ]; then
		echo "你发的是什么图片表情呀？"
	else
		echo "$str"
	fi
}

function normal
{
	if ((welcomemsg)); then echo "Hello, $sender!"; fi
	func
}

function entry
{
	func
}

function help
{
	echo "帮助功能取消了哦！"
	#	./question/normal.sh
}

function func
{
	lognum=`grep $uid qqlog.txt | wc -l`
	if [ "${context:0:1}" == "@" ] || [ "${context:0:1}" == "＠" ]; then
		if [ -z ${context:1} ]
		then
			echo "您要说什么呢？"
		else
			./question/normal.sh "${context:1}"
		fi
		
	else
		case "$context" in
#		*help* | *Help* | "帮助" ) help;;
		\?*-* |  ？*-*)
			./question/study.sh "$context";;
		"<img "* )
			emohandle;;
		* )
		       if [ $lognum == 0 ]
		       then	
			       echo "您好，我是妹抖.
			主人不在，请稍后联系!
			想和我聊天，可以在消息前面加上@哦!
			--------不要忘了加@哦！"
				check_err "$context"
			else 
				check_err "$context"
				if [ $lognum == 5 ]
			then
				echo "喂,都说主人不在了,怎么还在骚扰他老人家啊？ 不介意的话就和我聊天嘛!
				消息前面不要忘了加@哦！"
			fi
			fi
			echo $uid >>./qqlog.txt;;
		esac
	fi
	exit 0
}

function status
{
	now=$(date +%s)
	echo "$(date -d "@$starttime" '+S: %Y-%m-%d %H:%M:%S'), $(date -d "@$logintime" '+L: %Y-%m-%d %H:%M:%S'), $(date -d "@$now" '+N: %Y-%m-%d %H:%M:%S'), "
	elapsed=$(printf "%.0F" $(echo "$now - $logintime" | bc))
	printf "Duration: %02d:%02d:%02d, " $((elapsed / 3600)) $((elapsed / 60 % 60)) $((elapsed % 60))
	elapsed=$(printf "%.0F" $(echo "$now - $starttime" | bc))
	printf "Elapsed: %02d:%02d:%02d, \n" $((elapsed / 3600)) $((elapsed / 60 % 60)) $((elapsed % 60))
	echo -e "QQ number: $qq, Refresh speed: $sleep"
}
