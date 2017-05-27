# ssh-honeypot
SSH Honeypot based on the pshitt project

## Quick Start
Getting started is quiet easy -- simply run this docker command:
```
sudo docker run -d --name ssh-honeypot -p 22:2200 danielschulz/ssh-honeypot
```

For more variables to configure this behaviour:
```
sudo docker run -d --name ssh-honeypot -p 22:2200 -v ${PWD}/ssh-key-TEST:/apps/sw/data/keyfiles/keyfile:Z -e DIRECTORY_LOGS="/apps/sw/data/pshitt/logs" -e DIRECTORY_DATA="/apps/sw/data/pshitt/data" -e THREADS=3 danielschulz/ssh-honeypot
```

Obviously, you are free to configure:
- the Docker Container's name, which here is "ssh-honeypot"
- the Docker Container's port mapping (${HOST_PORT}:${CONTAINER_PORT})
- the internally used RSA private RSA-Keyfile using the volumne mount (${HOST_PATH}:${CONTAINER_PATH}) so your Honeypot is not so easy to detect from the outside

## Helpful Advice

### SELinux
When mapping your Private Keyfile using the volume mount option, please make sure SELinux will not get in between Docker reading your files. So either
- map the file to the correct `svirt_sandbox_file_t` SELinux Context or
- reduce your security level in SELinux to at least `Permissive` using `sudo setenforce 0` or `sudo setenforce 'Permissive'`.

I'd prefer the former. The `:Z` option in the volume mapping takes care for it; but it can be done manually as well using:
```
sudo chcon -Rt svirt_sandbox_file_t ./ssh-key-TEST
```

### Provide the Private RSA Keyfile
The daemon will only start with a genuine RSA Private Keyfile provided. It is highly advisable to provide a custom RSA Keyfile, which is for this purpose only.

This command creates a password-less four Kilobytes long RSA Keyfile named `ssh-key-TEST` in this folder:
```
ssh-keygen -t rsa -N '' -b $(( 4*1024 )) -C "user@host" -f ./ssh-key-TEST
```

### Port 22 may be Occupied
When mapping this Docker Container to the host's port 22, this may end up taken. So make sure to clear it first. Honeypots in general will work best using the default port 22 as most invaders may look for this one. Also when SELinux is active and in `Enforcing` mode, make sure Docker has the privileges and the correct SELinux context to use port 22.
