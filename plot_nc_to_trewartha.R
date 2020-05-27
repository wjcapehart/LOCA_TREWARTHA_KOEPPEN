library(package = "tidyverse") # bulk frequently-used tidyverse packages
library(package = "lubridate") # tidyverse date-time support'


library(package = "PCICt") # Implementation of POSIXct Work-Alike for 365 and 360 Day Calendars


# Mapping  support
library(package = "maps")
library(package = "mapproj")
library(package = "rgdal")
library(package = "rgeos")

# array -> dataframe
library(package = "reshape2")



# netcdf
library(package = "ncdf4")
library(package = "ncdf4.helpers")

# file

time_step = 1


directory = "/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/climatology/DERIVED/YEARLY/TREWARTHA/"
filename = "./LOCA_NGP_TREWARTHA_allensembles_allscenarios_2006-2099_30Y_MEAN_MONTHLY_MEAN_01Y_PRODUCT_INTERVAL.nc"

file_url = str_c(directory,
                 filename,
                 sep = "")



ncngp  = nc_open(filename = file_url)

lon         =  ncvar_get(nc    = ncngp,
                         varid = "lon")

lat         =  ncvar_get(nc    = ncngp,
                         varid = "lat")

ensemble    = ncvar_get(nc    = ncngp,
                        varid = "ensemble")
scenario    = ncvar_get(nc    = ncngp,
                        varid = "scenario")
year_start    = ncvar_get(nc    = ncngp,
                          varid = "year_start")

year_end    = ncvar_get(nc    = ncngp,
                        varid = "year_end")


time_bnds  = str_c(year_start,
                   "-",
                   year_end,
                   sep = "")




classes_table = ncvar_get(nc    = ncngp,
                          varid = "trewartha_string",
                          start = c( 2),
                          count = c(-1))



class2L_cols  = ncvar_get(nc    = ncngp,
                          varid = "trewartha_colors",
                          start = c( 4),
                          count = c(-1))


class2L_cols        = as.array(class2L_cols)
names(class2L_cols) = as_factor(classes_table)


##
# maps
load(file = "./canadian_provinces.Rdata")
# inported field is canada_data = canadian_provinces


usa_data   = map_data(map="state",
                      xlim=c(-114.2812, -86.21875),
                      ylim=c (33.96875,  52.78125) )
water_data = map_data(map="lakes",
                      xlim=c(-114.2812,-86.21875),
                      ylim=c( 33.96875, 52.78125) )


for (t in 1:length(year_start))
{
      decade_string = time_bnds[t]
      print(decade_string)

     # new((/ n_time, n_ens, n_scen, n_lat, n_lon /), integer)
      class        = ncvar_get(nc    = ncngp,
                               varid = "trewartha_code",
                               start = c( 1,  1,  1,  1, t),
                               count = c(-1, -1, -1, -1, 1))

      dimnames(class) = list("lon"       = lon,
                             "lat"       = lat,
                             "scenario"  = scenario)

      class = melt(data       = class,
                  value.name = "Class_Number",
                  id.vars    = c("lon",
                                 "lat",
                                 "scenario"),
                  na.rm     = FALSE)
      
      
      class$scenario     = as.character(x = class$scenario)
      class$Class_Number =   as.numeric(x = class$Class_Number)

      if (year_end[t] <= 2005) {
        class          = class %>% filter(!(scenario == "rcp85"))
        class$scenario = "Historical"
      } else {
        class$scenario[(class$scenario == "hist/rcp45")] = "RCP 4.5"
        class$scenario[(class$scenario == "rcp85")]      = "RCP 8.5"
      }


      class$Class_Number[class$Class_Number == 0] = NA
      
      class$Zone = "NA"
      class$Zone = classes_table[class$Class_Number]
      
      class$Zone[class$Zone  == "NA"] = NA

      class$Zone = as_factor(class$Zone)


      mymap = ggplot(data = class)  +

             aes(x     = lon,
                 y     = lat) +

             facet_grid(cols = vars(scenario)) +

             theme_bw() +

             theme(strip.background = element_rect(fill=NA),
                   aspect.ratio     = 1)+

             labs(title    = "CMIP5 LOCA Climate Ensemble Analyses",
                  subtitle = str_c(decade_string,
                                   "Trewartha Climate Zones (Ensemble Mean)",
                                   sep = " "),
                  caption = "South Dakota School of Mines & Technology\nAtmospheric & Environmental Sciences") +

             xlab(label = "Longitude") +

             ylab(label = "Latitude") +

             guides(fill=guide_legend(ncol=2)) +

             coord_cartesian(xlim=c(min(lon), 
                                    max(lon)),
                             ylim=c(min(lat),  
                                    max(lat)) )  +
        
             scale_fill_manual(values = class2L_cols,
                               breaks = classes_table,
                               drop   = FALSE) +

             geom_raster(data    = class,
                         mapping = aes(x    = lon,
                                       y    = lat,
                                       fill = Zone)) +

             geom_polygon(data  = usa_data,
                                  mapping = aes(x     =   long,
                                                y     =    lat,
                                                group =  group),
                                  fill  = NA,
                                  color = "black")  +

             geom_polygon(data  = water_data,
                                  mapping = aes(x     =   long,
                                                y     =    lat,
                                                group =  group),
                                  fill  = NA,
                                  color = "black")  +

             geom_polygon(data  = canadian_provinces,
                                  mapping = aes(x     =   long,
                                                y     =    lat,
                                                group =  group),
                                  fill  = NA,
                                  color = "black")

      ggsave(filename = str_c("./",
                              decade_string,
                              "_LOCA_TREWARTHA_MAP.png",
                              sep = ""),
             plot     = mymap,
             device   = "png",
             width    = 10.50, 
             height   =  5.75)

}
