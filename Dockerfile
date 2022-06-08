FROM ubuntu:22.04 as build
RUN apt update && apt install -y git curl zip
WORKDIR /opt
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH="/opt/flutter/bin:${PATH}"
RUN flutter doctor

WORKDIR /app
ADD . /app
RUN flutter build web --web-renderer html

FROM nginx:1.21
COPY --from=build /app/build/web /usr/share/nginx/html