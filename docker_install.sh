#!/usr/bin/env bash
# 0.ipv6设置
mkdir -p /etc/docker
tee /etc/docker/daemon.json  << EOF
{
  "experimental": true,
  "ipv6": true,
  "ip6tables": true,
  "fixed-cidr-v6": "2408:8256::/64"
}
EOF

# 安装
function aptIn(){
	apt --no-install-recommends -y install $1
}
aptIn expect

# 1.添加GPG密钥
aptIn apt-transport-https ca-certificates curl gnupg lsb-release

# 2.添加gpq
curl -fsSL http://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu/gpg |  apt-key add -

# 3.安装ppa仓库
apt-get update && aptIn software-properties-common

# 4.添加docker软件源

(echo -e "\r")| add-apt-repository "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"



# 5.更新 apt 软件包缓存，并安装 docker-ce。
apt update && aptIn docker-ce docker-ce-cli containerd.io
# 重新加载
systemctl daemon-reload
systemctl restart docker
