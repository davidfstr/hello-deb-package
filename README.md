# hello .deb Package

This directory contains instructions for building a .deb package that installs 
a `hello` command line tool.

## Prerequisites

* Docker
* Python 3.x

## How to Build

* Go to this directory in the Terminal and run the following commands:

```
$ docker build -t hello-build:latest .
$ mkdir -p build
$ docker save -o build/hello-build.tar hello-build:latest
$ cd build
$ tar xf hello-build.tar
$ python3 <<EOF
import json
with open('manifest.json', 'rb') as f:
    manifest = json.load(f)
print(manifest[0]['Layers'][-1])
EOF
```

* On that last command you should get output like:

```
70fe9f79e984de8cc35a2dec436c205f81a028668cd8e848787a6de3698540b4/layer.tar
```

* Save that output to $LAYER using code like:

```
export LAYER=70fe9f79e984de8cc35a2dec436c205f81a028668cd8e848787a6de3698540b4/layer.tar
```

* Continue executing commands:

```
$ mkdir layer
$ tar Cxf layer $LAYER
$ cd layer
$ cp -r ../../DEBIAN ./DEBIAN
$ find . -name .DS_Store | xargs rm  # remove .DS_Store files created by macOS
# rmdir etc  # remove empty etc directory
$ docker run -it -v .:/home --name deb-builder debian:latest
$$ dpkg-deb --root-owner-group --build home
$$ dpkg -c home.deb | more  # (Optional) verify contents look OK
$$ apt-get update
$$ apt-get install lintian -y
$$ lintian --tag-display-limit 0 home.deb  # (Optional) verify output looks OK
$$ cp home.deb /home/hello_1.0_all.deb
$$ exit
```

* There should now be a .deb package in the current directory in Terminal:
* To verify that package is installable, run the following commands:

```
$ docker run -it -v .:/home --name deb-tester debian:latest
$$ apt-get update
$$ apt-get install ./home/hello_1.0_all.deb -y
$$ which hello  # ensure installed
/usr/bin/hello
$$ hello  # ensure runs
Hello world!
$$ exit
```

* You now have a verified `hello_1.0_all.deb` package! 🎉 
