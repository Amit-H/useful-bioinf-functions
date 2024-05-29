plot_pathway_enrichment <- function(pathway_enrich_res_up, pathway_enrich_res_down, analysis_name) {
  """
  Plots pathway enrichment results for up- and down-regulated genes.

  Parameters:
  - pathway_enrich_res_up: Data frame containing pathway enrichment results for up-regulated genes.
  - pathway_enrich_res_down: Data frame containing pathway enrichment results for down-regulated genes.
  - analysis_name: Name of the analysis, used as the plot title.

  Returns:
  - ggplot object: A plot visualizing pathway enrichment results.

  The function processes pathway enrichment results for up- and down-regulated genes,
  extracts the top 10 enriched pathways for each regulation direction, combines them,
  adjusts count values based on regulation direction, formats pathway descriptions,
  determines significance based on p-values, and generates gradient fill values for
  visualization. It then creates a ggplot object representing a bar plot of gene counts
  for the combined enriched pathways, where pathway significance is represented by
  color gradient based on p-values.
  """
  library(dplyr)
  library(ggplot2)
  
  up_res <- as.data.frame(pathway_enrich_res_up) %>%
    mutate(regulation = "up") %>%
    top_n(10, wt = Count)
  
  down_res <- as.data.frame(pathway_enrich_res_down) %>%
    mutate(regulation = "down") %>%
    top_n(10, wt = Count)
  
  combined_res <- bind_rows(up_res, down_res)
  
  combined_res$Count <- ifelse(combined_res$regulation == "up", combined_res$Count, -combined_res$Count)
  
  combined_res$Description <- sapply(strsplit(gsub("_", " ", combined_res$Description), " "), 
                                     function(x) paste(toupper(substring(x, 1, 1)), 
                                                       tolower(substring(x, 2)), sep = "", collapse = " "))
  combined_res$Description <- gsub("Gobp ", "", combined_res$Description)
  
  row.names(combined_res) <- combined_res$Description
  
  combined_res$significance <- ifelse(combined_res$p.adjust < 0.05, "significant", "not_significant")
  
  combined_res$gradient_fill <- ifelse(combined_res$significance == "significant", combined_res$p.adjust, NA)
  
  plot <- ggplot(combined_res, aes(x = reorder(Description, abs(Count)), y = Count, fill = gradient_fill)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    labs(y = "Gene Count", title = analysis_name) +
    scale_y_continuous(labels = abs, 
                       breaks = seq(round(min(combined_res$Count), -1), round(max(combined_res$Count), -1), by = 10)) +
    theme_minimal() +
    scale_fill_gradient(low = "red", high = "blue", na.value = "grey") +
    theme(legend.title = element_blank()) +
    guides(fill = guide_colourbar(title = "p-value - adjusted")) +
    xlab(label = NULL)
  
  return(plot)
}
