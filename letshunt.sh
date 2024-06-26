#! /bin/bash

# Ensure correct usage of the script
if [ $# -ne 1 ]; then
    echo "Usage: $0 <target>"
    exit 1
fi

# Assigning target
target=$1
output_dir=~/hacktheworld/$target

# Create output directory
mkdir -p $output_dir

echo "Mapping Attack surface via Subdomain Enumaration"

echo "Starting subfinder"
subfinder -d $target -o $output_dir/subfinder.txt
sort -u $output_dir/subfinder.txt >> $output_dir/subdomains.txt
rm -f $output_dir/subfinder.txt

echo "Starting assetfinder"
assetfinder --subs-only $target | tee $output_dir/assetfinder.txt
sort -u $output_dir/assetfinder.txt >> $output_dir/subdomains.txt
rm -f $output_dir/assetfinder.txt

echo "Starting Sublist3r"
cd ~
cd Sublist3r/
python3 sublist3r.py -d $target | tee $output_dir/sublist3r.txt
cd $output_dir/
awk '/Total Unique Subdomains Found/{p=1; next} p' sublist3r.txt > sorted_sublist3r.txt

echo "Finalizing attack surface"
sort -u $output_dir/subdomains.txt > $output_dir/subdomains_sorted.txt
cat $output_dir/subdomains_sorted.txt | wc -l
