
OS_NAME=`uname`
HOST_NAME=`hostname`


echo ****************
echo *****************

export PERIOD_STRING="1976-2005"
export    START_DATE="1976-01-01 00:00:00.0"
export      END_DATE="2005-12-31 00:00:00.0"
export            NY=30



ncpdq --permut time,ensemble,scenario,lat,lon temp.nc temp2.nc

    directory="/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornwaite_Budget"
    directory="/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornwaite_Budget"

    directory="."

    master_file=${directory}/LOCAL_TREWARTHA_ALL_ENSEMBLES.nc
    # master_file="http://kyrill.ias.sdsmt.edu:8080/thredds/dodsC/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornwaite_Budget/LOCAL_TREWARTHA_ALL_ENSEMBLES.nc"

     outdir=${directory}/climatology/${PERIOD_STRING}
    #  outfile=${outdir}/LOCAL_CHEYENNE_THORTHWAITE_${PERIOD_STRING}.nc


     export SUBSETFILE=tw_${PERIOD_STRING}.nc
     echo
     echo Using Period String = ${PERIOD_STRING} clipping file
     echo
     echo Processing  seldate ${START_DATE} - ${END_DATE}
     echo
     echo  ncks -d time,\'${START_DATE}\',\'${END_DATE}\' ${master_file} ${SUBSETFILE}
     echo
          ncks -d time,\'${START_DATE}\',\'${END_DATE}\' ${master_file} ${SUBSETFILE}
     echo

     ncks -d time,'1950-01-01 00:00:00.0','1979-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_1950-1979.nc
     ncks -d time,'2000-01-01 00:00:00.0','2029-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2000-2029.nc
     ncks -d time,'2036-01-01 00:00:00.0','2065-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2036-2065.nc
     ncks -d time,'2070-01-01 00:00:00.0','2099-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2070-2099.nc
     ncks -d time,'1950-01-01 00:00:00.0','1959-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_1950-1959.nc
     ncks -d time,'1960-01-01 00:00:00.0','1969-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_1960-1969.nc
     ncks -d time,'1970-01-01 00:00:00.0','1979-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_1970-1979.nc
     ncks -d time,'1980-01-01 00:00:00.0','1989-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_1980-1989.nc
     ncks -d time,'1990-01-01 00:00:00.0','1999-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_1990-1999.nc
     ncks -d time,'2000-01-01 00:00:00.0','2009-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2000-2009.nc
     ncks -d time,'2010-01-01 00:00:00.0','2019-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2010-2019.nc
     ncks -d time,'2020-01-01 00:00:00.0','2029-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2020-2029.nc
     ncks -d time,'2030-01-01 00:00:00.0','2039-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2030-2039.nc
     ncks -d time,'2040-01-01 00:00:00.0','2049-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2040-2049.nc
     ncks -d time,'2050-01-01 00:00:00.0','2059-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2050-2059.nc


     ncks -d time,'2050-01-01 00:00:00.0','2059-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2050-2059.nc

     ncks -d time,'2060-01-01 00:00:00.0','2069-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2060-2069.nc
     ncks -d time,'2070-01-01 00:00:00.0','2079-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2070-2079.nc
     ncks -d time,'2080-01-01 00:00:00.0','2089-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2080-2089.nc
     ncks -d time,'2090-01-01 00:00:00.0','2099-12-31 00:00:00.0' ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc tw_2090-2099.nc



     #!/bin/bash
     FILES=./tw_*.nc
     for f in $FILES
     do
       years=`echo $f | cut -c6-14`
       echo "Processing $f file..."
       mv -v $f ./LOCAL_TREWARTHA_ALL_ENSEMBLES_${years}.nc
     done
