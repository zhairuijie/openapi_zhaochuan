FROM golang:1.18.6 as builder
# 指定构建过程中的工作目录
WORKDIR /app
# 将当前目录（dockerfile所在目录）下所有文件都拷贝到工作目录下（.dockerignore中文件除外）
COPY . /app/

# 执行代码编译命令。操作系统参数为linux，编译后的二进制产物命名为main，并存放在当前目录下。
RUN GOPROXY=https://goproxy.cn,direct GOOS=linux GOARCH=amd64 go build -o douyincloud .

FROM public-cn-beijing.cr.volces.com/public/base:alpine-3.13

WORKDIR /opt/application

COPY --from=builder /app/douyincloud /app/run.sh /opt/application/

USER root

RUN chmod -R 777 /opt/application/run.sh

RUN /opt/application/run.sh