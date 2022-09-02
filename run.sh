#!/usr/bin/with-contenv bashio

echo "Hello world!"
magick -version
pwd
ls -l
#Grab A random photo
#sftp with key?
#/config/www/pics/nature-images.jpg 
magick nature-images.jpg pic.png 
echo "magic complete"
ls -l
#sftp {user}@{host}:{remoteFileName} {localFileName}
#sftp root@172.31.0.2:/config/www/pics/nature-images.jpg /photo/.
