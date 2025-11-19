FROM alpine:3.20 AS builder

RUN apk add --no-cache git nodejs npm python3 make g++

RUN git clone https://github.com/NetrisTV/ws-scrcpy.git /ws-scrcpy

WORKDIR /ws-scrcpy
RUN npm install
RUN npm run dist

WORKDIR dist
RUN npm install

FROM alpine:3.20 AS runner
LABEL maintainer="Haroun EL ALAMI <haroun.dev@gmail.com>"

RUN apk add --no-cache android-tools npm python3 make g++
COPY --from=builder /ws-scrcpy/dist /root/ws-scrcpy

WORKDIR /root/ws-scrcpy
RUN npm rebuild

CMD ["npm", "start"]