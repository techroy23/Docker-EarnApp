#!/bin/bash
hostname="DESKTOP-$(tr -dc 'A-Z0-9' </dev/urandom | head -c 7)"
machine_id=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
boot_id=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
vendors=("Acer" "Apple" "Asus" "Dell" "HP" "Lenovo" "MSI" "Samsung" "Sony" "LG" "Microsoft" "Alienware" "Razer" "Huawei" "IBM" "Intel" "Panasonic" "Fujitsu" "Toshiba" "Gigabyte" "EVGA" "Zotac" "Google")
vendor=${vendors[$RANDOM % ${#vendors[@]}]}
prefixes=("INS" "PAV" "THK" "ZEN" "OMN" "ASP" "LEG" "VOS" "XPS" "PRD" "ROG" "STR" "ENV" "TUF" "VIO" "GRM")
prefix=${prefixes[$RANDOM % ${#prefixes[@]}]}
model_number=$(shuf -i 10000-99999 -n 1)
suffixes=("LX" "GX" "TX" "VX" "FX" "NX" "ZX" "HX" "DX" "CX")
suffix=${suffixes[$RANDOM % ${#suffixes[@]}]}
version=$(shuf -i 10-99 -n 1)
model="$prefix-$model_number-$suffix$version"
major=$((RANDOM % 9 + 1))
minor=$(printf "%02d" $((RANDOM % 100)))
patch=$((RANDOM % 10))
build=$((RANDOM % 10))
firmware_version="${major}.${minor}.${patch}-${build}"
start_date="2010-01-01"
end_date="2020-12-31"
start_sec=$(date -d "$start_date" +%s)
end_sec=$(date -d "$end_date" +%s)
rand_sec=$(shuf -i ${start_sec}-${end_sec} -n 1)
firmware_date=$(date -d "@$rand_sec" "+%a %Y-%m-%d")
firmware_date_only=$(echo "$firmware_date" | cut -d' ' -f2)
firmware_date_sec=$(date -d "$firmware_date_only" +%s)
today_sec=$(date +%s)
diff_sec=$(( today_sec - firmware_date_sec ))
diff_days=$(( diff_sec / 86400 ))
years=$(( diff_days / 365 ))
rem_days=$(( diff_days % 365 ))
months=$(( rem_days / 30 ))
days=$(( rem_days % 30 ))
firmware_age="${years}y ${months}month ${days}d"

cat << 'EOF' > /usr/bin/lsb_release
#!/bin/bash
echo "No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 24.04 LTS
Release:        24.04
Codename:       noble"
EOF

cat << EOF > /usr/bin/hostnamectl
#!/bin/bash
echo " Static hostname: ${hostname}
       Icon name: computer
         Chassis: desktop
      Machine ID: ${machine_id}
         Boot ID: ${boot_id}
  Virtualization: none
Operating System: Ubuntu 24.04 LTS
          Kernel: Linux 6.15.0-00-generic
    Architecture: x86-64
 Hardware Vendor: ${vendor}
  Hardware Model: ${model}
Firmware Version: ${firmware_version}
   Firmware Date: ${firmware_date}
    Firmware Age: ${firmware_age}"
EOF

chmod a+x /usr/bin/lsb_release /usr/bin/hostnamectl
