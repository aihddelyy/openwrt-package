#!/bin/bash

shopt -s extglob
set +e
git rm -r --cache * >/dev/null 2>&1 &
rm -rf `find ./* -maxdepth 0 -type d ! -name ".github/diy"` >/dev/null 2>&1
mkdir -p relevance

# 定义稀疏克隆函数
function git_sparse_clone() {
trap 'rm -rf "$tmpdir"' EXIT
branch="$1" curl="$2" && shift 2
rootdir="$PWD"
tmpdir="$(mktemp -d)" || exit 1
if [ ${#branch} -lt 10 ]; then
    git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
    cd "$tmpdir"
else
    git clone --filter=blob:none --sparse "$curl" "$tmpdir"
    cd "$tmpdir"
    git checkout $branch
fi
if [ "$?" != 0 ]; then
    echo "error on $curl"
    exit 1
fi
git sparse-checkout init --cone
git sparse-checkout set "$@"
mv -n $@ $rootdir/ || true
cd $rootdir
}

# 定义移动目录函数
function mvdir() {
mv -n `find $1/* -maxdepth 0 -type d` ./
rm -rf $1
}

# 定义克隆函数
function git_clone() {
git clone --depth 1 $1 $2
if [ "$?" != 0 ]; then
    echo "error on $1"
    pid="$( ps -q $$ )"
    kill $pid
fi
}

git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config
git clone --depth 1 https://github.com/kiddin9/luci-app-adguardhome
git clone --depth 1 https://github.com/sirpdboy/luci-app-partexp
# git clone --depth 1 https://github.com/sbwml/v2ray-geodata
git clone --depth 1 https://github.com/muink/luci-app-homeproxy
# git clone --depth 1 https://github.com/asvow/luci-app-tailscale
# git clone --depth 1 https://github.com/tty228/luci-app-wechatpush
# git clone --depth 1 https://github.com/sirpdboy/luci-app-poweroffdevice
git clone --depth 1 https://github.com/sirpdboy/luci-app-netdata
git clone --depth 1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic
# git clone --depth 1 https://github.com/BROBIRD/openwrt-r8168
# git clone --depth 1 https://github.com/sbwml/package_kernel_r8125
git clone --depth 1 https://github.com/sbwml/luci-app-filemanager
# git clone --depth 1 https://github.com/schen39/luci-app-serverchan

git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages passwall-packages && cp passwall-packages ./relevance/ ; rm -rf passwall-packages
# git clone --depth 1 -b main https://github.com/fw876/helloworld && mvdir helloworld
# git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go && mvdir luci-app-ddns-go

git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall && mv -n openwrt-passwall/luci-app-passwall ./ ; rm -rf openwrt-passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2 && mv -n openwrt-passwall2/luci-app-passwall2 ./ ; rm -rf openwrt-passwall2
git clone --depth 1 https://github.com/kenzok8/wall && mv -n wall/adguardhome wall/filebrowser ./relevance/ ; rm -rf wall
# git clone --depth 1 https://github.com/xiangfeidexiaohuo/extra-ipk && mv -n extra-ipk/patch/wall-luci/luci-app-vssr ./ ; rm -rf extra-ipk
# git clone --depth 1 https://github.com/sbwml/luci-app-alist openwrt-alist && mv -n openwrt-alist/*alist ./ ; rm -rf openwrt-alist
git clone --depth 1 https://github.com/lisaac/luci-app-dockerman dockerman && mv -n dockerman/applications/luci-app-dockerman ./ ; rm -rf dockerman
git clone --depth 1 https://github.com/sbwml/packages_lang_golang && mv -n packages_lang_golang/golang ./relevance/ ; rm -rf packages_lang_golang
git clone --depth 1 https://github.com/linkease/istore luci-app-istore
git clone --depth 1 https://github.com/linkease/nas-packages-luci nas-packages-luci && mv -n nas-packages-luci/luci/luci-app-quickstart ./ ; rm -rf nas-packages-luci
git clone --depth 1 https://github.com/linkease/nas-packages nas-packages && mv -n nas-packages/network/services/quickstart ./relevance/ ; rm -rf nas-packages
git clone --depth 1 https://github.com/sirpdboy/luci-app-lucky sirpdboy-lucik && mv -n sirpdboy-lucik/*lucky ./ && mv -n lucky ./relevance/ ; rm -rf sirpdboy-lucik
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns luci-app-mosdns
# git clone --depth 1 https://github.com/sbwml/luci-app-qbittorrent sirpdboy-qbittorrent && mv -n sirpdboy-qbittorrent/* ./ ; rm -rf sirpdboy-qbittorrent
# git clone --depth 1 https://github.com/messense/aliyundrive-webdav aliyundrive && mv -n aliyundrive/openwrt/* ./ ; rm -rf aliyundrive
# git clone --depth 1 https://github.com/fw876/helloworld && mv -n helloworld/luci-app-ssr-plus ./ ; rm -rf helloworld
# git clone --depth 1 https://github.com/kiddin9/kwrt-packages && mv -n kwrt-packages/luci-app-bypass kwrt-packages/luci-app-fileassistant ./ ; rm -rf kwrt-packages
# git clone --depth 1 https://github.com/immortalwrt/packages && mv -n packages/net/{cdnspeedtest,dae,daed,vsftpd,transmission} ./ ; rm -rf packages
git clone --depth 1 https://github.com/immortalwrt/luci && mv -n luci/applications/{luci-app-filebrowser,luci-app-gost,luci-app-usb-printer,luci-app-vlmcsd,luci-app-transmission} ./ ; rm -rf luci
git clone --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki OpenWrt-nikki && mv -n OpenWrt-nikki/*nikki ./ && mv -n nikki ./relevance/ ; rm -rf OpenWrt-nikki
# git clone --depth 1 https://github.com/muink/openwrt-fchomo openwrt-fchomo && mv -n openwrt-fchomo/*homo ./ ; rm -rf openwrt-fchomo
git clone --depth 1 https://github.com/kiddin9/kwrt-packages kwrt-packages && mv -n kwrt-packages/*adbyby* ./ && mv -n adbyby ./relevance/ ; rm -rf kwrt-packages

git clone --depth 1 -b dev https://github.com/vernesong/OpenClash && mv -n OpenClash/luci-app-openclash ./ ; rm -rf OpenClash
# git_sparse_clone openwrt-24.10 "https://github.com/immortalwrt/luci" applications/luci-app-argon-config

# 清理目录
# mkdir -p relevance
# mv -f `find ./* -maxdepth 0 -type d ! -name "luci-app*"` ./relevance/ >/dev/null 2>&1
rm -rf ./*/.git & rm -rf ./*/.gitattributes
rm -rf ./*/.svn & rm -rf ./*/.github & rm -rf ./*/.gitignore
