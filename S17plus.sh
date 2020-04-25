#!/bin/sh

#############################################
# VARIABLE
#
ADDRESS=$1
PORT=80
username=root
password=root

_ant_pool1=sfarm1.btc.sigmapool.com:3333
_ant_pool2=sfarm2.btc.sigmapool.com:3333
_ant_pool3=ru1.btc.sigmapool.com:3333

_ant_pool1=$(jq -nr --arg v "$_ant_pool1" '$v|@uri')
_ant_pool2=$(jq -nr --arg v "$_ant_pool2" '$v|@uri')
_ant_pool3=$(jq -nr --arg v "$_ant_pool3" '$v|@uri')

echo ${_ant_pool1}

_ant_pool1user=$2.0000
_ant_pool1pw=123
_ant_pool2user=$2.0000
_ant_pool1pw=123
_ant_pool3user=$2.0000
_ant_pool1pw=123

COUNTER=1
#################
# PROGRAMM
#
while read line
 do
   li=$(echo $line|tr -d '\n')
   li2=$(echo $li|tr -d ' ')
   if [ ${#line} -lt 2 ]
   then
     continue
   fi
#-#   ping -c 2 -- $li2>>/dev/null
ADDRESS=$li2
echo '	$ADDRESS = '$ADDRESS
echo '	$COUNTER = '$COUNTER
COUNTER=$(printf "%0004d" $COUNTER)
_ant_pool1user=$2.${COUNTER}

_ant_pool2user=${_ant_pool1user}
_ant_pool3user=${_ant_pool2user}

######################################
# CURL POST
#
RET=$(curl --max-time 2 -s "http://$ADDRESS:$PORT/cgi-bin/set_miner_conf.cgi" -H 'Authorization: Digest username="'$username'", realm="antMiner Configuration", nonce="7d9c8566fed24a4148b8b7a362c8cdf1", uri="/cgi-bin/set_miner_conf.cgi", response="aae9ffc8dd0762c8e8e8ea9f5899e174", qop=auth, nc=00000017, cnonce="d8042e5d610f4cdd"' --data "_ant_pool1url=${_ant_pool1}&_ant_pool1user=${_ant_pool1user}&_ant_pool1pw=${_ant_pool1pw}&_ant_pool2url=${_ant_pool2}&_ant_pool2user=${_ant_pool2user}&_ant_pool2pw=${_ant_pool1pw}&_ant_pool3url=${_ant_pool3}&_ant_pool3user=${_ant_pool3user}&_ant_pool3pw=${_ant_pool1pw}&_ant_nobeeper=false&_ant_notempoverctrl=false&_ant_fan_customize_switch=false&_ant_fan_customize_value=&_ant_freq=&_ant_voltage=1950" --compressed)
#'
echo $RET

COUNTER=`expr $COUNTER + 1`
#echo '$COUNTER = '$COUNTER
#echo '$_ant_pool1user = '$_ant_pool1user
##########################################
  if [ $? -gt 0 ]
   then 
      echo 'bad'
  else
      echo 'good'
  fi
done<$1
