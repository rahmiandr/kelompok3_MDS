## Create data model
library(datamodelr)
file_path <- "D:/S2 STATISTIKA/SEMESTER 2/MANAJEMEN DATA STATISTIKA/PRAKTIKUM/kelompok3_MDS/image/datamodel.yml"
dm <- dm_read_yaml(file_path)
dm

## Create a graph object to plot the model
library(dm)
library(DiagrammeR)

graph <- dm_create_graph(dm,rankdir = "BT", col_attr = c("column", "type"),
                         view_type = "keys-only" )

dm_render_graph(graph)


display <- list(
  accent1 = c("novel"),
  accent2 = c("penulis"),
  accent3 = c("penerbit"),
  accent4 = c("user") )

dm <- dm_set_display(dm, display)
graph <- dm_create_graph(dm, rankdir = "BT", col_attr = c("column", "type"))
dm_render_graph(graph)

graph <- dm_create_graph( 
  dm,
  graph_attrs = "rankdir = RL, bgcolor = '#F4F0EF' ", 
  edge_attrs = "dir = both, arrowtail = crow, arrowhead = odiamond",
  node_attrs = "fontname = 'Arial'",
  rankdir = "BT", col_attr = c("column", "type"),
  view_type = "keys-only" )

dm_render_graph(graph)


