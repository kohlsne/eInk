#!/bin/sh
X_EINK=1872
Y_EINK=1404
DIM_EINK="${X_EINK}x${Y_EINK}!"
MQTT_HOST=172.31.0.2
MQTT_USER=kohlsn
MQTT_PASSWORD=buba3Cito35
MQTT_PORT=1883
PIC="/photos/pic.jpg"
echo $MQTT_HOST
echo $MQTT_USER
echo $MQTT_PASSWORD
echo $MQTT_PORT
echo $PIC
echo "Hello"

mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASSWORD  -t mqtt_test -m "This IS a TEST"
#mosquitto_pub -h 127.0.0.1 -t home-assistant/switch/1/on -m "Switch is ON"

#mosquitto_pub -h 127.0.0.1  -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASSWORD  -t mqtt_test -m "This IS a TEST"
#mosquitto_pub -h $MQTT_HOST -t home-assistant/switch/1/on -m "Switch is ON"

#	mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -u kohlsn -P buba3Cito35 -t +/eink/\#
gcc -o main main.c
while true
do
	echo "Wait for MQTT"
	mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASSWORD -t homeassistant/eink/\# | while read -r payload
	do
		echo "Rx MQTT: ${payload}"
		if [[ $payload == *"pull"* ]]; then
			echo "Pull"
			#Get Random Photo with horizontal orientation
			magick $PIC -resize $DIM_EINK resize.jpg
			mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASSWORD -t homeassistant/camera/pull -f resize.jpg
		elif [[ $payload == *"push"* ]]; then
			echo "Push"
			magick $PIC -resize $DIM_EINK -grayscale Rec709Luminance -depth 4 gray.jpg
			mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASSWORD -t homeassistant/camera/push -f gray.jpg
			magick $PIC -resize $DIM_EINK -grayscale Rec709Luminance -depth 4 pic.pgm
			echo "Parsing Started"
			./main
		#	cp pic.bin /config/www/pics/pic.bin
			echo "Parsing Complete"
			#Send/split up file and send to eink display	
			mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASSWORD -t zigbee2mqtt/eink/display -f pic.bin
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
