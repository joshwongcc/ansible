FROM archlinux:base AS base
USER root
RUN pacman -Syy && \
    pacman -S git vim tmux curl openssh base-devel ansible --noconfirm

FROM base AS asquith
RUN groupadd --gid 1000 observer
RUN useradd --create-home --shell /bin/bash --gid 1000 --uid 1000 abettik
RUN echo "%observer ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV USER abettik
USER abettik

FROM asquith
WORKDIR /home/abettik/ansible
COPY --chown=abettik:observer . .
CMD /bin/bash -c \
    "ansible-playbook local.yaml --tags untagged --ask-vault-pass; /bin/bash"
