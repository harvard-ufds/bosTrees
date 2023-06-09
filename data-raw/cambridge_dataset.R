# Wrangling Cambridge tree dataset

camTrees <- readr::read_csv("https://data.cambridgema.gov/api/views/82zb-7qc9/rows.csv?accessType=DOWNLOAD")

# Wrangling
# Clean up names
# Split on location info
camTrees <- camTrees %>%
  janitor::clean_names(case = "upper_camel") %>%
  mutate(Geometry = str_replace(Geometry, "POINT \\(", "")) %>%
  tidyr::separate(col = Geometry, into = c("Longitude", "Latitude"),
                  sep = " ") %>%
  mutate(Longitude = parse_number(Longitude),
         Latitude = parse_number(Latitude))

usethis::use_data(camTrees, overwrite = TRUE)
