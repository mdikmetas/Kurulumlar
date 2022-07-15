#!/bin/bash
echo "=================================================="
echo "   _  ______  ___  __________________";
echo "  / |/ / __ \/ _ \/ __/  _/ __/_  __/";
echo " /    / /_/ / // / _/_/ /_\ \  / /   ";
echo "/_/|_/\____/____/___/___/___/ /_/    ";
echo -e "\e[0m"
echo "=================================================="                                     


sleep 2

# DEGISKENLER by Nodeist
QCK_WALLET=wallet
QCK=quicksilverd
QCK_ID=killerqueen-1
QCK_PORT=36
QCK_FOLDER=.quicksilverd
QCK_VER=v0.4.2
QCK_REPO=https://github.com/ingenuity-build/quicksilver.git
QCK_GENESIS=https://raw.githubusercontent.com/ingenuity-build/testnets/main/killerqueen/genesis.json
QCK_ADDRBOOK=
QCK_MIN_GAS=0
QCK_DENOM=uqck
QCK_SEEDS=dd3460ec11f78b4a7c4336f22a356fe00805ab64@seed.killerqueen-1.quicksilver.zone:26656
QCK_PEERS=4742e1b942acf17c31794cce80d199886d172c4f@135.181.133.37:31656,a57ef5ba1cc5197356707c661e2bf33e51b2847e@154.26.130.167:44656,d1bd9c232bcc31e163082f83642b42d5f382ecbc@43.156.106.22:26656,201721bd252ebf90c46113b5d5ecafbdd428e2f2@43.156.225.194:26656,46d2eb9953403de555369ab5d144c713a6e5b960@144.76.67.53:2390,cdef7359f527cf0c7813a3fa640d412651798c79@65.108.75.32:11656,89064c6c8992d0348a6fa20434e50d33b27713c8@65.108.233.4:26656,3fd5878b299c0061a3965547b5927911e265c741@43.156.106.69:26656,7a91e43cabc2df44beac2ce6b7b5d4bb34c15376@43.156.105.72:26656,167918c83385f9532c9b25f7c9bdec67d053aaea@43.156.106.60:26656,fcfcf2402f106b300ada70fce2ff52603290c43a@104.248.112.44:11656,daa689918642101fbedced891166647c2a575a78@75.119.135.34:26656,b1265b31daa3e0cdd32a38105f7190afdba04109@43.133.184.206:26656

sleep 1

echo "export QCK_WALLET=${QCK_WALLET}" >> $HOME/.bash_profile
echo "export QCK=${QCK}" >> $HOME/.bash_profile
echo "export QCK_ID=${QCK_ID}" >> $HOME/.bash_profile
echo "export QCK_PORT=${QCK_PORT}" >> $HOME/.bash_profile
echo "export QCK_FOLDER=${QCK_FOLDER}" >> $HOME/.bash_profile
echo "export QCK_VER=${QCK_VER}" >> $HOME/.bash_profile
echo "export QCK_REPO=${QCK_REPO}" >> $HOME/.bash_profile
echo "export QCK_GENESIS=${QCK_GENESIS}" >> $HOME/.bash_profile
echo "export QCK_PEERS=${QCK_PEERS}" >> $HOME/.bash_profile
echo "export QCK_SEED=${QCK_SEED}" >> $HOME/.bash_profile
echo "export QCK_MIN_GAS=${QCK_MIN_GAS}" >> $HOME/.bash_profile
echo "export QCK_MIN_GAS=${QCK_DENOM}" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 1

if [ ! $NODENAME ]; then
	read -p "NODE ISMI YAZINIZ: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

echo -e "NODE ISMINIZ: \e[1m\e[32m$NODENAME\e[0m"
echo -e "CUZDAN ISMINIZ: \e[1m\e[32m$WALLET\e[0m"
echo -e "CHAIN ISMI: \e[1m\e[32m$QCK_ID\e[0m"
echo -e "PORT NUMARANIZ: \e[1m\e[32m$QCK_PORT\e[0m"
echo '================================================='

sleep 2


# GUNCELLEMELER by Nodeist
echo -e "\e[1m\e[32m1. GUNCELLEMELER YUKLENIYOR... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y


# GEREKLI PAKETLER by Nodeist
echo -e "\e[1m\e[32m2. GEREKLILIKLER YUKLENIYOR... \e[0m" && sleep 1
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

# GO KURULUMU by Nodeist
echo -e "\e[1m\e[32m1. GO KURULUYOR... \e[0m" && sleep 1
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

sleep 1

# KUTUPHANE KURULUMU by Nodeist
echo -e "\e[1m\e[32m1. REPO YUKLENIYOR... \e[0m" && sleep 1
cd $HOME
git clone $QCK_REPO
cd core
git checkout $QCK_VER
make install

sleep 1

# KONFIGURASYON by Nodeist
echo -e "\e[1m\e[32m1. KONFIGURASYONLAR AYARLANIYOR... \e[0m" && sleep 1
$QCK config chain-id $QCK_ID
$QCK config keyring-backend file
$QCK init $NODENAME --chain-id $QCK_ID

# ADDRBOOK ve GENESIS by Nodeist
wget $QCK_GENESIS -O $HOME/$QCK_FOLDER/config/genesis.json
wget $QCK_ADDRBOOK -O $HOME/$QCK_FOLDER/config/addrbook.json

# EŞLER VE TOHUMLAR by Nodeist
SEEDS="$QCK_SEEDS"
PEERS="$QCK_PEERS"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$QCK_FOLDER/config/config.toml

sleep 1


# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$QCK_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$QCK_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$QCK_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$QCK_FOLDER/config/app.toml


# ÖZELLEŞTİRİLMİŞ PORTLAR by Nodeist
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${QCK_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${QCK_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${QCK_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${QCK_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${QCK_PORT}660\"%" $HOME/$QCK_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${QCK_PORT}317\"%; s%^address = \":8080\"%address = \":${QCK_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${QCK_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${QCK_PORT}091\"%" $HOME/$QCK_FOLDER/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${QCK_PORT}657\"%" $HOME/$QCK_FOLDER/config/client.toml

# PROMETHEUS AKTIVASYON by Nodeist
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$QCK_FOLDER/config/config.toml

# MINIMUM GAS AYARI by Nodeist
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00125$QCK_DENOM\"/" $HOME/$QCK_FOLDER/config/app.toml

# INDEXER AYARI by Nodeist
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$QCK_FOLDER/config/config.toml

# RESET by Nodeist
$QCK tendermint unsafe-reset-all --home $HOME/$QCK_FOLDER

echo -e "\e[1m\e[32m4. SERVIS BASLATILIYOR... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/$QCK.service > /dev/null <<EOF
[Unit]
Description=$QCK
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which $QCK) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF


# SERVISLERI BASLAT by Nodeist
sudo systemctl daemon-reload
sudo systemctl enable kujirad
sudo systemctl restart kujirad

echo '=============== KURULUM TAMAM! by Nodeist ==================='
echo -e 'LOGLARI KONTROL ET: \e[1m\e[32mjournalctl -f $QCK\e[0m'
echo -e "SENKRONIZASYONU KONTROL ET: \e[1m\e[32mcurl -s localhost:${QCK_PORT}657/status | jq .result.sync_info\e[0m"

source $HOME/.bash_profile
