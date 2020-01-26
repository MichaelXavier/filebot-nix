#!/bin/bash
# https://aur.archlinux.org/cgit/aur.git/tree/filebot-arch.sh?h=filebot

# force JVM language and encoding settings
# TODO: drop
# export LANG="en_US.UTF-8"
# export LC_ALL="en_US.UTF-8"

# TODO: set this
PRG="$0"
# resolve relative symlinks
while [ -h "$PRG" ] ; do
	ls=`ls -ld "$PRG"`
	link=`expr "$ls" : '.*-> \(.*\)$'`
	if expr "$link" : '/.*' > /dev/null; then
		PRG="$link"
	else
		PRG="`dirname "$PRG"`/$link"
	fi
done

# get canonical path
PRG_DIR=`dirname "$PRG"`
FILEBOT_HOME=`cd "$PRG_DIR" && pwd`

APP_ROOT=$FILEBOT_HOME
JAR_DIR=$APP_ROOT/jar

# add APP_ROOT to LD_LIBRARY_PATH
#TODO: this is probably an issue
if [ ! -z "$LD_LIBRARY_PATH" ]; then
	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$APP_ROOT"
else
	export LD_LIBRARY_PATH="$APP_ROOT"
fi

# choose extractor
EXTRACTOR="ApacheVFS"			# use Apache Commons VFS2 with junrar plugin
# EXTRACTOR="SevenZipExecutable"	# use the 7z executable
# EXTRACTOR="SevenZipNativeBindings"	# use the lib7-Zip-JBinding.so native library

# start filebot
java -Dsun.java2d.opengl=true -Dunixfs=false -DuseGVFS=false -DuseExtendedFileAttributes=true -DuseCreationDate=false -Djava.net.useSystemProxies=false -Dapplication.deployment=AUR -Dfile.encoding="UTF-8" -Dsun.jnu.encoding="UTF-8" -Djna.nosys=false -Djna.nounpack=true -Dnet.filebot.Archive.extractor="$EXTRACTOR" -Dnet.filebot.AcoustID.fpcalc="fpcalc" -Dapplication.dir=$HOME/.config/filebot -Djava.io.tmpdir=/tmp/filebot -Dapplication.update=skip -Djna.library.path=$JAR_DIR $JAVA_OPTS -cp $JAR_DIR/filebot.jar net.filebot.Main "$@"

