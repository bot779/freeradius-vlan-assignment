# freeradius-vlan-assignment
Dynamically assign VLANs based on MAC address (or other) attributes

mac_query.sh is an external BASH script, called from freeradius.
(Freeradius must be configured to do this via its config files)

mac_query.sh assigns a VLAN based on CALLING_STATION_ID attribute (MAC address)
when a corresponding entry is found in the "mactab" file.

This (VLAN assignment) works for cisco wireless lan controllers (WLCs) and Ruckus ZoneDirectors.

Another version of this code once worked well with 802.1x for Extreme (wired) switches.
(especially with the Extreme multiple supplicant feature and with mac auth bypass)

It tested/worked with cisco switches.
(cisco switches seemed to require a different 802.1x config based on the switch model involved)

The mactab file contains space delimited lines/records of the format: MAC, followed by VLAN, followed by (optional) comments.
