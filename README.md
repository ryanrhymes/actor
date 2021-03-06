# OCaml Distributed Data Processing

A distributed data processing system developed in OCaml

# Todo

How to express arbitrary DAG? How to express loop? Apply function.

Interface to Irmin or HDFS to provide persistent storage

Test delay-bounded and error-bounded barrier

Split Context module into server and client two modules

Implement parameter.mli

Implement barrier control in parameter modules

Rename ... DataContext and ModelContext?

Implement Coordinate Descent in model parallel ...

Enhance Mapreduce engine, incorporate with owl.

Add techreport based on the barrier control.


# How to compile & run it?

To compile and build the system, you do not have to install all the software yourself. You can simply pull a ready-made container to set up development environment.

```bash
docker pull ryanrhymes/actor
```

Then you can start the container by

```bash
docker run -t -i ryanrhymes/actor:latest /bin/bash
```

After the container starts, go to the home director, clone the git repository.

```bash
git clone https://github.com/ryanrhymes/actor.git
```

Then you can compile and build the system.

```bash
make oasis && make
```
