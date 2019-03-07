


load "./trewartha_func.ncl"




undef("calcPolygonAreaAndCentroid")
function calcPolygonAreaAndCentroid(x, y, firstVert, lastVert)
  local cY, cY, a, tmp
begin
  cX = 0.d
  cY = 0.d
  area = 0.d
  do i=firstVert,lastVert
    if (i .eq. lastVert) then
      j = firstVert
    else
      j = i + 1
    end if
    tmp = x(i)*y(j) - x(j)*y(i)
    area = area + tmp
    cX = cX + (x(i) + x(j))*tmp
    cY = cY + (y(i) + y(j))*tmp
  end do

  area = area / 2.0
  cX = cX / (6.0 * area)
  cY = cY / (6.0 * area)

  ; recall that the area calculation may yield a negative result, 
  ; depending upon CW vs. CCW ordering of the vertices.
  return (/ abs(area), cX, cY /)
end


begin
;************************************************
; get pointer to netcdf file with polygons
;************************************************

dir = "/accounts/wcapehar/Thornthwaite/NCL/"

 fname = dir+"climdiv_polygons2.nc"
 ncdf = addfile(fname,"r")

 climate_data = dir+"ncdc_divisional_climate_zone_data_and_thornthwaite_mather_water_budgets_1895-2016.nc"
 fclim = addfile(climate_data,"r")

    number_of_years = 15; 
    
    state_and_zone_string = fclim->state_and_zone_string
    state_and_zone        = fclim->state_and_zone
    state_indicies        = fclim->state_indicies
    state_abrevs          = fclim->state_abrevs
    state_and_zone        = fclim->state_and_zone

    year                  = fclim->year
    month                 = fclim->month
    time2d                = fclim->time
    caldate2d             = fclim->caldate
    temperature2d         = fclim->mean_monthly_temperature
    precipitation2d       = fclim->total_monthly_precip

    ny = dimsizes(year)
    nm = dimsizes(month)
    nz = dimsizes(state_and_zone)



   trewartha_string = (/   "U",   \ ;  0
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

   trewartha_legend = (/   "Unclassified",                \ ; "U",   \ ;  0
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

   trewartha_colors = (/   "white",         \ ;  "Foreground",                  \ ; "NA",   \ ;  0
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



   nclasses = dimsizes(trewartha_legend)


    time                  = time2d(ny-1-(number_of_years-1), :)
       time!0             = "time"
       time&time          =  time
       copy_VarAtts(time2d,time)
       nt = dimsizes(time)
       copy_VarAtts(time2d,time)
       time@calendarconv = cd_calendar(time,-1)

    precipitation                   = dim_avg_n_Wrap(precipitation2d(:,ny-1-(number_of_years-1):ny-1, :),1)
       precipitation!0              = "state_and_zone"
       precipitation!1              = "time"
       precipitation&state_and_zone =  state_and_zone
       precipitation&time           =  time
       copy_VarAtts(precipitation2d,precipitation)
       precipitation@calendarconv = cd_calendar(time,-1)


    temperature                   = dim_avg_n_Wrap(temperature2d(:,ny-1-(number_of_years-1):ny-1, :),1)
       temperature!0              = "state_and_zone"
       temperature!1              = "time"
       temperature&state_and_zone =  state_and_zone
       temperature&time           =  time
       copy_VarAtts(temperature2d,temperature)
       temperature@calendarconv = cd_calendar(time,-1)

 

    trewartha_class  = new( nz, integer )
       trewartha_class!0 ="state_and_zone"
       trewartha_class&state_and_zone        = state_and_zone
       trewartha_class@state_abrevs          = state_abrevs
       trewartha_class@state_indicies        = state_indicies
       trewartha_class@state_and_zone_string = state_and_zone_string
       trewartha_class@trewartha_legend      = trewartha_legend
       trewartha_class@trewartha_string      = trewartha_string


   do k = 0, nz-1 
      trewartha_class(k) = wjc_trewartha_func(temperature(k,:), precipitation(k,:), 1) 
      print(state_and_zone_string(k)+" "+ trewartha_string(trewartha_class(k)))
   end do


;************************************************
; some parameters
;************************************************
  statenames = new((/48/),"string")

; climate divisions in each state                   
  ncds = new((/48/),"integer")
 statenames = (/ "AL","AR","AZ","CA","CO","CT","DE","FL","GA","IA","ID","IL", \
                 "IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT", \
                 "NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA", \
                 "RI","SC","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY" /)
  ncds =      (/   8,   9,   7,   7,   5,   3,   2,   6,   9,   9,  10,   9, \
                   9,   9,   4,   9,   3,   8,   3,  10,   9,   6,  10,   7, \
                   8,   9,   8,   2,   3,   8,   4,  10,  10,   9,   9,  10, \
                   1,   7,   9,   4,  10,   7,   7,   3,  10,   9,   6,  10  /)
         
  npoly = sum(ncds)   ; number of polygons to draw
;************************************************
; create the plot
;************************************************
 wks = gsn_open_wks ("pdf",dir+"Climate_Trewartha_M"+sprinti("%0.2i", number_of_years*12))     ; send graphics to PNG file
 
gsn_define_colormap(wks, trewartha_colors)  

 res=True
      
; map resources for projection
 res@mpLambertParallel1F = 33.0         ; two parallels
 res@mpLambertParallel2F = 45.0
 res@mpLambertMeridianF  = -95.0        ; central meridian

 res@mpLimitMode         = "LatLon"     ; limit map via lat/lon
 res@mpMinLatF           = 26.0         ; map area
 res@mpMaxLatF           = 50.0         ; latitudes
 res@mpMinLonF           = -120.0       ; and
 res@mpMaxLonF           = -73.0        ; longitudes
 
; map resources
 res@mpDataBaseVersion   = "Ncarg4_1"   ; change database
 res@mpFillOn            = True         ; fill continents
 res@mpPerimOn           = False        ; no box around map

 res@mpAreaMaskingOn        = True                 ; draw only parts of map 
 res@mpFillAreaSpecifiers   = (/"Water","Land"/)   ; what parts to fill
 res@mpSpecifiedFillColors  = (/0,0/)              ; fill with background color
 res@mpOutlineBoundarySets  = "USStates"           ; what outlines to use
 res@mpMaskAreaSpecifiers   = (/"Conterminous US"/); don't fill here
 res@mpGridAndLimbOn        = False                ; no lat/lon lines
    res@gsnMaximize        = False                ; no lat/lon lines

; increase viewport size (make map bigger)
 res@vpWidthF  = 0.93
 res@vpHeightF = 0.93
 res@vpXF      = 0.05
 res@vpYF      = 0.99   
      
 res@gsnDraw  = False       ; don't draw the plots now
 res@gsnFrame = False       ; or advance the frame

 plot = gsn_map(wks,"LambertConformal",res) ; create the plot   
 
; polygon resources
  res_poly             = True
  res_poly@gsEdgesOn   = True       ; draw border around polygons
  res_poly@gsEdgeColor = "black"    


polygons_per_class = new(nz,integer)

polygons_per_class(:) = 0

;**************************************************
; prepare to draw polygons
;**************************************************
  srand (12345)                ; set the seed for the random number generator
;*********************************************
; get the polygon data and fill polygons with 
; random colors using the default color table
;*********************************************
  do st = 1, 48
    do cd = 1, ncds(st-1)

       working_cd = cd

       if (statenames(st-1) .eq. "NE") then
          if (cd .eq. 4) then
             working_cd = 7
          end if
          if (cd .eq. 7) then
             working_cd =8
          end if
          if (cd .eq. 8) then
             working_cd = 9
          end if
       end if

      if (statenames(st-1) .eq. "VA") then
          if (cd .eq. 7) then
             working_cd =1
          end if
       end if

      varstr2 = statenames(st-1)+"_CD"+working_cd
      varstr = statenames(st-1)+"_CD"+cd

      indtarget = ind(state_and_zone_string .eq. varstr2)


      x = ncdf->$varstr$@lon                 ; lon stored in attribute
      y = ncdf->$varstr$@lat                 ; lat stored in attribute


      statsout = calcPolygonAreaAndCentroid(x, y, 0, dimsizes(x)-1)


      if(ismissing(indtarget)) then
         res_poly@gsFillColor = 0
      else
         res_poly@gsFillColor = trewartha_class(indtarget)+2
         polygons_per_class(trewartha_class(indtarget))  =   polygons_per_class(trewartha_class(indtarget))  + 1
      end if
      gsn_polygon (wks,plot,x,y,res_poly)
      tres       =  True
      tres@txFontHeightF = 0.005
      gsn_text(wks,plot,varstr2,statsout(1) ,statsout(2),tres)
;      gsn_text(wks,plot,trewartha_string(trewartha_class(indtarget)),statsout(1) ,statsout(2),tres)
      delete(varstr)
      delete(x)
      delete(y)
    end do
  end do
;********************************************
; Add a title to the plot in NDC Coordinates
;********************************************
 res_txt               = True                ; text resources
 res_txt@txFontHeightF = 0.016               ; select font size 
 gsn_text_ndc (wks,"Trewartha Categories", 0.5,0.78,res_txt) ; add text
 gsn_text_ndc (wks,"Number of Months: "+(number_of_years*12),0.5,0.76,res_txt) ; add text
 frame(wks)

do k = 1, nclasses-1
    print(polygons_per_class(k) + " " +trewartha_legend(k) + "  ("+ trewartha_string(k)+ ")")
end do



;;;;;;;;;;;;;;;;;
; Make Temp/Precip plots.

;  

   pcp                    = dim_avg_n_Wrap(precipitation2d(:,ny-1-(number_of_years-1):ny-1, :),1)
       pcp!0              = "state_and_zone"
       pcp!1              = "time"
       pcp&state_and_zone =  state_and_zone
       pcp&time           =  (/ 1,2,3,4,5,6,7,8,9,10,11,12 /)
       copy_VarAtts(precipitation2d,pcp)
       pcp@calendarconv = cd_calendar(time2d(ny-1-(number_of_years-1), :),-1)


    tmp                   = dim_avg_n_Wrap(temperature2d(:,ny-1-(number_of_years-1):ny-1, :),1)
       tmp!0              = "state_and_zone"
       tmp!1              = "time"
       tmp&state_and_zone =  state_and_zone
       tmp&time           =  (/ 1,2,3,4,5,6,7,8,9,10,11,12 /)
       copy_VarAtts(temperature2d,temperature)
       tmp@calendarconv = cd_calendar(time2d(ny-1-(number_of_years-1), :),-1)

class = trewartha_class

do k = 1, nclasses-1


if (any(class.eq.k)) then



    print(polygons_per_class(k) + " " +trewartha_legend(k) + "  ("+ trewartha_string(k)+ ")")

     add_zone = new(polygons_per_class(k)  , graphic)


     plotmap = gsn_map(wks,"LambertConformal",res) ; create the plot   
     zzz = 0
  do st = 1, 48
    do cd = 1, ncds(st-1)

       working_cd = cd

       if (statenames(st-1) .eq. "NE") then
          if (cd .ge. 4) then
             working_cd = 7
          end if
          if (cd .ge. 7) then
             working_cd =8
          end if
          if (cd .ge. 8) then
             working_cd = 8
          end if
       end if

      if (statenames(st-1) .eq. "VA") then
          if (cd .ge. 7) then
             working_cd =1
          end if
       end if

      varstr2 = statenames(st-1)+"_CD"+working_cd
      varstr = statenames(st-1)+"_CD"+cd

      indtarget = ind(state_and_zone_string .eq. varstr2)


      x = ncdf->$varstr$@lon                 ; lon stored in attribute
      y = ncdf->$varstr$@lat                 ; lat stored in attribute
      
      x@units = "degrees_east"
      y@units = "degrees_north"


      statsout = calcPolygonAreaAndCentroid(x, y, 0, dimsizes(x)-1)


      if(ismissing(indtarget)) then
         res_poly@gsFillColor = 0
      else
         res_poly@gsFillColor = class(indtarget)+2
      end if
      if (class(indtarget) .eq.k) then 
         add_zone(zzz) = gsn_add_polygon (wks,plotmap,x,y,res_poly)
         zzz = zzz + 1
      end if
      delete(varstr)
      delete(x)
      delete(y)
    end do
  end do

   
resP                 = True
 resP@txString = trewartha_legend(k) + "  ("+ trewartha_string(k)+ ")"
 gsn_panel(wks,(/ plotmap /),(/2,2/),resP)


delete(add_zone)
end if
end do ; if there... 


end
