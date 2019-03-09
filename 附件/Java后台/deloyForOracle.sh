#!/bin/bash
############################################
# this script function is :                
# deploy new docker container             
#                                          
# USER        YYYY-MM-DD - ACTION          
# junsansi    2016-01-25 - CREATED        
#                                          
############################################

parasnum=6
# function
help_msg()
{
cat << help
+----------------------------------------------------+
+ Error Cause:
+ you enter $# parameters
+ the total paramenter number must be $parasnum
+ 1st :DOCKER_NAME
+ 2nd :PROJECT_NAME
+ 3rd :PROJECT_VERSION
+ 4th :SOURCE_PORT
+ 5th :DESTINATION_PORT
+----------------------------------------------------+
help
}

# ----------------------------------------------------
# Check parameter number
# ----------------------------------------------------
if [ $# -ne ${parasnum} ]
then
        help_msg 
        exit
fi

# ----------------------------------------------------
# Initialize the parameter.
# ----------------------------------------------------
DOCKER_NAME=$1
PROJECT_NAME=$2
PROJ_VERSION=$3
SPORT=$4
DPORT=$5
SDPORT=$6

PROJ_VERSION=${PROJ_VERSION/"origin/"/""}

DOCKER_FILE="/data/dockerfiles/${DOCKER_NAME}/Dockerfile"
SERVER_FILE="/data/dockerfiles/${DOCKER_NAME}/server.xml"
WORK_DIR="/usr/local/tomcat/"
DOCKER_FILE_DIR=/data/dockerfiles/${DOCKER_NAME}
if [ ! -d ${DOCKER_FILE_DIR} ]; then
        mkdir -p ${DOCKER_FILE_DIR}
fi

# ----------------------------------------------------
# check docker images
# ----------------------------------------------------
DOCKER_IMAGE=`/usr/bin/docker images | grep ${DOCKER_NAME} | awk -F ' ' '{print $3}'`
if [ -n "${DOCKER_IMAGE}" ]; then
        # check docker container
        for dc in `/usr/bin/docker ps -a | grep ${DOCKER_NAME} | awk -F " " '{print $1}'`
        do
                echo "Stop container: ${dc}"
                /usr/bin/docker stop ${dc}
                # delete while docker container was exists
                echo "##Delete exists Container_Id: "${dc}
                /usr/bin/docker rm ${dc}
        done

        # delete while docker image was exists
        echo "##Delete exists Image: "${DOCKER_IMAGE}
        /usr/bin/docker rmi ${DOCKER_IMAGE} 
fi
echo ""

# ----------------------------------------------------
# Init dockerfile
# ----------------------------------------------------
echo "**Init dockerfile start: "${DOCKER_FILE}
#echo "FROM tomcat" > ${DOCKER_FILE}
#echo 'MAINTAINER junsansi "junsansi@sina.com"' >> ${DOCKER_FILE}
#echo "ADD *.war /usr/local/tomcat/webapps/${PROJECT_NAME}.war" >> ${DOCKER_FILE}
#echo "EXPOSE 8080" >> ${DOCKER_FILE}
#echo "CMD /usr/local/tomcat/bin/startup.sh && tail -f /usr/local/tomcat/logs/catalina.out" >> ${DOCKER_FILE}
#cat ${DOCKER_FILE}
#echo "**Init dockerfile end."

#第一行必须指令基于的基础镜像
#echo "FROM docker.io/tomcat:8.0.53-jre8-alpine" > ${DOCKER_FILE}
echo "FROM wangzunbin/tomcat8-sunjre8-alpine:1.0" > ${DOCKER_FILE}

#格式为maintainer ，指定维护者的信息
echo "MAINTAINER luoqy <290627601@qq.com>" >> ${DOCKER_FILE}

#指定一个环境变量，会被后续 RUN 指令使用，并在容器运行时保持
echo "ENV WORK_DIR /usr/local/tomcat/" >> ${DOCKER_FILE}

echo "ENV JPDA_ADDRESS "${DPORT} >> ${DOCKER_FILE}

#格式为Run 或者Run [“executable” ,”Param1”, “param2”]
#前者在shell终端上运行，即/bin/sh -C，后者使用exec运行。例如：RUN [“/bin/bash”, “-c”,”echo hello”]
#每条run指令在当前基础镜像执行，并且提交新镜像。当命令比较长时，可以使用“/”换行。
echo "RUN  rm -rf ${WORK_DIR}/webapps/* \
    rm -rf ${WORK_DIR}/conf/server.xml"  >> ${DOCKER_FILE}

#解决docker时区和宿舍时区不同
#echo 'RUN apk --no-cache add tzdata  && \
#    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
#    echo "Asia/Shanghai" > /etc/timezone'   >> ${DOCKER_FILE}


echo "COPY server.xml ${WORK_DIR}/conf/server.xml" >> ${DOCKER_FILE}

#增强版的COPY，支持将远程URL的资源加入到镜像的文件系统
echo "ADD ROOT.war ${WORK_DIR}/webapps/ROOT.war" >> ${DOCKER_FILE}

#挂载运行日志
#VOLUME /var/log/xzn/

#配置容器启动后执行的命令，并且不可被 docker run 提供的参数覆盖。
#每个Dockerfile中只能有一个 ENTRYPOINT ，当指定多个时，只有最后一个起效。
echo 'ENTRYPOINT ["catalina.sh", "jpda", "run"]' >> ${DOCKER_FILE}

echo "EXPOSE "${SPORT} >> ${DOCKER_FILE}
cat ${DOCKER_FILE}
echo "**Init dockerfile end."

# ----------------------------------------------------
# Init server.xml
# ----------------------------------------------------
echo "**Init server.xml start: "${SERVER_FILE}
echo "<?xml version='1.0' encoding='utf-8'?>" > ${SERVER_FILE}
echo '<Server port="'${SDPORT}'" shutdown="SHUTDOWN">					        ' >>${SERVER_FILE} 
echo ' <Listener className="org.apache.catalina.startup.VersionLoggerListener" />               ' >>${SERVER_FILE} 
echo ' <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on" />    ' >>${SERVER_FILE} 
echo ' <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />        ' >>${SERVER_FILE} 
echo ' <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />     ' >>${SERVER_FILE} 
echo ' <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" />      ' >>${SERVER_FILE} 
echo ' <GlobalNamingResources>                                                                  ' >>${SERVER_FILE} 
echo '   <Resource name="UserDatabase" auth="Container"                                         ' >>${SERVER_FILE} 
echo '             type="org.apache.catalina.UserDatabase"                                      ' >>${SERVER_FILE} 
echo '             description="User database that can be updated and saved"                    ' >>${SERVER_FILE} 
echo '             factory="org.apache.catalina.users.MemoryUserDatabaseFactory"                ' >>${SERVER_FILE} 
echo '             pathname="conf/tomcat-users.xml" />                                          ' >>${SERVER_FILE} 
echo ' </GlobalNamingResources>                                                                 ' >>${SERVER_FILE} 
echo ' <Service name="Catalina">                                                                ' >>${SERVER_FILE} 
echo '   <Connector port="'${SPORT}'" protocol="HTTP/1.1"                                       ' >>${SERVER_FILE} 
echo '             connectionTimeout="20000"                                                    ' >>${SERVER_FILE} 
echo '              redirectPort="8443" />                                                      ' >>${SERVER_FILE} 
echo '   <Connector port="8811" protocol="AJP/1.3" redirectPort="8443" />                       ' >>${SERVER_FILE} 
echo '   <Engine name="Catalina" defaultHost="localhost">                                       ' >>${SERVER_FILE} 
echo '     <Realm className="org.apache.catalina.realm.LockOutRealm">                           ' >>${SERVER_FILE} 
echo '       <Realm className="org.apache.catalina.realm.UserDatabaseRealm"                     ' >>${SERVER_FILE} 
echo '              resourceName="UserDatabase"/>                                               ' >>${SERVER_FILE} 
echo '     </Realm>                                                                             ' >>${SERVER_FILE} 
echo '     <Host name="localhost"  appBase="webapps"                                            ' >>${SERVER_FILE} 
echo '           unpackWARs="true" autoDeploy="true">                                           ' >>${SERVER_FILE} 
echo '       <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"      ' >>${SERVER_FILE} 
echo '              prefix="localhost_access_log" suffix=".txt"                                 ' >>${SERVER_FILE} 
echo '              pattern="%h %l %u %t &quot;%r&quot; %s %b" />		                        ' >>${SERVER_FILE} 
echo '	    <Valve className="org.apache.catalina.valves.RemoteIpValve"                         ' >>${SERVER_FILE} 
echo '			   remoteIpHeader="x-forwarded-for"                                             ' >>${SERVER_FILE} 
echo '			   remoteIpProxiesHeader="x-forwarded-by"                                       ' >>${SERVER_FILE} 
echo '			   protocolHeader="x-forwarded-proto" />                                        ' >>${SERVER_FILE} 
echo '     </Host>                                                                              ' >>${SERVER_FILE} 
echo '   </Engine>                                                                              ' >>${SERVER_FILE} 
echo ' </Service>                                                                               ' >>${SERVER_FILE} 
echo '</Server>                                                                                 ' >>${SERVER_FILE} 
cat ${SERVER_FILE}
echo "**Init server.xml end."

# ----------------------------------------------------
# Build dockerfile
# ----------------------------------------------------
cd ${DOCKER_FILE_DIR}
rm *.war -rf
mv /data/dockerfiles/war/${DOCKER_NAME}/*.war ./
echo ""
echo "##Build dockerfile for "${DOCKER_NAME}
/usr/bin/docker build -t ${DOCKER_NAME}:${PROJ_VERSION} . 


# ----------------------------------------------------
# Run docker container
# ----------------------------------------------------
echo ""
echo "##Running docker container: "${DOCKER_NAME}
#/usr/bin/docker run --name ${DOCKER_NAME}_d1 -d -p ${SPORT}:${DPORT} ${DOCKER_NAME}:${PROJ_VERSION}
#/usr/bin/docker run --name=${DOCKER_NAME}_${PROJ_VERSION} --net host -d ${DOCKER_NAME}:${PROJ_VERSION}
#解决时区的问题
#/usr/bin/docker run --name=${DOCKER_NAME}_${PROJ_VERSION} -e TZ="Asia/Shanghai" --net host -d ${DOCKER_NAME}:${PROJ_VERSION}
/usr/bin/docker run --name=${DOCKER_NAME}_${PROJ_VERSION}  --net host -d ${DOCKER_NAME}:${PROJ_VERSION}
#/usr/bin/docker run ${cmd}
#/usr/bin/docker run -v /etc/timezone:/etc/timezone -v /etc/localtime:/etc/localtime --name=${DOCKER_NAME}_${PROJ_VERSION} --net host -d ${DOCKER_NAME}:${PROJ_VERSION}
echo ""
