#!/bin/sh

apk update
apk add nano docker bc bash neofetch

rc-update add docker boot
service docker start

cat <<EOF > Dockerfile
FROM ubuntu:22.04

RUN apt-get update 
RUN apt-get install -y neofetch wget dialog openssh-server 
RUN wget -O /usr/bin/neofetch https://raw.githubusercontent.com/katy-the-kat/realinstallscript/refs/heads/main/flexingfr3
RUN wget -O /usr/bin/ddosprotection https://raw.githubusercontent.com/katy-the-kat/realinstallscript/refs/heads/main/ddosprotection
RUN chmod +x /usr/bin/ddosprotection
RUN sed -i 's/^#\\?\\s*PermitRootLogin\\s\\+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo 'root:root' | chpasswd
RUN printf '#!/bin/sh\\nexit 0' > /usr/sbin/policy-rc.d
RUN apt-get install -y systemd systemd-sysv dbus dbus-user-session
RUN printf "systemctl start systemd-logind" >> /etc/profile

CMD ["bash /usr/bin/ddosprotection &"]
ENTRYPOINT ["/sbin/init"]
EOF

docker build -t utmp .
docker run -p 23:22 --privileged --restart unless-stopped --name server -d utmp
