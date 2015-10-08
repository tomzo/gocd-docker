This is the repository which contains the Dockerfiles and supporting scripts for:

https://registry.hub.docker.com/u/gocd/gocd-dev/

https://registry.hub.docker.com/u/gocd/gocd-agent/

https://registry.hub.docker.com/u/gocd/gocd-server/

https://registry.hub.docker.com/u/gocd/gocd-build-installer/

Follow those URLs for more details about the actual images. For instructions to build the Docker images yourself, check
the first line of each Dockerfile.

## Building packages

Build official debian packages from master
```
docker run -it --rm=true -v `pwd`/out:/installers gocd/gocd-build-installer deb
```

Build debian and windows packages in custom branch from custom repository
```
docker run -it --rm=true -v -e REPO=https://github.com/arvindsv/gocd.git -e BRANCH=my_new_feature `pwd`/out:/installers gocd/gocd-build-installer deb win
```

Build debian packages for specific commit from custom repository
```
docker run -it --rm=true -v -e REPO=https://github.com/arvindsv/gocd.git -e COMMIT=sha `pwd`/out:/installers gocd/gocd-build-installer deb
```
