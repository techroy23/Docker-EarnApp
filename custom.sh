#!/bin/bash
# This script creates spoof scripts for lsb_release and hostnamectl
# with randomized output to simulate a typical desktop environment.

# -----------------------------
# Generate random values
# -----------------------------

# Generate a static "desktop" hostname of the form DESKTOP-XXXXXXX (7 random uppercase alphanumeric characters)
hostname="DESKTOP-$(tr -dc 'A-Z0-9' </dev/urandom | head -c 7)"

# Generate random 32 character hex strings (16 bytes) for Machine ID and Boot ID.
machine_id=$(xxd -p -l 16 /dev/urandom)
boot_id=$(xxd -p -l 16 /dev/urandom)

# Pick a random vendor from the array.
vendors=("Acer" "Apple" "Asus" "Dell" "HP" "Lenovo" "MSI" "Samsung" "Sony" "LG" "Microsoft" "Alienware" "Razer" "Huawei" "IBM" "Intel" "Panasonic" "Fujitsu" "Toshiba" "Gigabyte" "EVGA" "Zotac" "Google")
vendor=${vendors[$RANDOM % ${#vendors[@]}]}

# Generate a model
prefixes=("INS" "PAV" "THK" "ZEN" "OMN" "ASP" "LEG" "VOS" "XPS" "PRD" "ROG" "STR" "ENV" "TUF" "VIO" "GRM")
prefix=${prefixes[$RANDOM % ${#prefixes[@]}]}
model_number=$(shuf -i 10000-99999 -n 1)
suffixes=("LX" "GX" "TX" "VX" "FX" "NX" "ZX" "HX" "DX" "CX")
suffix=${suffixes[$RANDOM % ${#suffixes[@]}]}
version=$(shuf -i 10-99 -n 1)
model="$prefix-$model_number-$suffix$version"

# Generate a random Firmware Version in the format X.XX.X-X 
major=$((RANDOM % 9 + 1))
minor=$(printf "%02d" $((RANDOM % 100)))
patch=$((RANDOM % 10))
build=$((RANDOM % 10))
firmware_version="${major}.${minor}.${patch}-${build}"

# Generate a random Firmware Date within a specified range.
# Format the random date as "Day YYYY-MM-DD" (e.g., "Tue 2014-04-01")
start_date="2010-01-01"
end_date="2020-12-31"
start_sec=$(date -d "$start_date" +%s)
end_sec=$(date -d "$end_date" +%s)
rand_sec=$(shuf -i ${start_sec}-${end_sec} -n 1)
firmware_date=$(date -d "@$rand_sec" "+%a %Y-%m-%d")

# Calculate the firmware age as the difference between today's date and the firmware date using pure Bash.
# First, extract the "YYYY-MM-DD" portion from the firmware_date.
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


# -----------------------------
# Create the spoof scripts
# -----------------------------

# Create a spoof for lsb_release:
# This file provides static data for lsb_release -a.
cat << 'EOF' > /usr/bin/lsb_release
#!/bin/bash
echo "No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 24.04 LTS
Release:        24.04
Codename:       noble"
EOF

# Create a spoof for hostnamectl:
# This file outputs a formatted string with our randomized values.
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

# Make both scripts executable.
chmod a+x /usr/bin/lsb_release /usr/bin/hostnamectl

echo "Spoof scripts for lsb_release and hostnamectl have been created and set as executable."
