library(RPostgreSQL)
library(DBI)
driver <- dbDriver('PostgreSQL')
DB <- dbConnect(
  driver, 
  dbname="novel_indo", 
  host="localhost",
  port=5432,
  user="postgres",
  password="1234567"
)

dbListTables(DB)

dbListFields(DB, "penerbit")

knitr::kable(dbReadTable(DB, "penerbit"))


## Membuat koneksi ke database
DB <- dbConnect(RPostgreSQL::PostgreSQL(), 
                dbname = "novel_indo", 
                host = "localhost", 
                port = 5432, 
                user = "postgres", 
                password = "1234567")


# Data penerbit
data_penerbit <- read.csv("https://github.com/rahmiandr/kelompok3_MDS/raw/main/data/penerbit.csv", sep = ",", fill = TRUE)
str(data_penerbit)
for (i in 1:nrow(data_penerbit)) {
  query <- paste0("INSERT INTO \"penerbit\" (id_penerbit, nama_penerbit, alamat) VALUES (",
                  "'", data_penerbit[i, "id_penerbit"], "', ", 
                  "'", data_penerbit[i, "nama_penerbit"], "', ",
                  "'", data_penerbit[i, "alamat"], "');")
  query_execute <- DBI::dbGetQuery(conn = DB, statement = query)
}

## Melihat data dalam tabel
result <- dbGetQuery(DB, "SELECT * FROM \"penerbit\"")

## Menampilkan hasil
print(result)


# Data penulis
# Baca file CSV dengan opsi fill
data_penulis <- read.csv("https://github.com/rahmiandr/kelompok3_MDS/raw/main/data/penulis.csv", sep = ",", fill = TRUE)
str(data_penulis)

## Assuming 'tanggal_terbit' is the date column
data_penulis$tanggal_lahir <- as.Date(data_penulis$tanggal_lahir, format="%d %B %Y")
str(data_penulis)

for (i in 1:nrow(data_penulis)) {
  query <- paste0("INSERT INTO penulis (id_penulis, nama_penulis, tempat_lahir, tanggal_lahir, jumlah_buku) VALUES (",
                  "'", data_penulis[i, "id_penulis"], "', ", 
                  "'", data_penulis[i, "penulis"], "', ");
  
  # Menangani tempat_lahir kosong
  if (nzchar(data_penulis[i, "tempat_lahir"])) {
    query <- paste0(query, "'", data_penulis[i, "tempat_lahir"], "', ");
  } else {
    query <- paste0(query, "NULL, ");
  }
  
  # Menangani tanggal kosong
  if (!is.na(data_penulis[i, "tanggal_lahir"])) {
    query <- paste0(query, "'", format(data_penulis[i, "tanggal_lahir"], "%Y-%m-%d"), "', ");
  } else {
    query <- paste0(query, "NULL, ");
  }
  
  query <- paste0(query, data_penulis[i, "jumlah_buku"], ");");
  
  # Eksekusi pernyataan SQL
  DBI::dbExecute(conn = DB, statement = query)
}


## Melihat data dalam tabel
result <- dbGetQuery(DB, "SELECT * FROM \"penulis\"")

## Menampilkan hasil
print(result)


# Data novel
# Baca file CSV dengan opsi fill
data_novel <- read.csv("https://github.com/rahmiandr/kelompok3_MDS/raw/main/data/novel.csv", sep = ",", fill = TRUE)
str(data_novel)

for (i in 1:nrow(data_novel)) {
  query <- paste0("INSERT INTO novel (id_novel, id_penulis, id_penerbit, judul, ISBN, bahasa, tahun_terbit, edisi, jumlah_halaman, deskripsi, rating_novel) VALUES (",
                  "'", data_novel[i, "id_novel"], "', ",
                  "'", data_novel[i, "id_penulis"], "', ",
                  "'", data_novel[i, "id_penerbit"], "', ",
                  "'", data_novel[i, "judul"], "', ");
  
  # Handle ISBN
  if (nzchar(data_novel[i, "ISBN"])) {
    query <- paste0(query, "'", gsub("'", "''", data_novel[i, "ISBN"]), "', ");
  } else {
    query <- paste0(query, "NULL, ");
  }
  
  query <- paste0(query,
                  "'", data_novel[i, "bahasa"], "', ");
  
  # Handle tahun_terbit
  if (!is.na(data_novel[i, "tahun_terbit"])) {
    query <- paste0(query, data_novel[i, "tahun_terbit"], ", ");
  } else {
    query <- paste0(query, "NULL, ");
  }
  
  # Handle edisi
  if (!is.na(data_novel[i, "edisi"])) {
    query <- paste0(query, "'", gsub("'", "''", data_novel[i, "edisi"]), "', ");
  } else {
    query <- paste0(query, "NULL, ");
  }
  
  # Handle jumlah_halaman
  if (!is.na(data_novel[i, "jumlah_halaman"])) {
    query <- paste0(query, data_novel[i, "jumlah_halaman"], ", ");
  } else {
    query <- paste0(query, "NULL, ");
  }
  
  # Handle deskripsi
  if (nzchar(data_novel[i, "deskripsi"])) {
    query <- paste0(query, "'", gsub("'", "''", data_novel[i, "deskripsi"]), "', ");
  } else {
    query <- paste0(query, "NULL, ");
  }
  
  query <- paste0(query,
                  data_novel[i, "rating_novel"], ");")
  
  # Execute the SQL INSERT query
  DBI::dbExecute(conn = DB, statement = query)
}


## Melihat data dalam tabel
result <- dbGetQuery(DB, "SELECT * FROM \"novel\"")

## Menampilkan hasil
print(result)


# Data ulasan
# Baca file CSV dengan opsi fill
data_ulasan <- read.csv("https://github.com/rahmiandr/kelompok3_MDS/raw/main/data/ulasan.csv", sep = ",", fill = TRUE)
str(data_ulasan)

## Assuming 'tanggal_ulasan' is the date column
data_ulasan$tanggal_ulasan <- as.Date(data_ulasan$tanggal_ulasan, format="%d %B %Y")
str(data_ulasan)

# Menggantikan nilai NA dengan NULL pada kolom tanggal_ulasan
# data_ulasan$tanggal_ulasan[is.na(data_ulasan$tanggal_ulasan)] <- as.Date(NA)

# Menjalankan pernyataan SQL
for (i in 1:nrow(data_ulasan)) {
  escaped_ulasan <- gsub("'", "''", data_ulasan[i, "ulasan"])
  escaped_nama_user <- gsub("'", "''", data_ulasan[i, "nama_user"])
  
  query <- paste0("INSERT INTO ulasan (id_user, id_novel, nama_user, tanggal_ulasan, ulasan, rating_user) VALUES (",
                  "'", data_ulasan[i, "id_user"], "', ", 
                  "'", data_ulasan[i, "id_novel"], "', ", 
                  "'", escaped_nama_user, "', ", 
                  ifelse(is.na(data_ulasan[i, "tanggal_ulasan"]), "NULL", 
                         sprintf("'%s'", data_ulasan[i, "tanggal_ulasan"])), ", ", 
                  "'", escaped_ulasan, "', ", 
                  data_ulasan[i, "rating_user"], ");")
  
  DBI::dbExecute(conn = DB, statement = query)
}

## Melihat data dalam tabel
result <- dbGetQuery(DB, "SELECT * FROM \"ulasan\"")

## Menampilkan hasil
print(result)

---------------------------------------------------------------------
  
library(RPostgreSQL)
library(DBI)
driver <- dbDriver('PostgreSQL')
DB <- dbConnect(
  driver,
  dbname="uafemknk", # User & Default database
  host="topsy.db.elephantsql.com", # Server
  # port=5432,
  user="uafemknk", # User & Default database
  password="Uxf_vl9JGfj4X283QHpW95GYSWD9DCbQ" # Password
)


dbhost<- dbConnect(
  driver, 
  dbname="novel_indo", 
  host="localhost",
  port=5432,
  user="postgres",
  password="1234567"
)

# select departemen dari table departemen
penulis=dbReadTable(dbhost,'penulis')
penerbit=dbReadTable(dbhost,'penerbit')
novel=dbReadTable(dbhost,'novel')
ulasan=dbReadTable(dbhost,'ulasan')
dbWriteTable(DB,'penulis',penulis,overwrite=T,row.names=F)
dbWriteTable(DB,'penerbit',penerbit,overwrite=T,row.names=F)
dbWriteTable(DB,'novel',novel,overwrite=T,row.names=F)
dbWriteTable(DB,'ulasan',ulasan,overwrite=T,row.names=F)
