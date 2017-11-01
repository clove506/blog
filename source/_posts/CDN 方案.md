---
title: 前端静态化 & CDN 方案
date: 2017-5-27 9:39:00
categories: CDN
tags:
- CDN
---

# 前端静态化 & CDN 方案



## 为什么要静态化？

以 C 端2.0 方案举例，前端代码体积对比

| 压缩方式        | 体积大小  |
| ----------- | ----- |
| 无           | 5MB   |
| uglify      | 1MB   |
| uglify+gzip | 500KB |

采用 `uglify` + `gzip` 的好处显而易见，用户直观感受：快了！

<!-- more -->
## 为什么要用 CDN？



以下是 CDN 的工作流程

![file](http://static.wayknew.com/assets/2017-05-27/6e0084af-c995-4f0c-94e0-97ac052ea638.png)

关键技术是在解析 CDN 地址时，可以智能的根据用户所在地址，动态的解析就近的 IP。

前端部署采用 CDN 技术的好处有以下几点：

- 智能（重要）
  根据用户所在区域分配 CDN 资源获取地址；
- 性能（重要）
  CDN 服务商按流量提供服务
- 可用性
  目前来讲，CDN 的可用性较高
- 安全性
  应对 DDOS 攻击，这点可以忽略不计

采用 CDN 对用户来讲，提高非服务器所在地的用户的访问速度。

## 如何静态化

前端开发完毕后，执行编译并 `uglify` 命令，生成静态的 `html`, `js`, `css` 等文件。而非以往的通过运行一个 nodejs 服务器监听特定端口来提供服务。

简单来说，就是前端以后交付运行的将是静态资源，而非一个 Node 服务。

## CDN 部署

CDN 使用阿里云的 CDN 服务。
主要步骤：
1. 将 `pub.youhujia.com` 设置为 CDN 域名，域名解析类型为 CNAME，指向一个 CDN 域名，例如 pub.youhujia.com.k.some-cdn.com；
2. 配置协议类型：HTTP/HTTPS 均可；
3. 设置源地址，例如 pub.static.youhujia.com，此为优护家提供的 NGINX 下的静态资源服务地址；
4. 部署 NGINX 静态资源服务器 http://pub.static.youhujia.com，注意这是 HTTP 协议；
5. 将前端的静态资源更新到 NGINX 下。


### 主要开源库分离

例如 angular, jquery, zeptojs 使用又拍云 CDN 源。

## 自动化方案（jenkins）

### 配置 Dockefile

在前端项目中加入以下 Dockerfile

```
FROM nginx
COPY dist /usr/share/nginx/html
COPY nginx-conf /etc/nginx
VOLUME /usr/share/nginx/html
VOLUME /etc/nginx
```

### 准备 NGINX 配置文件

将完整的 NGINX 配置文件放入 nginx-conf 目录

### Jenkins

以开发环境举例。
​		
1. Developer 提交 commit，并 push 至 github
2. Push 操作触发 Jenkins 的 Buiild 任务
3. 运行预定义好的 nodejs build 命令，生成 dist/ 文件夹，即编译后的静态资源
4. build docker image, 将 dist 和 nginx-conf 复制到 docker 中
5. push docker image 至阿里云容器服务
6. 重新部署


##  关键配置文件

* Dockerfile 见上文

* nginx.conf

这里注意要开启 gzip 压缩

```conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    client_max_body_size 10G;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;
}
```

* default.conf
`/ns` 路径为 309 医院特别配置，跳转老页面用。

```conf
server {
    listen 80;
    server_name static.pubc.youhujia.com;
    root /usr/share/nginx/html;
    index index.html;

    location /ns {
        expires -1;
        add_header Pragma "no-cache";
        add_header Cache-Control "no-store, no-cache, must-revalidate, post-check=0, pre-check=0";
        try_files $uri $uri/ /ns/nurseindex.html;
    }

    location / {
        expires -1;
        add_header Pragma "no-cache";
        add_header Cache-Control "no-store, no-cache, must-revalidate, post-check=0, pre-check=0";
        try_files $uri $uri/ /index.html;
    }

    access_log  /var/log/nginx/static.pub.youhujia.com_access.log;
}
```
