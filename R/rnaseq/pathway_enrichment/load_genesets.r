#' Retrieve pathway information from MSigDB
#' 
#' This function retrieves pathway information from the Molecular Signatures Database (MSigDB) for a given species, category, and subcategory.
#' 
#' @param species a character vector indicating the species for which to retrieve pathway information (e.g. "Mus musculus")
#' @param category a character vector indicating the category of pathways to retrieve (e.g. "C5")
#' @param subcategory a character vector indicating the subcategory of pathways to retrieve (e.g. "BP")
#' @return a list of data frames containing the pathway information, with one data frame for each pathway category (e.g. GO, REACTOME, KEGG, HALLMARK)
#' @import dplyr
#' @importFrom msigdbr msigdbr
get_pathways <- function(species, category, subcategory) {
  GO <- msigdbr(species = species, category = category, subcategory = subcategory) %>% 
    dplyr::select(gs_name, gene_symbol)
  
  REACTOME <- msigdbr(species = species, category = "C2", subcategory = 'REACTOME') %>% 
    dplyr::select(gs_name, gene_symbol)
  
  KEGG <- msigdbr(species = species, category = "C2", subcategory = 'KEGG') %>% 
    dplyr::select(gs_name, gene_symbol)
  
  HALLMARK <- msigdbr(species = species, category = "H") %>% 
    dplyr::select(gs_name, gene_symbol)
  
  pathways <- list(GO = GO, REACTOME = REACTOME, KEGG = KEGG, HALLMARK = HALLMARK)
  return(pathways)
}
