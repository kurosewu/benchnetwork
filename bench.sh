#!/bin/bash
# =======================================
# | Benchmark mod by M Fauzan Romandhoni|
# =======================================

DATE=$(date -R | cut -d " " -f -4)

_exists() {
    local cmd="$1"
    if eval type type > /dev/null 2>&1; then
        eval type "$cmd" > /dev/null 2>&1
    elif command > /dev/null 2>&1; then
        command -v "$cmd" > /dev/null 2>&1
    else
        which "$cmd" > /dev/null 2>&1
    fi
    local rt=$?
    return ${rt}
}

get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print $0}' /etc/redhat-release && return    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}
arch=$( uname -m )
    if _exists "getconf"; then
        lbit=$( getconf LONG_BIT )
    else
        echo ${arch} | grep -q "64" && lbit="64" || lbit="32"
    fi

# Download/Upload today
ttoday="$(vnstat | grep today | awk '{print $8" "substr ($9, 1, 3)}')"

# Download/Upload current month
tmon="$(vnstat -m | grep `date +%G-%m` | awk '{print $8" "substr ($9, 1 ,3)}')"

cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
cores=$( awk -F: '/processor/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F'[ :]' '/cpu MHz/ {print $4;exit}' /proc/cpuinfo )
up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
tcpctrl=$( sysctl net.ipv4.tcp_congestion_control | awk -F ' ' '{print $3}' )
opsy=$( get_opsy )
kern=$( uname -r )
hos=$(hostname)
MYIP=$(curl -sS ipv4.icanhazip.com)
domain=$(cat /usr/local/etc/xray/domain)
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )

clear
echo -e " \e[031;1mSystem Info\e[0m ($hos)"
echo -e " -------------------------------"
echo -e " \e[031;1mISP\e[0m: $ISP"
echo -e " \e[031;1mAdress\e[0m: $domain"
echo -e " \e[031;1mIP\e[0m: $MYIP"
echo -e " \e[031;1mTimezone\e[0m: Asia/Jakarta"
echo -e " \e[031;1mOS\e[0m: $opsy"
echo -e " \e[031;1mArch\e[0m: $arch ($lbit Bit)"
echo -e " \e[031;1mKernel\e[0m: $kern"
if [ -n "$cname" ]; then
echo -e " \e[031;1mCPU Model\e[0m: $cname"
else
echo -e " \e[031;1mCPU Model\e[0m: CPU model not detected"
fi
if [ -n "$freq" ]; then
echo -e " \e[031;1mCPU Cores\e[0m: $cores @ $freq MHz"
else
echo -e " \e[031;1mCPU Cores\e[0m: $cores"
fi
echo -e " \e[031;1mSystem uptime\e[0m: $up"
echo -e " \e[031;1mTCP CC\e[0m: $tcpctrl"
echo -e " \e[031;1mBandwidth Today\e[0m: $ttoday ($DATE)"
echo -e " \e[031;1mBandwidth Monthly\e[0m: $tmon ($(date +%B/%Y))"
echo -e " \e[031;1mTelegram\e[0m: http://t.me/zann404"
echo -e " \e[031;1mFacebook\e[0m: http://fb.me/zan404"
echo -e ""
