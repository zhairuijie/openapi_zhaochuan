FROM public-cn-beijing.cr.volces.com/public/golang:alpine as builder
# 指定构建过程中的工作目录
WORKDIR /app
# 将当前目录（dockerfile所在目录）下所有文件都拷贝到工作目录下（.dockerignore中文件除外）
COPY . /app/

# 执行代码编译命令。操作系统参数为linux，编译后的二进制产物命名为main，并存放在当前目录下。
RUN GOPROXY=https://goproxy.cn,direct GOOS=linux GOARCH=amd64 go build -o douyincloud .

FROM public-cn-beijing.cr.volces.com/public/dycloud-golang:alpine-3.17

WORKDIR /opt/application

COPY --from=builder /app /opt/application

USER root

ENV DOUYINCLOUD_CERT_PATH=/usr/local/share/ca-certificates/douyincloud_egress.crt
RUN apk add ca-certificates curl
RUN echo '-----BEGIN CERTIFICATE-----\
          MIIDhzCCAm+gAwIBAgIUaHCAS5Ncp/badbDHbr4XuKuvxsUwDQYJKoZIhvcNAQEL\
          BQAwUzELMAkGA1UEBhMCQ04xCzAJBgNVBAgMAkdEMQswCQYDVQQHDAJTWjETMBEG\
          A1UECgwKQWNtZSwgSW5jLjEVMBMGA1UEAwwMQWNtZSBSb290IENBMB4XDTIyMDgy\
          NDAzNDYwNFoXDTMyMDgyMTAzNDYwNFowUzELMAkGA1UEBhMCQ04xCzAJBgNVBAgM\
          AkdEMQswCQYDVQQHDAJTWjETMBEGA1UECgwKQWNtZSwgSW5jLjEVMBMGA1UEAwwM\
          QWNtZSBSb290IENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2nJT\
          mBguZhhPMWJ+zboASqwg6/AtkrziNO6fTodBsI8qXq5XvMfMawseICNi9GxmzVcW\
          nsmdR/K+iTB0E/IvgEKjScyliFHJi1AG2M4irerYalTpIWFNuRM1Zbx/DBbsLhXQ\
          ICoHcJycFYyNXGitt3Q/kQgLN+xPhHbaN7T9pO3anzrQJ2OWTLqTQwQJ+K/0imfG\
          /YMk1R4sbNw+9vHMHMzNyzIj+Gc95fefwsRjBWMHP5hCSY87985qDhzZ2xLIGCEf\
          t0xzCQVyUbxdJ49Le6IbIc8M8cGmTKFlKBfEnFN4bt4VflDoC7MBmbmtq79bKOAi\
          Avxj2XDFdTx9RAQg5QIDAQABo1MwUTAdBgNVHQ4EFgQUUvup3gmtSWiD0iqdwSBQ\
          zFnH04cwHwYDVR0jBBgwFoAUUvup3gmtSWiD0iqdwSBQzFnH04cwDwYDVR0TAQH/\
          BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAxVgjTcaBatupJdwKTxx/Ax514cN8\
          NiaV9hiGpWpm0Xc/vLdwZEn/3Em2k6Thf9qt5tqRuU3C7wHpCFiahJo/qdZefWge\
          PUGS6o7r6cCiwQZWjprgqQGrCqGUdNgqtOw6L54vSQq16Sfa8B1O0nQN2rEOvCiy\
          dKMvvQK7iEIAeXZoWyr868yWuSBupNjaoNHkOFa/ZdGQEOEOBKlO6OBHFeXBNHo1\
          pQ6kqC4zCF8cB1lU1R//rae9gcj+61xBV++lPBcW6lkkcZd18X8RB/YYHltGkb5G\
          7JQA5A4XnIhs8i9wJkekGP4Poe+t+MdGZWoZ7pPuJdy53z5EHJDxWP0dsg==\
          -----END CERTIFICATE-----' > $DOUYINCLOUD_CERT_PATH
RUN update-ca-certificates

RUN chmod 777 run.sh

EXPOSE 8000

#CMD /opt/application/run.sh