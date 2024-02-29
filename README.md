<p align="center" style="width: 800px; height: 400px;">
  <img idth="400" height="200" src="image/logo.png">
</p>

<div align="center">

# Goodreads Novel Indonesia Database

[Tentang](#scroll-tentang)
•
[Screenshot](#rice_scene-screenshot)
•
[Demo](#dvd-demo)
•
[Dokumentasi](#blue_book-dokumentasi)

</div>

## :bookmark_tabs: Menu

- [Tentang](#scroll-tentang)
- [Screenshot](#rice_scene-screenshot)
- [Demo](#dvd-demo)
- [Dokumentasi](#blue_book-dokumentasi)
- [Requirements](#exclamation-requirements)
- [Skema Database](#floppy_disk-skema-database)
- [ERD](#rotating_light-erd)
- [Deskripsi Data](#heavy_check_mark-deskripsi-data)
- [Struktur Folder](#open_file_folder-struktur-folder)
- [Tim Pengembang](#smiley_cat-tim-pengembang)

## :scroll: Tentang

<div align="justify">
Selamat datang di Goodreads Novel Indonesia Database, informasi lengkap untuk pecinta novel tanah air! Kami adalah database novel yang memberikan informasi lengkap seputar novel Indonesia yang tersedia di Goodreads, memungkinkan pengguna untuk menjelajahi dan menemukan berbagai jenis novel dari berbagai genre. Dengan berbagai judul dan penulis yang terdaftar, kami menyajikan informasi terkini dan ulasan berkualitas dari komunitas Goodreads yang dapat membantu para calon pembaca untuk menemukan novel yang dinginkan.

## :rice_scene: Screenshot

<p align="center">
  <img width="900" height="500" src="image/logo.png">
</p>

## :dvd: Demo

Berikut merupakan link untuk shinnyapps atau dashboard dari project kami:
https://akmarinak98.shinyapps.io/database_publikasi_statistika/

## :blue_book: Dokumentasi 

Dokumentasi penggunaan aplikasi database. Anda dapat juga membuat dokumentasi lives menggunakan readthedocs.org (opsional).

## :floppy_disk: Skema Database
Menggambarkan struktur *primary key* **novel**, **penulis**, **penerbit** dan **ulasan** dengan masing-masing *foreign key* dalam membangun relasi antara tabel atau entitas.

<p align="center" style="width: 800px; height: 400px;">
  <img width="600" height="400" src="image/Skema MDS fix.png">
</p>


## :rotating_light: ERD
RD (Entity Relationship Diagram) menampilkan hubungan antara entitas dengan atribut. Pada project ini, entitas judul terdapat tiga atribut yang berhubungan dengan atribut pada entitas lain, yaitu id_sinta berhubungan dengan entitas penulis, id_instansi berhubungan dengan entitas instansi, id_dept berhubungan dengan entitas departemen.

Selanjutnya, entitas penulis terdapat dua atribut yang berhubungan dengan atribut pada entitas lain, yaitu id_instansi berhubungan dengan entitas instansi, id_dept bergubungan dengan entitas departemen.

Selain itu, entitas departemen dan entitas instansi saling berhubungan pada atribut id_instansi.

<p align="center" style="width: 800px; height: 400px;">
  <img width="600" height="400" src="image/ERD.png">
</p>

## :smiley_cat: Tim Pengembang
+ Database Manager : [Ratu Risha Ulfia](https://github.com/Raturisha) (G1501231041)
+ Frontend Developer : [Yunia Hasnataeni](https://github.com/YuniaHasnataeni) (G1501231001)
+ Backend Developer : [Rahmi Anadra](https://github.com/rahmiandr) (G1501231051)
+ Technical Writer : [Monica Rahma Fauziah](https://github.com/monicarahma) (G1501231057)
