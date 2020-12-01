#! /usr/bin/env bash

target="${1:-google.com}"

dnshosts=()
dnshostsv6=()
# cloudflare
dnshostsv6+=('2606:4700:4007::1001')
dnshostsv6+=('2606:4700:4700::1111')
dnshosts+=('1.0.0.1')
dnshosts+=('1.1.1.1')

# quadnine dns
dnshostsv6+=('2620:fe::fe')
dnshostsv6+=('2620:fe::9')
dnshosts+=('9.9.9.9')
dnshosts+=('149.112.112.112')

# opendns, no-filtering
dnshostsv6+=('2620:0:ccc::2')
dnshostsv6+=('2620:0:ccd::2')

# opendns
dnshostsv6+=('2620:119:35::35')
dnshostsv6+=('2620:119:53::53')
dnshosts+=('208.67.222.222')
dnshosts+=('208.67.220.220')

# google public dns
dnshostsv6+=('2001:4860:4860::8888')
dnshostsv6+=('2001:4860:4860::8844')
dnshosts+=('8.8.8.8')
dnshosts+=('8.8.4.4')

# dyn dns
dnshosts+=('216.146.35.35')
dnshosts+=('216.146.36.36')

echo "${dnshosts[*]}"
echo "${dnshosts[@]}"

for dns in "${dnshosts[@]}"; do
  i="10";
  time="0";
  echo -n "${dns}: "
  while [ $i -gt 0 ]; do
    # dig "@${dns}" "${target}" A | awk -v DNS="$dns" '$3 ~ "time" {print $4,DNS}'
    trip=$(dig "@${dns}" "${target}" A | awk '$3 ~ "time" {print $4}')
    time=$((time + trip))
    ((i--))
  done
  echo $time
done # | sort -nk2

# for dns in "${dnshostsv6[@]}"; do
#   echo "${dns}"
#   dig -6 "@${dns}" "google.com" AAAA +short
#   echo
# done
