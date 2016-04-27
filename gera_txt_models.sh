DIR=`pwd`

echo $DIR

for MODEL in bccr_bcm2_0 cccma_cgcm3_1 cccma_cgcm3_1_t63 cnrm_cm3 csiro_mk3_0 csiro_mk3_5 gfdl_cm2_0 gfdl_cm2_1 giss_aom giss_model_e_h giss_model_e_r iap_fgoals1_0_g ingv_echam4 inmcm3_0 ipsl_cm4 miroc3_2_hires miroc3_2_medres miub_echo_g mpi_echam5 mri_cgcm2_3_2a ncar_ccsm3_0 ncar_pcm1 ukmo_hadcm3 ukmo_hadgem1; do 

#for MODEL in ncar_ccsm3_0; do 

cp ${DIR}/temporary.ersst.glb.70.99.nc $MODEL/run1

cd $MODEL/run1
echo MODEL $MODEL 
fin=`ls -1 tos_O1*.nc`
echo $fin

#cdo setcalendar,standard -sellonlatbox,-90,20,-60,60 -seldate,1970-1-1,1999-12-31 -remapbil,"temporary.ersst.glb.70.99.nc" $fin "temporary.${fin}"

cdo setcalendar,standard -sellonlatbox,-90,10,-60,60 -seldate,1970-1-1,1999-12-31 $fin "temporary.${fin}"

cat << EOF > gera_txt.jnl 
set mem/size=700
use "temporary.${fin}"
!use "temporary.ersst.glb.70.99.nc"
!show data/var
!set var/bad=-999. tos
!let atn = tos[y=5:20@ave,x=-50:-20@ave,d=1]
!let ats = tos[y=-20:-5@ave,x=-30:0@ave,d=1]
!let ertn = sst[y=5:20@ave,x=-50:-20@ave,d=2]
!let erts = sst[y=-20:-5@ave,x=-30:0@ave,d=2]
list/clobber/form=(300f10.2)/file="${DIR}/tos.mensal.default.grid.$MODEL.1945.1993.txt" tos
!list/nohead/form=(2f8.3)/clobber/file="${DIR}/grad.ersst.mensal.$MODEL.1970.1999.txt" atn, ats
!list/nohead/form=(2f8.3)/clobber/file="${DIR}/grad.mensal.ERSST.1970.1999.txt" ertn, erts

!
EOF
ferret -script gera_txt.jnl


rm -f temporary.${fin}

cd ${DIR}

done
