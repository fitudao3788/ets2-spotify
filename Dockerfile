FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget supervisor dbus pulseaudio icecast2 darkice \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/librespot.tar.gz https://github.com/devgianlu/go-librespot/releases/download/v0.7.4/go-librespot_linux_x86_64.tar.gz \
    && tar -xzf /tmp/librespot.tar.gz -C /tmp \
    && mv /tmp/go-librespot /usr/local/bin/librespot \
    && rm -rf /tmp/README.md

COPY --from=ghcr.io/astral-sh/uv:0.11.29 /uv /uvx /bin/

ADD ./assets/supervisord.conf /etc/supervisor/supervisord.conf
ADD ./assets/icecast.xml /etc/icecast2/icecast.xml
ADD ./assets/darkice.cfg /etc/darkice.cfg

COPY ./web /app/web
ENV UV_NO_DEV=1
RUN cd /app/web && uv sync --locked

RUN usermod -d /var/run/pulse pulse \
    && sed -i 's/load-module module-native-protocol-unix.*/load-module module-native-protocol-unix auth-anonymous=1/' /etc/pulse/system.pa

EXPOSE 8000 8080

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
