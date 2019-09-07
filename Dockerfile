# 指定这个镜像的基础是什么，我们选择了node: 8.9.3这个版本作为基础镜像
FROM node:8.9.3

# 安装nginx
RUN apt-get update \
	&& apt-get install -y nginx

# 指定工作目录
WORKDIR /app

# 将当前目录下的所有文件拷贝到工作目录下
COPY . /app/

# 生么运行时容器提供服务端口
EXPOSE 80

# 1. 安装依赖
# 2. 运行 npm run build
# 3. 将 dist 目录的所有文件拷贝到 nginx 的目录下
# 4. 删除工作目录的文件, 尤其是 node_modules 以减小镜像体积
# 由于镜像构建的每一步都会产生新层
# 为了减小镜像体积， 竟可能将一些同类操作, 集成到一个步骤中, 如下:
RUN npm config set registry https://registry.npm.taobao.org \
	&& npm install \
	&& npm run build \
	&& cp -r dist/* /var/www/html \
	&& rm -rf /app

# 以前台方式启动 nginx
CMD ["nginx", "-g", "daemon off;"]
