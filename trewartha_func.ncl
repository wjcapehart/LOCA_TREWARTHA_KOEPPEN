
undef("wjc_trewartha_func")
function wjc_trewartha_func(T_mean,  \
                            P_month, \
                            latitude )
local trewartha_string, \
      trewartha_legend, \
      warm_season,      \
      cold_season,      \
      pe,               \
      dry_summer,       \
      wet_summer,       \
      p_lt_60,          \
      n_gt_18,          \
      n_gt_10,          \
      n_gt_00
begin


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



   if (latitude .ge. 0) then
      warm_season  = (/ 4, 5, 6,  7,  8,  9 /) - 1
      cold_season  = (/ 1, 2, 3, 10, 11, 12 /) - 1
   else
      cold_seaon  = (/ 4, 5, 6,  7,  8,  9 /) - 1
      warm_season = (/ 1, 2, 3, 10, 11, 12 /) - 1
   end if

   pe = 10*(avg(T_mean)-10) + 300 * sum(P_month(warm_season)) / sum(P_month)

   n_gt_18 = dimsizes( ind(T_mean .ge. 18)  )
   n_gt_10 = dimsizes( ind(T_mean .ge. 10)  )
   n_gt_00 = dimsizes( ind(T_mean .ge.  0)  )

   p_lt_60 = dimsizes( ind(P_month .lt. 60)  )

   dry_summer = (min(P_month(warm_season)) .lt.  30) .and. (min(P_month(warm_season)) .lt.  max(P_month(cold_season))/3 )
   dry_winter = (max(P_month(warm_season)) .gt.  min(P_month(cold_season))*10 )



   ;;;  Screen for Desert Climates (BW)
   if (sum(P_month) .lt. pe) then
      if (max(T_mean).ge. 22.2) then
         trewartha = 6 ; BWh
      else
         trewartha = 7 ; BWk
      end if
   else
      ;;;  Screen for Steppe Climates (BS)
      if ((sum(P_month) .ge. pe) .and. (sum(P_month) .le. 2*pe) )  then
         if (max(T_mean).ge. 22.2) then
            trewartha = 4 ; BSh
         else
            trewartha = 5 ; BSk
         end if
      else
         ;;;  Screen for Tropical (A)
         if ( min(T_mean).gt.18) then
            if (p_lt_60 .le. 2)  then
               trewartha = 1 ; Ar
            else
               if ( sum(P_month(cold_season)) .lt. sum(P_month(warm_season)) ) then
                  trewartha = 2 ; Aw
               else
                  trewartha = 3 ; As
               end if
            end if
         else
            if (n_gt_10 .ge. 8) then
               if (dry_summer .and. (sum(P_month).lt.890)) then
                  if (max(T_mean).ge. 22.2) then
                     trewartha = 10 ; Csa
                  else
                     trewartha = 11 ; Csb
                  end if
               else
                  if (dry_winter .and. (sum(P_month).lt.890)) then
                     if (max(T_mean).ge. 22.2) then
                        trewartha = 12 ; Cwa
                     else
                        trewartha = 13 ; Cwb
                     end if
                  else
                     if (max(T_mean).ge. 22.2) then
                        trewartha = 8 ; Cfa
                     else
                        trewartha = 9 ; Cfb
                     end if
                  end if
               end if
            else
               if (( 4 .le. n_gt_10) .and. (n_gt_10 .le. 7) ) then
                     if (min(T_mean) .gt. 0) then
                        trewartha = 14 ; Do
                     else
                        if (max(T_mean).ge. 22.2) then
                           trewartha = 15 ; Dca
                        else
                           trewartha = 16 ; Dcb
                        end if
                     end if
               else
                  if (max(T_mean) .ge. 10) then
                        if (min(T_mean) .gt. -10) then
                           trewartha = 17 ; Eo
                        else
                           trewartha = 18 ; Ec
                        end if
                  else
                     if (10 .gt. (max(T_mean)) .and. (max(T_mean) .gt. 0)) then
                        rewartha(yy, jj, ii) = 19 ; Ft
                     else
                        if (max(T_mean) .le. 0) then
                           trewartha = 20 ; Fi
                        end if
                     end if
                  end if
               end if
            end if
         end if
      end if
   end if

   return(trewartha)

end
