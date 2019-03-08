


load "./trewartha_func.ncl"



begin

    setfileoption("nc","Format","NetCDF4")


    trewartha_class_number                        = ispan(0,20,1)
    trewartha_class_number!0                      = "trewartha_class_number"
    trewartha_class_number&trewartha_class_number = trewartha_class_number
    trewartha_class_number@long_name              = "Trewartha Climate Class Number Lookup Code"
    trewartha_class_number@description            = "Trewartha Climate Class Number Lookup Code"

    trewartha_string = (/  "NA",  \ ;  0
                           "Ar",  \ ;  1
                           "Aw",  \ ;  2
                           "As",  \ ;  3
                           "BSh", \ ;  4
                           "BSk", \ ;  5
                           "BWh", \ ;  6
                           "BWk", \ ;  7
                           "Cfa", \ ;  8
                           "Cfb", \ ;  9
                           "Csa", \ ; 10
                           "Csb", \ ; 11
                           "Cwa", \ ; 12
                           "Cwb", \ ; 13
                           "Do",  \ ; 14
                           "Dca", \ ; 15
                           "Dcb", \ ; 16
                           "Eo",  \ ; 17
                           "Ec",  \ ; 18
                           "Ft",  \ ; 19
                           "Fi"  /) ; 20

    trewartha_string!0                      = "trewartha_class_number"
    trewartha_string&trewartha_class_number =  trewartha_class_number
    trewartha_string@long_name              = "Trewartha Climate Class Letter Code"
    trewartha_string@description            = "Trewartha Climate Class Letter Code"

    trewartha_class_number@trewartha_string = trewartha_string



    trewartha_legend = (/  "Unclassified",                \ ; "U",   \ ;  0
                           "Tropical Rainforest",         \ ; "Ar",  \ ;  1
                           "Tropical Savanna",            \ ; "Aw",  \ ;  2
                           "Tropical Dry Summer",         \ ; "As",  \ ;  3
                           "Warm Steppe",                 \ ; "BSh", \ ;  4
                           "Cool Steppe",                 \ ; "BSk", \ ;  5
                           "Warm Dessert",                \ ; "BWh", \ ;  6
                           "Cool Dessert",                \ ; "BWk", \ ;  7
                           "Warm Subtropical Humid",      \ ; "Cfa", \ ;  8
                           "Cool Subtropical Humid",      \ ; "Cfb", \ ;  9
                           "Warm Subtropical Dry Summer", \ ; "Csa", \ ; 10
                           "Cool Subtropical Dry Summer", \ ; "Csb", \ ; 11
                           "Warm Subtropical Dry Winter", \ ; "Cwa", \ ; 12
                           "Cool Subtropical Dry Winter", \ ; "Cwb", \ ; 13
                           "Oceanic",                     \ ; "Do",  \ ; 14
                           "Warm Continental",            \ ; "Dca", \ ; 15
                           "Cool Continental",            \ ; "Dcb", \ ; 16
                           "Oceanic Boreal",              \ ; "Eo",  \ ; 17
                           "Continental Boreal",          \ ; "Ec",  \ ; 18
                           "Tundra",                      \ ; "Ft",  \ ; 19
                           "Ice"                          /) ; "Fi"  /) ; 20


    trewartha_legend!0                      = "trewartha_class_number"
    trewartha_legend&trewartha_class_number =  trewartha_class_number
    trewartha_legend@long_name              = "Trewartha Climate Class Descriptive Name"
    trewartha_legend@description            = "Trewartha Climate Class Descriptive Name"
    trewartha_legend@trewartha_string       =  trewartha_string


    trewartha_colors = (/  "white",         \ ;  "Foreground",                  \ ; "NA",   \ ;  0
                           "black",         \ ;  "Background",                  \ ; "NA",   \ ;  0
                           "black",         \ ;  "Unclassified",                \ ; "U",   \ ;  0
                           "magenta3",      \ ;  "Tropical Rainforest",         \ ; "Ar",  \ ;  1
                           "maroon1",       \ ;  "Tropical Savanna",            \ ; "Aw",  \ ;  2
                           "maroon3",       \ ;  "Tropical Dry Summer",         \ ; "As",  \ ;  3
                           "tan1",          \ ;  "Warm Steppe",                 \ ; "BSh", \ ;  4
                           "tan3",          \ ;  "Cool Steppe",                 \ ; "BSk", \ ;  5
                           "navajowhite3",  \ ;  "Warm Dessert",                \ ; "BWh", \ ;  6
                           "navajowhite",   \ ;  "Cool Dessert",                \ ; "BWk", \ ;  7
                           "chartreuse1",   \ ;  "Warm Subtropical Humid",      \ ; "Cfa", \ ;  8
                           "chartreuse3",   \ ;  "Cool Subtropical Humid",      \ ; "Cfb", \ ;  9
                           "darkseagreen1", \ ;  "Warm Subtropical Dry Summer", \ ; "Csa", \ ; 10
                           "darkseagreen3", \ ;  "Cool Subtropical Dry Summer", \ ; "Csb", \ ; 11
                           "olivedrab1",    \ ;  "Warm Subtropical Dry Winter", \ ; "Cwa", \ ; 12
                           "olivedrab3",    \ ;  "Cool Subtropical Dry Winter", \ ; "Cwb", \ ; 13
                           "dodgerblue",    \ ;  "Oceanic",                     \ ; "Do",  \ ; 14
                           "dodgerblue3",   \ ;  "Warm Continental",            \ ; "Dca", \ ; 15
                           "dodgerblue4",   \ ;  "Cool Continental",            \ ; "Dcb", \ ; 16
                           "steelblue3",    \ ;  "Oceanic Boreal",              \ ; "Eo",  \ ; 17
                           "steelblue4",    \ ;  "Continental Boreal",          \ ; "Ec",  \ ; 18
                           "slategray1",    \ ;  "Tundra",                      \ ; "Ft",  \ ; 19
                           "white"          /) ;  "Ice"                         /) ; "Fi"  /) ; 20

      trewartha_class_number_bw                           = ispan(-2,20,1)
      trewartha_class_number_bw!0                         = "trewartha_class_number_bw"
      trewartha_class_number_bw&trewartha_class_number_bw = trewartha_class_number_bw
      trewartha_class_number_bw@long_name                 = "Trewartha Color Table Matching Table"
      trewartha_class_number_bw@description               = "Trewartha Color Table Matching Table"
      trewartha_class_number_bw@comment                   = "-2 = 0 NCL = foreground; -1 = 1 NCL background; 0-20 Trewartha Colors"

      trewartha_colors!0                  = "trewartha_class_number_bw"
      trewartha_colors&trewartha_class_number_bw   =  trewartha_class_number_bw
      trewartha_colors@long_name                   = "Trewartha Climate Class Color Table"
      trewartha_colors@description                 = "Trewartha Climate Class Color Table"
      trewartha_colors@trewartha_string            =  (/  "foreground", \ ; -2
                                                          "background", \ ; -1
                                                          "NA",  \ ;  0
                                                          "Ar",  \ ;  1
                                                          "Aw",  \ ;  2
                                                          "As",  \ ;  3
                                                          "BSh", \ ;  4
                                                          "BSk", \ ;  5
                                                          "BWh", \ ;  6
                                                          "BWk", \ ;  7
                                                          "Cfa", \ ;  8
                                                          "Cfb", \ ;  9
                                                          "Csa", \ ; 10
                                                          "Csb", \ ; 11
                                                          "Cwa", \ ; 12
                                                          "Cwb", \ ; 13
                                                          "Do",  \ ; 14
                                                          "Dca", \ ; 15
                                                          "Dcb", \ ; 16
                                                          "Eo",  \ ; 17
                                                          "Ec",  \ ; 18
                                                          "Ft",  \ ; 19
                                                          "Fi"  /) ; 20


   n_classes = dimsizes(trewartha_legend)

   f_temp = addfile("/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/climatology/MONTHLY/tasavg/LOCA_NGP_tasavg_allensembles_allscenarios_2006-2099_30Y_MEAN_MONTHLY_MEAN_01Y_PRODUCT_INTERVAL.nc", "r")
   f_prec = addfile("/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/climatology/MONTHLY/pr/LOCA_NGP_pr_allensembles_allscenarios_2006-2099_30Y_MEAN_MONTHLY_MEAN_01Y_PRODUCT_INTERVAL.nc", "r")

   lat                = f_prec->lat
   lon                = f_prec->lon
   lat_bnds           = f_prec->lat_bnds
   lon_bnds           = f_prec->lon_bnds
   climatology_bounds = f_prec->climatology_bounds
   year_start         = f_prec->year_start
   year_end           = f_prec->year_end
   scenario           = f_prec->scenario
   ensemble           = f_prec->ensemble
   time               = f_prec->time

   n_time             = dimsizes(time)
   n_lat              = dimsizes(lat)
   n_lon              = dimsizes(lon)
   n_ens              = dimsizes(ensemble)
   n_scen             = dimsizes(scenario)

   trewartha_code                           = new((/ n_time, n_ens, n_scen, n_lat, n_lon /), "integer")
   trewartha_code!0                         = "time"
   trewartha_code&time                      =  time
   trewartha_code!1                         = "ensemble"
   trewartha_code&ensemble                  =  ensemble
   trewartha_code!2                         = "scenario"
   trewartha_code&scenario                  =  scenario
   trewartha_code!3                         = "lat"
   trewartha_code&lat                       =  lat
   trewartha_code!4                         = "lon"
   trewartha_code&lon                       =  lon
   trewartha_code@description               = "Trewartha Numerical Category"
   trewartha_code@long_name                 = trewartha_code@description
   trewartha_code@trewartha_string          = trewartha_string
   trewartha_code@trewartha_legend          = trewartha_legend
   trewartha_code@trewartha_colors          = trewartha_colors
   trewartha_code@trewartha_class_number_bw = trewartha_class_number_bw



   do t = 0, n_time-1
     do e = 0, n_ens-1

       do j = 0, n_lat-1

         prec_rcp45 = f_prec->pr_running_avg(t,:,e,0,j,:)
         temp_rcp45 = f_temp->tasavg_running_avg(t,:,e,0,j,:)

         if (year_start(t) .gt. 2005) then
            prec_rcp85 = f_prec->pr_running_avg(t,:,e,1,j,:)
            temp_rcp85 = f_temp->tasavg_running_avg(t,:,e,1,j,:)
         end if

         do i = 0, n_lon-1
             trewartha_code(t,e,0,i,j) = wjc_trewartha_func(temp_rcp45(:,i), \
                                                            prec_rcp45(:,i), \
                                                            lat(j))
           if (year_start .gt. 2005) then
             trewartha_code(t,e,1,i,j) = wjc_trewartha_func(temp_rcp85(:,i), \
                                                            prec_rcp85(:,i), \
                                                            lat(j))
           end if

         end do


       end do


     end do
   end do


   delete(f_prec)
   delete(f_temp)

   directory = "/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/climatology/DERIVED/YEARLY/TREWARTHA/"

   filename = "./LOCA_NGP_TREWARTHA_allensembles_allscenarios_2006-2099_30Y_MEAN_MONTHLY_MEAN_01Y_PRODUCT_INTERVAL.nc"

   system("rm -frv "+directory+filename)

   print(directory+filename)

   f_tre = addfile(directory+filename,"c")

   f_tre->time               = time
   f_tre->climatology_bounds = climatology_bounds
   f_tre->ensemble           = ensemble
   f_tre->scenario           = scenario
   f_tre->year_start         = year_start
   f_tre->year_end           = year_end
   f_tre->lat                = lat
   f_tre->lat_bnds           = lat_bnds
   f_tre->lon                = lon
   f_tre->lon_bnds           = lon_bnds

   f_tre->trewartha_class_number     = trewartha_class_number
   f_tre->trewartha_string           = trewartha_string
   f_tre->trewartha_class_number_bw  = trewartha_class_number_bw
   f_tre->trewartha_colors           = trewartha_colors
   f_tre->trewartha_code             = trewartha_code

   delete(f_tre)


end
