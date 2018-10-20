INSTALL="/usr/bin/install"

all: cbsdvnc

glyphs.h: genfont
	./genfont > glyphs.h

genfont: genfont.c
	cc -g -O2 -o $@ src/genfont.c -Wall -lz

cbsdvnc: src/vncterm.c
	cc -O2 -g -o $@ src/vncterm.c -Wall -Wno-deprecated-declarations -ljail -lvncserver -lpthread -lz -ljpeg -lutil -lgnutls -I/usr/local/include -L/usr/local/lib

install:
	if ! test -d /usr/local/cbsd; then \
		mkdir /usr/local/cbsd; \
	fi
	if ! test -d /usr/local/cbsd/modules; then \
		mkdir /usr/local/cbsd/modules; \
	fi
	if ! test -d /usr/local/cbsd/modules/vncterm.d; then \
		mkdir /usr/local/cbsd/modules/vncterm.d; \
	fi
	${INSTALL} -o root -g wheel -m 555 cbsdvnc /usr/local/cbsd/modules/vncterm.d/cbsdvnc
	${INSTALL} -o root -g wheel -m 555 jvncall /usr/local/cbsd/modules/vncterm.d/jvncall
	${INSTALL} -o root -g wheel -m 444 securecmd /usr/local/cbsd/modules/vncterm.d/securecmd
	${INSTALL} -o root -g wheel -m 555 vncterm /usr/local/cbsd/modules/vncterm.d/vncterm
	${INSTALL} -o root -g wheel -m 555 vncterm-daemon /usr/local/cbsd/modules/vncterm.d/vncterm-daemon

clean:
	rm -rf genfont cbsdvnc *.core
