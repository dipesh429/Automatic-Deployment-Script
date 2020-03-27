#! /bin/bash

#Variables
PWD=$(pwd)
javaRoot=${PWD}/frequencyMgmt/src/main/webapp/Application/
javaPropPath=${PWD}/frequencyMgmt/src/main/resources/
reactBuildPath=${PWD}/frequencyReact/build/
sshPas="P@ssw0rdD16!"


cd frequencyReact
mv src/app-config.js src/app-config-dev.js 
mv src/app-config-prod.js src/app-config.js
npm run build 
mv src/app-config.js src/app-config-prod.js
mv src/app-config-dev.js src/app-config.js
rm -rf ${javaRoot}* 
cp -r ${reactBuildPath}* ${javaRoot}
mv ${javaPropPath}application.properties ${javaPropPath}application.dev.properties
mv ${javaPropPath}application.prod.properties ${javaPropPath}application.properties
cd ../frequencyMgmt && mvn clean && mvn package
mv ${javaPropPath}application.properties ${javaPropPath}application.prod.properties
mv ${javaPropPath}application.dev.properties ${javaPropPath}application.properties

sshpass -p ${sshPas} ssh -o StrictHostKeyChecking=no phoenix@stg.phoenixsolutions.com.np -p 2235 "echo ${sshPas} | sudo -S rm /opt/tomcat/webapps/fms.war";
sshpass -p ${sshPas} scp -o StrictHostKeyChecking=no -r -P 2235 /home/dipesh/phoenix/frequenctNTA/frequencyMgmt/target/fms.war phoenix@stg.phoenixsolutions.com.np:/opt/tomcat/webapps