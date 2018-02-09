# this may result in race condition with the other
# containers which will try to access these folders
mkdir /var/log/common-log/master
mkdir /var/log/common-log/logging
mkdir /var/log/common-log/static
while :
do
	sleep 10
done