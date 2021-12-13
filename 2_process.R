source("2_process/src/process_and_style.R")

p2_targets_list <- list(
  tar_target(
    p2_nwis_data_clean_csv, 
    process_data(filein = p1_site_data_csv, 
                 fileout = "2_process/out/nwis_data_clean.csv"),
    format = "file"
  ),
  tar_target(
    p2_cleaned_data_csv,
    annotate_and_style_data(filein = p2_nwis_data_clean_csv, site_info = p1_site_info,
                            fileout = "2_process/out/cleaned_data.csv"),
    format = "file"
  )
)