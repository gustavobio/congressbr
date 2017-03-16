#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom purrr map
#' @importFrom dplyr as_data_frame
#' @importFrom stringi stri_trans_general
#' @title Downloads and tidies information on the political parties in the
#' Federal Senate.
#' @return A tibble, of classes \code{tbl_df}, \code{tbl} and \code{data.frame}.
#' @author Robert Myles McDonnell, Guilherme Jardim Duarte & Danilo Freire.
#' @param ascii \code{logical}. TRUE by default, removes latin-1 characters
#' from returned object.
#' @usage
#' sen_parties(ascii = TRUE)
#' @examples
#' \code{party <- sen_parties(); head(party)}
#' @export
sen_parties <- function(ascii = TRUE){
  x <- httr::GET("http://legis.senado.gov.br/dadosabertos/senador/partidos")
  x <- status(x)
  x <- x$ListaPartidos$Partidos$Partido
  x <- purrr::map(x, dplyr::as_data_frame)
  x <- do.call(rbind, x)
  if(ascii == TRUE){
    x$Nome <- stringi::stri_trans_general(x$Nome, "Latin-ASCII")
  }
  return(x)
}


#' @title Downloads and tidies information on the types of declarations senators
#' can make in the Federal Senate.
#' @param ascii \code{logical}. TRUE by default, removes latin-1 characters
#' from returned object.
#' @param print \code{logical}. If TRUE (the default), prints the dataframe to
#' the console.
#' @return A tibble, of classes \code{tbl_df}, \code{tbl} and \code{data.frame}.
#' @author Robert Myles McDonnell, Guilherme Jardim Duarte & Danilo Freire.
#' @usage \code{sen_statement_list(return = TRUE, ascii = TRUE)}
#' @examples
#' st <- sen_statement_list()
#' @export
sen_statement_list <- function(ascii = TRUE, print = TRUE){
  x <- httr::GET("http://legis.senado.gov.br/dadosabertos/senador/lista/tiposPronunciamento")
  x <- status(x)
  x <- x$ListaTiposPronunciamento$TiposPronunciamento$TipoPronunciamento
  x <- purrr::map(x, dplyr::as_data_frame)
  x <- do.call(rbind, x)
  if(ascii == TRUE){
    x$Descricao <- stringi::stri_trans_general(x$Descricao, "Latin-ASCII")
  }
  colnames(x) <- c("Abbreviation", "Description")
  if(print == TRUE){
    head(x, n = 9L)
  }
  return(x)
}


#' @title A list of state abbreviations for use with the functions of congressbr.
#' @description This function prints out a character vector of Brazilian
#' state abbreviations to the console.
#' @author Robert Myles McDonnell, Guilherme Jardim Duarte & Danilo Freire.
#' @note This is most useful if you already have an idea of what state you want
#'  and its abbreviation. If not, to see the full dataset, use
#'  \code{data("statesBR")}, which has the abbreviation, "UF"
#'  (\emph{Unidade Federal}) and the full name of the states.
#' @export
UF <- function(){
  uf <- c("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES",
          "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR",
          "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC",
          "SP", "SE")
  print(uf)
}



#' @title Downloads and tidies information on the types of bills that come to
#' a vote in the Federal Senate.
#' @param active. Possible values are \code{TRUE}, \code{FALSE}, or can be left as
#' \code{NULL}, in which case both active and inactive bill types are returned.
#' @param ascii \code{logical}. TRUE by default, removes latin-1 characters
#' from returned object.
#' @param print \code{logical}. If TRUE (the default), prints the dataframe to
#' the console.
#' @return A tibble, of classes \code{tbl_df}, \code{tbl} and \code{data.frame}.
#' @author Robert Myles McDonnell, Guilherme Jardim Duarte & Danilo Freire.
#' @examples
#' bills <- sen_bills_list(active = TRUE)
#' @export
sen_bills_list <- function(active = NULL, ascii = TRUE){

  base_url <- "http://legis.senado.gov.br/dadosabertos/materia/tiposNorma"

  if(!is.null(active)){
    if(active == TRUE){
      active <- "?indAtivos=S"
    } else{
      active <- "?indAtivos=N"
    }
    base_url <- base_url %p% active
  }

  request <- httr::GET(base_url)
  request <- status(request)
  request <- request$ListaTiposDocumento$TiposDocumento$TipoDocumento

  bills <- dplyr::data_frame(
    id = purrr::map_chr(request, "Codigo", .null = NA_character_),
    bill_abbr = purrr::map_chr(request, "Sigla", .null = NA_character_),
    bill_description = purrr::map_chr(request, "Descricao", .null = NA_character_)
  )
  if(ascii == TRUE){
    bills$bill_description <- stringi::stri_trans_general(
      bills$bill_description, "Latin-ASCII")
  }
  return(bills)
}