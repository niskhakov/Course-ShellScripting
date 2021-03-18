#!/bin/bash

# This script shows the open network ports on a system
# Use -4 as an argument to limit to tcpv4 ports

netstat -nutl ${1} | grep ':' | awk '{print  $4}' | awk -F ':' '{print $NF}'

# -p option on netstat shows program that using this port, root required
# sudo netstat -nutlp

#     1  cut -c 1 /etc/passwd
#     2  cut -c 7 /etc/passwd
#     3  cut -c 7-7 /etc/passwd
#     4  cut -c 4-7 /etc/passwd
#     5  cut -c 4- /etc/passwd
#     6  cut -c -4 /etc/passwd
#     7  cut -c 1-4 /etc/passwd
#     8  cut -c 1,3,5 /etc/passwd
#     9  cut -c 999 /etc/passwd
#    10  cut -b  /etc/passwd
#    11  cut -b 1 /etc/passwd
#    12  cut -b 2 /etc/passwd
#    13  cut -f /etc/passwd
#    14  echo -e "one\ttwo\tthree" | cut -f 1
#    15  echo -e "one\ttwo\tthree" | cut -f 2
#    16  echo -e "one\ttwo\tthree" | cut -f 3
#    17  echo -e "one,two,three" | cut -d ',' -f 3
#    18  echo -e "one,two,three" | cut -d ',' -f 2
#    19  echo -e "one,two,three" | cut -d ',' -f 1
#    20  echo -e "one\ttwo\tthree" | cut -d '\' -f 2
#    21  echo "one\ttwo\tthree" | cut -d '\' -f 2
#    22  cut -d ':' -f 1,3 /etc/passwd
#    23  cut -d ':' -f 1,3 --output-delimiter="," /etc/passwd
#    24  echo 'first,last' > people.csv
#    25  echo 'John,Smith' >> people.csv
#    26  echo 'fristly,mclasty' >> people.csv
#    27  echo 'nail,iskhakov' >> people.csv
#    28  cat people.csv
#    29  cut -d ',' -f 1 people.csv
#    30  grep first people.csv
#    31  grep 'first,last' people.csv
#    32  grep '^first' people.csv
#    33  grep 'last$' people.csv
#    34  grep '^first,last$' people.csv
#    35  grep -v '^first,last$' people.csv
#    36  grep -v '^first,last$' people.csv | cut -d ',' -f 1
#    37  cut -d ',' -f 1 people.csv | grep -v '^first$'
#    38  awk -F 'DATA:' '{print $2}' people.csv
#    39  cut -d ':' -f 1,3 /etc/passwd
#    40  awk -F ':' '{print $1, $3}' /etc/passwd
#    41  awk -F ':' '{print $1 $3}' /etc/passwd
#    42  awk -F ':' '{print $1, $3}' /etc/passwd
#    43  awk -F ':' -v OFS=',' '{print $1, $3}' /etc/passwd
#    44  awk -F ':' '{print $1 "," $2}' /etc/passwd
#    45  awk -F ':' '{print $1 "," $3}' /etc/passwd
#    46  awk -F ':' '{print $1 ", " $3}' /etc/passwd
#    47  awk -F ':' '{print "COL1:" $1 ", COL3:^C$3}' /etc/passwd
#    48  awk -F ':' '{print "COL1:" $1 ", COL3:"$3}' /etc/passwd
#    49  awk -F ':' '{print $3 $1}' /etc/passwd
#    50  awk -F ':' '{print "UID:" $3 ";LOGIN:"  $1}' /etc/passwd
#    51  awk -F ':' '{print $NF}' /etc/passwd
#    52  awk -F ':' '{print $(NF-1)}' /etc/passwd
#    53  echo 'L1C1    L1C2' > lines
#    54  echo '    L2C1 L2C2   ' >> lines
#    55  echo ' L3C1   L3C3' >> lines
#    56  echo -e 'L4C1\tL4C2' >> lines
#    57  cat lines
#    58  awk '{print $1, $2}' lines
#    59  netstat -nutl
#    60  netstat -nutl | grep -v '^Active'
#    61  netstat -nutl | grep -v '^Active' | grep -v '^Proto'
#    62  netstat -nutl | grep -Ev '^Active|^Proto'
#    63  netstat -nutl
#    64  netstat -nutl | grep ':'
#    65* netstat -nutl |
#    66  netstat -nutl | grep ':' | awk '{print  $4}'
#    67  netstat -nutl | grep ':' | awk '{print  $4}' | awk -F ':' '{print $NF}'
#    68  netstat -4nutl | grep ':' | awk '{print  $4}' | awk -F ':' '{print $NF}'
#    69  netstat -4nutl
#    70  netstat -4nutl | grep ':' | awk '{print  $4}' | cut -d ':' -f 2
#    71  netstat -4nutl | grep ':' | awk '{print  $4}' | awk -F ':' '{print $NF}'
#    72  cd /vagrant/
#    73  ./luser-demo13.sh -4
#    74  ./luser-demo13.sh
#    75  ./luser-demo13.sh -p
#    76  sudo netstat -nutlp
#    77  sudo netstat -nutlp | grep 22