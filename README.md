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

## Building images

`gocd-build-installer` is good enough to build all packages from gocd git repository.
Then `gocd-server` and `gocd-agent` images can be build using packages produced
by the build-installer container.

**To build gocd-server and gocd-agent images** from any repository and branch/commit
you will need:
1. Working docker daemon. (Can be a remote one)
2. Checkout of this repository.

This will first build *development* environment, then server and agent images.
It may take 2-3 hours, depending on you setup.
To build server and agent images only .deb packages are needed. But during the
process you can also build any additional packages by setting `PACKAGES='deb win osx rpm zip'`

```
git clone git@github.com:tomzo/gocd-docker.git
cd gocd-docker
# optional - remote docker host
export DOCKER_HOST=tcp://<docker-ip>:2375
# optional - tag for your images
export TAG=15.3-2500
# optional - docker registry (to tag before pushing)
export DOCKER_REGISTRY=tomzo
# optional - set custom repository
export REPO=https://github.com/tomzo/gocd.git
export COMMIT=sha
./build-go-server.sh
./build-go-agent.sh
```
