FROM alpine:edge AS builder

RUN apk upgrade
RUN apk add --no-cache git nodejs npm python3 make g++

RUN git clone https://github.com/NetrisTV/ws-scrcpy.git /ws-scrcpy

WORKDIR /ws-scrcpy
RUN npm install
RUN npm run dist

WORKDIR dist
RUN npm install

FROM alpine:edge AS runner
LABEL maintainer="Haroun EL ALAMI <haroun.dev@gmail.com>"

RUN apk add --no-cache android-tools npm
COPY --from=builder /ws-scrcpy/dist /root/ws-scrcpy

WORKDIR /root/ws-scrcpy
CMD ["npm", "start"]