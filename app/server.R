library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(RPostgreSQL)
library(DBI)
library(DT)
library(bs4Dash)
library(dplyr)
library(plotly)
library(ggplot2)



#======================= Koneksi Shiny ke Database =======================#
connectDB <- function(){
  tryCatch({
    driver <- dbDriver('PostgreSQL')
    # mengatur koneksi ke server database ElephantSQL
    db <- dbConnect(
      driver,
      dbname = "uafemknk", 
      host = "topsy.db.elephantsql.com",
      user = "uafemknk",
      password = "vHlk8GXVd5l6q5zXphKTF6mbKpgyN-2q"
    )
    return(db)
  }, error = function(e) {
    stop("Tidak dapat terhubung ke database: ", e$message)
  })
}

db <- connectDB()

# Query untuk mengambil nama penulis dan penerbit unik
unique_authors_query <- "SELECT DISTINCT nama_penulis FROM penulis ORDER BY nama_penulis"
unique_publishers_query <- "SELECT DISTINCT nama_penerbit FROM penerbit ORDER BY nama_penerbit"
ratings_range_query <- "SELECT MIN(rating_novel) as min_rating, MAX(rating_novel) as max_rating FROM novel"
years_range_query <- "SELECT MIN(tahun_terbit) as min_year, MAX(tahun_terbit) as max_year FROM novel"

title_novel_query <- "SELECT DISTINCT judul FROM novel ORDER BY judul"

# Jalankan Query
unique_authors <- dbGetQuery(db, unique_authors_query)
unique_publishers <- dbGetQuery(db, unique_publishers_query)
ratings_range <- dbGetQuery(db, ratings_range_query)
years_range <- dbGetQuery(db, years_range_query)

title_novel <- dbGetQuery(db, title_novel_query)

#============================= SERVER (back-end) ==============================#
server <- function(input, output, session) {
  
  # Render UI untuk Select Penulis
  output$filter_1 <- renderUI({
    selectInput(
      inputId = "selected_author",
      label = "Pilih Penulis",
      choices = c("", unique_authors$nama_penulis)  
    )
  })
  
  output$filter_2 <- renderUI({
    selectInput(
      inputId = "selected_publisher",
      label = "Pilih Penerbit",
      choices = c("", unique_publishers$nama_penerbit)  
    )
  })
  
  output$filter_3 <- renderUI({
    sliderInput(
      inputId = "selected_year",
      label = "Pilih Tahun Terbit",
      min = years_range$min_year,
      max = years_range$max_year,
      value = c(years_range$min_year, years_range$max_year)
    )
  })
  
  # Render UI untuk Slider Rating
  output$filter_4 <- renderUI({
    sliderInput(
      inputId = "selected_rating",
      label = "Pilih Rating",
      min = ratings_range$min_rating,
      max = ratings_range$max_rating,
      value = c(ratings_range$min_rating, ratings_range$max_rating)
    )
  })
  
  # Render UI untuk Select Ulasan
  output$filter_5 <- renderUI({
    selectInput(
      inputId = "selected_title",
      label = "Pilih judul novel",
      choices = c("", title_novel$judul)  
    )
  })
  
  
  observe({
    updateSelectInput(session, "selected_author", selected = "")
    updateSelectInput(session, "selected_publisher", selected = "")
    updateSliderInput(session, "selected_rating", value = c(NA, NA))
    updateSliderInput(session, "selected_year", value = c(NA, NA))
    updateSelectInput(session, "selected_title", selected = "")
  })
  
  # Fungsi Reaktif untuk Menampilkan Tabel Berdasarkan Filter
  output$out_tbl1 <- renderDataTable({
    query <- paste0(
      "SELECT novel.judul, novel.ISBN, novel.bahasa, novel.edisi, novel.jumlah_halaman, novel.deskripsi ",
      "FROM novel ",
      "INNER JOIN penulis ON novel.id_penulis = penulis.id_penulis ",
      "INNER JOIN penerbit ON novel.id_penerbit = penerbit.id_penerbit "
    )
    
    conditions <- vector("list", 4)
    
    if (input$selected_author != "") {
      conditions[[1]] <- sprintf("penulis.nama_penulis = '%s'", input$selected_author)
    }
    if (input$selected_publisher != "") {
      conditions[[2]] <- sprintf("penerbit.nama_penerbit = '%s'", input$selected_publisher)
    }
    if (!is.null(input$selected_year)) {
      conditions[[3]] <- sprintf("novel.tahun_terbit BETWEEN %s AND %s", input$selected_year[1], input$selected_year[2])
    }
    if (!is.null(input$selected_rating)) {
      conditions[[4]] <- sprintf("novel.rating_novel BETWEEN %s AND %s", input$selected_rating[1], input$selected_rating[2])
    }
    
    conditions <- conditions[!sapply(conditions, is.null)]
    
    if (length(conditions) > 0) {
      query <- sprintf("%s WHERE %s", query, paste(conditions, collapse = " AND "))
    }
    
    tryCatch({
      db <- connectDB()
      data <- dbGetQuery(db, query)
      dbDisconnect(db)
      return(data)
    }, error = function(e) {
      warning("Error fetching data: ", e$message)
      return(data.frame())
    })
  }, options = list(pageLength = 5, scrollX = TRUE))
  
  # Fungsi Reaktif untuk Menampilkan Tabel Berdasarkan Filter
  output$out_tbl2 <- renderDataTable({
    query <- paste0(
      "SELECT ulasan.nama_user, ulasan.ulasan, ulasan.rating_user ",
      "FROM ulasan ",
      "INNER JOIN novel ON ulasan.id_novel = novel.id_novel"
    )
    
    conditions <- vector("list", 1)
    
    if (input$selected_title != "") {
      conditions[[1]] <- sprintf("novel.judul = '%s'", input$selected_title)
    }
    
    conditions <- conditions[!sapply(conditions, is.null)]
    
    if (length(conditions) > 0) {
      query <- paste0(query, " WHERE ", paste(conditions, collapse = " AND "))
    }
    
    tryCatch({
      db <- connectDB()
      data <- dbGetQuery(db, query)
      dbDisconnect(db)
      return(data)
    }, error = function(e) {
      warning("Error fetching data: ", e$message)
      return(data.frame())
    })
  }, options = list(pageLength = 5, scrollX = TRUE))
  
  # Query untuk mendapatkan 10 novel teratas berdasarkan rating
  top_novels_query <- "
  SELECT n.judul, n.rating_novel
  FROM public.novel n
  ORDER BY n.rating_novel DESC
  LIMIT 10
  "
  
  # Query untuk mendapatkan 10 novel teratas berdasarkan tahun terbit
  year_novels_query <- "
  SELECT n.judul, n.tahun_terbit
  FROM public.novel n
  ORDER BY n.tahun_terbit DESC
  LIMIT 10
  "
  
  # Query untuk mendapatkan 10 penulis dengan jumlah buku terbanyak
  top_authors_query <- "
  SELECT p.nama_penulis, p.jumlah_buku
  FROM public.penulis p
  ORDER BY p.jumlah_buku DESC
  LIMIT 10
  "
  
  # Output untuk 10 novel dengan rating teratas
  output$out_tbl3 <- renderTable({
    db <- connectDB()
    on.exit(dbDisconnect(db))
    dbGetQuery(db, top_novels_query)
  })
  
  # Output untuk 10 novel dengan tahun terbit teratas
  output$out_tbl4 <- renderTable({
    db <- connectDB()
    on.exit(dbDisconnect(db))
    dbGetQuery(db, year_novels_query)
  })
  
  # Output untuk 10 penulis dengan buku terbanyak
  output$out_tbl5 <- renderTable({
    db <- connectDB()
    on.exit(dbDisconnect(db))
    dbGetQuery(db, top_authors_query)
  })
  
  # Fungsi reaktif untuk membuat bar chart
  output$rating_chart <- renderPlotly({
    data <- dbGetQuery(db, "SELECT rating_novel, COUNT(*) as jumlah FROM novel GROUP BY rating_novel ORDER BY rating_novel DESC")
    
    ggplot(data, aes(x = as.factor(rating_novel), y = jumlah)) +
      geom_bar(stat = "identity", fill = "skyblue") +
      labs(title = "", x = "Rating Novel", y = "Jumlah") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Untuk memutar label sumbu x agar lebih mudah dibaca
  })
  
  # Fungsi reaktif untuk membuat bar chart
  output$year_chart <- renderPlotly({
    data <- dbGetQuery(db, "SELECT tahun_terbit, COUNT(*) as jumlah FROM novel GROUP BY tahun_terbit ORDER BY tahun_terbit")
    
    ggplot(data, aes(x = as.factor(tahun_terbit), y = jumlah)) +
      geom_bar(stat = "identity", fill = "skyblue") +
      labs(title = "", x = "Tahun Terbit", y = "Jumlah") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Untuk memutar label sumbu x agar lebih mudah dibaca
  })
  
  # Fungsi reaktif untuk membuat pie chart
  output$language_chart <- renderPlotly({
    data <- dbGetQuery(db, "SELECT bahasa, COUNT(*) as jumlah FROM novel GROUP BY bahasa")
    
    plot_ly(data, labels = ~bahasa, values = ~jumlah, type = 'pie') %>%
      layout(title = "")
  })
  
  # Fungsi reaktif untuk membuat bar chart jumlah halaman novel
  output$page_count_chart <- renderPlotly({
    data <- dbGetQuery(db, "SELECT jumlah_halaman FROM novel")
    
    ggplot(data, aes(x = jumlah_halaman)) +
      geom_histogram(binwidth = 50, fill = "skyblue", color = "black") +
      labs(title = "", x = "Jumlah Halaman", y = "Jumlah Buku") +
      theme_minimal()
  })
  
  # Fungsi reaktif untuk membuat jumlah buku penulis
  output$penulis_chart <- renderPlotly({
    # Query data penulis dan jumlah bukunya dari database
    query <- "SELECT nama_penulis, jumlah_buku FROM penulis"
    penulis_data <- dbGetQuery(db, query)
    
    # Buat pie chart dengan plotly
    plot_ly(penulis_data, labels = ~nama_penulis, values = ~jumlah_buku, type = 'pie') %>%
      layout(title = "")
  })
  
  # Fungsi reaktif untuk membuat tempat lahir penulis
  output$tempat_lahir_penulis_chart <- renderPlotly({
  # Query data penulis dan tempat lahir dari database
  query <- "SELECT nama_penulis, tempat_lahir FROM penulis"
  penulis_data <- dbGetQuery(db, query)
  
  # Hitung jumlah penulis untuk setiap tempat lahir
  penulis_count <- penulis_data %>% group_by(tempat_lahir) %>% summarise(count = n())
  
  # Buat bar plot dengan ggplot2
  ggplot(penulis_count, aes(x = tempat_lahir, y = count, fill = tempat_lahir)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(title = "",
         x = "Tempat Lahir",
         y = "Jumlah Penulis")
  })
  
  # Fungsi reaktif untuk membuat scatter plot penerbit
  output$penerbit_scatter_plot <- renderPlotly({
    # Query data penerbit dari database
    query <- "SELECT nama_penerbit, alamat FROM penerbit"
    penerbit_data <- dbGetQuery(db, query)
    
    # Buat scatter plot dengan plotly
    plot_ly(penerbit_data, x = ~alamat, y = ~nama_penerbit, type = 'scatter', mode = 'markers') %>%
      layout(title = "", xaxis = list(title = "Alamat"), yaxis = list(title = "Nama Penerbit"))
  })
  
  # Fungsi reaktif untuk untuk Jumlah Rating User
  # Query untuk mengambil data ulasan
  query <- "SELECT rating_user FROM ulasan"
  # Mengambil data ulasan dari database
  ulasan <- dbGetQuery(db, query)
  
  # Histogram untuk Distribusi Rating User
  output$rating_distribution <- renderPlotly({
    plot_ly(ulasan, x = ~rating_user, type = "histogram") %>%
      layout(title = "", xaxis = list(title = "Rating"), yaxis = list(title = "Jumlah Ulasan"))
  })
  
  # Fungsi reaktif untuk scatter plot rating per user
  # Query untuk mengambil data nama pengguna dan rating dari ulasan
  query <- "SELECT nama_user, rating_user FROM ulasan"
  
  # Mengambil data dari database
  ulasan_data <- dbGetQuery(db, query)
  
  # Scatter Plot untuk Nama User dan Rating User
  output$scatter_plot <- renderPlotly({
    plot_ly(ulasan_data, x = ~nama_user, y = ~rating_user, color = ~rating_user,
            type = 'scatter', mode = 'markers', marker = list(size = 10)) %>%
      layout(title = "",
             xaxis = list(title = "Nama User"),
             yaxis = list(title = "Rating User"))
  })
}
    
