# Slackware-current ARM & ARM64 Installer Untuk Termux

## Apa ini?
Script sederhana untuk instalasi Slackware Linux di Android menggunakan Termux environment.

## Fiturnya apa saja?
- Deteksi arsitektur mesin otomatis
- Instalasi menurut arsitektur mesin
- Dua pilihan install
- - Miniroot
- - Development
- Fitur melanjutkan instalasi yang terhenti
- Fitur upgrade miniroot ke development
- Fitur uninstall

## Cara Pakai
Pada Termux, unduh program `wget` dengan perintah:

`$ apt -y upgrade && apt -y install wget`

Unduh Slackware net-install script:

`$ wget https://github.com/dhocnet/slackarm-netinst/raw/master/slackarm-netinst.sh`

Eksekusi dengan perintah:

`$ bash slackarm-netinst.sh`

Ikuti dialog untuk menyelesaikan instalasi.

## Cara Upgrade
Saat script dijalankan, script akan mendeteksi direktori instalasi Slackware. Bila ditemukan, Anda akan diperlihatkan pilihan **Lanjutkan instalasi**, **Install ulang** dan **Hapus instalan**.

Untuk melakukan upgrade, pilih **Lanjutkan instalasi** lalu pilih **Upgrade ke developer**.

## Perlu Diketahui
Terdapat dua pilihan instalasi yang disediakan. `miniroot` dan `development`. Miniroot akan mengunduh paket sekitar 76MB dan akan memakan ruang penyimpanan sekitar 400MB.

Sedangkan development akan mengunduh paket sekitar 1.5GB dan memakan ruang penyimpanan sekitar 3.5GB.

> Nilai paket yang diunduh dan setelah instalasi adalah nilai perkiraan yang mengikuti perubahan paket dari server.

## PERINGATAN!!!
Sebaiknya Anda melakukan instalasi menggunakan jaringan yang stabil dan cepat karena banyaknya paket yang diunduh untuk membangun sistem.

## Manajer Paket
Untuk manajer paket kami menyarankan untuk menggunakan `slpkg` karena `slplg` mendukung fitur deteksi dependensi pada repository tertentu yang dapat memudahkan proses penambahan program baru.

Instalasinya dapat dilakukan dengan perintah:

`# pip install slpkg --upgrade`

> Perintah diatas dijalankan pada sistem Slackware

## Catatan:
- Instalasi Development masih dalam pengembangan!

## Panduan Dengan Gambar
Langkah-langkah penggunaan bisa di simak di https://blog.dhocnet.work/2018/08/panduan-instalasi-slackware-linux-di.html.

