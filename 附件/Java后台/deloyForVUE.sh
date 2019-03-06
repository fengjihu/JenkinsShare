s script function is :                
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
PKG=$6

PROJ_VERSION=${PROJ_VERSION/"origin/"/""}

DOCKER_FILE="/data/dockerfiles/${DOCKER_NAME}/Dockerfile"
NGINX_FILE="/data/dockerfiles/${DOCKER_NAME}/nginx.conf"
DOCKER_FILE_DIR=/data/dockerfiles/${DOCKER_NAME}
echo ${DOCKER_FILE_DIR}
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
echo "FROM docker.io/nginx" > ${DOCKER_FILE}


#格式为maintainer ，指定维护者的信息
echo "MAINTAINER luoqy <290627601@qq.com>"                                                  >> ${DOCKER_FILE}

echo "RUN  rm -rf /etc/nginx/nginx.conf \
    rm -rf /usr/share/nginx/html/* "                                                        >> ${DOCKER_FILE}

echo "COPY dist /usr/share/nginx/html" 														>> ${DOCKER_FILE}
echo "COPY nginx.conf /etc/nginx/nginx.conf" 												>> ${DOCKER_FILE}

echo 'ENTRYPOINT ["nginx", "-g", "daemon off;"]' 											>> ${DOCKER_FILE}

echo "EXPOSE "${SPORT} 																		>> ${DOCKER_FILE}
cat ${DOCKER_FILE}
echo "**Init dockerfile end."

# ----------------------------------------------------
# Init nginx.conf
# ----------------------------------------------------
echo "#Init nginx.conf start: "   > ${NGINX_FILE}

echo 'user  nginx;   																		' >>${NGINX_FILE} 
echo 'worker_processes  1;  															    ' >>${NGINX_FILE} 
echo 'error_log  /var/log/nginx/error.log warn;   											' >>${NGINX_FILE} 
echo 'pid        /var/run/nginx.pid;   														' >>${NGINX_FILE} 
echo 'events {   																			' >>${NGINX_FILE} 
echo '    worker_connections  1024;   														' >>${NGINX_FILE} 
echo '}   																					' >>${NGINX_FILE} 
echo 'http {   																				' >>${NGINX_FILE} 
echo '    include       /etc/nginx/mime.types;   											' >>${NGINX_FILE} 
echo '    default_type  application/octet-stream;   										' >>${NGINX_FILE} 
echo '    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '   		' >>${NGINX_FILE} 
echo '                      '$status $body_bytes_sent "$http_referer" '   					' >>${NGINX_FILE} 
echo '                      '"$http_user_agent" "$http_x_forwarded_for"';   				' >>${NGINX_FILE} 
echo '    access_log  /var/log/nginx/access.log  main;   									' >>${NGINX_FILE} 
echo '    sendfile        on;   															' >>${NGINX_FILE} 
echo '    #tcp_nopush     on;   															' >>${NGINX_FILE} 
echo '    keepalive_timeout  65;   															' >>${NGINX_FILE} 
echo '    #gzip  on;   																		' >>${NGINX_FILE} 
echo '   upstream ydtAdmin {   															' >>${NGINX_FILE} 
echo '      server 192.168.1.180:'${DPORT}' fail_timeout=60;   								' >>${NGINX_FILE} 
echo '   }   																				' >>${NGINX_FILE} 
echo '   server {   																		' >>${NGINX_FILE} 
echo '       listen       '${SPORT}';   													' >>${NGINX_FILE} 
echo '       server_name  admin.ydt.com;   													' >>${NGINX_FILE} 
echo '       location / {   																' >>${NGINX_FILE} 
echo '            root   /usr/share/nginx/html;   											' >>${NGINX_FILE} 
echo '           # index  index.html index.htm;   											' >>${NGINX_FILE} 
echo '           # proxy_pass http://ydt_admin;   											' >>${NGINX_FILE} 
echo '       }   																			' >>${NGINX_FILE} 
echo '      # location ~ .*\.(html|htm|gif|jpg|jpeg|bmp|png|ico|txt|js|css)$ {   			' >>${NGINX_FILE} 
echo '       location ~ .*\.(html|htm|git|jpg|jpeg|bmp|png|ico|js|css)$ {   							' >>${NGINX_FILE} 
echo '            root /usr/share/nginx/html;   											' >>${NGINX_FILE} 
echo '       }   																			' >>${NGINX_FILE} 
echo '       location ~* \.json$ {   														' >>${NGINX_FILE} 
echo '	          proxy_pass http://ydtAdmin;   											' >>${NGINX_FILE} 
echo '       }   																			' >>${NGINX_FILE} 
echo '   }   																				' >>${NGINX_FILE} 
echo '}   																					' >>${NGINX_FILE} 

cat ${NGINX_FILE}
echo "**Init nginx.conf end."

# ----------------------------------------------------
# Build dockerfile
# ----------------------------------------------------
cd ${DOCKER_FILE_DIR}
rm -rf dist
mkdir dist
mv /data/dockerfiles/static/${DOCKER_NAME}/${PKG} ./
tar -zxvf ${PKG} -C dist/
rm -rf ${PKG}

echo ""
echo "##Build dockerfile for "${DOCKER_NAME}
/usr/bin/docker build -t ${DOCKER_NAME}:${PROJ_VERSION} . 


# ----------------------------------------------------
# Run docker container
# ----------------------------------------------------
echo ""
echo "##Running docker container: "${DOCKER_NAME}
/usr/bin/docker run --name=${DOCKER_NAME}_${PROJ_VERSION} --net host -d ${DOCKER_NAME}:${PROJ_VERSION}
#/usr/bin/docker run ${cmd}

echo ""

