process_data <- function(site_data, fileout){
  nwis_data_clean <- rename(site_data, water_temperature = X_00010_00000) %>% 
    select(-agency_cd, -X_00010_00000_cd, -tz_cd)
  write_csv(nwis_data_clean, fileout)
  return(fileout)
}

annotate_and_style_data <- function(filein, site_info, fileout){
  site_data<- read_csv(filein)
  annotated_data <- left_join(site_data, site_info, by = "site_no") %>% 
    select(station_name = station_nm, site_no, dateTime, water_temperature, latitude = dec_lat_va, longitude = dec_long_va)%>%
    mutate(station_name = as.factor(station_name))
    write_csv(annotated_data, fileout)
  
  return(fileout)
}

