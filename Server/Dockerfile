FROM ubuntu:20.04

RUN apt-get -y update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install aspcud && \
  apt-get install -y ocaml && \
  apt-get install -y opam && \
  apt-get install -y python3 python3-pip

RUN useradd -ms /bin/bash admin
USER admin

RUN opam init -a -y --disable-sandboxing --compiler=4.04.0; eval $(opam config env)

COPY --chown=admin:admin requirements.txt /home/vasyl/diploma_thesis/requirements.txt
RUN pip3 install -r /home/vasyl/diploma_thesis/requirements.txt

COPY --chown=admin:admin src/diploma_thesis /home/vasyl/diploma_thesis

WORKDIR /diploma_thesis
ENTRYPOINT [ "python3", "/home/vasyl/diploma_thesis/main.py"]
