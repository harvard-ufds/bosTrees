## Wrangle Boston tree data
bosTrees <- readr::read_csv("https://bostonopendata-boston.opendata.arcgis.com/datasets/boston::primary-street-trees-public.csv?outSR=%7B%22latestWkid%22%3A2249%2C%22wkid%22%3A102686%7D")

# Some initial wrangling
bosTrees <- bosTrees |>
  dplyr::rename(Longitude = POINT_X, Latitude = POINT_Y) |>
  dplyr::filter(Longitude != 0) |>
  dplyr::select(-X, -Y)

#renaming for consistency in cultivar name
bosTrees$Species<- dplyr::recode_factor(
  bosTrees$Species,
                                        "Malus" = "MALUS",
                                        "RED MAPLE" = "ACER RUBRUM",
                                        "ACER GINNALA FLAME" = "ACER GINNALA 'FLAME'",
                                        "PRUNUS VIRGINIANA CANADA RED" = "PRUNUS VIRGINIANA 'CANADA RED'",
                                        "GLEDITSIA TRI. INERMIS SKYLINE" = "GLEDITSIA TRIACANTHOS 'INERMIS'",
                                        "ACER RUBRUM OCT. GLORY" = "ACER RUBRUM 'OCT. GLORY'",
                                        "ACER RUBRUM RED SUNSET" = "ACER RUBRUM 'RED SUNSET'",
                                        "MALUS GOLDEN RAINDROPS" = "MALUS 'GOLDEN RAINDROPS'",
                                        "ACER RUBRUM SUN VALLEY" = "ACER RUBRUM 'SUN VALLEY'",
                                        "MALUS SUGARTYME" = "MALUS 'SUGARTYME'",
                                        "LIQUIDAMBAR STYR. 'HAPPI DAZE'" = "LIQUIDAMBAR STYRACIFLUA 'HAPPI DAZE'",
                                        "PRUNUS SUB AUTUMNALIS" = "PRUNUS SUBHIRTELLA 'AUTUMNALIS'",
                                        "PRUNUS SUB. AUTUMNALIS" = "PRUNUS SUBHIRTELLA 'AUTUMNALIS'",
                                        "QUERCUS MACRO" = "QUERCUS MACROCARPA",
                                        "LIQUIDAMBAR STYR" = "LIQUIDAMBAR STYRACIFLUA",
                                        "GLEDITSIA TRI. INERMIS" = "GLEDITSIA TRIACANTHOS 'INERMIS'",
                                        "GLEDITSIA TRI. INERMIS HALKA" = "GLEDITSIA TRIACANTHOS 'INERMIS'",
                                        "GLEDITSIA TRI. INERMIS 'SHADEMASTER'" = "GLEDITSIA TRIACANTHOS 'INERMIS'",
                                        "PLATANUS X ACERIFOLLIA 'EXCLAMATION'" = "PLATANUS x ACERIFOLIA 'EXCLAMATION'"
)

#separate name into cultivar, species, genus
bosTrees<-tidyr::separate(bosTrees, Species, c("A", "B"), sep = " '", remove = TRUE)|>
  dplyr::rename(Cultivar = B, Else = A)
bosTrees<-tidyr::separate(bosTrees, Else, c("A", "B"), sep = " ", remove = FALSE, extra = "merge")|>
  dplyr::rename(Genus = A, Species = B)

#remove all caps
bosTrees$Genus<-stringr::str_to_title(bosTrees$Genus)
bosTrees$Species<-stringr::str_to_title(bosTrees$Species)
bosTrees$Cultivar<-stringr::str_to_title(bosTrees$Cultivar)
bosTrees$Else<-stringr::str_to_sentence(bosTrees$Else)

#import Cambridge trees for Common Names
crossover <- readr::read_csv("https://data.cambridgema.gov/api/views/82zb-7qc9/rows.csv?accessType=DOWNLOAD")
crossover<- crossover|>
  dplyr::select(Scientific, CommonName)|>
  dplyr::count(Scientific, CommonName)|>
  dplyr::group_by(Scientific)|>
  dplyr::slice_max(n, n=1)|>
  dplyr::select(Scientific, CommonName)

#rename some to match
crossover$Scientific<-dplyr::recode_factor(crossover$Scientific,
                                           "Ulmus carpiniforlia" = "Ulmus carpinifolia",
                                           "Ulmus sp" = "Ulmus",
                                           "Prunus × yedoensis" = "Prunus x yedoensis",
                                           "Prunus sp" = "Prunus",
                                           "Malus sp" = "Malus",
                                           "Platanus acerifolia" = "Platanus x acerifolia"
                                          )

#join and find non-matches for names, there are some that don't have any info
bosTrees<- dplyr::left_join(bosTrees, crossover, by = c("Else" = "Scientific"))
bosTrees|>dplyr::mutate(CommonName =
                   as.character(dplyr::case_when(
                     Else %in% "Acer truncatum" ~ "Shangtung Maple",
                     Else %in% "Amelanchier laevis" ~ "Allegheny Serviceberry",
                     Else %in% "Amelanchier x cumulus" ~ "Cumulus Serviceberry",
                     Else %in% "Liriodendron" ~ "Tulip Tree",
                     Else %in% "Malus x zumi" ~ "Crabapple",
                     Else %in% "Only one tree planted" ~ NA_character_,
                     Else %in% "Prunus rosaceae" ~ "Taiwan Cherry",
                     Else %in% "Quercus acutissima" ~ "Sawtooth Oak",
                     Else %in% "Quercus x" ~ "Regal Prince Oak",
                     Else %in% "Ulmus wilsoniana" ~ "Prospector Oak",
                     TRUE ~ as.character(CommonName)
                   ))
)
#clean names, drop Column with species and genus info
bosTrees$CommonName<-stringr::str_to_title(bosTrees$CommonName)
bosTrees <- subset(bosTrees, select = -Else)

# Filter out unnecessary columns
bosTrees <- bosTrees |>
  dplyr::select(-A, -Flag, -GlobalID, -CreationDa, -Creator, -EditDate, -Editor, -GlobalID_2, -CreationDate, -Creator_1, -EditDate_1, -Editor_1)

# Merge categories of the same kind
bosTrees <- bosTrees |>
  dplyr::mutate(Leaning =
                  dplyr::case_when(Leaning == 'No' ~ "N",
                                   TRUE ~ as.character(Leaning)),
                TreeThere =
                  dplyr::case_when(TreeThere == 'Yes' ~ 'Y',
                                   TRUE ~ as.character(TreeThere)))

# Merge `Notes` and `Info` columns with a semicolon
bosTrees$Notes <- paste(bosTrees$Info, bosTrees$Notes, sep = "; ")

# Remove "NA;" and ";NA" occurrences
bosTrees$Notes <- gsub("NA;", "", bosTrees$Notes)
bosTrees$Notes <- gsub(";NA", "", bosTrees$Notes)

# Drop the original "Info" column if needed
bosTrees$Info <- NULL

usethis::use_data(bosTrees, overwrite = TRUE)
