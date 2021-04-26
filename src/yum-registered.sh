#!/bin/bash
# RedHat 8 yum源注册配置

# 注意事项：
# 需要一个RedHat官网账户，订阅并激活
# 检查系统是否联网，注册需联网配置
# 检查系统时间是否正确

# 可能报错：This system is registered to Red Hat Subscription Management, but is not receiving updates. You can use subscription-manager to assign subscriptions
# 存在问题:
# 1.日期和时间错误
# 2.系统可能已经注册但没有附加订阅
# 解决方法：
# 1.修改对应的日期和时间 （此项需手动修改）
# 2.使用命令：subscription-manager attach --auto 已在脚本中自动判断，并自动执行

i=1
a=0
while [ ${i} -ne 0 ]
do
	echo "--- Please Enter Account ---"
	echo -n "USERNAME : "
	read user
	echo -n "PASSWORD : "
	read -s passwd
	echo ""
	echo "----------------------------"
	subscription-manager register --auto-attach --username=${user} --password=${passwd} --force
	if [ $? -ne 0 ]
	then
		subscription-manager attach --auto
	fi
	if [ $? -eq 0 ]
	then
		i=0
		yum clean all
		yum repolist
	else
		i=1
		echo -e "\033[43;35m error,please re-register! \033[0m \n"
		let a++
		if [ ${a} -eq 5 ]
		then
			echo -e "\033[43;35m Five errors already! exit 1 \033[0m \n"
			exit 1
		fi
	fi
done
