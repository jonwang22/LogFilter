#!/bin/bash

# You are a Junior Security Analyst at Chase Bank, responsible for monitoring the bank's digital security infrastructure. Recently, you and your team has noticed an increase in suspicious login attempts on the main server. These incidents could indicate potential unauthorized access or brute-force attacks targeting customer accounts.

# As part of the cybersecurity team, your task is to investigate these incidents by analyzing the authentication logs stored on the server. The log file (/var/log/auth_log.log) records all login attempts, and your job is to identify any entries that indicate suspicious login attempts.

# Instructions: Run the script /home/ubuntu/scripts/LogFilterScript to create a auth_log.log file you will analyze. The file will be created in /var/log/auth_log.log. Develop a Bash script to analyze auth_log.log file. Your script should read through each line of the log file, searching for each keyword, which indicates potentially suspicious login attempts. if the line contains this keyword, write the line to a new file called suspicious_activity.log. This file will store all the entries that match the criteria. Automate the script to run daily.

# Define arrays of normal and suspicious log messages
# normal_messages=(
#    "Jul 31 10:15:32 server sshd[1234]: Accepted password for user1 from 192.168.1.1 port 22 ssh2"
#    "Jul 31 10:16:12 server sshd[1235]: Accepted publickey for user2 from 192.168.1.2 port 22 ssh2"
#    "Jul 31 10:17:45 server sshd[1236]: Session opened for user3 by (uid=0)"
#    "Jul 31 10:18:03 server sshd[1237]: Disconnected from user4 192.168.1.4 port 22"
#    "Jul 31 10:19:11 server sshd[1238]: Connection from 192.168.1.5 port 22"
#    "Jul 31 10:20:34 server sshd[1239]: Session closed for user5"
#    "Jul 31 10:21:50 server sshd[1247]: Accepted password for user10 from 192.168.1.12 port 22 ssh2"
#    "Jul 31 10:22:30 server sshd[1248]: Accepted publickey for user11 from 192.168.1.13 port 22 ssh2"
#    "Jul 31 10:23:15 server sshd[1249]: Session opened for user12 by (uid=0)"
#    "Jul 31 10:24:05 server sshd[1250]: Disconnected from user13 192.168.1.14 port 22"
#)

# suspicious_messages=(
#    "Jul 31 10:21:57 server sshd[1240]: Failed password for invalid user admin from 192.168.1.6 port 22 ssh2"
#    "Jul 31 10:22:20 server sshd[1241]: Unauthorized access attempt from 192.168.1.7 port 22"
#    "Jul 31 10:23:43 server sshd[1242]: error: Could not load host key: /etc/ssh/ssh_host_rsa_key"
#    "Jul 31 10:24:09 server sshd[1243]: Failed password for user6 from 192.168.1.8 port 22 ssh2"
#    "Jul 31 10:25:30 server sshd[1244]: error: PAM: Authentication failure for user7 from 192.168.1.9"
#    "Jul 31 10:26:14 server sshd[1245]: Failed password for user8 from 192.168.1.10 port 22 ssh2"
#    "Jul 31 10:27:56 server sshd[1246]: Unauthorized access by user9 detected from 192.168.1.11"
#    "Jul 31 10:28:32 server sshd[1251]: Failed password for invalid user root from 192.168.1.15 port 22 ssh2"
#    "Jul 31 10:29:15 server sshd[1252]: error: PAM: Authentication failure for user13 from 192.168.1.16"
#    "Jul 31 10:30:45 server sshd[1253]: Unauthorized access attempt detected from 192.168.1.17"
#)

# The objective is to find all the suspicious messages in the auth_log.log file and output it into suspicious_activity.log file.
# The main keywords that we are looking for within the suspicious messages are "Failed", "Unauthorized", and "Error". These three keywords are unique to the suspicious messages and searching for them within the file will not flag any of the normal messages.

# Identifying my variables to use for my script. Setting the source file, destination file, keywords array, and a tempfile to temporarily hold onto our output.
logsource="/var/log/auth_log.log"
logdestination="/home/ubuntu/scripts/LogFilterScript/suspicious_activity.log"
keywords=("Failed" "Unauthorized" "Error")
tempfile="/home/ubuntu/scripts/LogFilterScript/tempfile"

# Adding some user friendly output for our users notifying what is happening.
echo "Searching $logsource for suspicious activity..."

# Adding some formatting to the destination file for our output to make it visually pleasing. We're redirecting our echo statements into our destination file.
echo " " >> $logdestination
echo "=============================================================================" >> $logdestination
echo "Suspicious Log Messages found on $(date)" >> $logdestination
echo "=============================================================================" >> $logdestination
echo " " >> $logdestination

# This for loop specifically searches and then outputs the results into a file but the issue is that the results are not in chronilogical order but grouped by keyword. This works but not what we're looking for specifically.
# for keyword in "${keywords[@]}";
# do
#	grep -i "$keyword" $logsource | sort >> $logdestination
# done

# Here, while we are reading the input file line by line, we will look for every word within every line we iterate through and if we find the keyword matching any word
# within that line via regex, then we will write that line into our tempfile for now. 
# We add a break because we don't need to look for any more instances of that word within the line to determine our action so we move on to the next line.
# IFS= is setting the Internal Field Separator to empty so that each line is read as-is. 
# read is the command to read the line from input, -r prevents backslash escapes, line is our variable the read line is stored in.
while IFS= read -r line;
do
	for keyword in "${keywords[@]}";
	do
		if [[ "${line,,}" =~ ${keyword,,} ]]; # ",," is a way for us to test the string in lowercase for the keyword in lowercase without compromising the original state of the line.
		then
			echo "$line" >> "$tempfile" 
			break
		fi
	done
done < $logsource

# Here we are taking the tempfile we created during our while loop, we're sorting the contents and then redirecting that to the destination file.
# Once we've redirected the stdout, we will then remove that tempfile.
sort "$tempfile" >> "$logdestination"
rm "$tempfile"

# Skipping a line within the destination file for user visuals
echo " " >> $logdestination

# Notifying user that script is complete.
echo "Search completed, please look at the $logdestination for results"

# Setting up the cronjob, commenting out command because the cronjob has already been set on ec2 instance.
# crontab -e
# 0 0 * * * /home/ubuntu/scripts/LogFilterScript/logfilter.sh 

