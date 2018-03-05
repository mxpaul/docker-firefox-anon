XDG_RUNTIME_DIR=/run/user/1000 docker run --rm -it \
	-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse \
  -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native \
  -v /dev/shm:/dev/shm \
	--group-add $(getent group audio | cut -d: -f3) \
	--device /dev/snd \
mrmxpaul/firefox-anon \
;
	#-v ~/.config/pulse/cookie:/home/tty/.config/pulse/cookie \
	#-v /run/dbus/:/run/dbus/ -v /dev/shm:/dev/shm \
	#--device /dev/snd \
  #-v `pwd`/Downloads:/home/tty/Downloads \
