#!/bin/sh

# unquote CALLING_STATION_ID which is set by radius
CALLING_STATION_ID=`echo $CALLING_STATION_ID| tr -d '".-'`

RADDB=/etc/raddb

# Set defaults.
TunnelType="VLAN"
TunnelMediumType="IEEE-802"
TunnelPrivateGroupId="48"

ENVFILE=$RADDB/script/mac_query.env
#ENVFILE=/tmp/radius_mac_query.env
env > $ENVFILE

if tty >/dev/null
then
  set -x
fi


VLAN=`fgrep -i ${CALLING_STATION_ID} $RADDB/mactab | head -1 | ( read OLDMAC VLAN JUNK; echo $VLAN )`
if [ -z "${VLAN}" ]
then
  echo "Could not find Calling-Station-Id = $CALLING_STATION_ID in $RADDB/mactab" >> $ENVFILE
  VLAN=48
else
  echo "Found Calling-Station-Id = $CALLING_STATION_ID in $RADDB/mactab" >> $ENVFILE
fi

TunnelPrivateGroupId=$VLAN
#echo "Tunnel-Private-Group-Id:0 = \"${TunnelPrivateGroupId}\""
echo "Tunnel-Private-Group-Id:0 = \"${TunnelPrivateGroupId}\""
echo "Tunnel-Private-Group-Id = ${TunnelPrivateGroupId}" >> $ENVFILE
echo "VLAN = $VLAN" >> $ENVFILE
echo "Calling-Station-Id = $CALLING_STATION_ID" >> $ENVFILE

exit 0

# Only alter Wireless-802.11 requests.
if [ "${NAS_PORT_TYPE}" = "Wireless-802.11" -a "${REALM}" != "internal.org.com.au" ]; then
  # Determine VLAN to be used.
  if [ "${REALM}" = "some.other.org.net.au" ]; then
      # Force user into specific tunnel group.
      TunnelPrivateGroupId="1234"
    elif [ "${REALM}" = "DEFAULT" ]; then
      # Force user into specific tunnel group.
      TunnelPrivateGroupId="4321"
  fi

  # Return actual VLAN assignment.
#  echo "Tunnel-Type:1 = ${TunnelType}"
#  echo "Tunnel-Medium-Type:1 = ${TunnelMediumType}"
#  echo "Tunnel-Private-Group-Id:1 = \"${TunnelPrivateGroupId}\""
fi

exit 0
