# TP4 : Une distribution orientée serveur



# I. Checklist

---

**Configuration IP statique**

```bash
[audren@node1 ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
TYPE=Ethernet
BOOTPROTO=static
NAME=enp0s8
DEVICE=enp0s8
ONBOOT=yes
IPADDR=10.200.1.69
NETMASK=255.255.255.0
```

**Definir une IP à la VM**

```bash
[audren@node1 ~]$ ip a | tail -6
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:18:e3:49 brd ff:ff:ff:ff:ff:ff
    inet "10.200.1.69/24" brd 10.200.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe18:e349/64 scope link
       valid_lft forever preferred_lft forever
```

---


**Analyse service ssh :**

```bash
[audren@node1 ~]$ sudo systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2021-11-24 11:09:15 CET; 1h 35min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 844 (sshd)
    Tasks: 1 (limit: 4934)
   Memory: 4.4M
   CGroup: /system.slice/sshd.service
           └─844 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes256-cb>
[...]
```
---

**Accès internet**

```bash
[audren@node1 ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=114 time=19.2 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=114 time=17.9 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=114 time=16.3 ms
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 16.266/17.809/19.220/1.209 ms


[audren@node1 ~]$ ping google.com
PING google.com (216.58.201.238) 56(84) bytes of data.
64 bytes from fra02s18-in-f14.1e100.net (216.58.201.238): icmp_seq=1 ttl=114 time=15.9 ms
64 bytes from fra02s18-in-f14.1e100.net (216.58.201.238): icmp_seq=2 ttl=114 time=16.4 ms
64 bytes from fra02s18-in-f14.1e100.net (216.58.201.238): icmp_seq=3 ttl=114 time=15.10 ms
^C
--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 15.946/16.098/16.372/0.194 ms
```

**Résolution de nom**

```bash
[audren@node1 nginx]$ ping pcf.fr
PING pcf.fr (91.194.60.79) 56(84) bytes of data.
64 bytes from commun.octopuce.fr (91.194.60.79): icmp_seq=1 ttl=55 time=16.7 ms
64 bytes from commun.octopuce.fr (91.194.60.79): icmp_seq=2 ttl=55 time=17.5 ms
^C
--- pcf.fr ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 16.667/17.101/17.536/0.453 ms
---
```


**Nom de la machine**
```bash
[audren@node1 ~]$ cat /etc/hostname
node1.tp4.linux
[audren@node1 ~]$ hostname
node1.tp4.linux

```

# II. Mettre en place un service


## 1. Install

**Installation de NGINX**
```bash
[audren@node1 ~]$ sudo dnf install nginx
```

## 2. Analyse


```bash
[audren@node1 ~]$ sudo systemctl start nginx
[audren@node1 ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Wed 2021-11-24 11:33:03 CET; 1h 2min ago
  Process: 20742 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 20741 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 20738 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 20744 (nginx)
    Tasks: 2 (limit: 4934)
   Memory: 3.7M
   CGroup: /system.slice/nginx.service
           ├─20744 nginx: master process /usr/sbin/nginx
           └─20745 nginx: worker process

[...]
```

**Analyse du service NGINX**

```bash

[audren@node1 ~]$ sudo ps -ef | grep nginx
root       20744       1  0 11:33 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      20745   20744  0 11:33 ?        00:00:00 nginx: worker process

[audren@node1 ~]$ sudo ss -ltpn | grep nginx
LISTEN 0      128          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=20745,fd=8),("nginx",pid=20744,fd=8))
LISTEN 0      128             [::]:80           [::]:*    users:(("nginx",pid=20745,fd=9),("nginx",pid=20744,fd=9))
```
## 4. Visite du service web

**Configuration du firewall pour autoriser le trafic vers le service NGINX** 
```bash
[audren@node1 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[audren@node1 ~]$ sudo firewall-cmd --reload
success
```
**Fonctionnement du service**

```bash
[audren@node1 ~]$ curl http://10.200.1.69:80 | head -1
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
```

## 5. Modif de la conf du serveur web

**Changer le port d'écoute**

```bash
[audren@node1 nginx]$ cat nginx.conf | grep 80
        listen       8080 default_server;
        listen       [::]:8080 default_server;
        
        
        
[audren@node1 nginx]$ sudo systemctl restart nginx
[audren@node1 nginx]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Wed 2021-11-24 13:22:35 CET; 8s ago
  Process: 26248 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 26246 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 26244 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 26250 (nginx)
    Tasks: 2 (limit: 4934)
   Memory: 3.6M
   CGroup: /system.slice/nginx.service
           ├─26250 nginx: master process /usr/sbin/nginx
           └─26251 nginx: worker process
[...]


[audren@node1 nginx]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[audren@node1 nginx]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success


[audren@node1 nginx]$ sudo ss -ltpn | grep nginx
LISTEN 0      128          0.0.0.0:8080      0.0.0.0:*    users:(("nginx",pid=26251,fd=8),("nginx",pid=26250,fd=8))
LISTEN 0      128             [::]:8080         [::]:*    users:(("nginx",pid=26251,fd=9),("nginx",pid=26250,fd=9))

[audren@node1 nginx]$ curl http://10.200.1.69:8080
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
```

---

**Changer l'utilisateur qui lance le service**

```bash
[audren@node1 nginx]$ sudo useradd web
[audren@node1 nginx]$ sudo passwd web
Changing password for user web.
New password:
Retype new password:
passwd: all authentication tokens updated successfully.

[audren@node1 home]$ ls
audren  web

[audren@node1 home]$ cat nginx.conf | grep user
user web;
[...]

[audren@node1 home]$ ps -ef | grep nginx
root       26443       1  0 13:57 ?        00:00:00 nginx: master process /usr/sbin/nginx
web        26444   26443  0 13:57 ?        00:00:00 nginx: worker process
```

---

**Changer l'emplacement de la racine Web**

```bash
[audren@node1 nginx]$ mkdir /var/www
[audren@node1 nginx]$ mkdir /var/www/super_site_web
[audren@node1 nginx]$ sudo nano index.html

[audren@node1 nginx]$ sudo chown web /var/www/super_site_web/index.html
[audren@node1 nginx]$ sudo chown web /var/www/super_site_web
[audren@node1 nginx]$ sudo chown web /var/www

[audren@node1 nginx]$ ls -l /var/www
drwxr-xr-x. 2 web root 24 Nov 24 14:06 super_site_web


[audren@node1 nginx]$ cat nginx.conf | grep root
        root         /var/www/super_site_web;
        
[audren@node1 nginx]$ curl http://10.200.1.69:8080
<h1>COMRADE</h1>
```
