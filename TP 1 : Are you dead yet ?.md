# TP 1 : Are you dead yet ?

---

 Plusieurs manières différentes de péter une machine linux :

**- Première façon :**

    sudo rm -r /*
    
Ici on supprime tous les dossiers (et fichiers) depuis la racine de la VM

**- Deuxième façon :**

    exo-open --launch TerminalEmulator
    
    sudo nano ~/.bashrc
    xinput disable 11
    xinput disable 12
    
On va tout d'abord aller dans l'application "Session and Startup" puis dans "Application Autostart" pour ajouter une commande qui s'éxécutera au moment ou l'utilisateur va se login, la commande en question est ici "exo-open --launch TerminalEmulator". Après cela on va tout simplement faire en sorte que la souris et le clavier soient inutilisables en tapant "sudo nano ~/.bashrc" dans un nouveau terminal on va ouvrir un fichier pour rentrer nos commmandes au début de celui-ci afin qu'elles se lancent directement au login, rendant la machine complétement inutile.

**- Troisième façon :**

    exo-open --launch TerminalEmulator
    
    sudo nano ~/.bashrc
    :(){:|:&};:


De la même manière que précédemment, on va faire en sorte que notre commande s'éxécute au login. Ici la commande en question est une forkbomb, elle va tout simplement créer un fichier qui va se répliquer de plus en plus jusqu'à saturer le CPU de la machine ce qui va la faire crash. 

**- Quatrième façon :**

    chmod 000 /lib/systemd/systemd

En une seule ligne on va tout simplement enlever tous les droits à tous les utilisateurs (y compris root) et rendre la machine impossible à utiliser.

**- Cinquième façon :**
    
    exo-open --launch TerminalEmulator
    sudo nano ~/.bashrc
    shutdown now

On va à nouveau autostart notre commande, cette fois-ci la commande ferme tout simplement la machine à chaque fois qu'on essaie de se login.