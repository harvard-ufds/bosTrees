#' Street trees in Boston
#'
#' Includes data for street trees in Boston. Provided by Boston's GIS department.
#'
#' @format A tibble with 6836 rows and 25 variables:
#' \describe{
#'   \item{FID}{unique identifier for each tree}
#'   \item{Species}{a character denoting species}
#'   \item{Address}{The Boston address that the tree is at}
#'   \item{Notes}{Notes for finding the tree or information about the tree}
#'   \item{Season}{The season in which the tree was recorded}
#'   \item{Inspected}{A binary for whether or not the tree was inspected}
#'   \item{Alive}{A binary for whether or not the tree is alive}
#'   \item{Leaning}{A binary for whether or not the tree is leaning}
#'   \item{TreeThere}{A binary for whether or not there is a tree at the address}
#'   \item{Longitude}{Longitude information}
#'   \item{Latitude}{Latitude information}
#'   \item{Watered}{A binary for whether or not the tree is watered}
#' }
#' @source{https://data.boston.gov/dataset/primary-street-trees-public}

"bosTrees"
