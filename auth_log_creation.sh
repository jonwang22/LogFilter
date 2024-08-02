#!/bin/bash

# Define the output log file in /var/log
log_file="/var/log/auth_log.log"

# Clear the log file if it exists
sudo bash -c "echo '' > $log_file"

# Define arrays of normal and suspicious log messages
normal_messages=(
    "Jul 31 10:15:32 server sshd[1234]: Accepted password for user1 from 192.168.1.1 port 22 ssh2"
    "Jul 31 10:16:12 server sshd[1235]: Accepted publickey for user2 from 192.168.1.2 port 22 ssh2"
    "Jul 31 10:17:45 server sshd[1236]: Session opened for user3 by (uid=0)"
    "Jul 31 10:18:03 server sshd[1237]: Disconnected from user4 192.168.1.4 port 22"
    "Jul 31 10:19:11 server sshd[1238]: Connection from 192.168.1.5 port 22"
    "Jul 31 10:20:34 server sshd[1239]: Session closed for user5"
    "Jul 31 10:21:50 server sshd[1247]: Accepted password for user10 from 192.168.1.12 port 22 ssh2"
    "Jul 31 10:22:30 server sshd[1248]: Accepted publickey for user11 from 192.168.1.13 port 22 ssh2"
    "Jul 31 10:23:15 server sshd[1249]: Session opened for user12 by (uid=0)"
    "Jul 31 10:24:05 server sshd[1250]: Disconnected from user13 192.168.1.14 port 22"
)

suspicious_messages=(
    "Jul 31 10:21:57 server sshd[1240]: Failed password for invalid user admin from 192.168.1.6 port 22 ssh2"
    "Jul 31 10:22:20 server sshd[1241]: Unauthorized access attempt from 192.168.1.7 port 22"
    "Jul 31 10:23:43 server sshd[1242]: error: Could not load host key: /etc/ssh/ssh_host_rsa_key"
    "Jul 31 10:24:09 server sshd[1243]: Failed password for user6 from 192.168.1.8 port 22 ssh2"
    "Jul 31 10:25:30 server sshd[1244]: error: PAM: Authentication failure for user7 from 192.168.1.9"
    "Jul 31 10:26:14 server sshd[1245]: Failed password for user8 from 192.168.1.10 port 22 ssh2"
    "Jul 31 10:27:56 server sshd[1246]: Unauthorized access by user9 detected from 192.168.1.11"
    "Jul 31 10:28:32 server sshd[1251]: Failed password for invalid user root from 192.168.1.15 port 22 ssh2"
    "Jul 31 10:29:15 server sshd[1252]: error: PAM: Authentication failure for user13 from 192.168.1.16"
    "Jul 31 10:30:45 server sshd[1253]: Unauthorized access attempt detected from 192.168.1.17"
)

# Add a mix of normal and suspicious entries to the log file
for i in {1..20}; do
    echo "${normal_messages[$((RANDOM % ${#normal_messages[@]}))]}" | sudo tee -a "$log_file" > /dev/null
    echo "${suspicious_messages[$((RANDOM % ${#suspicious_messages[@]}))]}" | sudo tee -a "$log_file" > /dev/null
done

# Add additional normal entries to balance the log
for i in {1..40}; do
    echo "${normal_messages[$((RANDOM % ${#normal_messages[@]}))]}" | sudo tee -a "$log_file" > /dev/null
done

echo "Log file created at $log_file"
