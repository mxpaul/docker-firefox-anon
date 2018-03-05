FROM alpine:edge

LABEL maintainer mxpaul <mmonk@cpan.org>

ENV GROUP=wheel
ENV UID=1000
ENV FF_PROGRAM_DIR=/usr/lib/firefox-52.6.0
ENV FF_GENERAL_CONFIG_PATH=$FF_PROGRAM_DIR/mozilla.cfg
ENV FF_PREF_DIR=$FF_PROGRAM_DIR/browser/defaults/preferences

RUN apk add --no-cache \
	--repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
	ttf-ubuntu-font-family \
	firefox-esr \
	vlc \
	vlc-plugins-video_chroma \
	vlc-plugins-video_filter \
	vlc-plugins-stream_out \
	vlc-plugins-stream_filter \
	vlc-plugins-mux \
	vlc-plugins-meta_engine \
	vlc-plugins-codec \
	vlc-plugins-gui \
	vlc-plugins-misc \
	vlc-plugins-visualization \
	vlc-libs \
	shadow \
	alsa-lib \
	alsa-plugins-pulse \
	pulseaudio\
;

#RUN apk add --no-cache strace

RUN adduser -u ${UID} -G ${GROUP} -D tty
RUN usermod -a -G audio tty
#RUN usermod -a -G audio,video tty

#RUN perl -E 'say map {sprintf ("%x", int(256*rand())) } 1..16' > /etc/machine-id
RUN touch /etc/machine-id && chmod 0666 /etc/machine-id
RUN echo '#!/bin/sh' > /usr/bin/firefox-runner
RUN echo 'printf "%04x" $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM > /etc/machine-id && /usr/bin/firefox --no-remote' >> /usr/bin/firefox-runner
RUN chmod 0755 /usr/bin/firefox-runner
RUN cat /usr/bin/firefox-runner

RUN echo '// Required line to ignore it!' > $FF_PREF_DIR/00_admin-prefs.js
RUN echo 'pref("general.config.filename", "mozilla.cfg");' >> $FF_PREF_DIR/00_admin-prefs.js
RUN echo 'pref("general.config.obscure_value", 0);' >> $FF_PREF_DIR/00_admin-prefs.js
#RUN cat $FF_PREF_DIR/00_admin-prefs.js


COPY --chown=0:0 mozilla.cfg $FF_GENERAL_CONFIG_PATH
RUN chmod 0644 $FF_GENERAL_CONFIG_PATH

ADD --chown=0:0 extensions.tgz $FF_PROGRAM_DIR/distribution/

USER tty

ENTRYPOINT [ "/usr/bin/firefox-runner" ]
#WORKDIR /usr/lib/firefox-52.6.0
#ENTRYPOINT [ "/bin/sh" ]
#ENTRYPOINT [ "strace", "-f", "-e", "trace=stat", "firefox" ]

