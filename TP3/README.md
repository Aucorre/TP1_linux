# TP3 
---

**idcard:**

```bash
audren@node1:/srv/idcard$ ./idcard.sh
Machine name :  node1.tp2.linux
OS NAME="Ubuntu"
VERSION="20.04.3 LTS (Focal Fossa)" and Kernel version is Linux version 5.11.0-38-generic
IP 192.168.56.111/24
RAM : 1,3Gi RAM remaining of 1,9Gi
Disque 2,6G remaining
Top 5 processes by RAM usage : 
- systemd 
- kthreadd
- rcu_gp
- rcu_par_gp
- kworker/0:0H-events_highpri
Listening ports :
Listening ports : 
tcp   LISTEN 0      4096    127.0.0.53%lo:domain           0.0.0.0:*
tcp   LISTEN 0      128           0.0.0.0:ssh              0.0.0.0:*
tcp   LISTEN 0      5           127.0.0.1:ipp              0.0.0.0:*
tcp   LISTEN 0      128              [::]:ssh                 [::]:*
tcp   LISTEN 0      5               [::1]:ipp                 [::]:*
tcp   LISTEN 0      32                  *:666                    *:*
Here s your random cat https://cdn2.thecatapi.com/images/eer.jpg
```

**Youtube-dl:**

Output : 

Si les conditions sont vérifiées:

```bash
audren@node1:/srv/yt$ sudo bash yt.sh https://www.youtube.com/watch?v=dQw4w9WgXcQ
Video https://www.youtube.com/watch?v=dQw4w9WgXcQ was downloaded.
File Path : /srv/yt/downloads/Rick Astley - Never Gonna Give You Up (Official Music Video)/Rick Astley - Never Gonna Give You Up (Official Music Video)
```

Si il manque un dossier :

```bash
audren@node1:~/Tp-Linux/TP3/srv/yt$ ls
yt.sh
audren@node1:~/Tp-Linux/TP3/srv/yt$ sudo bash yt.sh https://www.youtube.com/watch?v=jjs27jXL0Zs&ab_channel=REDD%C3%A9fis
Dossier downloads non existant, réessayez.
```

Si le lien n'est pas bon :
```bash
audren@node1:~/Tp-Linux/TP3/srv/yt$ sudo bash yt.sh https://www.youtube.com/watch?v=titouanvaaleclerc
The link is wrong dummie
```
Le fichier de log:
```bash
audren@node1:~/Tp-Linux/TP3/srv/yt$ cat /var/log/yt/download.log
[11/22/21 21:31:53] Video https://www.youtube.com/watch?v=dQw4w9WgXcQ was downloaded. File Path : /srv/yt/downloads/Rick Astley - Never Gonna Give You Up (Official Music Video)/Rick Astley - Never Gonna Give You Up (Official Music Video)
[11/22/21 21:35:22] Video https://www.youtube.com/watch?v=PQgyW10xD8s was downloaded. File Path : /srv/yt/downloads/Arch Linux Installation Guide 2020/Arch Linux Installation Guide 2020

```
**Youtube-dl Service :**


Le service : 
```bash
audren@node1:~/Tp-Linux/TP3/srv/yt-v2$ cat /etc/systemd/system/yt.service
[Unit]
Description= Youtube DL Service

[Service]
ExecStart=sudo bash /home/audren/Tp-Linux/TP3/srv/yt-v2/yt-v2.sh

[Install]
WantedBy=multi-user.target
```

Au lancement:

```bash
 yt.service - YT service
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-11-22 22:01:52 CET; 4s ago
   Main PID: 2622 (sudo)
      Tasks: 3 (limit: 2312)
     Memory: 1.4M
     CGroup: /system.slice/yt.service
             ├─2622 /usr/bin/sudo bash /srv/yt/yt-v2.sh
             ├─2623 bash /srv/yt/yt-v2.sh
             └─2624 sleep 5s

nov. 22 22:01:52 node1.tp2.linux systemd[1]: Started YT service.
nov. 22 22:01:52 node1.tp2.linux sudo[2622]:     root : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/bin/bash /srv/yt>
nov. 22 22:01:52 node1.tp2.linux sudo[2622]: pam_unix(sudo:session): session opened for user root by (uid=0)
```

Le service fonctionne pour l'instant.

```bash
audren@node1:~/Tp-Linux/TP3/srv/yt-v2$ echo "https://www.youtube.com/watch?v=yPE0OHogJgc" >> video-urls
audren@node1:~/Tp-Linux/TP3/srv/yt-v2$ cat video-urls
https://www.youtube.com/watch?v=yPE0OHogJgc
```

Le premier lien a été téléchargé et est donc supprimé
Les logs ->

```bash
audren@node1:~/Tp-Linux/TP3/srv/yt-v2$ tail -f /var/log/yt/download.log 
[11/22/21 22:08:36] Video https://www.youtube.com/watch?v=PE0OHogJgc was downloaded. File Path : /srv/yt/downloads/Top 10 Reasons Why Cats are Better than Dogs/Top 10 Reasons Why Cats are Better than Dogs
```

le journal:

```bash
journalctl -xe -u yt
    [...]
    -- The job identifier is 3507.
    nov. 22 22:31:39 node1.tp2.linux bash[4802]: Video https://www.youtube.com/watch?v=PE0OHogJgc was downloaded
    nov. 22 22:31:39 node1.tp2.linux bash[4802]: File path : /srv/yt/downloads/op 10 Reasons Why Cats are Better than Dogs/Top 10 Reasons Why Cats are Better than Dogs
```

