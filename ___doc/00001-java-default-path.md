sudo vim  /etc/profile

Add following lines in end

JAVA_HOME=/home/claivent/.jdks/corretto-17.0.16
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
export JAVA_HOME
export JRE_HOME
export PATH
