#! /bin/sh
#@
#@ sustain - keep SSH connection open
#@

SLEEP_TIME=3;

MyIP()
{
	local_ip=$(/sbin/ifconfig | sed -e 's/.*inet addr:/inet /' | awk '($1 == "inet") {print $2; exit 0}');
	public_ip=$(curl -s ifconfig.io);
	echo "Internal IP:   |" "${local_ip}";
	echo "Public IP:     |" "${public_ip}";
} 

Hostname()
{
	h=$(hostname)

	if [ -f /etc/khostname ]; then
		k=$(cat /etc/khostname);
		h=$(echo "$h" | awk -F. '{print $1}'); # trim possible domain name
		echo "Hostname:      |" "${k} / ${h}";
	else
		echo "Hostname:      |" "${h}";
	fi		
} 

UpTime()
{
	echo "Uptime:        |" "$(uptime -p)";
} 

Users()
{
	users=$(who | awk '{print $1 $5}');
	for i in ${users}; do
  		echo "User:          |" "${i}";
	done
}

CPU()
{
	echo "CPU:           | `LC_ALL=C top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'`%";
}

RAM()
{
	echo "RAM total:     | `free -g | awk '/Mem:/ {printf "%d", ($2 + 1)}'` GB";
	echo "RAM used:      | `free -m | awk '/Mem:/ { printf("%3.1f%%", $3/$2*100) }'`";
}

Memory()
{
	echo "Memory total:  | `df -h / | awk '/\// {print $(NF-4)}'`";
	echo "Memory used:   | `df -h / | awk '/\// {print $(NF-1) "(" $(NF-3) ")"}'`";
}

DisplayStats()
{
	echo "_________________________________________________________________";
	MyIP
	Hostname
	UpTime
	Users
	CPU
	RAM
	Memory
	echo "_________________________________________________________________";
}

DisplayImage()
{
	# image can be changed https://fsymbols.com/generators/carty
	cat << EOF 

░██████╗███████╗██████╗░██╗░░░██╗███████╗██████╗░  ██╗░░██╗░█████╗░░█████╗░██╗░░██╗███████╗██████╗░
██╔════╝██╔════╝██╔══██╗██║░░░██║██╔════╝██╔══██╗  ██║░░██║██╔══██╗██╔══██╗██║░██╔╝██╔════╝██╔══██╗
╚█████╗░█████╗░░██████╔╝╚██╗░██╔╝█████╗░░██████╔╝  ███████║███████║██║░░╚═╝█████═╝░█████╗░░██║░░██║
░╚═══██╗██╔══╝░░██╔══██╗░╚████╔╝░██╔══╝░░██╔══██╗  ██╔══██║██╔══██║██║░░██╗██╔═██╗░██╔══╝░░██║░░██║
██████╔╝███████╗██║░░██║░░╚██╔╝░░███████╗██║░░██║  ██║░░██║██║░░██║╚█████╔╝██║░╚██╗███████╗██████╔╝
╚═════╝░╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═╝░░╚═╝  ╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝╚══════╝╚═════╝░

EOF
}

option="$1"
if [ $# -ne 0 ]; then
	awk '/^#@/ {print substr($0,3)}' $0
	exit 1
fi

clear;
imageDisplayed=0

while [ 1 ]
do
	if [[ ${imageDisplayed} -eq 0 ]]; then
		DisplayStats;
		imageDisplayed=1;
	else
		DisplayImage
		imageDisplayed=0;
	fi
	sleep ${SLEEP_TIME};
	clear;
done
