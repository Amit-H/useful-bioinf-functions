#' Generate Enrichment Plot
#'
#' This function generates an enrichment plot based on the results of a pathway enrichment analysis.
#'
#' @param enrich_res The results of the enrichment analysis, typically obtained from a software package or an API. It should be a data frame or a similar object that contains the enrichment results for multiple pathways.
#' @param pathways A named list of pathway gene sets. Each element of the list represents a pathway, and the element name is the pathway label. The gene set should be a character vector containing the gene names associated with the pathway.
#' @param title The title of the enrichment plot. Default is "Enrichment Analysis Results".
#'
#' @return A grid object that represents the final enrichment plot combining multiple pathway dotplots.
#'
#' @importFrom gridExtra grid.arrange
#' @importFrom cowplot ggdraw draw_label
#' @importFrom enrichR enricher
#' @importFrom enrichplot dotplot
#'
#' @examples
#' # Example usage
#' # Assuming you have the enrichment analysis results in the 'enrich_res' variable
#' # and the pathway gene sets in the 'pathways' variable
#' plot <- generate_enrichment_plot(enrich_res, pathways)
#' plot
#'
#' @export
generate_enrichment_plot <- function(enrich_res, pathways, title = "Enrichment Analysis Results", universe) {
  
  library(gridExtra)
  library(cowplot)
  
  # check if any enriched terms are detected with adjusted p-value less than 0.05
  if (length(enrich_res) == 0) {
    message("No enriched terms detected.")
    return(NULL)
  }
  
  # create an empty list to store the results
  results <- list()
  
  for (i in names(pathways)) {
    # run enrichment analysis
    pathway_enrich_res <- enricher(enrich_res, TERM2GENE=pathways[[i]], universe = universe)
    
    # check if any enriched terms are detected with adjusted p-value less than 0.05
    if (any(pathway_enrich_res@result$p.adjust < 0.05)) {
      # create dotplot
      pathway_dotplot <- dotplot(pathway_enrich_res, showCategory=15)
      
      # store the results and add pathway label to the plot
      results[[i]] <- list(plot = pathway_dotplot, label = i)
    }
  }
  
  # check if any enriched terms are detected with adjusted p-value less than 0.05
  if (length(results) == 0) {
    message("No enriched terms detected.")
    return(NULL)
  }
  
  # combine all the plots into a single figure using plot_grid
  plot_list <- lapply(results, function(x) {
    plot <- x$plot
    
    # add pathway label to the plot
    label <- x$label
    plot <- plot + ggtitle(label)
    
    plot
  })
  
  # determine number of plots and arrange them accordingly
  n_plots <- length(plot_list)
  if (n_plots == 1) {
    final_plot <- plot_list[[1]]
  } else if (n_plots == 2) {
    final_plot <- plot_grid(plotlist = plot_list, ncol = 2)
  } else if (n_plots == 3) {
    final_plot <- plot_grid(plotlist = plot_list, ncol = 3)
  } else if (n_plots >= 4) {
    final_plot <- plot_grid(plotlist = plot_list, ncol = 2)
  }
  
  # add title to the final plot
  plot_title <- ggdraw() +
    draw_label(title, fontface = "bold", size = 16)
  final_plot <- plot_grid(plot_title, final_plot, nrow = 2, rel_heights = c(0.1, 1))
  
  return(final_plot)
}
