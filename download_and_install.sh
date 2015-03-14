#!/bin/sh
ROOT_UID=0   # Root has $UID 0.

if [ "$UID" -eq "$ROOT_UID" ]  # Will the real "root" please stand up?
then
  echo "Logged in as Root"
else
  echo "Would you please log in as root and Restart the script"
  exit 0
fi


echo "Downloading the files from: "
echo "http://fedora-cell-project.googlecode.com/files/"


count=0
countDecimal2="0"


## Check of alle Cell SDK bestanden al gedownload zijn, zo niet download ze nu.
while [ $count -ne 13 ]
do
  if [ $count -lt 10 ]
   then 
     countDecimal2="0"
   else
     countDecimal2=""
  fi

  if [ -f "Cell_SDK$countDecimal2$count" ]
  then
   echo "Cell_SDK$countDecimal2$count exists!"
  else
   echo "Cell_SDK$countDecimal2$count does NOT exists! downloading now."
   wget http://fedora-cell-project.googlecode.com/files/Cell_SDK$countDecimal2$count
  fi
count=`expr $count + 1`
done

## Check of er al een checksum bestand gedownload is, zoniet download die opnieuw.
if [ -f "checksum" ]
  then
   echo "Checksum file exists!"
  else
   echo "Downloading checksum.."
   wget http://fedora-cell-project.googlecode.com/files/checksum
  fi

echo
echo "Merging the files.." 
if [ -f "Cell_SDK_Complete.tar.gz" ]
 then
  echo "Cell_SDK_Complete.tar.gz allready exists,"
  echo "A new one will be created."
  rm -rf Cell_SDK_Complete.tar.gz
fi
ls Cell_SDK?? | while read a; do cat $a >> Cell_SDK_Complete.tar.gz; done
echo "Checking if everything was downloaded correctly"
md5sum -c checksum

if [ $? = 0 ]  # Kijk of de sum gelijk is aan de check
then
  echo -e '\033[1;32mFiles are correct\033[0m' 
else
  echo -e '\033[1;31mFiles are corrupt!!\033[0m' 
  echo -e '\033[1;31mExiting..\033[0m' 
  echo -n Press "<Enter>" to close this window.
  read ex
  exit 0
read x
fi

echo "Removing files.."
rm -rf Cell_SDK?? #remove de gesplitste files.

echo "Extracting the installer.."
tar -xzvf Cell_SDK_Complete.tar.gz
if [ -d "Cell_SDK_Complete" ]
 then
  echo "Extracting completed!"
  echo "Executing install script."
  cd Cell_SDK_Complete/
  sh installsdk.sh
 else
  echo -e '\033[1;31mSomething went wrong when trying to extract..\033[0m' 
  echo -e '\033[1;31mPlease do this manualy and report it at:\033[0m' 
  echo -e '\033[1;31mhttp://fedora-cell-project.googlecode.com\033[0m' 
fi
