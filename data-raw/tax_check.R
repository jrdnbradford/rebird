#!/usr/bin/env Rscript
compare_dataframes <- function(df1, df2) {
  df1_sorted <- df1[do.call(order, df1),]
  df2_sorted <- df2[do.call(order, df2),]
  identical(df1_sorted, df2_sorted)
}

print("Loading current taxonomy...")
temp_env <- new.env()
load("data/tax.rda", envir = temp_env)
old_tax <- temp_env$tax
paste("Current num columns:", ncol(old_tax))
print("Current column names:")
colnames(old_tax)
paste("Current num rows:", nrow(old_tax))

print("Retrieving taxonomy from eBird...")
new_tax <- rebird::ebirdtaxonomy()
paste("Latest num columns:", ncol(new_tax))
print("Latest column names:")
colnames(new_tax)
paste("Latest num rows:", nrow(new_tax))
needs_update <- !(compare_dataframes(old_tax, new_tax))

print(paste("Needs update?:", needs_update))
if (needs_update) print("The next job to create an issue should run.")
cat(paste0("result=", needs_update), file=Sys.getenv("GITHUB_OUTPUT"), append=TRUE)
