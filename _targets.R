library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

p1_targets_list <- list(
  tar_target(site_data_01427207, download_nwis_site_data('01427207')),
  tar_target(site_data_01432160, download_nwis_site_data('01432160')),
  tar_target(site_data_01436690, download_nwis_site_data('01436690')),
  tar_target(site_data_01466500, download_nwis_site_data('01466500')),
  
  tar_target(site_data,
             {
               site_data<-list(site_data_01427207, site_data_01432160, 
                    site_data_01436690, site_data_01466500) %>% 
                 bind_rows() 
               return(site_data)
             }
  ),
  
  tar_target(
    site_info,
    nwis_site_info(site_data = site_data)
  )
)

p2_targets_list <- list(
  tar_target(
    nwis_data_clean_csv, 
    process_data(site_data = site_data, 
                 fileout = "2_process/out/nwis_data_clean.csv")
  ),
  tar_target(
    cleaned_data_csv,
    annotate_and_style_data(filein = nwis_data_clean_csv, site_info = site_info,
                            fileout = "2_process/out/cleaned_data.csv")
  )
)

p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", filein = cleaned_data_csv),
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
