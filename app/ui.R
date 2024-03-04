library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(RPostgreSQL)
library(DBI)
library(DT)
library(bs4Dash)
library(dplyr)
library(fontawesome)

#=========================== Interface (Front-End) ============================#

fluidPage(
  dashboardPage(
    header <- dashboardHeader(
      title = div(
        style = "text-align: center;",
        img(src = "https://raw.githubusercontent.com/rahmiandr/kelompok3_MDS/main/image/logobaru.png", height = 40, style = "margin-bottom: -20px;"),  
        h1("Goodreads Novel Database", style = "color: black; font-size: 10px; font-weight: bold; margin-top: 20px;")
      ),
      titleWidth = "300px"  # Menyesuaikan lebar judul
    ),
    #------------SIDEBAR-----------------#
    sidebar = dashboardSidebar(
      collapsed = TRUE,
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
          text = "Cari Penulis",
          tabName = "penulis",
          icon = icon("user")
        ),
        menuItem(
          text = "Ulasan",
          tabName = "ulasan",
          icon = icon("star")
        )
      )
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
              "Pencarian Novel Indonesia",
              style = "font-size:75px;font-weight:bold;display: flex;align-items: center;"
            ),
            lead = "Selamat Datang di Goodreads Novel Indonesia Database!", 
            span("Goodreads Novel Indonesia adalah database novel yang memberikan informasi lengkap seputar Novel Indonesia yang tersedia di Goodreads, memungkinkan pengguna untuk menjelajahi dan menemukan berbagai novel terbaik di Indonesia. Dengan berbagai judul dan penulis yang terdaftar, kami menyajikan informasi terkini dan ulasan berkualitas dari komunitas Goodreads yang dapat membantu para calon pembaca untuk menemukan novel yang dinginkan.",
                 style = "font-size:20px;text-align:justify;"),
            status = "primary",
            href = "https://www.goodreads.com/"
          ),
          
          fluidRow(
            box(
              title = "Panduan",
              solidHeader = TRUE,
              status = "primary",
              background = "teal",  # Change background color to orange
              tags$p(
                tags$li("Arahkan kursor ke sisi kiri layar atau klik ikon garis tiga pada sisi pojok kanan atas untuk mengakses bilah sisi (side bar). 
                 Tiga fitur utama pada Goodreads Novel Indonesia adalah sebagai berikut."),
                tags$p(
                  tags$li("Cari Novel"),
                  tags$p("Pencarian novel dengan memanfaatkan fitur penyaringan tahun terbit, edisi, dan rating novel.
            Lengkapi kriteria penyaringan agar didapatkan publikasi yang relevan."),
                  tags$br(),
                  tags$li("Cari Penulis"),
                  tags$p("Pencarian nama penulis dengan memanfaatkan fitur penyaringan id penulis dan jumlah buku. 
            Lengkapi kriteria penyaringan agar didapatkan publikasi yang relevan."),
                  tags$br(),
                  tags$li("Ulasan"),
                  tags$p("Informasi tentang ulasan yang diberikan oleh para pembaca."),
                  style = "color: white; font-size: 15px; text-align: justify; padding: 10px; border-radius: 5px; background-color: transparent;"  # Menghilangkan warna latar belakang
                ),
                width = 6,
                collapsible = TRUE,
                collapsed = TRUE
              )
            ),
            box(
              title = "Pengembang Situs",
              solidHeader = TRUE,
              status = "primary",
              background = "teal",  # Change background color to orange
              tags$p(
                tags$li("Ratu Risha Ulfia sebagai Database Manager"),
                tags$br(),
                tags$li("Yunia Hasnataeni sebagai Frontend Developer"),
                tags$br(),
                tags$li("Rahmi Anadra sebagai Backend Developer"),
                tags$br(),
                tags$li("Monica Rahma Fauziah sebagai Technical Writer"),
                style = "color: white; font-size: 15px; text-align: justify; padding: 10px; border-radius: 5px; background-color: transparent;"  # Menghilangkan warna latar belakang
              ),
              width = 6,
              collapsible = TRUE,
              collapsed = TRUE
            ),
          )
        ),
        
        #--------------------------Tab NOVEL--------------------------#
        tabItem(
          tabName = "novel",
          fluidRow(
            tags$h1("Pencarian Novel Indonesia")
          ),
          fluidRow(
            # Filter tahun terbit
            box(
              title = "Tahun Terbit",
              solidHeader = TRUE,
              status = "primary",
              background = "teal",  # Change background color to orange
              tags$p(
              tags$h3("Filter Tahun"),
              tags$p("Pilih rentang tahun terbit yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_1"),
              width = 4)
            ),
            # Filter edisi
            box(
              title = "Edisi",
              solidHeader = TRUE,
              status = "primary",
              background = "teal",  # Change background color to orange
              tags$p(
              tags$h3("Filter Edisi"),
              tags$p("Pilih edisi yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_2"),
              width = 4)
            ),
            # Filter rating
            box(
              title = "Rating",
              solidHeader = TRUE,
              status = "primary",
              background = "teal",  # Change background color to orange
              tags$p(
              tags$h3("Filter Rating"),
              tags$p("Pilih rentang rating yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_3"),
              width = 4)
            )
          ),
          fluidRow(
            # Display tabel 
            box(
              title = "Hasil Pencarian",
              solidHeader = TRUE,
              status = "primary",
              background = "teal",  # Change background color to orange
              tags$p(
              tags$h3("Tabel"),
              dataTableOutput("out_tbl1"),
              width = 12)
            )
          )
        ),
        #-------------------------Tab Penulis-------------------------#
        tabItem(
          tabName = "penulis",
          fluidRow(
            tags$h1("Pencarian Novel Indonesia")
          ),
          fluidRow(
            # Filter id penulis
            box(
              title = "ID Penulis",
              solidHeader = TRUE,
              status = "primary",
              background = "teal",  # Change background color to orange
              tags$p(
              tags$h3("Filter ID Penulis"),
              tags$p("Pilih id penulis yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_4"),
              width = 6)
            ),
            # Filter jumlah buku
            box(
              title = "Jumlah Buku",
              solidHeader = TRUE,
              status = "primary",
              background = "teal",  # Change background color to orange
              tags$p(
              tags$h3("Filter Jumlah Buku"),
              tags$p("Pilih jumlah buku penulis yang ingin ditampilkan"),
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
              status = "primary",
              background = "teal",  # Change background color to orange
              tags$p(
              tags$h3("Tabel"),
              dataTableOutput("out_tbl2"),
              width = 12)
            )
          )
        ),
        #-------------------------Tab Statistik-------------------------#
        tabItem(
          tabName = "ulasan",
          tabsetPanel(
            type = "tabs",
            tabPanel(
              title = "Rating",
              fluidRow(
                tags$br(),
                tags$h2("10 Novel dengan Rating Terbaik pada Goodreads Novel Indonesia"),
                tags$p("Berikut adalah 10 novel terbaik dari seluruh novel di Goodreads Novel Indonesia Database")
                
              )
            )
          )
        )
      )
    ),
    #-----------------FOOTER-----------------#
    footer = dashboardFooter(
      left = "© 2024 Kelompok 2",
      right = "IPB University, 2024",
    )
  )
)