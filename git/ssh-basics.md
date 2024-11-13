@def tags = ["ssh"]
@def lang = "plaintext"

# Secure Shell ssh - the Swiss Army Knife of Remote Access

\toc

Survival in the wild is no problem if you carry your Swiss Army Knife.
So is survival in the internet -- provided you know ssh.

<!-- more -->


~~~
<center>
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Cybertool_mg_0709.jpg/1024px-Cybertool_mg_0709.jpg" 
style="width: 400px; text-align: center;"/>
Cybertool knife by Victorinox &copy; <a href="https://commons.wikimedia.org/wiki/File:Cybertool_mg_0709.jpg"> Rama </a>
</center>
~~~

## Resources



- [Cheat Sheet](http://www.cheat-sheets.org/saved-copy/OpenSSH_quickref.pdf)
- [Wikipedia Entry](http://en.wikipedia.org/wiki/Secure_Shell)
- Man pages  (OpenSSH on Debian Linux; mostly works for all Linux + MacOSX): [ssh](https://manpages.debian.org/bullseye/openssh-client/ssh.1.en.html), [scp](https://manpages.debian.org/bullseye/openssh-client/scp.1.en.html), [ssh-agent](https://manpages.debian.org/bullseye/openssh-client/ssh-agent.1.en.html), [ssh-keygen](https://manpages.debian.org/bullseye/openssh-client/ssh-keygen.1.en.html), [ssh_config](https://manpages.debian.org/bullseye/openssh-client/ssh_config.5.en.html)
- ssh on Microsoft Windows: [putty](http://www.putty.org/), [WinSCP](http://winscp.net)
- ssh on [Android](https://play.google.com/store/apps/details?id=com.sonelli.juicessh),
  [iOS](https://itunes.apple.com/de/app/serverauditor-ssh-shell-console/id549039908)

## Usage patterns

__S__ecure __sh__ell is a tool for encrypted remote access to computers connected to the
internet.

### Encrypted remote access with password authentication

Assume your your sysadmin  told you "Just use ssh to  gate in order to
log in to the institute".  Then  your institute which has the internet
domain `institute.com` probably has  a host `gate.institute.com`. Then
this should work:

```plaintext
mylaptop$ ssh user@gate.institute.com
user@gate.institute.com's password: 
Last login: Thu Dec 11 17:46:16 2014 from dslb-188-103-172-167.188.103.pools.vodafone-ip.de
```

As a result  you will see the  shell prompt of the  remote system.

If this is  the first connection from the computer  you are working on
to the institute,  you will be asked if you  really trust the identity
(which you  probably do  at this point  - if you  don't, you  can e.g.
phone  the  sysadmin   and  ask  her  to  read   the  fingerprint  for
comparison):

```
mylaptop$ ssh user@gate.institute.com
The authenticity of host 'gate.institute.com (180.95.11.140)' 
can't be established.
RSA1 key fingerprint is ce:e0:70:ea:7c:d4:e1:99:09:61:bd:0b:28:46:08:6b.
Are you sure you want to continue connecting (yes/no)?
```

After answering `yes`, you get

```
Warning: Permanently added 'gate.institute.de,180.95.11.140' 
(RSA1) to the list of known hosts.
```

Similarly, this authentication check may  be issued after a re-install
of the remote system. If nothing of  this is the case, this might be a
warning sign for a man-in-the middle attack.

After setting up this communication channel, all communication will be
encrypted   using  a   temporary  symmetric   session  key   which  is
automatically negotiated after authentication.

~~~

<center>
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/Symmetric_key_encryption.svg/1048px-Symmetric_key_encryption.svg.png"
style="width: 400px;">

Symmetric key encryption. (public domain)
</center>
~~~
### Copying data

Along with the secure shell suite comes the command `scp` which allows
you to copy  data between computers.  Fetching a file  from the remote
host using an absolute path goes like that:

```
scp user@gate.institute.com:/home/user/daten.dat daten.dat .
```

Fetching a file  from your home directory on the remote host goes like

```
scp user@gate.institute.com:daten.dat .
```

Likewise, you can copy data from your computer to the remote host:

```
scp daten.dat user@gate.institute.com:/home/user/daten.dat
scp daten.dat user@gate.institute.com:
```

Of course, every time you will be asked for your password...

### Executing commands on the remote host

As an example,

```
ssh user@gate.institute.com ls
```

executes the command ls on the remote host.
For interactive commands, you should use the `-t` switch:

```
ssh -t user@gate.institute.com  emacs -nw
```


If it is an X11 program, you can get encrypted transport
to X11 windows by adding `-X` to  the command line:

```
ssh -X user@gate.institute.com  emacs
```

Of course, every time you will be asked for your password...


### Public key authentication
Now, we want to get rid of these annoying password requests. This can be done by providing 
the remote host with an "public ssh key". 


In order to prepare this, you need to generate a private-public key pair. The secure shell suite provides
the command `ssh-keygen` which does this job:

```
mylaptop$ ssh-keygen
Generating public/private rsa1 key pair.
Enter file in which to save the key (/home/user/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):*************** 
Enter same passphrase again:***************
Your identification has been saved in /home/user/.ssh/id_rsa
Your public key has been saved in /home/user/.ssh/id_rsa.pub
The key fingerprint is:
5c:23:da:14:00:c6:6f:3f:6e:2d:69:26:e2:9c:60:b0 user@nmnb2
```

The private key is protected by the passphrase and marks your identity
if  activated.   _Both private  key  and  passphrase should  be  kept
safe. They are not meant to be given to others._

The public key is  used to check this identity. You  give it to anyone
(computer or person) whom you want to enable to do this check.

In particular, you can add this public  key to the contents of the file
`.ssh/authorized_keys`  in  your home  directory  on  the remote  host
(e.g. `gate.institute.com`).  To do this, use `scp` to copy the key and
`ssh` to log in to the remote and to edit the file. In the result, the contents
of that file will look like

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvyyza7e8tFrBhNMRd/3w+XL9PIeSNTUC+PcHOQI7kcfk4oTDnfysTkPleM3fM+r588sDRWKa7eivLoZ7NCF3EgMd0HUUVHjWbWZgF7KXylu4dcsDMvANH5BlgWysFqxzaTzy8CX8E03NYSkn5kqzgtnkIm+Z/QzLd4mq48oG9Ns3uPlhU4Wf2XGEqV/6EtLvHgAG/PtUP1kofO74oit2d8BH3fkU0UCMBlZqVCAoefFnR4qg3c18McK3dGhM741dpopeD3E+zaJ55AS9nIZFdbkOZNsrQR+FbzmwkqQDwQ060De5XijqdU3VD64xxHeQeFtgHG/LqAOCaUTzVtKzx fuhrmann@jfzbook.wias-berlin.de
```

Be  sure, that  the  whole  subdirectory `.ssh`  is  readable only  by
yourself. To ensure this, issue

```
chmod -R go-rwx .ssh
```

from the home directory on the remote host.

Then you can login using

```
mylaptop$ ssh -i .ssh/id_rsa gate.institute.com
Enter passphrase for RSA key 'user@nmnb2': 
```

So, now  you authenticate  with the passphrase  instead of  the remote
password.

You can  store as  many public keys  in `.ssh/authorized_keys`  as you
like, thus giving access to your  account to other identities of yours
(e.g. form  other computers)  or to other  people (wich  you should'nt
do).  Just add the line by line.   Be careful not to break the keys by
accidental insertion of a line break. Each key uses exactly one line.

Behind this implemenatation lies the idea of [public-key  cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography).



~~~

<center>
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Public_key_encryption.svg/1048px-Public_key_encryption.svg.png"
style="width: 400px;">

Public-private cryptography (public domain)
</center>
~~~




Nice...  but still I have to activate my key every time I want to use it...


### Password-less login: identity management by ssh-agent

Communicating with  `ssh-agent`, the command `ssh-add`  activates your
*private  key*  for  automatic  use  by  `ssh`  after  verifying  your
passphrase:

```
mylaptop$ ssh-add
Need passphrase for .ssh/id_rsa
Enter passphrase for user@nmnb2 
Identity added: .ssh/id_rsa (user@nmnb2)
```

The identity is then activated throughout your desktop session.
Now try to issue

```
ssh user@gate.institute.com
```

If  everything  works, you  will  be  logged  in without  password  or
passphrase request.   The `ssh-agent` provides the  activated identity
to the remote host, which uses the public key to check for the match.

As long  as you keep  your passphrase and  your private key  safe, the
connection is  encrypted and the procedure  is as safe as  you can get
using  current  technology  (provided all  participating  systems  are
regularly updated).   You can increase security  by specifying higher
key lengths and more sophisticated cipher schemes when generating your
key pair,  and by specifying  a more  advanced cipher for  the session
keys using the `-c` flag of ssh.

Modern  desktop  systems  automatically   start  the  `ssh-agent`,  so
probably you do not have to care  about this. In times long passed you
would have done this yourself by issuing e.g. one of

```
$ ssh-agent xterm
$ ssh-agent bash
$ ssh-agent twm
```
	
## Other uses of ssh keys: gitlab, github

There are more annoying cases where one is asked for a password, e.g. when authenticating
with gitlab and github. Both allow to use ssh keys for authentication. After authentication via the web UI,
one can add the public key used for ssh authentication to a gitlab server under

```
https://gitlab.institute.com/-/user_settings/ssh_keys
```

Same for github, here the url is 

```
https://github.com/settings/keys
```
## ssh tunnel
For security reasons, ssh access to an institution from outside may be restricted to a
single host. In order to log in to one of the other computers, one needs first to log in to
this ssh access server, only from there, the desired system can be reached.

Let us assume, that  the host `gate.institute.com` is the system
which allows ssh login from outside  and `sees` `myhost`.
The login process then can look like:


```
mylaptop$ ssh gate.institute.com
Last login: Wed Nov 13 21:46:35 2024 from i59f7af27.versanet.de
user@gate$ ssh myserver
Last login: Wed Nov 13 21:47:20 2024 from gate.institute.com
user@myserver$
```

Alternatively, you can log in  from your laptop `mylaptop` to `gate.institute.com` using the command

````
mylaptop$ ssh gate.institute.com  -L 9000:myserver:22
````

This forwards port 22 (ssh) of `myserver` to port 9000 of `mylaptop` which can be accessed as `localhost`.
So now you can log in to `myserver` via
````
mylaptop$ ssh localhost -p9000
Last login: Wed Nov 13 21:47:20 2024 from gate.institute.com
user@myserver$
````

Ahhh ports... Every computer,  when connected to the internet has an "IP address" wich is this 
kind of number: 192.168.111.3 (for IPv4) and `fe80::dcc2:3e53:c099:8cde` (for IPv6). Connections
to a computer can be established in parallel by different services (e.g. ssh, http, smtp, imap), and
each of these services can be accessed via a specific "port". 


One can automatically establish this kind of tunneling for each log in to `gate.institute.com`.
Just add the following lines to your `~/.ssh/config` file
```
LocalForward 9000 myserver:22

Host smyserver
   Hostname localhost
   Port 9000
   HostKeyAlias smyserver
```

The you can login
```
mylaptop$ ssh gate.institute.com
gate$
```

and in another window
```
mylaptop$ ssh smyserver
myserver$
```
