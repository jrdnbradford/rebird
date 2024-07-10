#!/usr/bin/env Rscript
compare_dataframes <- function(df1, df2) {
  # Sort the dataframes by row and column for comparison
  df1_sorted <- df1[do.call(order, df1), ]
  df2_sorted <- df2[do.call(order, df2), ]

  # Check if the sorted dataframes are identical
  identical(df1_sorted, df2_sorted)
}

print("Loading current taxonomy...")
temp_env <- new.env()
load("data/tax.rda", envir = temp_env)
old_tax <- temp_env$tax
old_tax_new <- old_tax[do.call(order, old_tax),]
colnames(old_tax)
paste("Num rows:", nrow(old_tax))

print("Retrieving taxonomy from eBird...")
new_tax <- rebird::ebirdtaxonomy()
colnames(new_tax)
paste("Num rows:", nrow(new_tax))

needs_update <- !(compare_dataframes(old_tax, new_tax))

find_differences(old_tax, new_tax)
print(paste("Needs update?:", needs_update))
cat(paste0("result=", needs_update), "\n", file=Sys.getenv("GITHUB_OUTPUT"), append=TRUE)
cat(readLines(Sys.getenv("GITHUB_OUTPUT")), sep = "\n")
