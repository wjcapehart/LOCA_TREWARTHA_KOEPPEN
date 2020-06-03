


begin
  setfileoption("nc", "Format",  "NetCDF4")

  delta_t = 10h

  start_years =toshort(ispan(1950,2090,delta_t))
  print(start_years)

  do ii = 0, dimsizes(start_years)-1


    climatology_start_year                    := start_years(ii)
    climatology_start_year@long_name          = "Climatology Start Year"
    climatology_start_year@description        = climatology_start_year@long_name
    climatology_start_year@standard_name      = "time"
    climatology_start_year@units              = "years since 0000-01-01 00:00:00"
    climatology_start_year@calendar           = "standard"
    climatology_start_year@bounds             = "climatology_bnds"
    climatology_start_year!0                  = "climatology_period"



    climatology_end_year                    := toshort(start_years(ii) + delta_t - 1h)
    climatology_end_year@long_name          = "Climatology End Year"
    climatology_end_year@description        = climatology_end_year@long_name
    climatology_end_year@standard_name      = "time"
    climatology_end_year@units              = "years since 0000-01-01 00:00:00"
    climatology_end_year@calendar           = "standard"
    climatology_end_year@bounds             = "climatology_bnds"
    climatology_end_year!0                  = "climatology_period"



    climatology_period                    := sprinti("%0.4i",climatology_start_year) + "-" +sprinti("%0.4i",climatology_end_year)
    climatology_period@long_name          = "Climatology Period"
    climatology_period@description        = climatology_period@long_name
    climatology_period@bounds             = "climatology_bnds"
    climatology_period!0                  = "climatology_period"
    climatology_period&climatology_period = climatology_period


    climatology_start_year&climatology_period = climatology_period
    climatology_end_year&climatology_period = climatology_period



    climatology_duration    = (/ delta_t  /)
    climatology_period@long_name = "length of climatology period"
    climatology_duration@description = "length of climatology period"
    climatology_duration@standard_name = "time"
    climatology_duration!0 = "climatology_period"
    climatology_duration&climatology_period = climatology_period




    in_file    := "http://kyrill.ias.sdsmt.edu:8080/thredds/dodsC/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornwaite_Budget/"+climatology_duration+"-yr/LOCAL_TREWARTHA_ALL_ENSEMBLES_"+climatology_period+".nc"
    in_file    = "/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornwaite_Budget/"+climatology_duration+"-yr/LOCAL_TREWARTHA_ALL_ENSEMBLES_"+climatology_period+".nc"
    out_file   := "./LOCAL_TREWARTHA_ALL_ENSEMBLES_CLIM_"+climatology_period+".nc"


    fin  := addfile(in_file, "r")
    system("rm -frv " + out_file)
    fout := addfile(out_file,"c")









    time      := fin->time
    scenario  := fin->scenario
    scenario  := chartostring(scenario)
      scenario@long_name   = "Scenario"
      scenario@description = scenario@long_name
    ensemble  := fin->ensemble
    ensemble  := chartostring(ensemble)
      ensemble@long_name   = "Ensemble"
      ensemble@description = ensemble@long_name
      ensemble!0 = "ensemble"
      ensemble&ensemble = ensemble

    lon       := fin->lon
    lat       := fin->lat
    lat_bnds  := fin->lat_bnds
    lon_bnds  := fin->lon_bnds
    time_bnds := fin->time_bnds

    climatology_bnds      = (/ time_bnds(0:0,:) /)
    climatology_bnds(0,0) = toshort(min(time))
    climatology_bnds(0,1) = toshort(max(time))
    climatology_bnds@long_name = "Climate Period Bounds"
    climatology_bnds@description = climatology_bnds@long_name
    climatology_bnds@standard_name = "time"
    climatology_bnds@calendar = "standard"
    climatology_bnds@units = time@units
    climatology_bnds!0 = "climatology_period"
    climatology_bnds&climatology_period = climatology_period
    climatology_bnds!1 = "bnds"


    climatology_year_bnds      := (/ toshort(time_bnds(0:0,:)) /)
    climatology_year_bnds(0,0) = toshort(climatology_start_year)
    climatology_year_bnds(0,1) = toshort(climatology_end_year)
    climatology_year_bnds@long_name = "Climate Period Bounds"
    climatology_year_bnds@description = climatology_bnds@long_name
    climatology_year_bnds@standard_name = "time"
    climatology_year_bnds@calendar = "standard"
    climatology_year_bnds@units = climatology_start_year@units
    climatology_year_bnds!0 = "climatology_period"
    climatology_year_bnds&climatology_period = climatology_period
    climatology_year_bnds!1 = "bnds"




    delete(climatology_bnds&climatology_period )
    climatology_bnds!0                  = "climatology_period"
    climatology_bnds&climatology_period = climatology_period

    time_parts := cd_calendar(time, -5)

    year  := time_parts(:,0)
      year!0         = "year"
      year&year      = year
      year@long_name = "year"
    month := toshort(time_parts(:,1))
      month!0         = "month"
      month&month     = month
      month@long_name = "Calendar Month"
      month@description = month@long_name
      month@units = "month"
      month@calendar_month_LUT = (/ default_fillvalue("string"), "January", "February", "March","April","May","June","July","August","September","October","November","December" /)
      month@comment = "calendar month LUT indexing starts at 0, 1=January, 12=December"

      if (max(year) .le. 2005) then
        print("All Historical")

      else
        print("All Future")

      end if
      print(scenario)






              print(out_file)
              print(climatology_year_bnds)
              fout->climatology_period = climatology_period
              fout->month = month
              fout->ensemble = ensemble
              fout->lon = lon
              fout->lat = lat
              fout->climatology_bnds = climatology_bnds
              fout->lon_bnds = lon_bnds
              fout->lat_bnds = lat_bnds
              fout->climatology_year_bnds = climatology_year_bnds
              fout->climatology_duration = climatology_duration

print(fout)





    x := fin->mean_temperature
      print(x@long_name)
      x!0     = "month"
      x&month = month
      x&ensemble        = ensemble
      x&scenario        = scenario
      if (max(year) .le. 2005) then
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if

      y := x(0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + y@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + y@long_name
        z@description  := y@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(ind(month .eq. k+1),:,:,:,:)
        y(k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,0),3)) /)
        z(k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,0),3)) /)
      end do

      mean_monthly_temperature  := y
      stdev_monthly_temperature := z

    x := fin->total_precipitation
      print(x@long_name)
      x!0        = "month"
      x&month    = month
      x&ensemble = ensemble
      x&scenario = scenario
      if (max(year) .le. 2005) then
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      y := x(0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + y@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + y@long_name
        z@description  := y@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(ind(month .eq. k+1),:,:,:,:)
        y(k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,0),3)) /)
        z(k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,0),3)) /)
      end do

      mean_monthly_precipitation  := y
      stdev_monthly_precipitation := z



    x := fin->potential_evapotranspiration
      print(x@long_name)
      x!0        = "month"
      x&month    = month
      x&ensemble = ensemble
      x&scenario = scenario
      if (max(year) .le. 2005) then
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      y := x(0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + y@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + y@long_name
        z@description  := y@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(ind(month .eq. k+1),:,:,:,:)
        y(k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,0),3)) /)
        z(k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,0),3)) /)

      end do

      mean_potential_evapotranspiration  := y
      stdev_potential_evapotranspiration := z



    x := fin->evapotranspiration
      print(x@long_name)
      x!0        = "month"
      x&month    = month
      x&ensemble = ensemble
      x&scenario = scenario
      if (max(year) .le. 2005) then
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      y := x(0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + y@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + y@long_name
        z@description  := y@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(ind(month .eq. k+1),:,:,:,:)
        y(k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,0),3)) /)
        z(k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,0),3)) /)

      end do

      mean_evapotranspiration  := y
      stdev_evapotranspiration := z


    x := fin->storage
      print(x@long_name)

      x!0        = "month"
      x&month    = month
      x&ensemble = ensemble
      x&scenario = scenario
      if (max(year) .le. 2005) then
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      y := x(0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + y@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + y@long_name
        z@description  := y@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(ind(month .eq. k+1),:,:,:,:)
        y(k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,0),3)) /)
        z(k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,0),3)) /)

      end do

      mean_storage  := y
      stdev_storage := z


    x := fin->snowpack
      print(x@long_name)

      x!0        = "month"
      x&month    = month
      x&ensemble = ensemble
      x&scenario = scenario

      if (max(year) .le. 2005) then
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      y := x(0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + y@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + y@long_name
        z@description  := y@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(ind(month .eq. k+1),:,:,:,:)
        y(k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,0),3)) /)
        z(k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,0),3)) /)

      end do

      mean_snowpack  := y
      stdev_snowpack := z



    x := fin->deficit
      print(x@long_name)
      x!0        = "month"
      x&month    = month
      x&ensemble = ensemble
      x&scenario = scenario

      if (max(year) .le. 2005) then
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      y := x(0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + y@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + y@long_name
        z@description  := y@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(ind(month .eq. k+1),:,:,:,:)
        y(k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,0),3)) /)
        z(k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,0),3)) /)

      end do

      mean_deficit  := y
      stdev_deficit := z



    x := fin->recharge
      print(x@long_name)
      x!0         = "month"
      x&month     = month
      x&ensemble  = ensemble
      x&scenario  = scenario

      if (max(year) .le. 2005) then
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      y := x(0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + y@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + y@long_name
        z@description  := y@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(ind(month .eq. k+1),:,:,:,:)
        y(k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,0),3)) /)
        z(k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,0),3)) /)

      end do

      mean_recharge  := y
      stdev_recharge := z



    x := fin->surplus
      print(x@long_name)
      x!0        = "month"
      x&month    = month
      x&ensemble = ensemble
      x&scenario = scenario

      if (max(year) .le. 2005) then
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      y := x(0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + y@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + y@long_name
        z@description  := y@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(ind(month .eq. k+1),:,:,:,:)
        y(k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,0),3)) /)
        z(k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,0),3)) /)

      end do

      mean_surplus  := y
      stdev_surplus := z

      month := toshort(ispan(1,12,1))
        month!0         = "month"
        month&month     = month
        month@long_name = "Calendar Month"
        month@description = month@long_name
        month@units = "month"
        month@axis = "T"
        month@calendar_month_LUT = (/ default_fillvalue("string"), "January", "February", "March","April","May","June","July","August","September","October","November","December" /)
        month@comment = "calendar month LUT indexing starts at 0, 1=January, 12=December"


    fout->mean_monthly_temperature          = mean_monthly_temperature
    fout->mean_monthly_precipitation        = mean_monthly_precipitation
    fout->mean_potential_evapotranspiration = mean_potential_evapotranspiration
    fout->mean_evapotranspiration           = mean_evapotranspiration
    fout->mean_storage                      = mean_storage
    fout->mean_snowpack                     = mean_snowpack
    fout->mean_deficit                      = mean_deficit
    fout->mean_recharge                     = mean_recharge
    fout->mean_surplus                      = mean_surplus


    fout->stdev_monthly_temperature          = stdev_monthly_temperature
    fout->stdev_monthly_precipitation        = stdev_monthly_precipitation
    fout->stdev_potential_evapotranspiration = stdev_potential_evapotranspiration
    fout->stdev_evapotranspiration           = stdev_evapotranspiration
    fout->stdev_storage                      = stdev_storage
    fout->stdev_snowpack                     = stdev_snowpack
    fout->stdev_deficit                      = stdev_deficit
    fout->stdev_recharge                     = stdev_recharge
    fout->stdev_surplus                      = stdev_surplus

    delete(fout)
    delete(fin)

  end do

end
