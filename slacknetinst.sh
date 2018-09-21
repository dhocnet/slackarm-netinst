#!/data/data/com.termux/files/usr/bin/bash
#
# Script installer Slackware-current ARM
#
# Oleh          : mongkeelutfi
# Email         : mongkee.lutfi@gmail.com
# Blog          : https://blog.dhocnet.work
# Kode sumber   : https://github.com/dhocnet/slackarm-netinst
#
# Tanggal       : 31 Juli 2018
#               : 01 Agustus 2018
#                : 05 Agustus 2018

# mengaktifkan teks blinkblink - text formating
shopt -s xpg_echo

# memperbaiki variabel $HOME pada beberapa ROM saat berada pada mode root
HOME=/data/data/com.termux/files/home

# paket miniroot
PKG_MINI="a/aaa_base
a/aaa_elflibs
a/aaa_terminfo
a/acl
a/attr
a/bash
a/tar
a/bin
a/btrfs-progs
a/bzip2
a/coreutils
a/dbus
a/dcron
a/devs
a/dialog
a/e2fsprogs
a/ed
a/etc
a/file
a/findutils
a/hostname
a/hwdata
a/lbzip2
a/less
a/gawk
a/gettext
a/getty-ps
a/glibc-solibs
a/glibc-zoneinfo
a/gptfdisk
a/grep
a/gzip
a/jfsutils
a/inotify-tools
a/kmod
a/lrzip
a/lzip
a/lzlib
a/pkgtools
a/procps-ng
a/reiserfsprogs
a/shadow
a/sed
a/sysklogd
a/usbutils
a/util-linux
a/which
a/xfsprogs
a/xz
ap/groff
ap/man-db
ap/man-pages
ap/nano
ap/slackpkg
d/perl
d/python
d/python-pip
d/python-setuptools
n/openssl
n/ca-certificates
n/gnupg
n/lftp
n/libmnl
n/network-scripts
n/nfs-utils
n/ntp
n/iputils
n/net-tools
n/iproute2
n/openssh
n/rpcbind
n/libtirpc
n/rsync
n/telnet
n/traceroute
n/wget
n/wpa_supplicant
n/wireless-tools
l/lzo
l/libnl3
l/libidn
l/libunistring
l/mpfr
l/ncurses
l/pcre"

# slackware pkgtools modifikasi untuk digunakan pada termux
INSTALLPKG_DL="https://github.com/dhocnet/slackarm-netinst/raw/master"

# slackware pkgtools
INSTALL_SYS=$HOME/slackware/tmp/installpkg
UPGRADE_SYS=$HOME/slackware/tmp/upgradepkg

# download folder sementara
WGET_P=$HOME/slackware/tmp/pkg

SETUP_MULAI () {
    clear
    # konfirmasi instalasi paket yang dibutuhkan oleh slackware
    # pkgtools
    echo "Anda membutuhkan beberapa program lain untuk
menyelesaikan instalasi Slackware-current ARM. Yaitu:

    1) wget
    2) coreutils
    3) proot
    4) util-linux
    5) grep
    6) Dialog
    7) lzip
"
    read -p 'Install program [Y/n]? ' ins_y
    if [ $ins_y = "n" ]
    then
        SETUP_BATAL
    else
        SETUP_TERMUX
    fi
}

SETUP_RESUME () {
    clear
    echo "Terdeteksi berkas slackware di sistem folder.
Apakah Anda ingin melanjutkan proses instalasi?

    Y - Lanjutkan
    N - Install baru (hapus instalasi lama)
    R - Hapus instalasi Slackware dari ponsel
"
    read -p 'Lanjutkan [Y/n/r]? ' SET_RES
    if [ $SET_RES = "n" | $SET_RES = "r" ]
    then
        clear
        echo "Menghapus instalasi lama ..."
        sleep 1
        chmod -R a+rw $HOME/slackware/usr/ 2> /dev/null
        rm -rf $HOME/slackware 2> /dev/null
        echo "OK."
        sleep 2
        if [ $SET_RES = "r" ]
        then
            rm /data/data/com.termux/files/usr/bin/slackwarego
            echo "Uninstall berhasil!"
            sleep 1
            kill $$
        else
            SETUP_TERMUX
        fi
    else
        clear
        echo "Pilih tipe instalasi untuk dilanjutkan\n
        1) Lanjutkan instalasi miniroot (default)
        2) Upgrade Miniroot ke Development\n"
        read -p 'Pilihan [1/2]? ' SET_UP
        if [ $SET_UP = "2" ]
        then
            INSTALL_DEVEL
        else
            INSTALL_DEFAULT
        fi
    fi
}

SETUP_BATAL () {
    clear
    echo "Istalasi Slackware-current ARM dibatalkan!\n"
}

SETUP_TERMUX () {
    clear
    echo "Menginstal program yang dibutuhkan ...\n"
    apt -y upgrade && apt -y install grep coreutils lzip proot tar wget util-linux dialog
    sleep 1
    SETUP_SELECT
}

SETUP_SELECT () {
    clear
    echo "PILIH JENIS INSTALASI
    
    1) Miniroot (default) - dl: 76MB/inst: 350MB+
    2) Development - dl: 851MB/inst: 5.8GB+
    "
    read -p 'Pilihan (default: 1) [1/2]: ' pilih_tipe
    if [ $pilih_tipe = "2" ]
    then
        if [ ! -d $HOME/slackware/tmp ]
        then
            mkdir -p $HOME/slackware/tmp
        fi
        INSTALL_DEVEL
    else
        INSTALL_DEFAULT
    fi
}

INSTALL_DEFAULT () {
    clear
    mkdir -p $WGET_P
    echo "Mengunduh program installer: installpkg"
    wget -c -t 0 -P $WGET_P/../ -q --show-progress $INSTALLPKG_DL/installpkg
    chmod +x $WGET_P/../installpkg
    echo "OK.\n"
    echo "Mengunduh paket dasar miniroot:"
    sleep 1
    for PKG_TODL in $PKG_MINI ; do
        wget -c -t 0 -T 10 -w 5 -P $WGET_P -q --show-progress ftp://mirrors.slackware.bg/$ARCH_SELECT/$PKG_TODL-*.txz
    done
    echo "OK.\n"
    echo "Memasang sistem dasar Slackware miniroot ..."
    sleep 2
    # buang pesan error yang timbul karena perintah perintah dari installscript doinst.sh
    # biasanya masalah yang timbul karena kesalahan chown fulan.binfulan atau perintah chroot
    # yang tidak terdapat pada termux environment
    $INSTALL_SYS --terse --root $HOME/slackware/ $WGET_P/*.txz 2> /dev/null
    INSTALL_STATER
}

INSTALL_DEVEL () {
    clear
    PKG_DEVDIR="a ap d l t"
    echo "Mengunduh program installer: upgradepkg, removepkg"
    wget -c -t 0 -P $WGET_P/../ -q --show-progress $INSTALLPKG_DL/{removepkg,upgradepkg}
    echo "OK.\n\nMengunduh paket Development:"
    chmod +x $WGET_P/../{removepkg,upgradepkg}
    sleep 1
    for PKG_DEVDL in $PKG_DEVDIR ; do
        wget -c -t 0 -r -np -nd -q --show-progress -T 10 -w 5 -A '.txz' -P $WGET_P https://mirrors.slackware.bg/$ARCH_SELECT/$PKG_DEVDL/
    done
    echo "OK.\n\nMemasang paket Development:"
    sleep 1
    ROOT=$HOME/slackware
    $UPGRADE_SYS --install-new $WGET_P/*.txz 2> /dev/null
    echo "\n\nInstalasi paket Development selesai.\nFinishing ..."
    sleep 1
    INSTALL_STATER
}

INSTALL_STATER () {
    clear
    echo "Memasang script pemicu ..."
    wget -c -q --show-progress -P $HOME/../usr/bin/ $INSTALLPKG_DL/slackwarego
    chmod +x $HOME/../usr/bin/slackwarego
    echo "nameserver 8.8.8.8" > $HOME/slackware/etc/resolv.conf
    echo "OK ..."
    clear
    echo "Membersihkan sisa-sisa instalasi ..."
    sleep 1
    rm -vrf $HOME/slackware/tmp/*
    echo "OK ..."
    sleep 1
    CARA_PAKAI
}

CARA_PAKAI () {
    clear
    echo "SELAMAT! Anda telah berhasil memasang Slackware Linux (current-$SELECT_ARCH) di perangkat Android.\n\n
    Oleh    : mongkeelutfi
    Info    : mongkee@gmail.com
    Blog    : https://blog.dhocnet.work
    Proyek  : https://github.com/dhocnet/slackarm-netinst\n
    21 September 2018, Denpasar, Bali\n
    Untuk menjalankan, gunakan perintah: slackwarego\n"
}

clear
echo "\nSlackware ARM - NetInstall\n-> https://github.com/dhocnet/slackarm-netinst/"
sleep 2

SELECT_ARCH=`uname -m`
if [ $SELECT_ARCH == 'armv7l' ]
then
    echo "Terdeteksi arsitektur ponsel; $SELECT_ARCH"
    ARCH_SELECT="slackwarearm/slackwarearm-current/slackware"
    sleep 1
elif [ $SELECT_ARCH == "aarch64" ]
then
    echo "Terdeteksi arsitektur ponsel: $SELECT_ARCH"
    ARCH_SELECT="slarm64/slarm64-current/slarm64"
    sleep 1
else
    echo "Arsitektur ponsel belum didukung!\nArsitektur: $SELECT_ARCH"
    sleep 3
    SETUP_BATAL
fi

if [ -d $HOME/slackware ]
then
    SETUP_RESUME
else
    SETUP_MULAI
fi
