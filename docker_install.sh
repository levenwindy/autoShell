#!/usr/bin/env bash
# 0.ipv6设置
mkdir -p /etc/docker
tee /etc/docker/daemon.json  << EOF
{
  "experimental": true,
  "ipv6": true,
  "ip6tables": true,
  "fixed-cidr-v6": "2408::/64"
}
EOF

# 安装命令 最简--no-install-recommends
#alias aptIn='apt --no-install-recommends -y install '
function aptIn(){
	apt --no-install-recommends -y install $1
}

# apt源
function aptSources(){
tee  /etc/apt/sources.list  << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
EOF
rm -rf /var/lib/apt/lists/* 
apt-get clean
apt-get update
}
# 如apt失败	

#!/usr/bin/env bash
# 0.ipv6设置
mkdir -p /etc/docker
tee /etc/docker/daemon.json  << EOF
{
  "experimental": true,
  "ipv6": true,
  "ip6tables": true,
  "fixed-cidr-v6": "2408::/64"
}
EOF

# 安装命令 最简--no-install-recommends
#alias aptIn='apt --no-install-recommends -y install '
function aptIn(){
	apt --no-install-recommends -y install $1
}

# apt源
function aptSources(){
tee  /etc/apt/sources.list  << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
EOF
rm -rf /var/lib/apt/lists/* 
apt-get clean
apt-get update
}
# 如apt失败	
aptIn apt-transport-https
if [ ! $? -eq 0 ];then
	echo 'apt安装失败 '
	exit 1
	aptSources
	aptIn apt-transport-https
fi

# 1.添加GPG密钥
aptIn apt-transport-https ca-certificates gnupg lsb-release
echo '# 1.添加GPG密钥'
exit 0

# 2.添加gpq
curl -fsSL http://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu/gpg |  apt-key add -
# 3.安装ppa仓库
apt-get update && aptIn software-properties-common

# 4.添加docker软件源
(echo -e "\r")| add-apt-repository "deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

# 5.更新 apt 软件包缓存，并安装 docker-ce。
apt-get update 
aptIn docker-ce docker-ce-cli containerd.io

# 重新加载
systemctl daemon-reload
systemctl restart docker
