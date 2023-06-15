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
                                        "GLEDITSIA TRI. INERMIS SKYLINE" = "GLEDITSIA TRI. INERMIS 'SKYLINE'",
                                        "ACER RUBRUM OCT. GLORY" = "ACER RUBRUM 'OCT. GLORY'",
                                        "ACER RUBRUM RED SUNSET" = "ACER RUBRUM 'RED SUNSET'",
                                        "MALUS GOLDEN RAINDROPS" = "MALUS 'GOLDEN RAINDROPS'",
                                        "ACER RUBRUM SUN VALLEY" = "ACER RUBRUM 'SUN VALLEY'",
                                        "MALUS SUGARTYME" = "MALUS 'SUGARTYME'"
)

#separate name into cultivar, species, genus
bosTrees<-tidyr::separate(bosTrees, Species, c("A", "B"), sep = "'", remove = TRUE)|>
  dplyr::rename(Cultivar = B, Else = A)
bosTrees<-tidyr::separate(bosTrees, Else, c("A", "B"), sep = " ", remove = TRUE, extra = "merge")|>
  dplyr::rename(Genus = A, Species = B)

#remove all caps
bosTrees$Genus<-stringr::str_to_title(bosTrees$Genus)
bosTrees$Species<-stringr::str_to_title(bosTrees$Species)
bosTrees$Cultivar<-stringr::str_to_title(bosTrees$Cultivar)

usethis::use_data(bosTrees, overwrite = TRUE)
