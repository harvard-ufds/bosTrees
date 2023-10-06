# Wrangling Cambridge tree dataset

camTrees <- readr::read_csv("https://data.cambridgema.gov/api/views/82zb-7qc9/rows.csv?accessType=DOWNLOAD")

# Wrangling
# Clean up names
# Split on location info
camTrees <- camTrees |>
  janitor::clean_names(case = "upper_camel") |>
  dplyr::mutate(Geometry = stringr::str_replace(Geometry, "POINT \\(", "")) |>
  tidyr::separate(col = Geometry, into = c("Longitude", "Latitude"),
                  sep = " ") |>
  dplyr::mutate(Longitude = readr::parse_number(Longitude),
         Latitude = readr::parse_number(Latitude))

# Filter out unnecessary columns
camTrees <- camTrees |>
  dplyr::select(-TreeWellId, -TreeGrate, -Cartegraph, -Cartegra1, -Creator, -Inspectr, -PlantingCo, -WateringRe, -LocationRe, -SiteReplan, -SiteRetire, -BiocharAd, -Pb, -StTreePrun, -OffStTreeP)

# Capitalize the first letter of each word in the specified columns
camTrees <- camTrees |>
  dplyr::mutate(
    Species = stringr::str_to_title(Species),
    SpeciesShort = stringr::str_to_title(SpeciesShort),
    Genus = stringr::str_to_title(Genus),
    Scientific = stringr::str_to_title(Scientific),
    Order = stringr::str_to_title(Order),
    CommonName = stringr::str_to_title(CommonName)
  )

#change plant date to year, get rid of species,cultivar
camTrees$PlantYear <- stringr::str_sub(camTrees$PlantDate, start = 7, end = 10)
camTrees$RemovalYear <- stringr::str_sub(camTrees$RemovalDate, start = 7, end = 10)
camTrees <- camTrees |>
  dplyr::select(-PlantDate, -RemovalDate, -Species, -Cultivar)

# Seems like they coded NA as zero for quantitative variables
# Change to zero for select quantitative variables to be NA
camTrees <- camTrees |>
  dplyr::mutate(Diameter = dplyr::na_if(Diameter, 0),
                SolarRating = dplyr::na_if(SolarRating, 0),
                Trunks = dplyr::na_if(Trunks, 0))

usethis::use_data(camTrees, overwrite = TRUE)
