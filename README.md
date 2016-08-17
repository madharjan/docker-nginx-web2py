# docker-nginx-web2py
Docker container for Nginx with Web2py based on [madharjan/docker-nginx](https://github.com/madharjan/docker-nginx/)

* Nginx 1.4.6 & Web2py 2.14.6 (docker-nginx-web2py)

## Build

**Clone this project**
```
git clone https://github.com/madharjan/docker-nginx-web2py
cd docker-nginx-web2py
```

**Build Containers**
```
# login to DockerHub
docker login

# build
make

# test
make test

# tag
make tag_latest

# update Makefile & Changelog.md
# release
make release
```

**Tag and Commit to Git**
```
git tag 1.4.6
git push origin 1.4.6
```

### Development Environment
using VirtualBox & Ubuntu Cloud Image (Mac & Windows)

**Install Tools**

* [VirtualBox][virtualbox] 4.3.10 or greater
* [Vagrant][vagrant] 1.6 or greater
* [Cygwin][cygwin] (if using Windows)

Install `vagrant-vbguest` plugin to auto install VirtualBox Guest Addition to virtual machine.
```
vagrant plugin install vagrant-vbguest
```

[virtualbox]: https://www.virtualbox.org/
[vagrant]: https://www.vagrantup.com/downloads.html
[cygwin]: https://cygwin.com/install.html

**Clone this project**

```
git clone https://github.com/madharjan/docker-nginx-web2py
cd docker-nginx-web2py
```

**Startup Ubuntu VM on VirtualBox**

```
vagrant up
```

**Build Container**

```
# login to DockerHub
vagrant ssh -c "docker login"  

# build
vagrant ssh -c "cd /vagrant; make"

# test
vagrant ssh -c "cd /vagrant; make test"

# tag
vagrant ssh -c "cd /vagrant; make tag_latest"

# update Makefile & Changelog.md
# release
vagrant ssh -c "cd /vagrant; make release"
```

**Tag and Commit to Git**
```
git tag 2.14.6
git push origin 2.14.6
```

## Run Container

### Nginx with Web2py

**Run `nginx-web2py` container**
```
docker run -d -t \
  -p 80:80 \
  --name web2py \
  madharjan/docker-nginx-web2py:2.14.6 /sbin/my_init
```
