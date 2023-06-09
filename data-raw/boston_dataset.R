## Wrangle Boston tree data
bosTrees <- readr::read_csv("https://bostonopendata-boston.opendata.arcgis.com/datasets/boston::primary-street-trees-public.csv?outSR=%7B%22latestWkid%22%3A2249%2C%22wkid%22%3A102686%7D")

# Some initial wrangling
bosTrees <- bosTrees |>
  dplyr::rename(Longitude = POINT_X, Latitude = POINT_Y) |>
  filter(Longitude != 0) |>
  select(-X, -Y)

usethis::use_data(bosTrees, overwrite = TRUE)
