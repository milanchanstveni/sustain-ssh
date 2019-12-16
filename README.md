# sustain-ssh
By default, SSH connections to the remote servers often get disconnected due to inactivity so this script keeps those connections alive and displays some nice information about the server. It also allows users 

## Usage
Upload **sustain.sh** script to remote server and place it in desired directory of executables so you can call it from any filesystem location on the server. Give execute permissions to that script:
```
sudo chmod +x /path/to/the/script
```
run it when you need to sustain the SSH connection:
```
sustain.sh
```
![](https://raw.githubusercontent.com/milanpantelic/sustain-ssh/master/sustain_usage.gif)

