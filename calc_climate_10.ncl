




begin
  setfileoption("nc", "Format",  "NetCDF4")
  setfileoption("nc", "CompressionLevel", 8)

  delta_t = 10h
    start_years := toshort(ispan(1950,2090,delta_t))

; delta_t := 30h
;  start_years := (/ 1950h, 1970h, 1976h, 2000h, 2011h, 2036h, 2061h, 2070h /)




  print(start_years)

  do ii = 0, dimsizes(start_years)-1


    climatology_start_year                    := start_years(ii)
    climatology_start_year@long_name          = "Climatology Start Year"
    climatology_start_year@description        = climatology_start_year@long_name
    climatology_start_year@standard_name      = "time"
    climatology_start_year@units              = "years since 0000-01-01 00:00:00"
    climatology_start_year@calendar           = "standard"
    climatology_start_year!0                  = "climatology_period"



    climatology_end_year                    := toshort(start_years(ii) + delta_t - 1h)
    climatology_end_year@long_name          = "Climatology End Year"
    climatology_end_year@description        = climatology_end_year@long_name
    climatology_end_year@standard_name      = "time"
    climatology_end_year@units              = "years since 0000-01-01 00:00:00"
    climatology_end_year@calendar           = "standard"
    climatology_end_year!0                  = "climatology_period"



    climatology_period                    := sprinti("%0.4i",climatology_start_year) + "-" +sprinti("%0.4i",climatology_end_year)
    climatology_period@long_name          = "Climatology Period"
    climatology_period@description        = climatology_period@long_name
    climatology_period!0                  = "climatology_period"
    climatology_period&climatology_period = climatology_period


    climatology_start_year&climatology_period = climatology_period
    climatology_end_year&climatology_period = climatology_period



    climatology_duration    = (/ delta_t  /)
    climatology_duration@long_name = "length of climatology period"
    climatology_duration@description = "length of climatology period"
    climatology_duration@standard_name = "time"
    climatology_duration!0 = "climatology_period"
    climatology_duration&climatology_period = climatology_period




    in_file    := "http://kyrill.ias.sdsmt.edu:8080/thredds/dodsC/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornthwaite_Budgets/"+climatology_duration+"-yr/LOCA_THORNTHWAITE_ALL_ENSEMBLES_"+climatology_period+".nc"
    in_file    =              "/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornthwaite_Budgets/"+climatology_duration+"-yr/LOCA_THORNTHWAITE_ALL_ENSEMBLES_"+climatology_period+".nc"
    out_file   :=             "/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornthwaite_Budgets/"+climatology_duration+"-yr/LOCA_THORNTHWAITE_ALL_ENSEMBLES_CLIM_"+climatology_period+".nc"


    fin  := addfile(in_file, "r")
    system("rm -frv " + out_file)









    time      := fin->time

    scenario              := chartostring(fin->scenario)
      scenario@long_name   = "Scenario"
      scenario@description = scenario@long_name
      scenario!0           = "scenario"
      scenario&scenario    = scenario


    ensemble              := chartostring(fin->ensemble)
      ensemble@long_name   = "Ensemble"
      ensemble@description = ensemble@long_name
      ensemble!0           = "ensemble"
      ensemble&ensemble    = ensemble


    lon       := fin->lon
    lat       := fin->lat
    lat_bnds  := fin->lat_bnds
    lon_bnds  := fin->lon_bnds
    time_bnds := fin->time_bnds

    nx = dimsizes(lon)
    ny = dimsizes(lat)
    nt = dimsizes(time)
    ne = dimsizes(ensemble)
    ns = dimsizes(scenario)

    climatology_bnds                    = new((/  1,2 /), "double")
    climatology_bnds(0,0)               = todouble(min(time_bnds))
    climatology_bnds(0,1)               = todouble(max(time_bnds))
    climatology_bnds@long_name          = "Climate Period Bounds"
    climatology_bnds@description        = climatology_bnds@long_name
    climatology_bnds@standard_name      = "time"
    climatology_bnds@calendar           = "standard"
    climatology_bnds@units              = time@units
    climatology_bnds!0                  = "climatology_period"
    climatology_bnds&climatology_period = climatology_period
    climatology_bnds!1                  = "bnds"


    climatology_year_bnds                   := new((/  1,2 /), "short")
    climatology_year_bnds(0,0)               = toshort(climatology_start_year)
    climatology_year_bnds(0,1)               = toshort(climatology_end_year)
    climatology_year_bnds@long_name          = "Climate Period Bounds"
    climatology_year_bnds@description        = climatology_bnds@long_name
    climatology_year_bnds@standard_name      = "time"
    climatology_year_bnds@calendar           = "standard"
    climatology_year_bnds@units              = climatology_start_year@units
    climatology_year_bnds!0                  = "climatology_period"
    climatology_year_bnds&climatology_period = climatology_period
    climatology_year_bnds!1                  = "bnds"
    climatology_bnds&climatology_period      = climatology_period

    time_parts := cd_calendar(time, -5)

    year            := time_parts(:,0)
      year!0         = "year"
      year&year      = year
      year@long_name = "year"

    month                     := toshort(time_parts(:,1))
      month!0                  = "month"
      month&month              = month
      month@long_name          = "Calendar Month"
      month@description        = month@long_name
      month@units              = "month"
      month@calendar_month_LUT = (/ "January", "February", "March","April","May","June","July","August","September","October","November","December" /)
      month@comment            = "calendar month LUT indexing starts at 0, 0=January, 11=December"


    X := fin->mean_temperature
      x := reshape(X, (/ 1, nt, ne, ns, ny, nx  /))
      copy_VarAtts(fin->mean_temperature, x)
      print(x@long_name)
      x!0     = "climatology_period"
      x!1     = "month"
      x!2     = "ensemble"
      x!3     = "scenario"
      x!4     = "lat"
      x!5     = "lon"
      x&climatology_period = climatology_period
      x&month              = month
      x&ensemble           = ensemble
      x&scenario           = scenario
      x&lat                = lat
      x&lon                = lon
        if ((min(year) .lt. 2005) .and. (max(year) .gt. 2005)) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:,:index_hist,:,1,:,:) = x(:,:index_hist,:,0,:,:)
        end if
      y := x(:,0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + X@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(:,0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + X@long_name
        z@description  := z@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(:,ind(month .eq. k+1),:,:,:,:)
        y(:,k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,1),3)) /)
        z(:,k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,1),3)) /)
      end do

      mean_monthly_temperature  := y
      stdev_monthly_temperature := z

    X := fin->total_precipitation
      x := reshape(X, (/ 1, nt, ne, ns, ny, nx  /))
      copy_VarAtts(fin->total_precipitation, x)
      print(x@long_name)
      x!0     = "climatology_period"
      x!1     = "month"
      x!2     = "ensemble"
      x!3     = "scenario"
      x!4     = "lat"
      x!5     = "lon"
      x&climatology_period = climatology_period
      x&month              = month
      x&ensemble           = ensemble
      x&scenario           = scenario
      x&lat                = lat
      x&lon                = lon
        if ((min(year) .lt. 2005) .and. (max(year) .gt. 2005)) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:,:index_hist,:,1,:,:) = x(:,:index_hist,:,0,:,:)
        end if
      y := x(:,0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + X@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(:,0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + X@long_name
        z@description  := z@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(:,ind(month .eq. k+1),:,:,:,:)
        y(:,k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,1),3)) /)
        z(:,k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,1),3)) /)
      end do

      mean_monthly_precipitation  := y
      stdev_monthly_precipitation := z



    X := fin->potential_evapotranspiration
      x := reshape(X, (/ 1, nt, ne, ns, ny, nx  /))
      copy_VarAtts(fin->potential_evapotranspiration, x)
      print(x@long_name)
      x!0     = "climatology_period"
      x!1     = "month"
      x!2     = "ensemble"
      x!3     = "scenario"
      x!4     = "lat"
      x!5     = "lon"
      x&climatology_period = climatology_period
      x&month              = month
      x&ensemble           = ensemble
      x&scenario           = scenario
      x&lat                = lat
      x&lon                = lon
        if ((min(year) .lt. 2005) .and. (max(year) .gt. 2005)) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:,:index_hist,:,1,:,:) = x(:,:index_hist,:,0,:,:)
        end if
      y := x(:,0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + X@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(:,0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + X@long_name
        z@description  := z@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(:,ind(month .eq. k+1),:,:,:,:)
        y(:,k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,1),3)) /)
        z(:,k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,1),3)) /)
      end do


      mean_potential_evapotranspiration  := y
      stdev_potential_evapotranspiration := z



    X := fin->evapotranspiration
      x := reshape(X, (/ 1, nt, ne, ns, ny, nx  /))
      copy_VarAtts(fin->evapotranspiration, x)
      print(x@long_name)
      x!0     = "climatology_period"
      x!1     = "month"
      x!2     = "ensemble"
      x!3     = "scenario"
      x!4     = "lat"
      x!5     = "lon"
      x&climatology_period = climatology_period
      x&month              = month
      x&ensemble           = ensemble
      x&scenario           = scenario
      x&lat                = lat
      x&lon                = lon
        if ((min(year) .lt. 2005) .and. (max(year) .gt. 2005)) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:,:index_hist,:,1,:,:) = x(:,:index_hist,:,0,:,:)
        end if
      y := x(:,0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + X@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(:,0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + X@long_name
        z@description  := z@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(:,ind(month .eq. k+1),:,:,:,:)
        y(:,k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,1),3)) /)
        z(:,k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,1),3)) /)
      end do


      mean_evapotranspiration  := y
      stdev_evapotranspiration := z


    X := fin->storage
      x := reshape(X, (/ 1, nt, ne, ns, ny, nx  /))
      copy_VarAtts(fin->storage, x)
      print(x@long_name)
      x!0     = "climatology_period"
      x!1     = "month"
      x!2     = "ensemble"
      x!3     = "scenario"
      x!4     = "lat"
      x!5     = "lon"
      x&climatology_period = climatology_period
      x&month              = month
      x&ensemble           = ensemble
      x&scenario           = scenario
      x&lat                = lat
      x&lon                = lon
        if ((min(year) .lt. 2005) .and. (max(year) .gt. 2005)) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:,:index_hist,:,1,:,:) = x(:,:index_hist,:,0,:,:)
        end if
      y := x(:,0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + X@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(:,0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + X@long_name
        z@description  := z@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(:,ind(month .eq. k+1),:,:,:,:)
        y(:,k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,1),3)) /)
        z(:,k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,1),3)) /)
      end do

      mean_storage  := y
      stdev_storage := z


    X := fin->snowpack
      x := reshape(X, (/ 1, nt, ne, ns, ny, nx  /))
      copy_VarAtts(fin->snowpack, x)
      print(x@long_name)
      x!0     = "climatology_period"
      x!1     = "month"
      x!2     = "ensemble"
      x!3     = "scenario"
      x!4     = "lat"
      x!5     = "lon"
      x&climatology_period = climatology_period
      x&month              = month
      x&ensemble           = ensemble
      x&scenario           = scenario
      x&lat                = lat
      x&lon                = lon
        if ((min(year) .lt. 2005) .and. (max(year) .gt. 2005)) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:,:index_hist,:,1,:,:) = x(:,:index_hist,:,0,:,:)
        end if
      y := x(:,0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + X@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(:,0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + X@long_name
        z@description  := z@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(:,ind(month .eq. k+1),:,:,:,:)
        y(:,k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,1),3)) /)
        z(:,k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,1),3)) /)
      end do

      mean_snowpack  := y
      stdev_snowpack := z



    X := fin->deficit
      x := reshape(X, (/ 1, nt, ne, ns, ny, nx  /))
      copy_VarAtts(fin->deficit, x)
      print(x@long_name)
      x!0     = "climatology_period"
      x!1     = "month"
      x!2     = "ensemble"
      x!3     = "scenario"
      x!4     = "lat"
      x!5     = "lon"
      x&climatology_period = climatology_period
      x&month              = month
      x&ensemble           = ensemble
      x&scenario           = scenario
      x&lat                = lat
      x&lon                = lon
        if ((min(year) .lt. 2005) .and. (max(year) .gt. 2005)) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:,:index_hist,:,1,:,:) = x(:,:index_hist,:,0,:,:)
        end if
      y := x(:,0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + X@long_name
        y@description  := X@long_name
        y@cell_methods := "time : monthly mean"
      z := x(:,0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + X@long_name
        z@description  := z@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(:,ind(month .eq. k+1),:,:,:,:)
        y(:,k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,1),3)) /)
        z(:,k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,1),3)) /)
      end do

      mean_deficit  := y
      stdev_deficit := z



    X := fin->recharge
      x := reshape(X, (/ 1, nt, ne, ns, ny, nx  /))
      copy_VarAtts(fin->recharge, x)
      print(x@long_name)
      x!0     = "climatology_period"
      x!1     = "month"
      x!2     = "ensemble"
      x!3     = "scenario"
      x!4     = "lat"
      x!5     = "lon"
      x&climatology_period = climatology_period
      x&month              = month
      x&ensemble           = ensemble
      x&scenario           = scenario
      x&lat                = lat
      x&lon                = lon
        if ((min(year) .lt. 2005) .and. (max(year) .gt. 2005)) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:,:index_hist,:,1,:,:) = x(:,:index_hist,:,0,:,:)
        end if
      y := x(:,0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + X@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(:,0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + X@long_name
        z@description  := z@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(:,ind(month .eq. k+1),:,:,:,:)
        y(:,k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,1),3)) /)
        z(:,k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,1),3)) /)
      end do

      mean_recharge  := y
      stdev_recharge := z



    X := fin->surplus
      x := reshape(X, (/ 1, nt, ne, ns, ny, nx  /))
      copy_VarAtts(fin->surplus, x)
      print(x@long_name)
      x!0     = "climatology_period"
      x!1     = "month"
      x!2     = "ensemble"
      x!3     = "scenario"
      x!4     = "lat"
      x!5     = "lon"
      x&climatology_period = climatology_period
      x&month              = month
      x&ensemble           = ensemble
      x&scenario           = scenario
      x&lat                = lat
      x&lon                = lon
        if ((min(year) .lt. 2005) .and. (max(year) .gt. 2005)) then
          index_hist = ind((month .eq. 12) .and. (year .eq. 2005))
          x(:,:index_hist,:,1,:,:) = x(:,:index_hist,:,0,:,:)
        end if
      y := x(:,0:11,:,:,:,:)
        y@long_name    := "Mean Monthly " + X@long_name
        y@description  := y@long_name
        y@cell_methods := "time : monthly mean"
      z := x(:,0:11,:,:,:,:)
        z@long_name    := "StDev Monthly " + X@long_name
        z@description  := z@long_name
        z@cell_methods := "time : monthly standard deviation"
      do k = 0,11
        temp         := x(:,ind(month .eq. k+1),:,:,:,:)
        y(:,k,:,:,:,:) = (/ toshort(round(    dim_avg_n(temp,1),3)) /)
        z(:,k,:,:,:,:) = (/ toshort(round( dim_stddev_n(temp,1),3)) /)
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

    delete(mean_monthly_temperature&month)
    delete(mean_monthly_precipitation&month)
    delete(mean_potential_evapotranspiration&month)
    delete(mean_evapotranspiration&month)
    delete(mean_storage&month)
    delete(mean_snowpack&month)
    delete(mean_deficit&month)
    delete(mean_recharge&month)
    delete(mean_surplus&month)

    delete(stdev_monthly_temperature&month)
    delete(stdev_monthly_precipitation&month)
    delete(stdev_potential_evapotranspiration&month)
    delete(stdev_evapotranspiration&month)
    delete(stdev_storage&month)
    delete(stdev_snowpack&month)
    delete(stdev_deficit&month)
    delete(stdev_recharge&month)
    delete(stdev_surplus&month)

    delete(mean_monthly_temperature!1)
    delete(mean_monthly_precipitation!1)
    delete(mean_potential_evapotranspiration!1)
    delete(mean_evapotranspiration!1)
    delete(mean_storage!1)
    delete(mean_snowpack!1)
    delete(mean_deficit!1)
    delete(mean_recharge!1)
    delete(mean_surplus!1)

    delete(stdev_monthly_temperature!1)
    delete(stdev_monthly_precipitation!1)
    delete(stdev_potential_evapotranspiration!1)
    delete(stdev_evapotranspiration!1)
    delete(stdev_storage!1)
    delete(stdev_snowpack!1)
    delete(stdev_deficit!1)
    delete(stdev_recharge!1)
    delete(stdev_surplus!1)

    mean_monthly_temperature!1          = "month"
    mean_monthly_precipitation!1        = "month"
    mean_potential_evapotranspiration!1 = "month"
    mean_evapotranspiration!1           = "month"
    mean_storage!1                      = "month"
    mean_snowpack!1                     = "month"
    mean_deficit!1                      = "month"
    mean_recharge!1                     = "month"
    mean_surplus!1                      = "month"

    stdev_monthly_temperature!1          = "month"
    stdev_monthly_precipitation!1        = "month"
    stdev_potential_evapotranspiration!1 = "month"
    stdev_evapotranspiration!1           = "month"
    stdev_storage!1                      = "month"
    stdev_snowpack!1                     = "month"
    stdev_deficit!1                      = "month"
    stdev_recharge!1                     = "month"
    stdev_surplus!1                      = "month"

    mean_monthly_temperature&month          = month
    mean_monthly_precipitation&month        = month
    mean_potential_evapotranspiration&month = month
    mean_evapotranspiration&month           = month
    mean_storage&month                      = month
    mean_snowpack&month                     = month
    mean_deficit&month                      = month
    mean_recharge&month                     = month
    mean_surplus&month                      = month

    stdev_monthly_temperature&month          = month
    stdev_monthly_precipitation&month        = month
    stdev_potential_evapotranspiration&month = month
    stdev_evapotranspiration&month           = month
    stdev_storage&month                      = month
    stdev_snowpack&month                     = month
    stdev_deficit&month                      = month
    stdev_recharge&month                     = month
    stdev_surplus&month                      = month

    print("writing period " + climatology_period)
    print("   time bounds " + climatology_bnds(0,0)      + " to " + climatology_bnds(0,1) )
    print("   year bounds " + climatology_year_bnds(0,0) + " to " + climatology_year_bnds(0,1) )
    print(" period length " + climatology_duration)

    fout := addfile(out_file,"c")

    fout->climatology_period = climatology_period

    delete(fout)

    print("ncks -h --mk_rec_dmn climatology_period " +out_file + " deleteme.nc")
    system("ncks -h --mk_rec_dmn climatology_period " +out_file + " deleteme.nc")
    print("mv deleteme.nc " + out_file   )
    system("mv deleteme.nc " + out_file   )

    fout := addfile(out_file,"w")


    fout->month                 = month
    fout->ensemble              = ensemble
    fout->lon                   = lon
    fout->lat                   = lat
    fout->climatology_bnds      = climatology_bnds
    fout->lon_bnds              = lon_bnds
    fout->lat_bnds              = lat_bnds
    fout->climatology_year_bnds = climatology_year_bnds
    fout->climatology_duration  = climatology_duration

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



    delete(mean_monthly_temperature)
    delete(mean_monthly_precipitation)
    delete(mean_potential_evapotranspiration)
    delete(mean_evapotranspiration)
    delete(mean_storage)
    delete(mean_snowpack)
    delete(mean_deficit)
    delete(mean_recharge)
    delete(mean_surplus)

    delete(stdev_monthly_temperature)
    delete(stdev_monthly_precipitation)
    delete(stdev_potential_evapotranspiration)
    delete(stdev_evapotranspiration)
    delete(stdev_storage)
    delete(stdev_snowpack)
    delete(stdev_deficit)
    delete(stdev_recharge)
    delete(stdev_surplus)
    delete(X)
    delete(x)
    delete(y)
    delete(z)
    delete(month)
    delete(ensemble)
    delete(scenario)
    delete(lat)
    delete(lon)
    delete(lon_bnds)
    delete(lat_bnds)
    delete(time_bnds)
    delete(time)
    delete(climatology_year_bnds)
    delete(climatology_duration)
    delete(climatology_period)
    delete(climatology_bnds)
    delete(climatology_start_year)
    delete(climatology_end_year)
    delete(k)
    delete(temp)
    delete(in_file)
    delete(out_file)


     print("-------------------")
  end do

  system("rm -vf /maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornthwaite_Budgets/LOCA_THORNTHWAITE_ALL_ENSEMBLES_CLIM_"+delta_t+"-yr.nc"   )
  print("ncrcat  /maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornthwaite_Budgets/"+delta_t+"-yr/LOCA_THORNTHWAITE_ALL_ENSEMBLES_CLIM_*-*.nc   /maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornthwaite_Budgets/LOCA_THORNTHWAITE_ALL_ENSEMBLES_CLIM_"+delta_t+"-yr.nc"    )

  system("ncrcat /maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornthwaite_Budgets/"+delta_t+"-yr/LOCA_THORNTHWAITE_ALL_ENSEMBLES_CLIM_*-*.nc   /maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornthwaite_Budgets/LOCA_THORNTHWAITE_ALL_ENSEMBLES_CLIM_"+delta_t+"-yr.nc"    )

end
