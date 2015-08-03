# docker-redmine
docker化redmine

## 镜像特点

- 2015/6/28 继承基础镜像docker-ubuntu

## 使用方法

- 获取代码并构建

        git clone https://github.com/Dockerlover/docker-redmine.git
        git clone https://github.com/redmine/redmine.git
        cp redmine docker-redmine
        cd docker-redmine
        docker build -t docker-redmine .

- 运行容器

        docker run -d -it --name mysql -p 8301:80 \
        -v /var/data/mysql:/var/lib/mysql docker-redmine
