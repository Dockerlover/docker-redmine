# 基础镜像
FROM docker-rails
# 维护人员
MAINTAINER  liuhong1.happy@163.com
# 添加环境变量
ENV USER_NAME admin
ENV SERVICE_ID redmine
ENV MYSQL_MAJOR 5.7
ENV MYSQL_VERSION 5.7.8-rc
ENV MYSQL_ROOT_PASSWORD testpass
ENV MYSQL_USER redmine
ENV MYSQL_PASSWORD testpass
ENV MYSQL_DATABASE redmine
# 安装mysql
RUN groupadd -r mysql && useradd -r -g mysql mysql
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5
RUN echo "deb http://repo.mysql.com/apt/debian/ wheezy mysql-${MYSQL_MAJOR}-dmr" > /etc/apt/sources.list.d/mysql.list
RUN { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections \
	&& apt-get update && apt-get install -y mysql-server="${MYSQL_VERSION}"* && rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql
# 设置mysql数据卷映射
VOLUME /var/lib/mysql
# 复制启动脚本
COPY start.sh /start.sh
RUN chmod +x /*.sh
#复制代码
COPY . /app
RUN gem install actionpack-action_caching actionpack-page_caching action_param_caching && bundle install
# 复制supervisord.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# 启动supervisord
CMD ["/usr/bin/supervisord"]
