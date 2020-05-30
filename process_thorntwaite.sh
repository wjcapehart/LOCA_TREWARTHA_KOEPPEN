#!/bin/bash


OS_NAME=`uname`
HOST_NAME=`hostname`


echo ****************
echo *****************







    directory="/maelstrom2/LOCA_GRIDDED_ENSEMBLES/LOCA_NGP/Specific_Regional_Aggregate_Sets/cheyenne_basin/DERIVED/Thornwaite_Budget"

    cd   ${directory}

   # setting the Setting the Available ensembles
   #   currently only those members that have hits
   #   for all three variables!

     declare -a ENSEMBLE=( "ACCESS1-0_r1i1p1"
                           "ACCESS1-3_r1i1p1"
                           "CCSM4_r6i1p1"
                           "CESM1-BGC_r1i1p1"
                           "CESM1-CAM5_r1i1p1"
                           "CMCC-CMS_r1i1p1"
                           "CMCC-CM_r1i1p1"
                           "CNRM-CM5_r1i1p1"
                           "CSIRO-Mk3-6-0_r1i1p1"
                           "CanESM2_r1i1p1"
                           "FGOALS-g2_r1i1p1"
                           "GFDL-CM3_r1i1p1"
                           "GFDL-ESM2G_r1i1p1"
                           "GFDL-ESM2M_r1i1p1"
                           "HadGEM2-AO_r1i1p1"
                           "HadGEM2-CC_r1i1p1"
                           "HadGEM2-ES_r1i1p1"
                           "IPSL-CM5A-LR_r1i1p1"
                           "IPSL-CM5A-MR_r1i1p1"
                           "MIROC-ESM-CHEM_r1i1p1"
                           "MIROC-ESM_r1i1p1"
                           "MIROC5_r1i1p1"
                           "MPI-ESM-LR_r1i1p1"
                           "MPI-ESM-MR_r1i1p1"
                           "MRI-CGCM3_r1i1p1"
                           "NorESM1-M_r1i1p1"
                           "bcc-csm1-1-m_r1i1p1" )


  for ENS in "${ENSEMBLE[@]}"
  do
    echo
    echo
    echo --------------------------------------
    echo
    echo Processing ${ENS}
    echo

    filename=./LOCAL_CHEYENNE_THORTHWAITE_${ENS}.nc

    echo
    echo Converting ensemble to the Record Variable
    echo
    echo nohup ncks -h --mk_rec_dmn ensemble  ${filename} temp.nc
         nohup ncks -h --mk_rec_dmn ensemble  ${filename} temp.nc


    echo
    echo Compress and Convert File
    echo
    echo nohup nccopy -7 -d 9 ./temp.nc ${filename}
         nohup nccopy -7 -d 9 ./temp.nc ${filename}
         rm -frv ./temp.nc




  done

  echo  nohup ncrcat         ./LOCAL_CHEYENNE_THORTHWAITE_*.nc ./LOCAL_TREWARTHA_ALL.nc
        nohup ncrcat         ./LOCAL_CHEYENNE_THORTHWAITE_*.nc ./LOCAL_TREWARTHA_ALL.nc

  echo  nohup nccopy -4 -d 9 ./LOCAL_TREWARTHA_ALL.nc          ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc
        nohup nccopy -4 -d 9 ./LOCAL_TREWARTHA_ALL.nc          ./LOCAL_TREWARTHA_ALL_ENSEMBLES.nc
        rm -frv              ./LOCAL_TREWARTHA_ALL.nc ./nohup.out
  echo
  echo
  echo "We're Out of Here Like Vladimir"
  echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
