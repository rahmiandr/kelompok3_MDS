library(RPostgreSQL)
library(DBI)
driver <- dbDriver('PostgreSQL')
DB <- dbConnect(
  driver,
  dbname="uafemknk", # User & Default database
  host="topsy.db.elephantsql.com", # Server
  # port=5432,
  user="uafemknk", # User & Default database
  password="vHlk8GXVd5l6q5zXphKTF6mbKpgyN-2q" # Password
)


dbhost<- dbConnect(
  driver, 
  dbname="novel_indo", 
  host="localhost",
  port=5432,
  user="postgres",
  password="1234567"
)

# select dari setiap tabel
penulis=dbReadTable(dbhost,'penulis')
penerbit=dbReadTable(dbhost,'penerbit')
novel=dbReadTable(dbhost,'novel')
ulasan=dbReadTable(dbhost,'ulasan')
dbWriteTable(DB,'penulis',penulis,overwrite=T,row.names=F)
dbWriteTable(DB,'penerbit',penerbit,overwrite=T,row.names=F)
dbWriteTable(DB,'novel',novel,overwrite=T,row.names=F)
dbWriteTable(DB,'ulasan',ulasan,overwrite=T,row.names=F)
