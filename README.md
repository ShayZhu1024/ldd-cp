# ldd-cp
Use the ldd command to find the libraries that the dynamically linked program depends on, and build them into the rootfs directory.  Extremely convenient for building very small Docker images.         


## usage

For simple programs, all dependent dynamic link libraries can be found, but for complex programs, some may be missing.

Place this script in a clean working directory.
The parameter that follows must be the absolute path corresponding to the command.

```bash
bash ldd-cp.sh  `which bash`
```

The script will then generate a rootfs directory in the current directory.

```bash
rootfs/
├── bin -> usr/bin
├── lib -> usr/lib/
├── lib32 -> usr/lib32
├── lib64 -> usr/lib64
├── libx32 -> usr/libx32/
├── sbin -> usr/sbin
└── usr
    ├── bin
    ├── lib
    │   └── x86_64-linux-gnu
    │       ├── ld-linux-x86-64.so.2
    │       ├── libc.so.6
    │       ├── libtinfo.so.6 -> libtinfo.so.6.3
    │       └── libtinfo.so.6.3
    ├── lib32
    ├── lib64
    │   └── ld-linux-x86-64.so.2 -> /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
    ├── libx32
    ├── local
    │   ├── bin
    │   └── sbin
    └── sbin

17 directories, 5 files
```

Then you need to place the executable itself into the corresponding bin directory.

```bash
cp -a `which bash` ./rootfs/bin/
```
OK!!!! 


## creating  image 

cd rootfs
```bash
tar zcf ../rootfs.tar.gz   ./*
```

create Dockerfile

```bash
FROM scratch
ADD rootfs.tar.gz  /
ENV ENV LD_LIBRARY_PATH=/lib/:/lib64/:/lib32/:/libx32/  PATH=/bin/:/usr/sbin/
CMD ["bash"]
```

Test whether it is effective

```bash
docker build -t bash:1.0.0  .

docker run -it --rm bash:1.0.0  bash
```
If some dynamic link libraries are still missing, you may need to manually locate them based on the prompts.

If you want to add other commands, repeat this step in the current working directory. There may be some errors, but they will not affect the creation of the dynamic link library.


