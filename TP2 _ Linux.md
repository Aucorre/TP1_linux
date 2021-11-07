# TP2 : Explorer et manipuler le système

---

**Changer le nom de la machine**

```bash
audren@audren: sudo hostname node1.tp2.linux
audren@audren:~$ hostname
node1.tp2.linux
audren@audren: echo "node1.tp2.linux" | sudo tee /etc/hostname
node1.tp2.linux
```

**Config réseau fonctionnelle**

VM:
```bash
audren@node1:~$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=63 time=21.4 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=63 time=22.8 ms
--- 1.1.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 22.789/23.418/24.047/1.863 ms
audren@node1:~$ ping ynov.com
PING ynov.com (92.243.16.143) 56(84) bytes of data.
64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=1 ttl=63 time=20.6 ms
64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=2 ttl=63 time=21.1 ms
--- ynov.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 20.592/20.870/21.148/0.355 ms
```

PC:
```bash
❯ ping 192.168.56.111
PING 192.168.56.111 (192.168.56.111) 56(84) bytes of data.
64 bytes from 192.168.56.111: icmp_seq=1 ttl=64 time=0.550 ms
64 bytes from 192.168.56.111: icmp_seq=2 ttl=64 time=0.558 ms
--- 192.168.56.111 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1023ms
rtt min/avg/max/mdev = 0.550/0.554/0.558/0.004 ms

```

## Partie 1 : SSH

**Installer le paquet openssh-server et lancer le service ssh**

```bash
audren@node1:~$ sudo apt install openssh-server -y
audren@node1:~$ systemctl start sshd
audren@node1:~$ systemctl status sshd
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-10-25 11:27:01 CEST; 44s ago
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 546 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 574 (sshd)
      Tasks: 1 (limit: 2314)
     Memory: 2.3M
        CPU: 12ms
     CGroup: /system.slice/ssh.service
             └─574 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
[...]
```

**Analyser le service en cours de fonctionnement**

```bash
audren@node1:~$ systemctl status sshd
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-10-25 11:27:01 CEST; 44s ago
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 546 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 574 (sshd)
      Tasks: 1 (limit: 2314)
     Memory: 2.3M
        CPU: 12ms
     CGroup: /system.slice/ssh.service
             └─574 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
[...]
audren@node1:~$ ps -aux | grep sshd
root         574  0.0  0.3  13132  6832 ?        Ss   11:27   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
audren@node1:~$ ss -l | grep ssh
u_str LISTEN 0      4096         /run/user/1000/gnupg/S.gpg-agent.ssh 19091                           * 0           
u_str LISTEN 0      10                     /run/user/1000/keyring/ssh 19713                           * 0           
tcp   LISTEN 0      128                                       0.0.0.0:ssh                       0.0.0.0:*           
tcp   LISTEN 0      128                                          [::]:ssh                          [::]:*
audren@node1:~$ journalctl | grep sshd
[...]
```

**Connectez vous au serveur**

```bash
❯ ssh audren@192.168.56.111
ECDSA key fingerprint is SHA256:JLDdG8nVoCRhDiMWP9lkvXEFha9qQ6XFMfYaUzeA7Po.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.56.111' (ECDSA) to the list of known hosts.
audren@192.168.56.111 s password:
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.11.0-38-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

51 updates can be applied immediately.
To see these additional updates run: apt list --upgradable


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
Your Hardware Enablement Stack (HWE) is supported until April 2025.

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with A

audren@node1:~$ 
```

**Modifier le comportement du service**

```bash
audren@node1:/etc/ssh$ sudo nano /etc/ssh/sshd_config
audren@node1:/etc/ssh$ cat /etc/ssh/sshd_config
#       $OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Include /etc/ssh/sshd_config.d/*.conf

Port 666
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
[...]
audren@node1:/etc/ssh$ systemctl restart sshd 
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to restart 'ssh.service'.
Authenticating as: audren,,, (audren)
Password: 
==== AUTHENTICATION COMPLETE ===
audren@node1:~$ ss -l | grep 666
tcp     LISTEN 0      128                                       0.0.0.0:666     0.0.0.0:*           
tcp     LISTEN 0      128                                          [::]:666        [::]:*
❯ ssh audren@192.168.56.111 -p 666
[...]
audren@192.168.56.111 s password: 
Welcome to Ubuntu 21.10 (GNU/Linux 5.13.0-19-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

0 updates can be applied immediately.

Last login:  14:47:08 2021 from 192.168.56.1
audren@node1:~$
```

---

## Partie 2 : FTP

**Installer le paquet vsftpd**

```bash
audren@node1:~$ sudo apt install vsftpd -y
[...]
```

**Lancer le service vsftpd**

```bash
audren@node1:~$ systemctl start vsftpd
[...]
audren@node1:~$ systemctl status vsftpd
● vsftpd.service - vsftpd FTP server
     Loaded: loaded (/lib/systemd/system/vsftpd.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2021-11-2 14:49:23 CEST; 1min 22s ago
   Main PID: 1987 (vsftpd)
      Tasks: 1 (limit: 2312)
     Memory: 684.0K
     CGroup: /system.slice/vsftpd.service
             └─1739 /usr/sbin/vsftpd /etc/vsftpd.conf
[...]
```

**Analyser le service en cours de fonctionnement**

```bash
audren@node1:~$ systemctl status vsftpd
● vsftpd.service - vsftpd FTP server
     Loaded: loaded (/lib/systemd/system/vsftpd.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-10-25 12:07:23 CEST; 1min 22s ago
    Process: 1738 ExecStartPre=/bin/mkdir -p /var/run/vsftpd/empty (code=exited, status=0/SUCCESS)
   Main PID: 1739 (vsftpd)
      Tasks: 1 (limit: 2314)
     Memory: 684.0K
        CPU: 2ms
     CGroup: /system.slice/vsftpd.service
             └─1739 /usr/sbin/vsftpd /etc/vsftpd.conf
[...]
audren@node1:~$ ps -aux | grep ftp
root        1987  0.0  0.1   6816  3024 ?        Ss   15:00   0:00 /usr/sbin/vsftpd /etc/vsftpd.conf
audren      2597  0.0  0.0  19380   724 pts/2    S+   15:06   0:00 grep --color=auto ftp/usr/sbin/vsftpd /etc/vsftpd.conf
audren@node1:~$ ss -l | grep ftp
tcp   LISTEN 0      32                                              *:ftp                             *:*
audren@node1:~$ journalctl | grep vsftpd
nov.02 12:06:58 node1.tp2.linux polkitd(authority=local)[460]: Operator of unix-process:1573:51411 successfully authenticated as unix-user:audren to gain ONE-SHOT authorization for action org.freedesktop.systemd1.manage-units for system-bus-name::1.80 [systemctl start vsftpd] (owned by unix-user:audren)
nov.02 12:07:22 node1.tp2.linux sudo[1586]:   audren : TTY=pts/0 ; PWD=/home/audren ; USER=root ; COMMAND=/usr/bin/apt install vsftpd
nov.02 12:07:23 node1.tp2.linux systemd[1]: Starting vsftpd FTP server...
nov.02 12:07:23 node1.tp2.linux systemd[1]: Started vsftpd FTP server.
nov.02 12:08:42 node1.tp2.linux polkitd(authority=local)[460]: Operator of unix-process:2243:61682 successfully authenticated as unix-user:audren to gain ONE-SHOT authorization for action org.freedesktop.systemd1.manage-units for system-bus-name::1.90 [systemctl start vsftpd] (owned by unix-user:audren)
nov.02 12:15:59 node1.tp2.linux sudo[2264]:   audren : TTY=pts/0 ; PWD=/home/audren ; USER=root ; COMMAND=/usr/bin/apt install vsftpd -y
audren@node1:~$ sudo cat /var/log/vsftpd.log 
Tue Nov 2 12:33:07 2021 [pid 2458] CONNECT: Client "::ffff:192.168.56.1"
Tue Nov 2 12:33:25 2021 [pid 2457] [Anonymous] FAIL LOGIN: Client "::ffff:192.168.56.1"
Tue Nov 02 12:33:33 2021 [pid 2466] CONNECT: Client "::ffff:192.168.56.1"
Tue Nov 02 12:33:41 2021 [pid 2465] [audren] OK LOGIN: Client "::ffff:192.168.56.1"
```

```bash
audren@node1:~$ sudo cat /etc/vsftpd.conf 
[...]
# Uncomment this to enable any form of FTP write command.
write_enable=YES
[...]
audren@node1:~$ ftp 192.168.56.111
Connected to 192.168.56.111.
220 (vsFTPd 3.0.3)
Name (192.168.56.111:audren): audren
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> dir
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    2 1000     1000         4096 Oct 19 10:53 Desktop
drwxr-xr-x    2 1000     1000         4096 Oct 19 10:53 Documents
drwxr-xr-x    2 1000     1000         4096 Oct 19 10:53 Downloads
drwxr-xr-x    2 1000     1000         4096 Oct 19 10:53 Music
drwxr-xr-x    2 1000     1000         4096 Oct 19 10:53 Pictures
drwxr-xr-x    2 1000     1000         4096 Oct 19 10:53 Public
drwxr-xr-x    2 1000     1000         4096 Oct 19 10:54 Templates
drwxr-xr-x    2 1000     1000         4096 Oct 19 10:53 Videos
-rw-rw-r--    1 1000     1000            0 Nov 07 15:20 ftp
226 Directory send OK.
ftp> get
(remote-file) ftp
(local-file) ftp
local: ftp remote: ftp
200 PORT command successful. Consider using PASV.
150 Opening BINARY mode data connection for ftp (0 bytes).
226 Transfer complete.
```
ftp> exit
221 Goodbye.
**Visualiser les logs**

```bash
Tue Nov  2 15:22:13 2021 [pid 2826] CONNECT: Client "::ffff:192.168.56.111"
Tue Nov  2 15:22:25 2021 [pid 2825] [audren] OK LOGIN: Client "::ffff:192.168.56.111"
Tue Nov  2 15:22:55 2021 [pid 2827] [audren] FAIL DOWNLOAD: Client "::ffff:192.168.56.111", "/home/audren/upload.txt", 0.00Kbyte/sec
Tue Nov  2 15:23:14 2021 [pid 2827] [audren] FAIL DOWNLOAD: Client "::ffff:192.168.56.111", "/home/audren/test.txt", 0.00Kbyte/sec
Tue Nov  2 15:31:37 2021 [pid 2873] CONNECT: Client "::ffff:192.168.56.111"
Tue Nov  2 15:31:43 2021 [pid 2872] [audren] OK LOGIN: Client "::ffff:192.168.56.111"
Tue Nov  2 15:32:34 2021 [pid 2874] [audren] OK DOWNLOAD: Client "::ffff:192.168.56.111", "/home/audren/ftp", 0.00Kbyte/sec
```
**Modifier le comportement du service**

```bash
audren@node1:~$ sudo cat /etc/vsftpd.conf 
[...]
listen_port=666
[...]
audren@node1:~$ ss -l | grep 666
tcp     LISTEN   0        128                                           0.0.0.0:666                                       0.0.0.0:*
tcp     LISTEN   0        128                                              [::]:666                                          [::]:*
```
**Connectez vous sur le nouveau port choisi**

```bash
audren@node1:~$ ftp 192.168.56.111 666
Connected to 192.168.56.111.
220 (vsFTPd 3.0.3)
Name (192.168.56.111:audren): audren
331 Please specify the password.
Password: 
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
audren@node1:~$ sudo cat /var/log/vsftpd.log 
Tue Nov 2 15:50:29 2021 [pid 3067] CONNECT: Client "::ffff:192.168.56.1"
Tue Nov 2 15:50:29 2021 [pid 3066] [audren] OK LOGIN: Client "::ffff:192.168.56.1"
Tue Nov 2 15:50:29 2021 [pid 3068] [audren] OK UPLOAD: Client "::ffff:192.168.56.1", "/home/audren/Public/img.png", 4696 bytes, 13488.05Kbyte/sec
Tue Nov 2 15:50:037 2021 [pid 3070] CONNECT: Client "::ffff:192.168.56.1"
Tue Nov 2 15:50:037 2021 [pid 3069] [audren] OK LOGIN: Client "::ffff:192.168.56.1"
Tue Nov 2 15:50:037 2021 [pid 3071] [audren] OK DOWNLOAD: Client "::ffff:192.168.56.1", "/home/audren/Templates/Plain Text.txt", 0.00Kbyte/sec
```

## Partie 3 : Création de votre propre service

Commande VM :
```bash
audren@node1:~$ nc -l 9001
```
Commande PC : 
```bash
audren@node1:~$ nc 192.168.56.111 9001
```
**Utiliser netcat pour stocker les données échangées dans un fichier**

```bash
audren@node1:~$ nc -l 9001 >> log.txt
salut
^C
audren@node1:~$ sudo cat log.txt
salut
```

**Créer un nouveau service**

```bash
audren@node1:~$ sudo nano /etc/systemd/system/chat_tp2.service
audren@node1:~$ sudo cat /etc/systemd/system/chat_tp2.service 
[Unit]
Description=Little chat service (TP2)

[Service]
ExecStart=/usr/bin/nc -l 9002

[Install]
WantedBy=multi-user.target
```

**Tester le nouveau service**

```bash
audren@node1:~$ systemctl start chat_tp2
[...]
audren@node1:~$ systemctl status chat_tp2
● chat_tp2.service - Little chat service (TP2)
     Loaded: loaded (/etc/systemd/system/chat_tp2.service; disabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-10-25 14:19:43 CEST; 3min 29s ago
   Main PID: 3476 (nc)
      Tasks: 1 (limit: 2314)
     Memory: 216.0K
        CPU: 2ms
     CGroup: /system.slice/chat_tp2.service
             └─3476 /usr/bin/nc -l 9002

nov.02 16:00:43 node1.tp2.linux systemd[1]: Started Little chat service (TP2).
audren@node1:~$ ss -l | grep 9002
tcp   LISTEN 0      1                                         0.0.0.0:9002                      0.0.0.0:*
audren@node1:~$ journalctl -xe -u chat_tp2
nov.02 16:05:50 node1.tp2.linux nc[3476]: ui
nov.02 16:05:51 node1.tp2.linux nc[3476]: bonjour