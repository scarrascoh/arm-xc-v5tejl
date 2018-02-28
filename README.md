# arm-xc-armv5tejl. ARM CrossCompile image for armv5tejl

Image with tools for crosscompile for the particular arm architecture armv5tejl

## Build

```bash
$ docker build -t scarrascoh/arm-xc-v5tejl:1.23.0 .
```

*Note:* Image compilation may take one hour.

## Run

```bash
$ docker run -ti --name arm-xc-v5tejl \
  scarrascoh/arm-xc-v5tejl:1.23.0 bash
```

## Usage

Binaries for cross-compile for ARM v5tejl are located on /home/arm/x-tools (and 
executables included in PATH environment)

*Note:* Tar files (that are downloaded by ct-ng by default) are provided inside config folder in order to 
allow a fastest compilation of build image.


# About crosstool-ng

This docker images uses crosstool-ng as toolchains for generate binaries for cross-compiling. You can find more info about it at their site [crosstool-ng.org](http://crosstool-ng.org/)


# Appendix A. How to build OpenSSH for ARM

```bash
export PATH="${PATH}:$WORKDIR/../x-tools/armv5tejl-unknown-linux-gnueabi/bin:${XTOOLNG_DIR}/bin"
export HOST=armv5tejl-unknown-linux-gnueabi
export ROOTFS=/home/arm/ssh-server/build
export SYSROOT=/home/arm/x-tools/armv5tejl-unknown-linux-gnueabi
```

## Compile zLib (v1.2.8)
cd ~/ssh-server/zlib-1.2.8 
AR=$HOST-ar CC=$HOST-gcc RANLIB=$HOST-ranlib ./configure --prefix=$ROOTFS/usr
make
make install

## Build openssl (v1.0.1e)
cd ~/ssh-server/openssl-1.0.1e
./Configure linux-armv4 shared zlib --prefix=$ROOTFS/usr --with-zlib-include=$ROOTFS/usr/include --with-zlib-lib=$ROOTFS/usr/lib
make CC=$HOST-gcc AR="$HOST-ar r" RANLIB=$HOST-ranlib
make CC=$HOST-gcc AR="$HOST-ar r" RANLIB=$HOST-ranlib INSTALL_PREFIX=$ROOTFS install

## Build openssh (v6.4p1)

**Step 1**
```bash
cd ~/ssh-server/openssh-6.4p1
./configure --host=$HOST --prefix=$ROOTFS/usr --with-zlib=$ROOTFS/usr --with-ssl-dir=$ROOTFS/usr
```
***Note**: If an openssl headers not found is thrown, check that openssl libraries were created under $ROOTFS/usr instead of $ROOTFS/usr/home/...*

**Step 2.** Remove the variable STRIP_OPT(or set value to "") and check-config in the rule install_files and install in Makefile.

**Step 3**
```bash
make && make DESTDIR=$ROOTFS install
```

## Generate ssh keys for server
```bash
ssh-keygen -t rsa1 -f $ROOTFS/usr/etc/ssh_host_key -N ""
ssh-keygen -t dsa -f $ROOTFS/usr/etc/ssh_host_dsa_key -N ""
ssh-keygen -t rsa -f $ROOTFS/usr/etc/ssh_host_rsa_key -N ""
ssh-keygen -t ecdsa -f $ROOTFS/usr/etc/ssh_host_ecdsa_key -N ""
```

### Copy required libraries with binaries under $ROOTFS (if target system does not have it)
cp /home/arm/x-tools/armv5tejl-unknown-linux-gnueabi/armv5tejl-unknown-linux-gnueabi/sysroot/lib/* $ROOTFS/usr/lib/
