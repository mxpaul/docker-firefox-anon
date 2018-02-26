docker run --rm -it \
	-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
mrmxpaul/firefox-anon \
;
	#-v /run/dbus/:/run/dbus/ -v /dev/shm:/dev/shm \
	#--device /dev/snd \
