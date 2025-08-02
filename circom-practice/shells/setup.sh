#! /bin/bash

Green='\033[0;32m'
NC='\033[0m'

printf "${Green}Step 1: Install circom${NC}\n"
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
sudo apt -y install build-essential
chmod +x $HOME/.cargo/env
$HOME/.cargo/env
git clone https://github.com/iden3/circom.git
cd ./circom
cargo build --release
cargo install --path circom
cd ../

printf "${Green}Step 2: Install snarkjs${NC}\n"
npm install -g snarkjs
