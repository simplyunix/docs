# Listing the missing paths can be achieved using the following:
# lspath |grep –i missing
Missing  hdisk20 fscsi0
Missing  hdisk20 fscsi0
Missing  hdisk20 fscsi1
Missing  hdisk20 fscsi1

# let’s get the name, parent connection and the status returned with:
# lspath -l hdisk20 -H -F "name:parent:connection:status" 
hdisk20:fscsi0:5001738065920143,6000000000000:Missing
hdisk20:fscsi0:5001738065920151,6000000000000:Missing
hdisk20:fscsi1:5001738065920183,6000000000000:Missing
hdisk20:fscsi1:5001738065920171,6000000000000:Missing

# I could now use the following to remove the first path in the output:
rmpath –dl hdisk20 –p fscsi0 –w 5001738065920143,6000000000000

# Now that we know how to remove a path individually, 
# let’s put that information into a simple listing. 
# The following listing contains the script:
#!/bin/sh
# rmpaths
>xrmpaths
echo "#!/bin/sh" >>xrmpaths
disks=$(lspv | awk '{print $1}')
for loop in $disks
do
lspath -l $loop -H -F "name:parent:connection:status" |grep Missing| awk -F: '{print "rmpath -dl",$1,"-p", $2, "-w", $3}'>>xrmpaths
done

# This script gives us a listing of all disks on the system. Then using that list, the script loops through parsing each disk into 
# the lspath command to output a listing of missing paths. Using awk we fill in the gaps to produce the correct syntax for the 
# rmpath command. The output produces the file xrmpaths, which contains the paths to remove. Though I have grepped for “Missing” 
# this could be placed with “Failed”. The resulting output file (script) xrmpaths may look like:
#!/bin/sh
rmpath –dl hdisk20 –p fscsi0 –w 5001738065920143,6000000000000
rmpath –dl hdisk20 –p fscsi0 –w 5001738065920151,6000000000000
rmpath –dl hdisk20 –p fscsi1 –w 5001738065920183,6000000000000
rmpath –dl hdisk20 –p fscsi1 –w 5001738065920171,6000000000000

Or

disks=$(lspv | awk '{print $1}')
for disk in $disks
do
lspath -l $disk  -F "name:parent:connection:status" | awk -F ":"  '/Disabled|Failed/ {print "rmpath -dl", $1, "-p", $2, "-w", $3}'
done

