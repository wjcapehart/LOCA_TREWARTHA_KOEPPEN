

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

  library(package = "ncdf4")
  library(package = "ncdf4.helpers")
  
  library(package = "PCICt")

  library(package = "ClimClass")

  library(package = "foreach")
  library(package = "doParallel")
  library(package = "parallel")

#
###############################################################
  


###############################################################
#
# File Control

 URL_Root = "http://kyrill.ias.sdsmt.edu:8080/thredds/dodsC/LOCA_NGP/climatology/"
 URL_Root = "/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/climatology/"
 OUT_ROOT = "/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/climatology/DERIVED/YEARLY/KOEPPEN/"

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
  



###############################################################
#
# extract the time series information.



  ens  = ensembles[1]
  var = "pr"
  agg = "CDO_MONTLY_TOTAL"


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
  
  
  ncf = nc_open(filename = URL_Name)
  
    longitude        = ncvar_get(nc           = ncf, 
                                 varid        = "lon", 
                                 verbose      = FALSE,
                                 raw_datavals = FALSE )
  
    latitude         = ncvar_get(nc           = ncf, 
                                 varid        = "lat", 
                                 verbose      = FALSE,
                                 raw_datavals = FALSE )  
    
    longitude_bounds = ncvar_get(nc           = ncf, 
                                 varid        = "lon_bnds", 
                                 verbose      = FALSE,
                                 raw_datavals = FALSE )
      
    
    latitude_bounds =  ncvar_get(nc           = ncf, 
                                 varid        = "lat_bnds", 
                                 verbose      = FALSE,
                                 raw_datavals = FALSE )      
    
    time_hist  = nc.get.time.series(f                            = ncf, 
                                         v                            = variable, 
                                         time.dim.name                = "time", 
                                         correct.for.gregorian.julian = FALSE, 
                                         return.bounds                = FALSE)
    
    time_hist = as.POSIXct(x  = time_hist,
                                tz = "UTC")
    
  remove(ncf)
  
  
  # historical time information

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
  
  
  ncf = nc_open(filename = URL_Name)
  
    time_futr = nc.get.time.series(f                            = ncf, 
                                   v                            = variable, 
                                   time.dim.name                = "time", 
                                   correct.for.gregorian.julian = FALSE, 
                                   return.bounds                = FALSE)
    
    time_futr = as.POSIXct(x  = time_futr, 
                           tz = "UTC")
    
  remove(ncf)    
  
  time = append(x      = time_hist,
                values = time_futr)
  
  t0h = 1
  t9h = length(time_hist)
  
  t0f = t9h + 1
  t9f = length(time)   
  
  print("Time Limits")
  print(time[t0h])
  print(time[t9h])
  print(time[t0f])
  print(time[t0f])

#
###############################################################
  


###############################################################
#
# Select Point Extraction


  target_lon =  -101.5988405
  target_lat =    44.0487306
  
    target_lon =  -100.3538
  target_lat =    44.3668
  
  i_targ = which(abs(longitude - target_lon) == min(abs(longitude - target_lon)))
  j_targ = which(abs(latitude  - target_lat) == min(abs(latitude  - target_lat)))

#
###############################################################
  


###############################################################
#
# Create Annual Holding Variable

  hist_year = seq(from = 1950,
                  to   = 2005)

  h_var = array(data  = NA,
                dim   = c(length(longitude),
                          length(latitude),
                          length(hist_year),
                          length(ensembles)),
                dimnames = list(longitude = longitude,
                                latitude  = latitude,
                                year      = hist_year,
                                ensemble  = ensembles))
  h_var = array(data  = NA,
                dim   = c(length(longitude),
                          length(latitude),
                          length(hist_year)),
                dimnames = list(longitude = longitude,
                                latitude  = latitude,
                                year      = hist_year))
  
  futr_year = seq(from = 2006,
                  to   = 2099)

  f_var = array(data = NA,
                dim   = c(length(longitude),
                          length(latitude),
                          length(futr_year),
                          length(ensembles)),
                dimnames = list(longitude = longitude,
                                latitude  = latitude,
                                year      = futr_year,
                                ensemble  = ensembles))

  
  f_var = array(data = NA,
                dim   = c(length(longitude),
                          length(latitude),
                          length(futr_year)),
                dimnames = list(longitude = longitude,
                                latitude  = latitude,
                                year      = futr_year))
  
#
###############################################################

  
  
  
###############################################################
#
# Crunch By Ensemble

  for (Ensemble in ensembles)
  { # Ensemble
    
    ens_m = which(ensembles == Ensemble)
    
    koeppen_histo = h_var
    koeppen_rcp45 = f_var
    koeppen_rcp85 = f_var
    
    print(str_c("     "))
    print(str_c("   - Opening Files"))
    print(str_c("     "))
    
    { # Open Files for Reading
  
      { # Historical Period
        
        scen   = "historical"
        period = "1950-2005"
        
        { # pr hist
      
          var = "pr"
          agg = "CDO_MONTLY_TOTAL"

          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   -- Opening ",variable))
        
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
          agg = "CDO_MONTLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   -- Opening ",variable))
        
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
          agg = "CDO_MONTLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   -- Opening ",variable))
        
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
          agg = "CDO_MONTLY_TOTAL"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   -- Opening ",variable))
        
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
          agg = "CDO_MONTLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   -- Opening ",variable))
        
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
          agg = "CDO_MONTLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   -- Opening ",variable))
        
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
          agg = "CDO_MONTLY_TOTAL"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   -- Opening ",variable))
        
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
          agg = "CDO_MONTLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   -- Opening ",variable))
        
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
          agg = "CDO_MONTLY_MEAN"
          
          variable = str_c(var,
                           ens,
                           scen,
                           sep = "_")
          
          print(str_c("   -- Opening ",variable))
        
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
    print(str_c("   - Marching Through Data ", Ensemble))
    print(str_c("     "))

    
    { # Calculate Climate Classification
      
      
      for (Longitude in longitude)
      { # longitude
        lon_i    = which(longitude == Longitude)
      
        
        { # Historical Period
          
          scen   = "historical"
          period = "1950-2005"
          
          
          
          { # pr hist
            
            var = "pr"
            
            variable = str_c(var,
                             ens,
                             scen,
                             sep = "_")
            
            print(str_c("   -- Reading ", variable, " ", Longitude))
            
            
            pr_0 = ncvar_get(nc           = nc_p0,
                             varid        = variable,
                             verbose      = FALSE,
                             raw_datavals = FALSE,
                             start        = c(lon_i,    1,  1),
                             count        = c(   1,    -1, -1))
            
            
          } # pr hist
          
          { # tasmin hist
            
            var = "tasmin"
            agg = "CDO_MONTLY_MEAN"
            
            variable = str_c(var,
                             ens,
                             scen,
                             sep = "_")
            
            print(str_c("   -- Reading ", variable, " ", Longitude))
            
            tmin_0 = ncvar_get(nc           = nc_n0,
                               varid        = variable,
                               verbose      = FALSE,
                               raw_datavals = FALSE,
                               start        = c(lon_i,    1,  1),
                               count        = c(    1,   -1, -1)) 
            
          } # tasmin hist
          
          { # tasmax hist
            
            var = "tasmax"
            agg = "CDO_MONTLY_MEAN"
            
            variable = str_c(var,
                             ens,
                             scen,
                             sep = "_")
            
            print(str_c("   -- Reading ", variable, " ", Longitude))
            
            tmax_0 = ncvar_get(nc           = nc_x0,
                               varid        = variable,
                               verbose      = FALSE,
                               raw_datavals = FALSE,
                               start        = c(lon_i,    1,  1),
                               count        = c(    1,   -1, -1)) 
            
          } # tasmax hist
          

          

        } # Historical Period
        
        { # RCP 4.5 Period     
          
          scen   = "rcp45"
          period = "2006-2099"
          
          { # pr rcp45
            
            var = "pr"
            
            variable = str_c(var,
                             ens,
                             scen,
                             sep = "_")
            
            print(str_c("   -- Reading ", variable, " ", Longitude))
            
            pr_4 = ncvar_get(nc           = nc_p4,
                             varid        = variable,
                             verbose      = FALSE,
                             raw_datavals = FALSE,
                             start        = c(lon_i,    1,  1),
                             count        = c(    1,   -1, -1)) 
            
            
          } # pr rcp45
          
          { # tasmin rcp45
            
            var = "tasmin"
            agg = "CDO_MONTLY_MEAN"
            
            variable = str_c(var,
                             ens,
                             scen,
                             sep = "_")
            
            print(str_c("   -- Reading ", variable, " ", Longitude))
            
            tmin_4 = ncvar_get(nc           = nc_n4,
                               varid        = variable,
                               verbose      = FALSE,
                               raw_datavals = FALSE,
                               start        = c(lon_i,    1,  1),
                               count        = c(    1,   -1, -1)) 
            
          } # tasmin rcp45
          
          { # tasmax rcp45
            
            var = "tasmax"
            agg = "CDO_MONTLY_MEAN"
            
            variable = str_c(var,
                             ens,
                             scen,
                             sep = "_")
            
            print(str_c("   -- Reading ", variable, " ", Longitude))
            
            tmax_4 = ncvar_get(nc           = nc_x4,
                               varid        = variable,
                               verbose      = FALSE,
                               raw_datavals = FALSE,
                               start        = c(lon_i,    1,  1),
                               count        = c(    1,   -1, -1)) 
            
          } # tasmax rcp45

          

        } # RCP 4.5 Period          
        
        { # RCP 8.5 Period     
          
          scen   = "rcp85"
          period = "2006-2099"
          
          { # pr rcp85
            
            var = "pr"
            
            variable = str_c(var,
                             ens,
                             scen,
                             sep = "_")
            
            print(str_c("   -- Reading ", variable, " ", Longitude))
            
            pr_8 = ncvar_get(nc           = nc_p8,
                             varid        = variable,
                             verbose      = FALSE,
                             raw_datavals = FALSE,
                             start        = c(lon_i,    1,  1),
                             count        = c(    1,   -1, -1)) 
            
            
          } # pr rcp85
          
          { # tasmin rcp85
            
            var = "tasmin"
            agg = "CDO_MONTLY_MEAN"
            
            variable = str_c(var,
                             ens,
                             scen,
                             sep = "_")
            
            print(str_c("   -- Reading ", variable, " ", Longitude))
            
            tmin_8 = ncvar_get(nc           = nc_n8,
                               varid        = variable,
                               verbose      = FALSE,
                               raw_datavals = FALSE,
                               start        = c(lon_i,    1,  1),
                               count        = c(    1,   -1, -1)) 
            
          } # tasmin rcp85
          
          { # tasmax rcp85
            
            var = "tasmax"
            agg = "CDO_MONTLY_MEAN"
            
            variable = str_c(var,
                             ens,
                             scen,
                             sep = "_")
            
            print(str_c("   -- Reading ", variable, " ", Longitude))
            
            tmax_8 = ncvar_get(nc           = nc_x8,
                               varid        = variable,
                               verbose      = FALSE,
                               raw_datavals = FALSE,
                               start        = c(lon_i,    1,  1),
                               count        = c(    1,   -1, -1)) 
            
          } # tasmax rcp85
          
        } # RCP 8.5 Period    
        
 
        ######################################################################
        #       
        # Create Parallel Block Here
        
        print(str_c("     "))
        print(str_c("   - Beginning Latitude Loop for ", Ensemble ," @ ", Longitude, " [",(lon_i*100.0/length(longitude)),"%] ",Sys.time() ))
        print(str_c("     "))

        for (Latitude in latitude) 
        { # latitude
          
          lat_j    = which(latitude == Latitude)
          
          
          if (!anyNA(pr_0[lat_j, ])) {  # check for water points
            
              library(package = "ClimClass")
            
                
              hist = data.frame(time  = time_hist,
                                year  = year(time_hist),
                                month = month(time_hist),
                                P     = pr_0[lat_j, ],
                                Tn    = tmin_0[lat_j, ],
                                Tx    = tmax_0[lat_j, ],
                                Tm    = (tmin_0[lat_j, ]+tmax_0[lat_j, ])/2)
              
              rcp45 = data.frame(time  = time_futr,
                                 year  = year(time_futr),
                                 month = month(time_futr),
                                 P     = pr_4[lat_j, ],
                                 Tn    = tmin_4[lat_j, ],
                                 Tx    = tmax_4[lat_j, ],
                                 Tm    = (tmin_4[lat_j, ]+tmax_4[lat_j, ])/2)  
              
              rcp85 = data.frame(time  = time_futr,
                                 year  = year(time_futr),
                                 month = month(time_futr),
                                 P     = pr_8[lat_j, ],
                                 Tn    = tmin_8[lat_j, ],
                                 Tx    = tmax_8[lat_j, ],
                                 Tm    = (tmin_8[lat_j, ]+tmax_8[lat_j, ])/2)
          
              for (year_k in 1:length(futr_year))
              { # time future
                
                if (year_k <= length(hist_year))  { # historical cases  
                  
                  Year = hist_year[year_k]  
                  
                  clim_norm = hist %>% filter(year == Year)
                  
                  koeppen_geiger = koeppen_geiger(clim_norm                 = clim_norm,
                                                  A_B_C_special_sub.classes = FALSE,
                                                  clim.resume_verbose       = TRUE,
                                                  class.nr                  = FALSE)
                  
                  koeppen_histo[lon_i,lat_j,year_k] = as.character(koeppen_geiger$class)                  
                  
                } # historical cases
                
                Year = futr_year[year_k]  
                
                clim_norm = rcp45 %>% filter(year == Year)
                
                koeppen_geiger = koeppen_geiger(clim_norm                 = clim_norm,
                                                A_B_C_special_sub.classes = FALSE,
                                                clim.resume_verbose       = TRUE,
                                                class.nr                  = FALSE)
                koeppen_rcp45[lon_i,lat_j,year_k] = as.character(koeppen_geiger$class)
    
               
                clim_norm = rcp85 %>% filter(year == Year)
                
                koeppen_geiger = koeppen_geiger(clim_norm                 = clim_norm,
                                                A_B_C_special_sub.classes = FALSE,
                                                clim.resume_verbose       = TRUE,
                                                class.nr                  = FALSE)
                
                koeppen_rcp85[lon_i,lat_j,year_k] = as.character(koeppen_geiger$class)
                
                            
              } # time future
          
          
          }  # check for water points
          
          
          #print(str_c(Ensemble,
          #            Longitude,
          #            Latitude,
          #            koeppen_histo[lon_i,lat_j,length(hist_year)],
          #            koeppen_rcp45[lon_i,lat_j,length(futr_year)],
          #            koeppen_rcp85[lon_i,lat_j,length(futr_year)],
          #            sep = " "))
          
          remove(hist, rcp45, rcp85)
                    
        } # latitude 
        
        #
        # End Parallel Block
        #
        ######################################################################
         
        
        remove(  pr_0,   pr_4,   pr_8)
        remove(tmax_0, tmax_4, tmax_8)
        remove(tmin_0, tmin_4, tmin_8)

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
      
    save(koeppen_histo,
         file = str_c(OUT_ROOT,"KOEPPEN_HISTO_",Ensemble,".Rdata",sep=""))

    
    save(koeppen_rcp45,
         file = str_c(OUT_ROOT,"KOEPPEN_RCP45_",Ensemble,".Rdata",sep=""))
  
    
    save(koeppen_rcp85,
         file = str_c(OUT_ROOT,"KOEPPEN_RCP85_",Ensemble,".Rdata",sep=""))
      
  } # Ensemble
  

#
###############################################################
  


