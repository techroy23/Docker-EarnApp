#!/bin/bash

##### Hostname Generation Section #####
# Generate a hostname with the prefix "DESKTOP-" followed by a random 7-character uppercase alphanumeric string.
hostname="DESKTOP-$(tr -dc 'A-Z0-9' </dev/urandom | head -c 7)"

##### Machine ID and Boot ID Section #####
# Generate a machine identifier by reading 16 bytes from /dev/urandom,
# converting them to hexadecimal format, and removing whitespace.
machine_id=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
# Generate a boot identifier using the same method.
boot_id=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')

##### Vendor and Model Generation Section #####

# Define an array of possible hardware vendor names.
vendors=("Acer" "Apple" "Asus" "Dell" "HP" "Lenovo" "MSI" "Samsung" "Sony" "LG" "Microsoft" "Alienware" "Razer" "Huawei" "IBM" "Intel" "Panasonic" "Fujitsu" "Toshiba" "Gigabyte" "EVGA" "Zotac" "Google")
# Randomly select one vendor from the vendors array.
vendor=${vendors[$RANDOM % ${#vendors[@]}]}

# Define an array of prefixes for the hardware model.
prefixes=("INS" "PAV" "THK" "ZEN" "OMN" "ASP" "LEG" "VOS" "XPS" "PRD" "ROG" "STR" "ENV" "TUF" "VIO" "GRM")
# Randomly select one prefix from the prefixes array.
prefix=${prefixes[$RANDOM % ${#prefixes[@]}]}
# Generate a random model number between 10000 and 99999.
model_number=$(shuf -i 10000-99999 -n 1)
# Define an array of suffixes for the hardware model.
suffixes=("LX" "GX" "TX" "VX" "FX" "NX" "ZX" "HX" "DX" "CX")
# Randomly select one suffix from the suffixes array.
suffix=${suffixes[$RANDOM % ${#suffixes[@]}]}
# Generate a random version number between 10 and 99.
version=$(shuf -i 10-99 -n 1)
# Construct the full hardware model string using the selected prefix, model number, suffix, and version.
model="$prefix-$model_number-$suffix$version"

##### Firmware Version Generation Section #####
# Generate random numbers for each part of the firmware version:
major=$((RANDOM % 9 + 1))         # Major version: random number between 1 and 9.
minor=$(printf "%02d" $((RANDOM % 100)))  # Minor version: random two-digit number with leading zero if needed.
patch=$((RANDOM % 10))            # Patch level: random number between 0 and 9.
build=$((RANDOM % 10))            # Build number: random number between 0 and 9.
# Construct the firmware version string in the format "major.minor.patch-build".
firmware_version="${major}.${minor}.${patch}-${build}"

##### Firmware Date and Age Calculation Section #####
# Define a start and end date for generating a random firmware date.
start_date="2010-01-01"
end_date="2020-12-31"
# Convert the start and end dates into seconds since the epoch.
start_sec=$(date -d "$start_date" +%s)
end_sec=$(date -d "$end_date" +%s)
# Generate a random second between start_sec and end_sec.
rand_sec=$(shuf -i ${start_sec}-${end_sec} -n 1)
# Convert the random seconds value back into a formatted date string.
firmware_date=$(date -d "@$rand_sec" "+%a %Y-%m-%d")
# Extract only the date part (ignoring the day abbreviation) for further computations.
firmware_date_only=$(echo "$firmware_date" | cut -d' ' -f2)
# Convert the extracted firmware date into seconds since the epoch.
firmware_date_sec=$(date -d "$firmware_date_only" +%s)
# Get the current time in seconds since the epoch.
today_sec=$(date +%s)
# Calculate the difference in seconds between today and the firmware date.
diff_sec=$(( today_sec - firmware_date_sec ))
# Convert the seconds difference into total days.
diff_days=$(( diff_sec / 86400 ))
# Determine the full years passed by dividing the total days by 365.
years=$(( diff_days / 365 ))
# Calculate the remaining days after accounting for full years.
rem_days=$(( diff_days % 365 ))
# Convert the remaining days into months (approximately 30 days per month).
months=$(( rem_days / 30 ))
# Determine the leftover days after months are accounted for.
days=$(( rem_days % 30 ))
# Construct a human-readable firmware age string.
firmware_age="${years}y ${months}month ${days}d"

##### Custom lsb_release Script Creation Section #####
# Create a custom lsb_release script that outputs Linux Standard Base (LSB) information.
cat << 'EOF' > /usr/bin/lsb_release
#!/bin/bash
echo "No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 24.04 LTS
Release:        24.04
Codename:       noble"
EOF

##### Custom hostnamectl Script Creation Section #####
# Create a custom hostnamectl script that displays system information.
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

##### Permissions Section #####
# Make both the lsb_release and hostnamectl scripts executable.
chmod a+x /usr/bin/lsb_release /usr/bin/hostnamectl
