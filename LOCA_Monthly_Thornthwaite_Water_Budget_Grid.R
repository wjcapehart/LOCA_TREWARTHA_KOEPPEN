
###############################################################
#
# Libaries

  library(package = "tidyverse")
  library(package = "tidypredict")

  library(package = "lubridate") # processing dates and time
  library(package = "stringr")


  library(package = "reshape2")  # manipulating data frames
  library(package = "extRemes")  # extreme data analysis
  library(package = "abind")

  library(package = "tidync")
  library(package = "ncdf4")

  library(package = "PCICt")

  library(package = "ClimClass")

  library(package = "RCurl") # General Network (HTTP/FTP/...) Client Interface for R

## Mapping Information

library(package = "rnaturalearth") # World Map Data from Natural Earth
library(package = "rgdal")         # Bindings for the 'Geospatial' Data Abstraction Library
#
###############################################################
  


###############################################################
#
# File Control

  URL_Root = "http://kyrill.ias.sdsmt.edu:8080/thredds/dodsC/LOCA_NGP/climatology/"
 URL_Root = "/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/climatology/"

#
###############################################################
  



###############################################################
#
# Ensemble Members

ensembles = c( "ACCESS1-0_r1i1p1",
               "ACCESS1-3_r1i1p1",
               "CCSM4_r6i1p1",
               "CESM1-BGC_r1i1p1",
               "CESM1-CAM5_r1i1p1",
               "CMCC-CMS_r1i1p1",
               "CMCC-CM_r1i1p1",
               "CNRM-CM5_r1i1p1",
               "CSIRO-Mk3-6-0_r1i1p1",
               "CanESM2_r1i1p1",
               "FGOALS-g2_r1i1p1",
               "GFDL-CM3_r1i1p1",
               "GFDL-ESM2G_r1i1p1",
               "GFDL-ESM2M_r1i1p1",
               "HadGEM2-AO_r1i1p1",
               "HadGEM2-CC_r1i1p1",
               "HadGEM2-ES_r1i1p1",
               "IPSL-CM5A-LR_r1i1p1",
               "IPSL-CM5A-MR_r1i1p1",
               "MIROC-ESM_r1i1p1",
               "MIROC5_r1i1p1",
               "MPI-ESM-LR_r1i1p1",
               "MPI-ESM-MR_r1i1p1",
               "MRI-CGCM3_r1i1p1",
               "NorESM1-M_r1i1p1",
               "bcc-csm1-1-m_r1i1p1" )

#
###############################################################
  







# Cracking huc grids.
HUC06 = 1012
soil_zone_capacity = 150
initial_snow_cover = 0
plotme = TRUE


URL_Name = "http://kyrill.ias.sdsmt.edu:8080/thredds/fileServer/CLASS_Examples/HUC08_Missouri_River_Basin.Rdata"


 my.connection = url(description = URL_Name)
     load(file = my.connection)
     close(con = my.connection)
     remove(my.connection)

remove(HUC08_MRB_LUT)

HUC06_MRB_Code_2D = HUC08_MRB_Code_2D
remove(HUC08_MRB_Code_2D)

HUC06_MRB_Code_Frame = HUC08_MRB_Code_Frame
remove(HUC08_MRB_Code_Frame)

# processing 2d

HUC06_MRB_Code_2D = trunc(x = HUC06_MRB_Code_2D/1e4)
HUC06_MRB_Code_2D[HUC06_MRB_Code_2D != HUC06] = NA


# processing frame

HUC06_MRB_Code_Frame = HUC06_MRB_Code_Frame %>%
  rename(HUC06_Code_ID = HUC08_Code_ID) %>%
  mutate(HUC06_Code_ID = trunc(as.numeric(as.character(HUC06_Code_ID))/1e4)) %>% 
  filter(HUC06_Code_ID == HUC06)

min_lon = min(HUC06_MRB_Code_Frame$lon)
max_lon = max(HUC06_MRB_Code_Frame$lon)
  
min_lat = min(HUC06_MRB_Code_Frame$lat)
max_lat = max(HUC06_MRB_Code_Frame$lat)

longitude2 = as.numeric(rownames(HUC06_MRB_Code_2D))
latitude2  = as.numeric(colnames(HUC06_MRB_Code_2D))

min_i = which(longitude2 == min_lon) -1
max_i = which(longitude2 == max_lon) +1

min_j = which(latitude2 == min_lat)  -1
max_j = which(latitude2 == max_lat) + 1

nx = max_i - min_i + 1 
ny = max_j - min_j + 1

remove(latitude2)
remove(longitude2)
remove(min_lon)
remove(min_lat)
remove(max_lon)
remove(max_lat)







###############################################################
#
# extract the time series information.



  ens  = ensembles[1]
  var = "tasmax"
  agg = "CDO_MONTHLY_MEAN"


  # historical time information

  scen   = "historical"
  period = "1950-2005"
  
  variable = str_c(var,
                   ens,
                   scen,
                   sep = "_")
  
  
  URL_Name = str_c(URL_Root,
                   period,
                   "/MONTHLY/",
                   var,
                   "/LOCA_NGP_",
                   variable,
                   "_",
                   period,
                   "_",
                   agg,
                   ".nc",
                   sep = "")
  
  print(str_c("Cracking ",
              URL_Name))
  
  ncf = nc_open(filename = URL_Name)
  
    longitude        = ncvar_get(nc           = ncf, 
                                 varid        = "lon", 
                                 start        = min_i,
                                 count        = nx,
                                 verbose      = FALSE,
                                 raw_datavals = FALSE )
  
    latitude         = ncvar_get(nc           = ncf, 
                                 varid        = "lat", 
                                 start        = min_j,
                                 count        = ny,
                                 verbose      = FALSE,
                                 raw_datavals = FALSE )  
    
    longitude_bounds = ncvar_get(nc           = ncf, 
                                 varid        = "lon_bnds", 
                                 start        = c(1,min_i),
                                 count        = c(2,nx),
                                 verbose      = FALSE,
                                 raw_datavals = FALSE )
      
    
    latitude_bounds =  ncvar_get(nc           = ncf, 
                                 varid        = "lat_bnds", 
                                 start        = c(1,min_j),
                                 count        = c(2,ny),
                                 verbose      = FALSE,
                                 raw_datavals = FALSE )      
    
    time_hist  = ncvar_get(nc           = ncf, 
                                 varid        = "time", 
                                 verbose      = FALSE,
                                 raw_datavals = FALSE ) 
    
    tunits = ncatt_get(nc      = ncf,
                       varid   = "time",
                       attname = "units")
    
    tunits = str_split(string  = tunits$value, 
                       pattern = " ")
    
    tunits = str_c(unlist(tunits)[3],
                   unlist(tunits)[4],
                   sep = " ") 

    print(str_c("origin = ", tunits))
    
  nc_close(nc = ncf)
    
  remove(ncf)
  
  
  # Future time information

  scen   = "rcp85"
  period = "2006-2099"
  
  variable = str_c(var,
                   ens,
                   scen,
                   sep = "_")
  
  
  URL_Name = str_c(URL_Root,
                   period,
                   "/MONTHLY/",
                   var,
                   "/LOCA_NGP_",
                   variable,
                   "_",
                   period,
                   "_",
                   agg,
                   ".nc",
                   sep = "")
  

  print(str_c("Cracking ",
              URL_Name))
  
  
  ncf = nc_open(filename = URL_Name)
  
    time_futr  = ncvar_get(nc           = ncf, 
                           varid        = "time", 
                           verbose      = FALSE,
                           raw_datavals = FALSE ) 
    

        

    
    raster_test = ncvar_get(nc           = ncf, 
                          varid        = variable, 
                          start        = c(min_i,min_j,1),
                          count        = c(nx,ny,1),
                          verbose      = FALSE,
                          raw_datavals = FALSE )    
    
  remove(ncf)    
  
  date_hist = as.Date(x      = time_hist,
                      origin = tunits)
  
  date_futr = as.Date(x      = time_futr,
                      origin = tunits) 
  
  time = append(time_hist, time_futr)
  
  date =  as.Date(x      = time,
                  origin = tunits)
  
  t0h = 1
  t9h = length(time_hist)
  
  t0f = t9h + 1
  t9f = length(time)   
  
  print("Time Limits")
  print(time[t0h])
  print(time[t9h])
  print(time[t0f])
  print(time[t9f])
  

  if (plotme) { #plotme
  
  
      filled.contour(x          = longitude,
                     y          = latitude, 
                     z          = raster_test, 
                     asp        = 1,
                     plot.title = title(main = "Full Extracted Region",
                                        xlab = "Longitude",
                                        ylab = "Latitude"))
        
      
      filled.contour(x          = longitude,
                     y          = latitude, 
                     z          = raster_test * 
                                  HUC06_MRB_Code_2D[min_i:max_i,min_j:max_j]/
                                  HUC06_MRB_Code_2D[min_i:max_i,min_j:max_j], 
                     asp        = 1,
                     plot.title = title(main = "Isolated HUC",
                                        xlab = "Longitude",
                                        ylab = "Latitude"))


  } # plot 1

#
###############################################################

remove(raster_test)
remove(HUC06_MRB_Code_2D)
remove(HUC06_MRB_Code_Frame)

date_start = as.Date(sprintf("%04d-%02d-%02d 00:00:00 UTC",year(date),month(date),1))
date_end   = as.Date(sprintf("%04d-%02d-%02d 23:59:59 UTC",year(date),month(date),days_in_month(date)))
date       = as.Date(sprintf("%04d-%02d-%02d 12:00:00 UTC",year(date),month(date),15)  )


time = as.numeric(date) - as.numeric(as.Date("1900-01-01 00:00:00 UTC"))




time_bounds = array( NA,  
                     dim=c(2,length(date)), 
                     dimnames=list("bnds" = c("low","high"),
                                   "date" = time))
time_bounds[1,] = date_start - as.numeric(as.Date("1900-01-01 00:00:00 UTC"))
time_bounds[2,] = date_end - as.numeric(as.Date("1900-01-01 00:00:00 UTC"))



longitude_bounds = array( as.array(longitude_bounds),  
                     dim=c(2,nx), 
                     dimnames=list("bnds" = c("low","high"),
                                   "longitude" = longitude))


latitude_bounds = array( as.array(latitude_bounds),  
                     dim=c(2,ny), 
                     dimnames=list("bnds" = c("low","high"),
                                   "latitude" = latitude))



remove(time_futr)
remove(time_hist)
remove(date_start)
remove(date_end)
remove(tunits)
remove(agg)










###############################################################
#
# Pull Available Water Capacity



URL_Name = "http://kyrill.ias.sdsmt.edu:8080/thredds/dodsC/CLASS_Examples/NGP_US_AWC.nc"

  ncf = nc_open(filename = URL_Name)

  awc_map = ncvar_get(nc         = ncf,
                      varid        = "usda_awc",
                      verbose      = FALSE,
                      raw_datavals = FALSE,
                      start        = c(min_i,min_j),
                      count        = c(  nx,    ny)) 


  remove(ncf)    

  
  awc_map = array(data  = awc_map,
                  dim   = c(length(longitude),
                            length(latitude)),
                  dimnames = list(longitude = longitude,
                                  latitude  = latitude))
  if (plotme) { #plotme
  
  
  filled.contour(x          = longitude,
                 y          = latitude, 
                 z          = awc_map,
                 asp        = 1,
                 plot.title = title(main = "Available Soil Availability",
                                    xlab = "Longitude",
                                    ylab = "Latitude"))
    
  }
    
#
###############################################################









###############################################################
#
# Create Monthly Holding Variable





  a_var = array(data  = NA_real_,
                dim   = c(length(longitude),
                          length(latitude),
                          2,
                          length(time),
                          1),
                dimnames = list(longitude = longitude,
                                latitude  = latitude,
                                scenario  = c("Historical / RCP 4.5",
                                              "RCP 8.5"),
                                time      = time,
                                ensemble  = c("Ensemble")))

#
###############################################################




###############################################################
#
# Crunch By Ensemble



    temperature           = a_var
    precipitation         = a_var
    potential_evaporation = a_var
    evaporation           = a_var
    snowpack              = a_var
    storage               = a_var
    deficit               = a_var
    recharge              = a_var
    surplus               = a_var
    

  Ensemble = ensembles[1]




  # for (Ensemble in ensembles)
  { # Ensemble
    
    
    
    ens_m = which(ensembles == Ensemble)
    
    temperature[,,,,]           = NA
    precipitation[,,,,]         = NA
    potential_evaporation[,,,,] = NA
    evaporation[,,,,]           = NA
    snowpack[,,,,]              = NA
    storage[,,,,]               = NA
    deficit[,,,,]               = NA
    recharge[,,,,]              = NA
    surplus[,,,,]              = NA
    


    
    print(str_c("     "))
    print(str_c("   - Opening Files"))
    print(str_c("     "))
    
    { # Open Files for Reading
  
      { # Historical Period
        
        scen   = "historical"
        period = "1950-2005"
        
        { # pr hist
      
          var = "pr"
          agg = "CDO_MONTHLY_TOTAL"

          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   - ",variable))
        
          URL_Name = str_c(URL_Root,
                           period,
                           "/MONTHLY/",
                           var,
                           "/LOCA_NGP_",
                           variable,
                           "_",
                           period,
                           "_",
                           agg,
                           ".nc",
                           sep = "")
        
          nc_p0 = nc_open(filename = URL_Name)
          
        } # pr hist
        
        { # tasmin hist
      
          var = "tasmin"
          agg = "CDO_MONTHLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   - ",variable))
        
          URL_Name = str_c(URL_Root,
                           period,
                           "/MONTHLY/",
                           var,
                           "/LOCA_NGP_",
                           variable,
                           "_",
                           period,
                           "_",
                           agg,
                           ".nc",
                           sep = "")
        
          nc_n0 = nc_open(filename = URL_Name)
        
        } # tasmin hist
      
        { # tasmax hist
      
          var = "tasmax"
          agg = "CDO_MONTHLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   - ",variable))
        
          URL_Name = str_c(URL_Root,
                           period,
                           "/MONTHLY/",
                           var,
                           "/LOCA_NGP_",
                           variable,
                           "_",
                           period,
                           "_",
                           agg,
                           ".nc",
                           sep = "")
        
          nc_x0 = nc_open(filename = URL_Name)
        
        } # tasmax hist
      
      } # Historical Period
      
      { # RCP 4.5
    
        scen   = "rcp45"
        period = "2006-2099"
        
        { # pr rcp45
      
          var = "pr"
          agg = "CDO_MONTHLY_TOTAL"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   - ",variable))
        
          URL_Name = str_c(URL_Root,
                           period,
                           "/MONTHLY/",
                           var,
                           "/LOCA_NGP_",
                           variable,
                           "_",
                           period,
                           "_",
                           agg,
                           ".nc",
                           sep = "")
        
          nc_p4 = nc_open(filename = URL_Name)
          
        } # pr rcp45
        
        { # tasmin rcp45
      
          var = "tasmin"
          agg = "CDO_MONTHLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   - ",variable))
        
          URL_Name = str_c(URL_Root,
                           period,
                           "/MONTHLY/",
                           var,
                           "/LOCA_NGP_",
                           variable,
                           "_",
                           period,
                           "_",
                           agg,
                           ".nc",
                           sep = "")
        
          nc_n4 = nc_open(filename = URL_Name)

        } # tasmin rcp45
      
        { # tasmax rcp45
      
          var = "tasmax"
          agg = "CDO_MONTHLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   - ",variable))
        
          URL_Name = str_c(URL_Root,
                           period,
                           "/MONTHLY/",
                           var,
                           "/LOCA_NGP_",
                           variable,
                           "_",
                           period,
                           "_",
                           agg,
                           ".nc",
                           sep = "")
        
          nc_x4 = nc_open(filename = URL_Name)

        } # tasmax rcp45
      
      } # RCP 4.5
    
      { # RCP 8.5
        
        scen   = "rcp85"
        period = "2006-2099"
        
        { # pr rcp85
      
          var = "pr"
          agg = "CDO_MONTHLY_TOTAL"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   - ",variable))
        
          URL_Name = str_c(URL_Root,
                           period,
                           "/MONTHLY/",
                           var,
                           "/LOCA_NGP_",
                           variable,
                           "_",
                           period,
                           "_",
                           agg,
                           ".nc",
                           sep = "")
        
          nc_p8 = nc_open(filename = URL_Name)
          
        } # pr rcp85
        
        { # tasmin rcp85
      
          var = "tasmin"
          agg = "CDO_MONTHLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   - ",variable))
        
          URL_Name = str_c(URL_Root,
                           period,
                           "/MONTHLY/",
                           var,
                           "/LOCA_NGP_",
                           variable,
                           "_",
                           period,
                           "_",
                           agg,
                           ".nc",
                           sep = "")
        
          nc_n8 = nc_open(filename = URL_Name)

        } # tasmin rcp85
      
        { # tasmax rcp85
      
          var = "tasmax"
          agg = "CDO_MONTHLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   - ",variable))
        
          URL_Name = str_c(URL_Root,
                           period,
                           "/MONTHLY/",
                           var,
                           "/LOCA_NGP_",
                           variable,
                           "_",
                           period,
                           "_",
                           agg,
                           ".nc",
                           sep = "")
        
          nc_x8 = nc_open(filename = URL_Name)

        } # tasmax rcp85
      
      } # RCP 8.5
      
    } # Open Files for Reading   
    
    print(str_c("     "))
    print(str_c("   - Spatially Marching Through Data"))
    print(str_c("     "))

    
    { # Spatially Through Map
      
      #Longitude = longitude[1]
      
      for (Longitude in longitude[1:3])
      { # longitude
        lon_i    = which(longitude == Longitude)

        
        
        #Latitude = latitude[1]
        
        for (Latitude in latitude[1:3])
        { # latitude
          lat_j    = which(latitude == Latitude)
          
          print(str_c(Ensemble,
                      Longitude,
                      Latitude,
                      sep = " "))
             
          { # Historical Data Pull 
      
            scen   = "historical"
            period = "1950-2005"
      
              { # pr hist
    
                var = "pr"

                variable = str_c(var,
                                 ens,
                                 scen,
                                 sep = "_")
                
                pr_0 = ncvar_get(nc           = nc_p0,
                                 varid        = variable,
                                 verbose      = FALSE,
                                 raw_datavals = FALSE,
                                 start        = c(lon_i,lat_j,  1),
                                 count        = c(   1,     1, -1))
  
                
              } # pr hist
      
              { # tasmin hist
            
                var = "tasmin"
                agg = "CDO_MONTHLY_MEAN"
                
                variable = str_c(var,
                                 ens,
                                 scen,
                                 sep = "_")
                
                tmin_0 = ncvar_get(nc           = nc_n0,
                                   varid        = variable,
                                   verbose      = FALSE,
                                   raw_datavals = FALSE,
                                   start        = c(lon_i,lat_j,  1),
                                   count        = c(   1,     1, -1)) 
  
              } # tasmin hist
    
              { # tasmax hist
            
                var = "tasmax"
                agg = "CDO_MONTHLY_MEAN"
                
                variable = str_c(var,
                                 ens,
                                 scen,
                                 sep = "_")
                
                tmax_0 = ncvar_get(nc           = nc_x0,
                                   varid        = variable,
                                   verbose      = FALSE,
                                   raw_datavals = FALSE,
                                   start        = c(lon_i,lat_j,  1),
                                   count        = c(   1,     1, -1))
                
              } # tasmax hist
            
              hist =     tibble(time  = date_hist,
                                year  = year(date_hist),
                                month = month(date_hist),
                                P     = pr_0,
                                Tn    = tmin_0,
                                Tx    = tmax_0,
                                Tm    = (tmin_0+tmax_0)/2)

              remove(pr_0, tmin_0, tmax_0)
              
          } # Historical Data Pull 
          
          { # RCP 4.5 Data Pull      
      
            scen   = "rcp45"
            period = "2006-2099"
      
              { # pr rcp45
    
                var = "pr"

                variable = str_c(var,
                                 ens,
                                 scen,
                                 sep = "_")
                
                pr_4 = ncvar_get(nc           = nc_p4,
                                 varid        = variable,
                                 verbose      = FALSE,
                                 raw_datavals = FALSE,
                                 start        = c(lon_i,lat_j,  1),
                                 count        = c(   1,     1, -1))
  
                
              } # pr rcp45
      
              { # tasmin rcp45
            
                var = "tasmin"
                agg = "CDO_MONTHLY_MEAN"
                
                variable = str_c(var,
                                 ens,
                                 scen,
                                 sep = "_")
                
                tmin_4 = ncvar_get(nc           = nc_n4,
                                   varid        = variable,
                                   verbose      = FALSE,
                                   raw_datavals = FALSE,
                                   start        = c(lon_i,lat_j,  1),
                                   count        = c(   1,     1, -1))  
  
              } # tasmin rcp45
    
              { # tasmax rcp45
            
                var = "tasmax"
                agg = "CDO_MONTHLY_MEAN"
                
                variable = str_c(var,
                                 ens,
                                 scen,
                                 sep = "_")
                
                tmax_4 = ncvar_get(nc           = nc_x4,
                                   varid        = variable,
                                   verbose      = FALSE,
                                   raw_datavals = FALSE,
                                   start        = c(lon_i,lat_j,  1),
                                   count        = c(   1,     1, -1))
                
              } # tasmax rcp45
            
              rcp45 =     tibble(time  = date_futr,
                                 year  = year(date_futr),
                                 month = month(date_futr),
                                 P     = pr_4,
                                 Tn    = tmin_4,
                                 Tx    = tmax_4,
                                 Tm    = (tmin_4+tmax_4)/2)
              
              remove(pr_4, tmin_4, tmax_4)
              
          } # RCP 4.5 Data Pull           
          
          { # RCP 8.5 Data Pull      
      
            scen   = "rcp85"
            period = "2006-2099"
      
              { # pr rcp85
    
                var = "pr"

                variable = str_c(var,
                                 ens,
                                 scen,
                                 sep = "_")
                
                pr_8 = ncvar_get(nc           = nc_p8,
                                 varid        = variable,
                                 verbose      = FALSE,
                                 raw_datavals = FALSE,
                                 start        = c(lon_i,lat_j,  1),
                                 count        = c(   1,     1, -1))
  
                
              } # pr rcp85
      
              { # tasmin rcp85
            
                var = "tasmin"
                agg = "CDO_MONTHLY_MEAN"
                
                variable = str_c(var,
                                 ens,
                                 scen,
                                 sep = "_")
                
                tmin_8 = ncvar_get(nc           = nc_n8,
                                   varid        = variable,
                                   verbose      = FALSE,
                                   raw_datavals = FALSE,
                                   start        = c(lon_i,lat_j,  1),
                                   count        = c(   1,     1, -1))  
  
              } # tasmin rcp85
    
              { # tasmax rcp85
            
                var = "tasmax"
                agg = "CDO_MONTHLY_MEAN"
                
                variable = str_c(var,
                                 ens,
                                 scen,
                                 sep = "_")
                
                tmax_8 = ncvar_get(nc           = nc_x8,
                                   varid        = variable,
                                   verbose      = FALSE,
                                   raw_datavals = FALSE,
                                   start        = c(lon_i,lat_j,  1),
                                   count        = c(   1,     1, -1))
                
              } # tasmax rcp85
            
              rcp85 =     tibble(time  = date_futr,
                                 year  = year(date_futr),
                                 month = month(date_futr),
                                 P     = pr_8,
                                 Tn    = tmin_8,
                                 Tx    = tmax_8,
                                 Tm    = (tmin_8+tmax_8)/2)
              
              remove(pr_8, tmin_8, tmax_8)   
              
          } # RCP 8.5 Data Pull  
        
        
          { # Calculate Water Budgtet
            
            { # RCP45 + Hist
              
              scen_k = 1
              
              time_series_45 = rbind(hist, rcp45)
              
              thornthwaite_45 = thornthwaite(series          = time_series_45, 
                                             latitude        = Latitude, 
                                             clim_norm       = NULL, 
                                             first.yr        = 1950, 
                                             last.yr         = 2099, 
                                             snow.init       = initial_snow_cover, 
                                             Tsnow           = -1, 
                                             TAW             = awc_map[lon_i,lat_j], 
                                             fr.sn.acc       = 0.95, 
                                             snow_melt_coeff = 1)
              
              

            } # RCP45 + Hist
            
            { # RCP85 + Hist
              
              scen_k = 2
              
              time_series_85 = rbind(hist, rcp85)
              
              thornthwaite_85 = thornthwaite(series          = time_series_85, 
                                             latitude        = Latitude, 
                                             clim_norm       = NULL, 
                                             first.yr        = 1950, 
                                             last.yr         = 2099, 
                                             snow.init       = initial_snow_cover, 
                                             Tsnow           = -1, 
                                             TAW             = awc_map[lon_i,lat_j], 
                                             fr.sn.acc       = 0.95, 
                                             snow_melt_coeff = 1)              
            } # RCP85 + Hist
            
            
                        
            { #  RCP 45 Load Thorntwaite Direct Water Budget Fields into their Variables  
              scen_k = 1
              
              temperature[          lon_i,lat_j,scen_k,,1] = time_series_45$Tm
              precipitation[        lon_i,lat_j,scen_k,,1] = time_series_45$P
              potential_evaporation[lon_i,lat_j,scen_k,,1] = as.vector(as.matrix(thornthwaite_45$W_balance$Et0))
              storage[              lon_i,lat_j,scen_k,,1] = as.vector(as.matrix(thornthwaite_45$W_balance$Storage))
              deficit[              lon_i,lat_j,scen_k,,1] = as.vector(as.matrix(thornthwaite_45$W_balance$Deficit))
              surplus[              lon_i,lat_j,scen_k,,1] = as.vector(as.matrix(thornthwaite_45$W_balance$Surplus))
              
            } # RCP 45 Load Thorntwaite Direct Water Budget Fields into their Variables  
            
            { #  RCP 85 Load Thorntwaite Direct Water Budget Fields into their Variables  
               scen_k = 2

              temperature[          lon_i,lat_j,scen_k,,1] = time_series_85$Tm
              precipitation[        lon_i,lat_j,scen_k,,1] = time_series_85$P
              potential_evaporation[lon_i,lat_j,scen_k,,1] = as.vector(as.matrix(thornthwaite_85$W_balance$Et0))
              storage[              lon_i,lat_j,scen_k,,1] = as.vector(as.matrix(thornthwaite_85$W_balance$Storage))
              deficit[              lon_i,lat_j,scen_k,,1] = as.vector(as.matrix(thornthwaite_85$W_balance$Deficit))
              surplus[              lon_i,lat_j,scen_k,,1] = as.vector(as.matrix(thornthwaite_85$W_balance$Surplus))
              
            } # RCP 85 Load Thorntwaite Direct Water Budget Fields into their Variables  
            
          } # Calculate Water Budgtet
          
          { # Load Thorntwaite Direct Water Budget Fields into their Variables
            
            evaporation = potential_evaporation - deficit
          
            recharge[,,, (2:t9f) ,] = storage[,,, (2:t9f) ,] - storage[,,, (1:(t9f-1)) ,]
            
            recharge[recharge<0] = 0
            
            snowpack = precipitation - evaporation - recharge - surplus
            
            snowpack[recharge<0] = 0
          
          } # Load Thorntwaite Direct Water Budget Fields into their Variables

            
                    
        } # latitude
        
        
      } # longitude
      
      
    } # Calculate Climate Classification
    
    
    nc_close(nc = nc_p0)  
    nc_close(nc = nc_n0)  
    nc_close(nc = nc_x0)  

    nc_close(nc = nc_p4)  
    nc_close(nc = nc_n4)  
    nc_close(nc = nc_x4)  
    
    nc_close(nc = nc_p8) 
    nc_close(nc = nc_n8) 
    nc_close(nc = nc_x8)  
    
    remove(nc_p0, nc_n0, nc_x0)
    remove(nc_p4, nc_n4, nc_x4)
    remove(nc_p8, nc_n8, nc_x8)
    
      

    
    
    
    
    {  # OUTPUT NETCDF FILE.
      
      ###############################################
      ###############################################
      ###############################################
      ###############################################
      ###############################################
      ###############################################
      ##
      ##  NetCDF File Creation
      ##
      ###############################################
      ###############################################
      ###############################################
      ###############################################
      ###############################################
      ###############################################
      
      fill_value_short = -32767
      fill_value_float = 9.96921e+36
      fill_value_dble  = 9.969209968386869e+36
      
      
        netcdf_output_file_name = paste("./LOCAL_CHEYENNE_THORTHWAITE_",
                                  Ensemble,
                                  ".nc",
                                  sep="")
        
        #### Dimensions
        
      
        netcdf_ens_dim   = ncdim_def(name    = "ensemble",
                                     units   = "",
                                     val     = 1:1,
                                     unlim   = FALSE,
                                     create_dimvar = FALSE)
        
        netcdf_time_dim  = ncdim_def(name    = "time",
                                     units   = "days since 1900-01-01 00:00:00",
                                     val     = time,
                                     unlim   = FALSE,
                                     calendar="standard")     
        
        netcdf_scen_dim  = ncdim_def(name    = "scenario",
                                     units   = "",
                                     val     = 1:2,
                                     unlim   = FALSE,
                                     create_dimvar = FALSE)


        
        netcdf_lon_dim     = ncdim_def(name  = "lon",
                                       units = "degrees_east",
                                       val   = longitude,
                                       unlim = FALSE)

        netcdf_lat_dim     = ncdim_def(name  = "lat",
                                       units = "degrees_north",
                                       val   = latitude,
                                       unlim = FALSE)
        
        netcdf_bounds_dim  = ncdim_def(name  = "bnds",
                                       units = "",
                                       val   = 1:2,
                                       unlim = FALSE,
                                       create_dimvar = FALSE)
        
        netcdf_enschar_dim  = ncdim_def(name          = "ensemble_member_characters",
                                        units         = "",
                                        val           =  1:max(nchar(ensembles)),
                                        create_dimvar = FALSE)
        
        netcdf_scenchar_dim = ncdim_def(name          = "scenario_characters",
                                        units         = "",
                                        val           =  1:max(nchar("HIST_RCP45")),
                                        create_dimvar = FALSE)
        
        #### End Dimensions
       
        #
        # coordinate bounding variables
        #
        
        netcdf_time_bounds   = ncvar_def(nam      = "time_bnds",
                                         units    = "days since 1900-01-01 00:00:00",
                                         dim      = list(netcdf_bounds_dim,
                                                         netcdf_time_dim),
                                         missval  = fill_value_float,
                                         longname = "Time Bounds",
                                         prec     = "single")
        
        netcdf_lon_bounds   = ncvar_def(nam      = "lon_bnds",
                                        units    = "degrees_east",
                                        dim      = list(netcdf_bounds_dim,
                                                        netcdf_lon_dim),
                                        missval  = fill_value_float,
                                        longname = "Longitude Bounds",
                                        prec     = "single")
        
        netcdf_lat_bounds   = ncvar_def(nam      = "lat_bnds",
                                        units    = "degrees_north",
                                        dim      = list(netcdf_bounds_dim,
                                                        netcdf_lat_dim),
                                        missval  = fill_value_float,
                                        longname = "Latitude Bounds",
                                        prec     = "single")    
        
        netcdf_ensemble = ncvar_def(nam      = "ensemble",
                                    units    = "",
                                    dim      = list(netcdf_enschar_dim,
                                                    netcdf_ens_dim),
                                    longname = "Ensemble Member",
                                    prec     = "char")

        netcdf_scenario = ncvar_def(nam      = "scenario",
                                    units    = "",
                                    dim      = list(netcdf_scenchar_dim,
                                                    netcdf_scen_dim),
                                    longname = "Scenario",
                                    prec     = "char")                      

        print("Miscelaneous Coordinates Created")

        #
        # variables
        #  
        
        netcdf_temperature = ncvar_def(nam      = "mean_temperature",
                                       units    = "degC",
                                       dim      = list(netcdf_lon_dim,
                                                       netcdf_lat_dim,
                                                       netcdf_scen_dim,
                                                       netcdf_time_dim,
                                                       netcdf_ens_dim),
                                       missval  = fill_value_short,
                                       longname = "Mean Monthly Temperature",
                                       prec     = "short")        

        netcdf_precip      = ncvar_def(nam      = "total_precipitation",
                                       units    = "kg m-2",
                                       dim      = list(netcdf_lon_dim,
                                                       netcdf_lat_dim,
                                                       netcdf_scen_dim,
                                                       netcdf_time_dim,
                                                       netcdf_ens_dim),
                                       missval  = fill_value_short,
                                       longname = "Total Monthly Precipitation",
                                       prec     = "short")        
          
        netcdf_pot_evap    = ncvar_def(nam      = "potential_evapotranspiration",
                                       units    = "kg m-2",
                                       dim      = list(netcdf_lon_dim,
                                                       netcdf_lat_dim,
                                                       netcdf_scen_dim,
                                                       netcdf_time_dim,
                                                       netcdf_ens_dim),
                                       missval  = fill_value_short,
                                       longname = "Total Monthly Potential Evapotranspiration",
                                       prec     = "short")         
        
        netcdf_evap        = ncvar_def(nam      = "evapotranspiration",
                                       units    = "kg m-2",
                                       dim      = list(netcdf_lon_dim,
                                                       netcdf_lat_dim,
                                                       netcdf_scen_dim,
                                                       netcdf_time_dim,
                                                       netcdf_ens_dim),
                                       missval  = fill_value_short,
                                       longname = "Total Monthly Evapotranspiration",
                                       prec     = "short")          
        
        netcdf_storage     = ncvar_def(nam      = "storage",
                                       units    = "kg m-2",
                                       dim      = list(netcdf_lon_dim,
                                                       netcdf_lat_dim,
                                                       netcdf_scen_dim,
                                                       netcdf_time_dim,
                                                       netcdf_ens_dim),
                                       missval  = fill_value_short,
                                       longname = "Mean Monthly Storage",
                                       prec     = "short") 
        
        netcdf_snowpack    = ncvar_def(nam      = "snowpack",
                                       units    = "kg m-2",
                                       dim      = list(netcdf_lon_dim,
                                                       netcdf_lat_dim,
                                                       netcdf_scen_dim,
                                                       netcdf_time_dim,
                                                       netcdf_ens_dim),
                                       missval  = fill_value_short,
                                       longname = "Total Monthly Snowpack",
                                       prec     = "short") 
        
        netcdf_deficit     = ncvar_def(nam      = "deficit",
                                       units    = "kg m-2",
                                       dim      = list(netcdf_lon_dim,
                                                       netcdf_lat_dim,
                                                       netcdf_scen_dim,
                                                       netcdf_time_dim,
                                                       netcdf_ens_dim),
                                       missval  = fill_value_short,
                                       longname = "Total Monthly Deficit",
                                       prec     = "short") 
        
        netcdf_recharge    = ncvar_def(nam      = "recharge",
                                       units    = "kg m-2",
                                       dim      = list(netcdf_lon_dim,
                                                       netcdf_lat_dim,
                                                       netcdf_scen_dim,
                                                       netcdf_time_dim,
                                                       netcdf_ens_dim),
                                       missval  = fill_value_short,
                                       longname = "Total Monthly Recharge",
                                       prec     = "short")         
        
         netcdf_surplus    = ncvar_def(nam      = "surplus",
                                       units    = "kg m-2",
                                       dim      = list(netcdf_lon_dim,
                                                       netcdf_lat_dim,
                                                       netcdf_scen_dim,
                                                       netcdf_time_dim,
                                                       netcdf_ens_dim),
                                       missval  = fill_value_short,
                                       longname = "Total Monthly Surplus",
                                       prec     = "short")      
         
        # Create the File
        
        nc_bud = nc_create(filename = netcdf_output_file_name,
                            vars     = list(netcdf_ensemble,
                                            netcdf_time_bounds,
                                            netcdf_scenario,
                                            netcdf_lon_bounds,
                                            netcdf_lat_bounds,
                                            netcdf_temperature,
                                            netcdf_precip,
                                            netcdf_pot_evap,
                                            netcdf_evap,
                                            netcdf_storage,
                                            netcdf_snowpack,
                                            netcdf_deficit,
                                            netcdf_recharge,
                                            netcdf_surplus))

        ##############
        #
        # Coordinate Attributes
        #    
        ##############   
        
        #
        # Time
        #
        
        ncatt_put(nc         = nc_bud,
                  varid      = "time",
                  attname    = "standard_name",
                  attval     = "time",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )
        
        ncatt_put(nc         = nc_bud,
                  varid      = "time",
                  attname    = "bounds",
                  attval     = "time_bnds",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )   
        
        ncatt_put(nc         = nc_bud,
                  varid      = "time",
                  attname    = "calendar",
                  attval     = "standard",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )
        
        #
        # Time Bounds
        #
        
        ncatt_put(nc         = nc_bud,
                  varid      = "time_bnds",
                  attname    = "standard_name",
                  attval     = "time",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )
        
        ncatt_put(nc         = nc_bud,
                  varid      = "time_bnds",
                  attname    = "long_name",
                  attval     = "Period Bounds",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )
        
        ncatt_put(nc         = nc_bud,
                  varid      = "time",
                  attname    = "bounds",
                  attval     = "time_bnds",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )       
        
        ncatt_put(nc         = nc_bud,
                  varid      = "time",
                  attname    = "axis",
                  attval     = "T",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )

        #
        # Lontitude
        #
        
        ncatt_put(nc         = nc_bud,
                  varid      = "lon",
                  attname    = "standard_name",
                  attval     = "longitude",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )
        
        ncatt_put(nc         = nc_bud,
                  varid      = "lon",
                  attname    = "axis",
                  attval     = "X",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )
        
        ncatt_put(nc         = nc_bud,
                  varid      = "lon",
                  attname    = "long_name",
                  attval     = "Longtidue",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )      
        
        ncatt_put(nc         = nc_bud,
                  varid      = "lon",
                  attname    = "bounds",
                  attval     = "lon_bnds",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )      
        #
        # Latitude
        #
        
        ncatt_put(nc         = nc_bud,
                  varid      = "lat",
                  attname    = "standard_name",
                  attval     = "latitude",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )
        
        ncatt_put(nc         = nc_bud,
                  varid      = "lat",
                  attname    = "axis",
                  attval     = "Y",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )
        
        ncatt_put(nc         = nc_bud,
                  varid      = "lat",
                  attname    = "long_name",
                  attval     = "Latitude",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )
        
        ncatt_put(nc         = nc_bud,
                  varid      = "lat",
                  attname    = "bounds",
                  attval     = "lat_bnds",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )         

        ##############
        #
        # Variable Attributes
        #    
        ##############           
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_temperature,
                  attname    = "description",
                  attval     = "Mean Monthly Temperature",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )        
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_precip,
                  attname    = "description",
                  attval     = "Total Monthly Precipitation",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE ) 
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_pot_evap         ,
                  attname    = "description",
                  attval     = "Total Monthly Potential Evapotranspiration",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )    
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_evap,
                  attname    = "description",
                  attval     = "Total Monthly Evapotranspiration",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )     
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_storage,
                  attname    = "description",
                  attval     = "Mean Monthly Storage",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )       
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_deficit,
                  attname    = "description",
                  attval     = "Mean Monthly Deficit",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )       
        
                
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_snowpack,
                  attname    = "description",
                  attval     = "Mean Monthly Snowpack",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )       
                
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_recharge,
                  attname    = "description",
                  attval     = "Mean Monthly Recharge",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )       
        
                
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_surplus,
                  attname    = "description",
                  attval     = "Mean Monthly Surplus",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )       
                
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_temperature,
                  attname    = "standard_name",
                  attval     = "air_temperature",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )        
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_precip,
                  attname    = "description",
                  attval     = "precipitation_amount",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE ) 
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_pot_evap         ,
                  attname    = "standard_name",
                  attval     = "water_potential_evaporation_amount",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )    
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_evap,
                  attname    = "standard_name",
                  attval     = "water_evaporation_amount",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )     
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_storage,
                  attname    = "standard_name",
                  attval     = "mass_content_of_water_in_soil",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )       
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_deficit,
                  attname    = "standard_name",
                  attval     = "Mean Monthly Deficit",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )       
        
                
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_snowpack,
                  attname    = "standard_name",
                  attval     = "liquid_water_content_of_surface_snow",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )       
              
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_surplus,
                  attname    = "standard_name",
                  attval     = "runoff_amount",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )     
        
                
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_temperature,
                  attname    = "add_offset",
                  attval     = 0.0,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )       
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_precip,
                  attname    = "add_offset",
                  attval     = 0.0,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_pot_evap         ,
                  attname    = "add_offset",
                  attval     = 0.0,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE ) 
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_evap,
                  attname    = "add_offset",
                  attval     = 0.0,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )    
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_storage,
                  attname    = "add_offset",
                  attval     = 0.0,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_deficit,
                  attname    = "add_offset",
                  attval     = 0.0,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )   
        
                
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_snowpack,
                  attname    = "add_offset",
                  attval     = "Mean Monthly Snowpack",
                  prec       = NA,
                  verbose    = FALSE,
                  definemode = FALSE )       
                
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_recharge,
                  attname    = "add_offset",
                  attval     = 0.0,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )      
        
                
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_surplus,
                  attname    = "add_offset",
                  attval     = 0.0,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )       
        
                 
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_temperature,
                  attname    = "scale_factor",
                  attval     = 0.01,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )       
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_precip,
                  attname    = "scale_factor",
                  attval     = 0.01,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )   
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_pot_evap         ,
                  attname    = "scale_factor",
                  attval     = 0.01,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )   
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_evap,
                  attname    = "scale_factor",
                  attval     = 0.01,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )     
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_storage,
                  attname    = "scale_factor",
                  attval     = 0.01,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )   
        
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_deficit,
                  attname    = "scale_factor",
                  attval     = 0.01,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )    
        
                
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_snowpack,
                  attname    = "scale_factor",
                  attval     = 0.01,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )       
                
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_recharge,
                  attname    = "scale_factor",
                  attval     = 0.01,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )      
        
                
        ncatt_put(nc         = nc_bud,
                  varid      = netcdf_surplus,
                  attname    = "scale_factor",
                  attval     = 0.01,
                  prec       = "single",
                  verbose    = FALSE,
                  definemode = FALSE )             
        
        
 
        ##############
        #
        # Drop Variables
        #    
        ##############
  
  
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_time_bounds,
                  vals    = time_bounds,
                  verbose = FALSE )
  
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_lon_bounds,
                  vals    = longitude_bounds,
                  verbose = FALSE )
  
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_lat_bounds,
                  vals    = latitude_bounds,
                  verbose = FALSE )
  
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_ensemble,
                  vals    =  c(Ensemble),
                  verbose = FALSE )
        
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_scenario,
                  vals    = c("HIST_RCP45","RCP85"),
                  verbose = FALSE )
        
        
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_temperature,
                  vals    = round(x = temperature * 0.1, digits=0),
                  verbose = FALSE )
        
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_precip,
                  vals    = round(x = precipitation * 10, digits=0),
                  verbose = FALSE )
        
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_pot_evap,
                  vals    = round(x = potential_evaporation * 10, digits=0),
                  verbose = FALSE )
        
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_evap,
                  vals    = round(x = evaporation * 10, digits=0),
                  verbose = FALSE )       
        
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_storage,
                  vals    = round(x = storage * 10, digits=0),
                  verbose = FALSE )           

        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_snowpack,
                  vals    = round(x = snowpack * 10, digits=0),
                  verbose = FALSE )         
        
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_deficit,
                  vals    = round(x = deficit * 10, digits=0),
                  verbose = FALSE )        
        
                
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_recharge,
                  vals    = round(x = recharge * 10, digits=0),
                  verbose = FALSE )   
                  
        ncvar_put(nc      = nc_bud,
                  varid   = netcdf_surplus,
                  vals    = round(x = surplus * 10, digits=0),
                  verbose = FALSE )     
                
        nc_close(nc_bud)
        
      
      
    }  # OUTPUT NETCDF FILE.
      
  } # Ensemble
  

#
###############################################################

