# Docker Template
## Intro
Example project to use dockers to run a project/tool in a contained environment.

Contains:
- `Makefile`
- `Dockerfile`

Here there is a template on how to build a **minimal** `Ubuntu 20.04` Docker that contains
only the necessary packages to build, run and deploy the example project.

## Components

1. The `Dockerfile` describes the customized ubuntu distro that will be built, such as its
langugage, packages, copied files, entrypoint etc.

2. The `entrypoint.sh` script, which is just a series of commands that are run as soon as
   the docker is run and has its 'starting directory' the one defined in the `Dockerfile`
   by `WORKDIR`.

3. The `Makefile` is an easy tool to automate and make interfacing with the project much
   smoother.

   Its targets:
    - build:
        - build the docker image

    - run:
        - runs the created image and runs the entrypoint script, which basically builds
            and runs our project software.

    - clean:
        - Deletes created docker

    - clean-img:
        - Deletes created docker image

    - reset:
        - calls upon clean and clean-img

    - help:
        - Displays help text to screen to explain the Makefile.
