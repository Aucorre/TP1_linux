# TP5 : Nextcloud :
---

# I. Setup DB


## 1. Install MariaDB

**Installer MariaDB sur la machine**
```bash
[audren@db ~]$ sudo dnf install mariadb-server
[...]
```
**Le service MariaDB**

```bash
[audren@db ~]$ sudo systemctl status mariadb
● mariadb.service - MariaDB 10.3 database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-11-25 11:31:27 CET; 8s ago
     Docs: man:mysqld(8)
           https://mariadb.com/kb/en/library/systemd/
  Process: 26308 ExecStartPost=/usr/libexec/mysql-check-upgrade (code=exited, status=0/SUCCESS)
  Process: 26173 ExecStartPre=/usr/libexec/mysql-prepare-db-dir mariadb.service (code=exited, status=0/SUCCESS)
  Process: 26149 ExecStartPre=/usr/libexec/mysql-check-socket (code=exited, status=0/SUCCESS)
 Main PID: 26276 (mysqld)
   Status: "Taking your SQL requests now..."
    Tasks: 30 (limit: 4934)
   Memory: 81.5M
   CGroup: /system.slice/mariadb.service
           └─26276 /usr/libexec/mysqld --basedir=/usr
[...]

[audren@db ~]$ sudo systemctl enable mariadb
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.

[audren@db ~]$ sudo ss -lntp | grep mys
LISTEN 0      80                 *:3306            *:*    users:(("mysqld",pid=26276,fd=21))


[audren@db ~]$ ps -ef | grep sql
mysql      26276       1  0 11:31 ?        00:00:00 /usr/libexec/mysqld --basedir=/usr
audren     26469   26412  0 11:48 pts/0    00:00:00 grep --color=auto sql
```
**Firewall**
```bash
[audren@db ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
success
[audren@db ~]$ sudo firewall-cmd --reload
success
```
## 2. Conf MariaDB

Première étape : le `mysql_secure_installation`. C'est un binaire qui sert à effectuer des configurations très récurrentes, on fait ça sur toutes les bases de données à l'install.  
C'est une question de sécu.

**Configuration élémentaire de la base**

On va mettre un mdp pour root (logique on veut pas que tout le monde puisse se connecter en root comme ça.) :
```
Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] Y
New password:
Re-enter new password:
Password updated successfully!
Reloading privilege tables..
 ... Success!
```

---

On nous demande si on autorise les connexions anonymes pour tester notre service avant de le rendre public pour rendre l'installation moins chiante.


```
By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] Y
 ... Success!
```
Oui, ça va empêcher les spams, pour créer un compte il faut rentrer quelques infos c'est plus secure que de laisser tout le monde accéder aux donées de la database.

---

Ici on veut savoir si on autorise la connexion en root depuis une autre machine que le localhost.

```
Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] Y
 ... Success!
```
Encore une fois c'est plus secure personne d'autre à accès a la machine localhost (enfin j'espère).

---
Une base de données est créée de base pour tester le service avant de le rendre public.

```
By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] Y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!
```
On va la supprimer parce que tout le monde peut y accéder puis on reload pour effectuer les changements:

```
Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] Y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```
---

**Préparation de la base en vue de l'utilisation par NextCloud**


```bash
[audren@db ~]$ sudo mysql -u root -p
[sudo] password for audren:
Enter password:
Welcome to the MariaDB monitor...
[...]
```

Puis, dans l'invite de commande SQL :

```sql
MariaDB [(none)]> CREATE USER 'nextcloud'@'10.5.1.11' IDENTIFIED BY 'meow';
Query OK, 0 rows affected (0.000 seconds)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.000 seconds)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.102.1.11';
Query OK, 0 rows affected (0.000 seconds)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.000 seconds)
```

## 3. Test



**Installation sur la machine `web.tp5.linux` de la commande `mysql`**

```bash
[audren@web ~]$ dnf provides mysql
[...]
Provide   : mysql = 8.0.26-1.module+e18.4.0+652+6de068a7
[audren@web ~]$ sudo dnf install mysql
[...]
Complete !
```

**Test de la connexion**
```bash
[audren@web ~]$ mysql --user=nextcloud -P 3306 --host=10.5.1.12 --password -D nextcloud
Enter password:
Welcome to the MySQL monitor
[...]
```
```sql
mysql> SHOW TABLES;
Empty set (0.00 sec)
```

# II. Setup Web

## 1. Install Apache

### A. Apache

**Installation d'Apache sur la machine `web.tp5.linux`**
```bash
[audren@web ~]$ sudo dnf install httpd
[sudo] password for audren:
[...]
Complete !
```
---

**Analyse du service Apache**
```bash
[audren@web ~]$ sudo systemctl start httpd
[audren@web ~]$ sudo systemctl enable httpd

[audren@web ~]$ ps -ef | grep httpd
root       24129       1  0 10:00 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     24130   24129  0 10:00 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     24131   24129  0 10:00 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     24132   24129  0 10:00 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     24133   24129  0 10:00 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND

[audren@web ~]$ sudo ss -lntp | grep httpd
LISTEN 0      128                *:80              *:*    users:(("httpd",pid=24133,fd=4),("httpd",pid=24132,fd=4),("httpd",pid=24131,fd=4),("httpd",pid=24129,fd=4))
```
---

**Un premier test**

```bash
[audren@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[audren@web ~]$ sudo firewall-cmd --reload
success
[audren@web ~]$ curl http://10.5.1.11
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
```


### B. PHP

**Installation de PHP**

```bash
[audren@web ~]$ sudo dnf install epel-release
[...]
Complete !
[audren@web ~]$ sudo dnf update
[...]
[audren@web ~]$ sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
[...]
Complete !
[audren@web ~]$ sudo dnf module enable php:remi-7.4
[...]
Complete !
[audren@web ~]$ sudo dnf install zip unzip libxml2 openssl php74-php php74-php-ctype php74-php-curl php74-php-gd php74-php-iconv php74-php-json php74-php-libxml php74-php-mbstring php74-php-openssl php74-php-posix php74-php-session php74-php-xml php74-php-zip php74-php-zlib php74-php-pdo php74-php-mysqlnd php74-php-intl php74-php-bcmath php74-php-gmp
```

## 2. Conf Apache

**Analyser la conf Apache**

```bash
[audren@web ~]$ cat /etc/httpd/conf/httpd.conf | grep conf.d
# Load config files in the "/etc/httpd/conf.d" directory, if any.
IncludeOptional conf.d/*.conf
```

**Créer un VirtualHost qui accueillera NextCloud**



```bash
[audren@web conf.d]$ sudo nano virtualhost.conf
[audren@web conf.d]$ sudo systemctl restart httpd
```

**Configurer la racine web**

```bash
[audren@web www]$ sudo mkdir nextcloud
[audren@web www]$ cd nextcloud/
[audren@web nextcloud]$ sudo mkdir html

[audren@web www]$ sudo chown apache nextcloud
[audren@web www]$ sudo chown apache nextcloud/html
[audren@web www]$ ls -l
total 0
drwxr-xr-x. 2 root   root  6 Nov 15 04:13 cgi-bin
drwxr-xr-x. 2 root   root  6 Nov 15 04:13 html
drwxr-xr-x. 3 apache root 18 Nov 26 11:02 nextcloud
[audren@web www]$ cd nextcloud/
[audren@web nextcloud]$ ls -l
total 0
drwxr-xr-x. 2 apache root 6 Nov 26 11:02 html
```

**Configurer PHP**

```bash
[audren@web nextcloud]$ cat /etc/opt/remi/php74/php.ini | grep date.timezone
; http://php.net/date.timezone
;date.timezone = "Europe/Paris"
```

## 3. Install NextCloud

**Récupérer Nextcloud**

```bash
[audren@web nextcloud]$ cd

[audren@web nextcloud]$ curl -SLO https://download.nextcloud.com/server/releases/nextcloud-21.0.1.zip

[audren@web nextcloud]$ ls
nextcloud-21.0.1.zip
```

**Ranger la chambre**
```bash
[audren@web ~]$ sudo chown -R apache:apache nextcloud
[audren@web ~]$ sudo mv nextcloud/* /var/www/nextcloud/html
[audren@web html]$ ls -l
total 4
drwxr-xr-x. 13 apache audren 4096 Apr  8  2021 nextcloud
```

## 4. Test


**Modifiez le fichier `hosts` de votre PC**
Je peux pas le montrer mais je l'ai fait donc on va faire comme si.


**Tester l'accès à NextCloud et finaliser son install'**

Notre petit site marche :![](https://i.imgur.com/c4je7ao.png)


La base de données ausi
```sql
mysql> SHOW TABLES;
+-----------------------------+
| Tables_in_nextcloud         |
+-----------------------------+
| oc_accounts                 |
| oc_accounts_data            |
| oc_activity                 |
| oc_activity_mq              |
| oc_addressbookchanges       |
[...]
77 rows in set (0.00 sec)
```
