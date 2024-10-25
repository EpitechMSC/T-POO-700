# # first stage builds vue 
# FROM node:22.7.0-alpine3.19 as build-stage

# WORKDIR /app
# COPY . .
# RUN npm ci
# RUN npm run build 


# //get build result from build-stage go to ../mobile and build cordova with an apk
FROM beevelop/android-nodejs

ENV CORDOVA_VERSION=12.0.0 \
    CORDOVA_BUILD_TOOLS_VERSION=33.0.2 \
    ANDROID_HOME=/opt/android

WORKDIR "/tmp"

RUN while true; do echo 'y'; sleep 2; done | sdkmanager "build-tools;${CORDOVA_BUILD_TOOLS_VERSION}" && \
    npm i -g --unsafe-perm cordova@${CORDOVA_VERSION} && \
    cordova -v && \
    cd /tmp && \
    cordova create myApp com.myCompany.myApp myApp && \
    cd myApp && \
    cordova plugin add cordova-plugin-camera --save && \
    cordova platform add android --save && \
    cordova requirements android && \
    cordova build android --verbose 

# RUN cordova create . com.gotham.mobile Mobile
# WORKDIR /app/Mobile
# RUN cordova platform add android
# # COPY --from=build-stage /app/dist /app/www
# RUN cordova build android 
# # //output the apk outside the container

COPY --from=cordova-build /output/app-release.apk /output/app-release.apk

CMD ["ls", "-l"]
