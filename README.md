# Technical Assessment
The following tasks should be completed, and all scripts, docker-compose, and ansible files pushed into a public git repository (eg GitHub). Clear instructions on how to run each of your deliverables should also be included. There are three sections within the technical assessment. There are also "Bonus Tasks" in each section which are optional.

## Project tree structure
```
.
├── ansible.d
│   └── postgres-play.yml
├── bash.d
│   ├── a a.wav
│   ├── b.wav
│   ├── c don't.wav
│   ├── d d.wav
│   └── rename.sh
├── docker.d
│   ├── docker-compose.yaml
│   └── src
│       ├── blue.html
│       ├── green.html
│       └── haproxy.cfg
└── README.md

4 directories, 11 files
```

## 1. PYTHON OR BASH SCRIPTING
- Write a script that will rename all files that have a `.wav` suffix in a given directory to `audiofile_DATESTAMP_###.wav`
- where `###` is a zero-padded integer that is incremented for each file encountered
- where `DATESTAMP` is in `YYYY-MM-DD` format, and is derived from the creation date of the file

##### Bonus Tasks (optional)
- extend code to be able to work with a different user-defined prefix and suffix - eg `videofile_DATESTAMP_###.mp4`
- implement argument management, so that directory, prefix and suffix can all be specified at runtime
- implement functionality to rename files in reverse-alphabetical order

### @1. BASH IMPLEMENTATION
The _rename_ script can be run using relative or absolute file-pahts `./rename.sh`
If no parameters are passed to the script, default values are assumed.
Default values are declared at the beginning in the `# GLOBALS` section.
For testing purposes empty `wav` files are provided in the `bash.d` directory.
Run `./rename.sh -h` for help.
This ignores all other parametrs, displays a help message and exits the script.
```
    PARAMETERS
        --dir, -d   directory-path           -d "."
        --suf, -s   suffix (file-extension)  -s "wav"
        --pre, -p   prefix                   -p "audiofile"
        --rev, -r   reverse-sort             -r [blank]
    EXAMPLE
    ./rename.sh -d "$HOME/music/dir" -r -p 'ABBA_prefix' -s 'mp3'
```

##### Execution
```bash
# Change directory to bash.d
./rename.sh
```

##### Tested with BASH
```
GNU bash, version 5.0.17(1)-release (x86_64-pc-linux-gnu)
```


## 2. DOCKER
Create a Docker-Compose multi-container application, that achieves the following goals:
- hosts a simple html page on two separate nginx containers
- the html page should contain the word _blue_ on one container and the word _green_ on the other
- place a haproxy loadbalancer container in front of nginx containers
- enable a method to view haproxy statistics via web interface

##### Bonus Tasks (optional)
- configure nginx access logs to be collected and stored in an ElasticSearch docker instance
- configure kibana to allow viewing these logs from ElasticSearch

### @2. DOCKER IMPLEMENTATION
A single docker compose file has been created.
Three docker containers are launched and run on `localhost`.
Both `nginx` containers have their respective _green_ or _blue_ `index.html`.
These files are _bound_ _(or mounted)_ to the container.
Internal ports `8000, 8001` are both exposed to `80`.
The `haprox` container waits for both `nginx` containers to be up.
It then listenes to and exposes port `80`.
This facilitates simple _round robin load balancing_.
Open a webbrowser with `http://localhost:80` and refreshing the page.

##### Starting the application
From within the `docker.d` directory run
```bash
docker-compose up -d
```

##### Testing load-balancing
```bash
for i in {1..6}; do
    curl http://localhost:80
    sleep 1
done
```

##### Stopping containers
```bash
docker kill haProxy nginxBlue nginxGreen
```

##### Tested with docker and docker-compose
```
Docker version 19.03.8, build afacb8b7f0
docker-compose version 1.24.0, build 0aa59064
```


## 3. ANSIBLE
create a simple ansible project (consisting of a playbook and role(s)) to configure a remote ubuntu server:
- use ansible to install postgresql on target server
- use ansible to ensure postgresql runs on server startup
- use ansible to enable inbound postgresql network connections from the network range `10.231.0.0/16` (md5)
- use ansible to ensure that SSH logins only work with ssh keypairs (no passwords)

##### Bonus Tasks (optional)
- use ansible to configure the firewall on the remote server to allow inbound connections on postgres port
- use ansible to configure a scheduled backup (dump) of the postgresql server

### @3. ANSIBLE IMPLEMENTATION
Provided ansible playbook is quite lean.
It is based on the assumption of having to manage one just one Ubuntu server.
This is directly derived from aforementioned requirement specification.
_"[C]onfigure a remote ubuntu server."_ (Singular)

The playbook runs aforementioned _tasks_ on the Ubuntu host sequentially:
1. Install postgres
2. Ensure postgres is up (state=started)
3. Find the `postgresql.conf` file
4. Add `10.231.0.0/16` to `liten_addresses`
5. Disable SSH login via password
6. Reload the SSH deamon
7. Allow incoming traffic on port `5432` via firewall
8. Create a cronjob for user `postgres` to run automated backups via `pg_dump`

The script should be invoked using the target-host's IP-address:
`ansible-playbook -i TA.RG.ET.IP, postgres-play.yml`


##### Tested with Ansible
```
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.2 (default, Jul 16 2020, 14:00:26) [GCC 9.3.0]
```