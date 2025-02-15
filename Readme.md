# FTP Server for Ubuntu

This script installs and configures an FTP server on Ubuntu using `vsftpd`. It supports Ubuntu versions 18.04, 20.04, 22.04, and 24.04.

## Features
- Automatic installation of `vsftpd`.
- Creates a user `ftp` with the password `ftpserver`.
- Simple interactive menu to start, stop, restart the server, and set folder access.
- Displays FTP server information (IP, port, username, and password).

## Installation

1. **Clone the repository:**
```
git clone https://github.com/y-nabeelxd/FTP-Server-Ubuntu && cd FTP-Server-Ubuntu
```

2. Make the script executable:

```
chmod +x ftp_server.sh
```


3. Run the script with sudo:

```
sudo ./ftp_server.sh
```

4. Follow the interactive menu to manage the FTP server.





Usage:

After running the script, you'll see a menu with the following options:
1: Start FTP server

2: Stop FTP server

3: Restart FTP server

4: Exit

af <path>: Set access to a specific folder (e.g., af /home/ftpdata).



————————————————————————————————————————————————



Default FTP Server Details:

Server IP: Displayed during runtime

Port: 21

Username: ftp

Password: ftpserver





Notes:
Ensure you run the script as root using sudo.
Make sure the specified folder exists before assigning access.


Uninstallation
To remove the FTP server and restore the original configuration:

```
sudo systemctl stop vsftpd
sudo apt remove --purge vsftpd -y
sudo rm -rf /etc/vsftpd.conf
sudo mv /etc/vsftpd.conf.bak /etc/vsftpd.conf
sudo deluser ftp --remove-home
```

Developed by: [NabeelXD](https://github.com/y-nabeelxd)
