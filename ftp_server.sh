#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   clear
   echo "This script must be run as root using sudo."
   sleep 3
   exit 1
fi

shutdown_ftp() {
    echo ""
    echo "Shutting down FTP server..."
    systemctl stop vsftpd
    echo "FTP server stopped."
    exit 0
}

trap shutdown_ftp SIGINT

version=$(lsb_release -rs)
clear
echo "Detected Ubuntu version: $version"

if [[ "$version" != "18.04" && "$version" != "20.04" && "$version" != "22.04" && "$version" != "24.04" ]]; then
    echo "Unsupported Ubuntu version. Supported versions: 18.04, 20.04, 22.04, 24.04."
    exit 1
fi

echo "Installing vsftpd FTP server..."
apt update && apt install -y vsftpd && apt install neofetch
clear

cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

echo "Configuring FTP server..."

cat > /etc/vsftpd.conf <<EOL
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=NO
allow_writeable_chroot=YES
listen_ipv6=NO
pam_service_name=vsftpd
user_sub_token=\$USER
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=50000
EOL

echo "Restarting FTP service..."
systemctl restart vsftpd

if id "ftp" &>/dev/null; then
    echo "User 'ftp' already exists."
    
    current_password=$(sudo getent shadow ftp | cut -d: -f2)
    
    echo "Changing password for 'ftp' to 'ftpserver'."
    echo "ftp:ftpserver" | sudo chpasswd
    clear

else
    echo "Creating 'ftp' user with password 'ftpserver'."
    useradd -m -s /bin/bash ftp
    echo "ftp:ftpserver" | sudo chpasswd
    clear
fi

set_access() {
    local path="$1"

    if [[ -d "$path" ]]; then
        echo "Setting access to: $path for FTP user."
        # Set the specified path as the FTP root
        cat > /etc/vsftpd.user_list <<EOL
ftp
EOL
        mkdir -p "$path"
        chown ftp:ftp "$path"
        sed -i "s|local_root=.*|local_root=$path|" /etc/vsftpd.conf

        echo "FTP root directory is now set to $path."
        systemctl restart vsftpd
    else
        echo "Error: Path $path does not exist."
    fi
}

neofetch
echo ""
echo ""

while true; do
    echo "SERVER BY NabeelXD"
    server_ip=$(hostname -I | awk '{print $1}')
    echo "FTP Server Information:"
    echo "-----------------------"
    echo "FTP Server IP: $server_ip"
    echo "FTP Port: 21 (Default)"
    echo "FTP Username: ftp"
    echo "FTP Password: ftpserver"
    echo ""
    echo "Available Commands:"
    echo "1. Start FTP server"
    echo "2. Stop FTP server"
    echo "3. Restart FTP server"
    echo "4. Exit"
    echo "af <path> - Set access to a specific folder"
    echo ""
    read -p "Enter your command: " command path

    case $command in
        1)
            systemctl start vsftpd
            clear
            echo "FTP server started."
            echo ""
            ;;
        2)
            systemctl stop vsftpd
            clear
            echo "FTP server stopped."
            echo ""
            ;;
        3)
            systemctl restart vsftpd
            clear
            echo "FTP server restarted."
            echo ""
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        af)
            if [[ -n "$path" ]]; then
                set_access "$path"
            else
                echo "Please specify a path for access."
            fi
            ;;
        *)
            echo "Invalid command."
            ;;
    esac
done
