#!/usr/bin/with-contenv bashio
#magick -version
#/config/www/pics/nature-images.jpg 
CONFIG_PATH=/data/options.json

X_EINK="$(bashio::config 'width')"
Y_EINK="$(bashio::config 'height')"
DIM_EINK="${X_EINK}x${Y_EINK}!"
MQTT_HOST=$(bashio::services mqtt "host")
MQTT_USER=$(bashio::services mqtt "username")
MQTT_PASSWORD=$(bashio::services mqtt "password")
MQTT_PORT=$(bashio::services mqtt "port")
MQTT_ADDON=$(bashio::services mqtt "addon")
#SUPERVISOR_TOKEN=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIwMjUyM2FiNjE0NjE0Zjc4YTY5ZGY4Njg1OGE2OGIxNSIsImlhdCI6MTY2MjY1NDYwNSwiZXhwIjoxOTc4MDE0NjA1fQ.9Xk_qRjYlyBJ3YFVkOigibW8Tcfm2l9Pagm35NyOB54
PIC="/config/www/pics/nature-images.jpg"
echo $MQTT_HOST
echo $MQTT_USER
echo $MQTT_PASSWORD
echo $SUPERVISOR_TOKEN
echo $MQTT_PORT
echo $PIC
echo "Hello"

#curl -sSL http://supervisor/supervisor/ping
#echo ""
#echo "Hello"
#curl -X GET -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" -H "Content-Type: application/json" http://supervisor/core/api/config
#echo ""
#echo "Hello"
#curl -sSL -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/network/info
#echo ""
#echo "Hello"
#echo services

#curl -X GET -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" -H "Content-Type: application/json" http://supervisor/services/


#echo ""
#echo "mqtt"


#curl -X GET -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" -H "Content-Type: application/json" http://supervisor/services/mqtt

#mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASSWORD  -t mqtt_test -m "This IS a TEST"
#mosquitto_pub -h 127.0.0.1 -t home-assistant/switch/1/on -m "Switch is ON"

#mosquitto_pub -h 127.0.0.1  -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASSWORD  -t mqtt_test -m "This IS a TEST"
#mosquitto_pub -h $MQTT_HOST -t home-assistant/switch/1/on -m "Switch is ON"

#	mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -u kohlsn -P buba3Cito35 -t +/eink/\#
gcc -o main main.c
while true
do
	echo "Wait for MQTT"
	mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -u kohlsn -P buba3Cito35 -t +/eink/\# | while read -r payload
	do
		echo "Rx MQTT: ${payload}"
		if [[ $payload == *"pull"* ]]; then
			echo "Pull"
			#Get Random Photo with horizontal orientation
			magick $PIC -resize $DIM_EINK /config/www/pics/pic.jpg
			mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u kohlsn -P buba3Cito35 -t homeassistant/camera/pull -f /config/www/pics/pic.jpg
		elif [[ $payload == *"push"* ]]; then
			echo "Push"
			magick $PIC -resize $DIM_EINK -grayscale Rec709Luminance -depth 4 gray.jpg
			mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u kohlsn -P buba3Cito35 -t homeassistant/camera/push -f gray.jpg
			magick $PIC -resize $DIM_EINK -grayscale Rec709Luminance -depth 4 pic.pgm
			echo "Parsing Started"
			./main
			cp pic.bin /config/www/pics/pic.bin
			echo "Parsing Complete"
			#Send/split up file and send to eink display	
			#mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u kohlsn -P buba3Cito35 -t zigbee2mqtt/eink/display -f pic.bin
		else  
			echo "eink Zigbee"
		fi

	done
	echo "Grayscale Conversion Complete"
	./main
	echo "Parsing Complete"
done

#sftp {user}@{host}:{remoteFileName} {localFileName}
#sftp root@172.31.0.2:/config/www/pics/nature-images.jpg /photo/.
