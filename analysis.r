# ---------------------------------------------------------

# Melbourne Bioinformatics Training Program

# This exercise to assess your familiarity with R and git. Please follow
# the instructions on the README page and link to your repo in your application.
# If you do not link to your repo, your application will be automatically denied.

# Leave all code you used in this R script with comments as appropriate.
# Let us know if you have any questions!


# You can use the resources available on our training website for help:
# Intro to R: https://mbite.org/intro-to-r
# Version Control with Git: https://mbite.org/intro-to-git/

# ----------------------------------------------------------

# Load libraries -------------------
# You may use base R or tidyverse for this exercise

library(tidyverse)
library(here)

# Load data here ----------------------
# Load each file with a meaningful variable name.

genetic_metadata <- read.csv(here::here("data/GSE60450_filtered_metadata.csv"))
normalised_gene_expression <- read.csv(here::here("data/GSE60450_GeneLevel_Normalized(CPM.and.TMM)_data.csv"))

# Inspect the data -------------------------

# What are the dimensions of each data set? (How many rows/columns in each?)
# Keep the code here for each file.

## Expression data
dim(normalised_gene_expression) # output: 23735 rows and 14 columns

## Metadata
dim(genetic_metadata) # output: 12 rows and 4 columns

# Prepare/combine the data for plotting ------------------------
# How can you combine this data into one data.frame?
combined_data <- normalised_gene_expression %>% 
  pivot_longer(cols = starts_with("GSM")) %>% # transform data into long format (appropriate for plotting)
  merge(genetic_metadata %>% # merge data based on GSM
          rename("name" = "X"), 
        by = "name")


# Plot the data --------------------------
## Plot the expression by cell type
## Can use boxplot() or geom_boxplot() in ggplot2
combined_data %>% 
  ggplot() + 
  geom_boxplot(aes(x = immunophenotype, 
                   y = value,
                   fill = developmental.stage)) + # further analyse data by splitting into developmental stage
  scale_y_log10() + # transform gene expression data to log10 scale to visualise data better
  xlab("Cell type") +
  ylab("Normalised gene expression (log10-transformed)") +
  theme_bw() + # adjust aesthetics to ease visualisation
  theme(axis.text=element_text(size=15), # increase font sizes and remove grid lines
        axis.title=element_text(size=16), 
        strip.text = element_text(size = 15), 
        legend.text=element_text(size=14), 
        legend.title=element_text(size=15), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())


## Save the plot
### Show code for saving the plot with ggsave() or a similar function
ggsave(here::here("results/gene_expression_by_cell_type.pdf"), dpi = 300)
