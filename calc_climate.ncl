


begin

  delta_t = 10

  start_years = (/ 1950 /)

  start_year = start_years(0)


    climatology_start_year                    = 1950
    climatology_start_year@long_name          = "Climatology Start Year"
    climatology_start_year@description        = climatology_start_year@long_name
    climatology_start_year@bounds             = "climatology_bnds"
    climatology_start_year!0                  = "climatology_period"



    climatology_end_year                    = climatology_start_year + delta_t - 1
    climatology_end_year@long_name          = "Climatology End Year"
    climatology_end_year@description        = climatology_end_year@long_name
    climatology_end_year@bounds             = "climatology_bnds"
    climatology_end_year!0                  = "climatology_period"



    climatology_period                    = "1950-1959"
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



    in_file    = "http://kyrill.ias.sdsmt.edu:8080/thredds/dodsC/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornwaite_Budget/"+climatology_duration+"-yr/LOCAL_TREWARTHA_ALL_ENSEMBLES_"+climatology_period+".nc"
    in_file    = "/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornwaite_Budget/"+climatology_duration+"-yr/LOCAL_TREWARTHA_ALL_ENSEMBLES_"+climatology_period+".nc"
    out_file   = "./LOCAL_TREWARTHA_ALL_ENSEMBLES_CLIM_"+climatology_period+".nc"


    fin = addfile(in_file,"r")

    time      := fin->time
    scenario  := fin->scenario
    scenario  := chartostring(scenario)
      scenario@long_name   = "Scenario"
      scenario@description = scenario@long_name
    ensemble  := fin->ensemble
    ensemble  := chartostring(ensemble)
      ensemble@long_name   = "Ensemble"
      ensemble@description = ensemble@long_name
    lon       := fin->lon
    lat       := fin->lat
    lat_bnds  := fin->lat_bnds
    lon_bnds  := fin->lon_bnds
    time_bnds := fin->time_bnds

    climatology_bnds      = time_bnds(0:0,:)
    climatology_bnds(0,0) = tofloat(min(time))
    climatology_bnds(0,1) = tofloat(max(time))

    time_parts = cd_calendar(time, -5)

    year  = time_parts(:,0)
      year!0         = "year"
      year&year      = year
      year@long_name = "year"
    month = time_parts(:,1)
      month!0         = "month"
      month&month     = month
      month@long_name = "month"


      if (max(year) .le. 2005) then
        scenario = scenario(0:0)
        scenario(0) := "Historical"
      end if


    x := fin->mean_temperature
      x!0     = "month"
      x&month = month
      x&ensemble        := ensemble
      if (max(year) .le. 2005) then
        x := x(:,:,0:0,:,:)
        scenario := scenario(0:0)
        scenario(0) = "Historical"
      else
        scenario(0) = "RCP45"
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      scenario!0        := "scenario"
      scenario&scenario := scenario
      x&scenario        := scenario
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
        y(k,:,:,:,:) := (/ round(  dim_avg_n(temp,0),3)   /)
        z(k,:,:,:,:) := (/ round( dim_stddev_n(temp,0),3) /)
      end do

      mean_monthly_temperature  := y
      stdev_monthly_temperature := z


    x := fin->total_precipitation
      x!0        := "month"
      x&month    := month
      x&ensemble := ensemble
      if (max(year) .le. 2005) then
        x := x(:,:,0:0,:,:)
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      x&scenario        := scenario
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
        y(k,:,:,:,:) := (/ round(  dim_avg_n(temp,0),3)   /)
        z(k,:,:,:,:) := (/ round( dim_stddev_n(temp,0),3) /)
      end do

      mean_monthly_precipitation  := y
      stdev_monthly_precipitation := z



    x := fin->potential_evapotranspiration
      x!0        := "month"
      x&month    := month
      x&ensemble := ensemble
      if (max(year) .le. 2005) then
        x := x(:,:,0:0,:,:)
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      x&scenario        := scenario
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
        y(k,:,:,:,:) := (/ round(  dim_avg_n(temp,0),3)   /)
        z(k,:,:,:,:) := (/ round( dim_stddev_n(temp,0),3) /)
      end do

      mean_potential_evapotranspiration  := y
      stdev_potential_evapotranspiration := z



    x := fin->evapotranspiration
      x!0        := "month"
      x&month    := month
      x&ensemble := ensemble
      if (max(year) .le. 2005) then
        x := x(:,:,0:0,:,:)
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      x&scenario        := scenario
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
        y(k,:,:,:,:) := (/ round(  dim_avg_n(temp,0),3)   /)
        z(k,:,:,:,:) := (/ round( dim_stddev_n(temp,0),3) /)
      end do

      mean_evapotranspiration  := y
      stdev_evapotranspiration := z


    x := fin->storage
      x!0        := "month"
      x&month    := month
      x&ensemble := ensemble
      if (max(year) .le. 2005) then
        x := x(:,:,0:0,:,:)
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      x&scenario        := scenario
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
        y(k,:,:,:,:) := (/  round( dim_avg_n(temp,0),3)   /)
        z(k,:,:,:,:) := (/ round( dim_stddev_n(temp,0),3) /)
      end do

      mean_storage  := y
      stdev_storage := z


    x := fin->snowpack
      x!0        := "month"
      x&month    := month
      x&ensemble := ensemble
      if (max(year) .le. 2005) then
        x := x(:,:,0:0,:,:)
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      x&scenario        := scenario
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
        y(k,:,:,:,:) := (/ round( dim_avg_n(temp,0),3)   /)
        z(k,:,:,:,:) := (/ round( dim_stddev_n(temp,0),3) /)
      end do

      mean_snowpack  := y
      stdev_snowpack := z



    x := fin->deficit
      x!0        := "month"
      x&month    := month
      x&ensemble := ensemble
      if (max(year) .le. 2005) then
        x := x(:,:,0:0,:,:)
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      x&scenario        := scenario
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
        y(k,:,:,:,:) := (/ round( dim_avg_n(temp,0),3)   /)
        z(k,:,:,:,:) := (/ round( dim_stddev_n(temp,0),3) /)
      end do

      mean_deficit  := y
      stdev_deficit := z



    x := fin->recharge
      x!0        := "month"
      x&month    := month
      x&ensemble := ensemble
      if (max(year) .le. 2005) then
        x := x(:,:,0:0,:,:)
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      x&scenario        := scenario
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
        y(k,:,:,:,:) := (/ round( dim_avg_n(temp,0),3)   /)
        z(k,:,:,:,:) := (/ round( dim_stddev_n(temp,0),3) /)
      end do

      mean_recharge  := y
      stdev_recharge := z



    x := fin->surplus
      x!0        := "month"
      x&month    := month
      x&ensemble := ensemble
      if (max(year) .le. 2005) then
        x := x(:,:,0:0,:,:)
      else
        if (min(year) .lt. 2005) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:index_hist,:,1,:,:) = x(:index_hist,:,0,:,:)
        end if
      end if
      x&scenario        := scenario
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
        y(k,:,:,:,:) := (/ round( dim_avg_n(temp,0),3)   /)
        z(k,:,:,:,:) := (/ round( dim_stddev_n(temp,0),3) /)
      end do

      mean_surplus  := y
      stdev_surplus := z

    fout->climatology_period = climatology_period
    fout->climatology_start_year = climatology_start_year
    fout->climatology_end_year = climatology_end_year
    fout->climatology_duration = climatology_duration
    fout->month = month
    fout->ensemble = ensemble
    fout->scenario = scenario
    fout->lon = lon
    fout->lat = lat
    fout->climatology_bnds = climatology_bnds
    fout->lon_bnds = lon_bnds
    fout->lat_bnds = lat_bnds

    f->mean_monthly_temperature          = mean_monthly_temperature
    f->mean_monthly_precipitation        = mean_monthly_precipitation
    f->mean_potential_evapotranspiration = mean_potential_evapotranspiration
    f->mean_evapotranspiration           = mean_evapotranspiration
    f->mean_storage                      = mean_storage
    f->mean_snowpack                     = mean_snowpack
    f->mean_deficit                      = mean_deficit
    f->mean_recharge                     = mean_recharge
    f->mean_surplus                      = mean_surplus


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



end
