#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(RPostgreSQL)
library(DBI)
library(DT)
library(bs4Dash)
library(dplyr)
library(plotly)
library(tidyverse)
library(rvest)


#=========================== Interface (Front-End) ============================#

fluidPage(
  dashboardPage(
    #--------------HEADER-----------------#
    header = dashboardHeader(
      title = div(
        style = "text-align: center;",
        img(src = "https://raw.githubusercontent.com/rahmiandr/kelompok3_MDS/main/image/logobaru.png", height = 40, style = "margin-bottom: -20px;"),  
        h1("Goodreads Novel Database", style = "color: #8b5A2B; font-size: 10px; font-weight: bold; margin-top: 20px;")
      ),
      titleWidth = "300px", status ="info"  # Menyesuaikan lebar judul dan warna tampilan sisi atas
    ),
    
    #------------SIDEBAR-----------------#
    sidebar = dashboardSidebar(
      collapsed = TRUE, #ubah skin mengubah warna tulisan saat diletakkan kusor
      sidebarMenu(
        menuItem(
          text = "Beranda",
          tabName = "beranda",
          icon = icon("house")
        ),
        menuItem(
          text = "Cari Novel",
          tabName = "novel",
          icon = icon("book")
        ),
        menuItem(
          text = "Ulasan Pembaca",
          tabName = "ulasan",
          icon = icon("edit")
        ),
        menuItem(
          text = "Daftar Novel",
          tabName = "daftar_novel",
          icon = icon("book-open")
        ),
        menuItem(
          text = "Statistik",
          tabName = "statistik",
          icon = icon("chart-column")
        ),
        menuItem(
          text = "Info",
          tabName = "info",
          icon = icon("users")
        )
      ),
      style = "background-color:#D3D3D3; font-size:20px;font-weight:bold; padding: 8px; border-radius: 4px;",
    HTML(paste0(
      "<br><br><br><br><br><br><br><br><br>",
      "<table style='margin-left:auto; margin-right:auto;'>",
      "<tr>",
      "<td style='padding: 5px;'><a href='https://www.facebook.com/Goodreads' target='_blank'><i class='fab fa-facebook-square fa-lg'></i></a></td>",
      "<td style='padding: 5px;'><a href='https://www.twitter.com/goodreads' target='_blank'><i class='fab fa-twitter fa-lg'></i></a></td>",
      "<td style='padding: 5px;'><a href='https://www.instagram.com/goodreads/' target='_blank'><i class='fab fa-instagram fa-lg'></i></a></td>",
      "</tr>",
      "</table>",
      "<br>"
    ))
    ),
    #-----------------BODY-----------------#
    body = dashboardBody(
      tabItems(
        #-------------------------Tab Beranda-------------------------#
        tabItem(
          tabName = "beranda",
          jumbotron(
            title = span(
              img(src = "https://raw.githubusercontent.com/rahmiandr/kelompok3_MDS/main/image/logo-removebg.png", height = 300, width = 500),
              "Sistem Pencarian Novel Indonesia",
              style = "font-size:80px;font-weight:bold;display: flex;align-items: center"
            ),
            
            lead = span(HTML("Hallo Readers! <br> Dalam lembaran kata, petualangan bersemi, mimpi terurai, dan hati menari. Selamat datang di dunia di mana halaman-halaman berbicara, dan cerita menunggu untuk diungkapkan."), style = "font-size:25px; font-weight: lighter; display: flex;align-items: center; padding: 10px; border-radius: 5px;"),
            
            href = "https://www.goodreads.com/list/show/67567.Novel_Indonesia_Terbaik",
            status="info"
          ),
          fluidRow(
            box(title = "Tentang",solidHeader = TRUE,status="info",
                tags$p("Goodreads Novel Indonesia adalah teman setia para pencinta buku, membantu Anda menemukan novel-novel yang sesuai dengan selera dan minat Anda.  
                Sumber daya lengkap untuk menemukan dan menikmati novel-novel terbaik dari penulis Indonesia! Dari kisah-kisah yang mendebarkan hingga petualangan yang memukau, 
                       kami hadir untuk memudahkan Anda menemukan cerita-cerita yang memikat hati dan pikiran. Jelajahi dunia yang kaya dengan judul-judul menarik dan penulis berbakat, 
                       serta nikmati ulasan-ulasan berkualitas dari komunitas pembaca kami. Temukan petualangan baru di setiap halaman, hanya di Goodreads Novel Indonesia!",
                       style = "background-color: #D3D3D3; color: black; font-size:15px;display: flex;align-items: center;text-align: justify; padding: 10px; border-radius: 5px;"),
                tags$p("Dengan informasi terkini dan ulasan yang dapat dipercaya, kami siap membawa Anda dalam perjalanan menemukan cerita-cerita tak terlupakan. 
                       Jadikan Goodreads Novel Indonesia sebagai panduan Anda dalam dunia literasi Indonesia yang kaya dan memikat!",
                       style = "background-color: #D3D3D3; color: black; font-size:15px;display: flex; align-items: center;text-align: justify; padding: 10px; border-radius: 5px;"), width = 6, collapsible = TRUE,
                collapsed = TRUE # 
            ),
            box(title = "Panduan Penggunaan", solidHeader = TRUE, status = "info",
                tags$p(
                  "Arahkan kursor ke sisi kiri layar atau klik ikon garis tiga pada sisi pojok kanan atas untuk mengakses bilah sisi (sidebar).",
                  "Tiga fitur utama pada Goodreads Novel Indonesia adalah sebagai berikut:", tags$br(),
                  tags$ol(
                    tags$li(
                      tags$p(
                        tags$strong("Cari Novel -"), " Pencarian novel dengan memanfaatkan fitur penyaringan penulis, penerbit, tahun terbit, dan rating novel. Lengkapi kriteria penyaringan agar didapatkan novel yang relevan."
                      )
                    ),
                    tags$li(
                      tags$p(
                        tags$strong("Cari Penulis -"), " Pencarian nama penulis dengan memanfaatkan fitur penyaringan tempat lahir, tahun lahir, dan jumlah buku. Lengkapi kriteria penyaringan agar didapatkan penulis yang relevan."
                      )
                    ),
                    tags$li(
                      tags$p(
                        tags$strong("Cari Penerbit -"), " Pencarian nama penerbit dengan memanfaatkan fitur penyaringan alamat penerbit. Lengkapi kriteria penyaringan agar didapatkan penerbit yang relevan."
                      )
                    )
                  ),
                  style = "background-color:#D3D3D3;color: black; font-size:15px;display: flex;align-items: center;text-align: justify; padding: 10px; border-radius: 5px;"
                ),
                width = 6,
                collapsible = TRUE,
                collapsed = TRUE
            )
          )
        ),
        
        
        #--------------------------Tab NOVEL--------------------------#
        tabItem(
          tabName = "novel",
          fluidRow(
            tags$h1("Yuk Cari Novel Sesuai Keinginanmu", style = "text-align: center; font-weight: bold;")
          ),
          fluidRow(
            # Filter penulis
            box(
              title = "Penulis",
              solidHeader = TRUE,
              status = "info",
              background = "gray",  # Change background color to orange
              tags$p(
                tags$h3("Filter Penulis"),
                tags$p("Pilih penulis yang ingin ditampilkan"),
                tags$br(),
                uiOutput("filter_1"),
                width = 4)
            ),
            # Filter penerbit
            box(
              title = "Penerbit",
              solidHeader = TRUE,
              status = "info",
              background = "gray",  # Change background color to orange
              tags$p(
                tags$h3("Filter Penerbit"),
                tags$p("Pilih penerbit yang ingin ditampilkan"),
                tags$br(),
                uiOutput("filter_2"),
                width = 4)
            ),
            # Filter tahun terbit
            box(
              title = "Tahun Terbit",
              solidHeader = TRUE,
              status = "info",
              background = "gray",  # Change background color to orange
              tags$p(
                tags$h3("Filter Tahun"),
                tags$p("Pilih rentang tahun terbit yang ingin ditampilkan"),
                tags$br(),
                uiOutput("filter_3"),
                width = 4)
            ),
            # Filter rating
            box(
              title = "Rating Novel",
              solidHeader = TRUE,
              status = "info",
              background = "gray",  # Change background color to orange
              tags$p(
                tags$h3("Filter Rating"),
                tags$p("Pilih rentang rating yang ingin ditampilkan"),
                tags$br(),
                uiOutput("filter_4"),
                width = 4)
            )
          ),
          fluidRow(
            # Display tabel 
            box(
              title = "Hasil Pencarian",
              solidHeader = TRUE,
              status = "info",
              width = 12, 
              background = "info", 
              div(
                style = "width: 100%;",
                tags$h3("Tabel"),
                dataTableOutput("out_tbl1")
              )
            )
          )
        ),
        #-------------------------Tab Ulasan-------------------------#
        tabItem(
          tabName = "ulasan",
          fluidRow(
            tags$h1("Lihat Ulasan dari Pembaca di Sini", style = "text-align: center; font-weight: bold;")
          ),
          fluidRow(
            # Filter Novel
            box(
              title = "Judul Novel",
              solidHeader = TRUE,
              status = "info",
              background = "gray",  # Change background color to orange
              tags$p(
                tags$h3("Filter Judul Novel"),
                tags$p("Pilih judul novel yang ingin ditampilkan"),
                tags$br(),
                uiOutput("filter_5"),
                width = 6)
            )
          ),
          fluidRow(
            # Display tabel 
            box(
              title = "Hasil Pencarian",
              solidHeader = TRUE,
              status = "info",
              width = 12, 
              background = "info", 
              div(
                style = "width: 100%;",
                tags$h3("Tabel"),
                dataTableOutput("out_tbl2")
              )
            )
          )
        ),
        
        #--------------------------Tab Daftar Novel--------------------------#
        tabItem(
          tabName = "daftar_novel",
          fluidRow(
            tags$h1("Daftar Novel pada Goodreads Novel Indonesia Database", style = "text-align: center; font-weight: bold;")
          ),
          fluidRow(
            style = "display: flex; justify-content: center; align-items: center;",
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1565658920i/1398034.jpg", height = 150, width = 100),
                   h6("Bumi Manusia", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1398034.Bumi_Manusia", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1489732961i/1362193.jpg", height = 150, width = 100),
                   h6("Laskar Pelangi", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1362193.Laskar_Pelangi", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1484031052i/1677677.jpg", height = 150, width = 100),
                   h6("Anak Semua Bangsa", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1677677.Anak_Semua_Bangsa", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1464425991i/1334844.jpg", height = 150, width = 100),
                   h6("Ronggeng Dukuh Paruk", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1334844.Ronggeng_Dukuh_Paruk", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1249749162i/6688121.jpg", height = 150, width = 100),
                   h6("Negeri 5 Menara", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/6688121-negeri-5-menara", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1484031184i/1677634.jpg", height = 150, width = 100),
                   h6("Jejak Langkah", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1677634.Jejak_Langkah", style = "text-align: center; display:block;", "Detail")
            )
          ),
          tags$br(),
          fluidRow(
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1485759293i/8343444.jpg", height = 150, width = 100),
                   h6("Daun Yang Jatuh Tak Pernah Membenci Angin", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/8343444-daun-yang-jatuh-tak-pernah-membenci-angin", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1502464714i/1353409.jpg", height = 150, width = 100),
                   h6("Cantik itu Luka", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1353409.Cantik_itu_Luka", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1484031123i/1677693.jpg", height = 150, width = 100),
                   h6("Rumah Kaca", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1677693.Rumah_Kaca", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1489733383i/1407874.jpg", height = 150, width = 100),
                   h6("Sang Pemimpi", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1407874.Sang_Pemimpi", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1340606900i/15721334.jpg", height = 150, width = 100),
                   h6("Negeri Para Bedebah", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/15721334-negeri-para-bedebah", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1356225544i/6765740.jpg", height = 150, width = 100),
                   h6("Perahu Kertas", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/6765740-perahu-kertas", style = "text-align: center; display:block;", "Detail")
            )
          ),
          tags$br(),
          fluidRow(
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1312549657i/12290008.jpg", height = 150, width = 100),
                   h6("Antologi Rasa", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/8343444-daun-yang-jatuh-tak-pernah-membenci-angin", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1581518812i/1096114.jpg", height = 150, width = 100),
                   h6("Ca-bau-kan: Hanya sebuah dosa", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1096114.Ca_bau_kan", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1346646534i/15982998.jpg", height = 150, width = 100),
                   h6("Lalita", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/15982998-lalita", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1436161520i/25857857.jpg", height = 150, width = 100),
                   h6("Dilan Bagian Kedua: Dia Adalah Dilanku Tahun 1991", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/25857857-dilan-bagian-kedua", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1237252067i/6056022.jpg", height = 150, width = 100),
                   h6("Katak Hendak Jadi Lembu", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/6056022-katak-hendak-jadi-lembu", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1486442776i/6788533.jpg", height = 150, width = 100),
                   h6("Refrain", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/6788533-refrain", style = "text-align: center; display:block;", "Detail")
            )
          ),
          tags$br(),
          fluidRow(
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1326688274i/13414402.jpg", height = 150, width = 100),
                   h6("Kau, Aku & Sepucuk Angpau Merah", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/13414402-kau-aku-sepucuk-angpau-merah", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1392083221i/3250365.jpg ", height = 150, width = 100),
                   h6("Aki", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/3250365-aki", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1387980025i/20317634.jpg", height = 150, width = 100),
                   h6("Maya", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/20317634-maya", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1412067973i/23288914.jpg", height = 150, width = 100),
                   h6("Rindu", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/23288914-rindu", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1277969339i/1761041.jpg", height = 150, width = 100),
                   h6("Karmila", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1761041.Karmila", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1409579772i/1667423.jpg", height = 150, width = 100),
                   h6("Autumn in Paris", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1667423.Autumn_in_Paris", style = "text-align: center; display:block;", "Detail")
            )
          ),
          tags$br(),
          fluidRow(
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1523718096i/38751629.jpg", height = 150, width = 100),
                   h6("Kura-Kura Berjanggut", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/38751629-kura-kura-berjanggut", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1491634214i/6496886.jpg", height = 150, width = 100),
                   h6("Separuh Bintang", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/6496886-separuh-bintang", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1496473216i/5637839.jpg", height = 150, width = 100),
                   h6("Jangan Pergi, Lara", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/5637839-jangan-pergi-lara", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1496315625i/35278713.jpg", height = 150, width = 100),
                   h6("Bintang", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/35278713-bintang", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1508735597i/36461208.jpg", height = 150, width = 100),
                   h6("Janshen", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/36461208-janshen", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1571370071i/48497661.jpg", height = 150, width = 100),
                   h6("Anak Gembala Yang Tertidur Panjang di Akhir Zaman", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/48497661-anak-gembala-yang-tertidur-panjang-di-akhir-zaman", style = "text-align: center; display:block;", "Detail")
            )
          ),
          tags$br(),
          fluidRow(
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1638144317i/57304990.jpg", height = 150, width = 100),
                   h6("Rapijali 3: Kembali", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/57304990-rapijali-3", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1604022613i/55817473.jpg", height = 150, width = 100),
                   h6("Perempuan yang Menangis kepada Bulan Hitam", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/55817473-perempuan-yang-menangis-kepada-bulan-hitam", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1370516953i/18042991.jpg", height = 150, width = 100),
                   h6("Dead Smokers Club Part 1", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/18042991-dead-smokers-club-part-1", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1235574085i/1489158.jpg", height = 150, width = 100),
                   h6("Geni Jora", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1489158.Geni_Jora", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1492577124i/6595231.jpg", height = 150, width = 100),
                   h6("Siege of Krog Naum", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/6595231-siege-of-krog-naum", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1228961334i/2040440.jpg", height = 150, width = 100),
                   h6("Cinta Tak Pernah Tepat Waktu", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/2040440.Cinta_Tak_Pernah_Tepat_Waktu", style = "text-align: center; display:block;", "Detail")
            ),
          ),
          tags$br(),
          fluidRow(
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1488354806i/3187852.jpg", height = 150, width = 100),
                   h6("The Truth about Forever: Kebencian Membuatmu Kesepian", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/3187852-the-truth-about-forever", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1227972517i/5956070.jpg", height = 150, width = 100),
                   h6("Jejak Kupu-kupu", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/5956070-jejak-kupu-kupu", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1433410933i/25661516.jpg", height = 150, width = 100),
                   h6("The Chronicles of Audy: 4/4", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/25661516-the-chronicles-of-audy", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1522123452i/39643727.jpg", height = 150, width = 100),
                   h6("Pergi", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/39643727-pergi", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1523921756i/39834891.jpg", height = 150, width = 100),
                   h6("Tiba Sebelum Berangkat", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/39834891-tiba-sebelum-berangkat", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1514363101i/37733232.jpg", height = 150, width = 100),
                   h6("Catatan Juang", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/37733232-catatan-juang", style = "text-align: center; display:block;", "Detail")
            )
          ),
          tags$br(),
          fluidRow(
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1261900400i/7156832.jpg", height = 150, width = 100),
                   h6("Meredam Dendam", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/7156832-meredam-dendam", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1223526947i/2040560.jpg", height = 150, width = 100),
                   h6("Kalatidha", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/2040560.Kalatidha", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1272950217i/8133199.jpg", height = 150, width = 100),
                   h6("Valharald", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/8133199-valharald", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1362369218i/982516.jpg", height = 150, width = 100),
                   h6("Tembang Tanah Air", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/982516.Tembang_Tanah_Air", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1634170562i/59345269.jpg", height = 150, width = 100),
                   h6("Kita Pergi Hari Ini", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/59345269-kita-pergi-hari-ini", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 2,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1227539416i/1494713.jpg", height = 150, width = 100),
                   h6("Kremil", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/1494713.Kremil", style = "text-align: center; display:block;", "Detail")
            )
          ),
          tags$br(),
          fluidRow(
            column(width = 6,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1302859993i/11045775.jpg", height = 150, width = 100),
                   h6("Revelation", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/11045775-revelation", style = "text-align: center; display:block;", "Detail")
            ),
            column(width = 6,
                   style = "display: flex; flex-direction: column; align-items: center;",
                   img(src = "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1584353767i/52416700.jpg", height = 150, width = 100),
                   h6("Selena", style = "text-align: center;"),
                   tags$a(href = "https://www.goodreads.com/book/show/52416700-selena", style = "text-align: center; display:block;", "Detail")
            )
          )
        ),
        
        #-------------------------Tab Statistik-------------------------#
        tabItem(
          tabName = "statistik",
          tabsetPanel(
            type = "tabs",
            tabPanel(
              title = "Novel",
              fluidRow(
                box(
                  title = "10 Novel dengan Rating Terbaik pada Goodreads Novel Indonesia",
                  status = "info",
                  solidHeader = TRUE,
                  background = "gray",
                  tags$h4("Rating Novel"),
                  tags$p("Peringkat diurutkan berdasarkan rating novel dari seluruh pembaca dalam database"),
                  tableOutput("out_tbl3"),
                  width = 6
                ),
                box(
                  title = "10 Novel dengan Tahun Terbit Terbaru pada Goodreads Novel Indonesia",
                  status = "info",
                  solidHeader = TRUE,
                  background = "gray",
                  tags$h4("Tahun Terbit Novel Novel"),
                  tags$p("Peringkat diurutkan berdasarkan tahun terbit novel dalam database"),
                  tableOutput("out_tbl4"),
                  width = 6
                )
              ),
              fluidRow(
                box(
                  title = "Jumlah Novel berdasarkan Rating",
                  solidHeader = TRUE,
                  status = "info",
                  background = "gray",  # Change background color to orange
                  plotlyOutput("rating_chart"),
                  width = 6
                ),
                box(
                  title = "Jumlah Buku berdasarkan Tahun Terbit",
                  solidHeader = TRUE,
                  status = "info",
                  background = "gray",  # Change background color to orange
                  plotlyOutput("year_chart"),
                  width = 6
                ),
                box(
                  title = "Distribusi Bahasa Novel",
                  solidHeader = TRUE,
                  status = "info",
                  background = "gray",  # Change background color to orange
                  plotlyOutput("language_chart"),
                  width = 6
                ),
                box(
                  title = "Distribusi Jumlah Halaman Novel",
                  solidHeader = TRUE,
                  status = "info",
                  background = "gray",  # Change background color to orange
                  plotlyOutput("page_count_chart"),
                  width = 6
                )
              )
            ),
            tabPanel(
              title = "Penulis",
              fluidRow(
                box(
                  title = "10 Penulis Novel Terbanyak pada Goodreads Novel Indonesia",
                  status = "info",
                  solidHeader = TRUE,
                  background = "gray",
                  h4("Banyak Buku"),
                  p("Peringkat diurutkan berdasarkan banyak novel yang telah ditulis dari masing-masing penulis dalam database"),
                  tableOutput("out_tbl5"),
                  width = 6
                )
              ),
              fluidRow(
                # Tambahkan visualisasi data penulis di sini
                box(
                  title = "Jumlah Buku per Penulis",
                  solidHeader = TRUE,
                  status = "info",
                  background = "gray",
                  # Tambahkan plotlyOutput untuk visualisasi data penulis
                  plotlyOutput("penulis_chart"),
                  width = 12
                ),
                box(
                  title = "Jumlah Penulis berdasarkan Tempat Lahir",
                  solidHeader = TRUE,
                  status = "info",
                  background = "gray",  # Change background color to orange
                  plotlyOutput("tempat_lahir_penulis_chart"),
                  width = 12
                )
              )
            ),
            tabPanel(
              title = "Penerbit",
              fluidRow(
                # Tambahkan visualisasi data penerbit
                box(
                  title = "Hubungan Nama Penerbit dengan Alamat",
                  solidHeader = TRUE,
                  status = "info",
                  background = "gray",
                  # Tambahkan plotlyOutput untuk visualisasi data penerbit
                  plotlyOutput("penerbit_scatter_plot"),
                  width = 12
                )
              )
            ),
            tabPanel(
              title = "Ulasan",
              fluidRow(
                # Tambahkan visualisasi data ulasan
                box(
                  title = "Distribusi Rating User",
                  solidHeader = TRUE,
                  status = "info",
                  background = "gray",
                  # Tambahkan plotlyOutput untuk visualisasi data ulasan
                  plotlyOutput("rating_distribution"),
                  width = 12
                ),
                box(
                  title = "Scatter Plot Nama User vs. Rating User",
                  solidHeader = TRUE,
                  status = "info",
                  background = "gray",
                  # Tambahkan plotlyOutput untuk visualisasi data penulis
                  plotlyOutput("scatter_plot"),
                  width = 12
                )
              )
            )
          )
        ),
        
        
        #-------------------------Tab Info-------------------------#
        tabItem(
          tabName = "info",
          fluidRow(
            box(
              title = "Tim Pengembang",
              status = "info",
              solidHeader = TRUE,
              width = 12,
              collapsible = TRUE,
              collapsed = FALSE,
              tags$p("Dashboard ini merupakan project Mata Kuliah Praktikum Manajemen Data Statistika (STA1582), Program Studi Magister Statistika dan Sains Data, IPB University."),
              fluidRow(
                tags$div(
                  style = "display: flex; justify-content: center; flex-wrap: wrap;",
                  tags$style(".team-member { margin-bottom: 5px; }"),  # Menambahkan CSS untuk mengatur jarak antar baris
                  tags$div(
                    style = "text-align: center; margin-right: 20px;",
                    tags$img(src = "https://raw.githubusercontent.com/rahmiandr/kelompok3_MDS/main/image/risha.jpg", height = 320, width = 320),
                    tags$p("Ratu Risha Ulfia", style = "font-weight: bold;", class = "team-member"),
                    tags$p("G1501231041", class = "team-member"),
                    tags$p("Database Manager", class = "team-member")  # Nomor Induk Mahasiswa
                  ),
                  tags$div(
                    style = "text-align: center; margin-right: 20px;",
                    tags$img(src = "https://raw.githubusercontent.com/rahmiandr/kelompok3_MDS/main/image/yunia.JPG", height = 320, width = 320),
                    tags$p("Yunia Hasnataeni", style = "font-weight: bold;", class = "team-member"),
                    tags$p("G1501231001", class = "team-member"),
                    tags$p("Frontend Developer", class = "team-member")  # Nomor Induk Mahasiswa
                  ),
                  tags$div(
                    style = "text-align: center; margin-right: 20px;",
                    tags$img(src = "https://raw.githubusercontent.com/rahmiandr/kelompok3_MDS/main/image/rahmi.jpg", height = 320, width = 320),
                    tags$p("Rahmi Anadra", style = "font-weight: bold;", class = "team-member"),
                    tags$p("G1501231051", class = "team-member"),
                    tags$p("Backend Developer", class = "team-member")  # Nomor Induk Mahasiswa
                  ),
                  tags$div(
                    style = "text-align: center; margin-right: 20px;",
                    tags$img(src = "https://raw.githubusercontent.com/rahmiandr/kelompok3_MDS/main/image/monic.jpg", height = 320, width = 320),
                    tags$p("Monica Rahma Fauziah", style = "font-weight: bold;", class = "team-member"),
                    tags$p("G1501231057", class = "team-member"),
                    tags$p("Technical Writer", class = "team-member")  # Nomor Induk Mahasiswa
                  )
                )
              ),
              footer = tags$p("Info lebih lanjut mengenai project ini dapat diakses di ",
                              tags$a("GitHub pengembang", href = "https://github.com/rahmiandr/kelompok3_MDS", target = "_blank")
              )
            )
          )
        )
        
        
      )
    ),
    #-----------------FOOTER-----------------#
    
    footer = dashboardFooter(
      left = "© Kelompok 3",
      right = "IPB University, 2024",
      
      
    )
  )
)
