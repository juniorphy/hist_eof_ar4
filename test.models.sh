#!/bin/bash

DIR=`pwd`

for MODEL in bccr_bcm2_0 cccma_cgcm3_1 cccma_cgcm3_1_t63 cnrm_cm3 csiro_mk3_0 csiro_mk3_5 gfdl_cm2_0 gfdl_cm2_1 giss_aom giss_model_e_h giss_model_e_r iap_fgoals1_0_g ingv_echam4 inmcm3_0 ipsl_cm4 miroc3_2_hires miroc3_2_medres miub_echo_g mpi_echam5 mri_cgcm2_3_2a ncar_ccsm3_0 ncar_pcm1 ukmo_hadcm3 ukmo_hadgem1; do 

echo $MODEL
for TRI in DJF MAM; do
echo $TRI
cat << EOF > test.jnl
define axis/t=1:1125:1 xt
define grid/t=xt gg
file/var=obs/grid=gg "../../sst-data/ersst.${TRI}.space1.txt" 
file/var=mod/grid=gg "${MODEL}/run1/${MODEL}.${TRI}.space1.txt" 
l/bad=999.0000/q p=obs[d=1]
l/bad=999.0000/q q=mod[d=2]

go variance
list/nohead/clobber/file=spc.correl.$MODEL.$TRI.txt correl

!if \`correl ge 0.80\` then
    define axis/t=1:87:1 tt
    define grid/t=tt gg
    file/var=oo/grid=gg "../../sst-data/PC1.${TRI}.txt"
    file/var=mm/grid=gg "${MODEL}/run1/PC1.$TRI.$MODEL.txt"
    l/q p=oo[d=3]
    l/q q=mm[d=4]
    go variance
    list/nohead/clobber/file=time.correl.$MODEL.$TRI.txt correl
!elif \`correl le (-0.80)\` then
!    define axis/t=1:87:1 tt
!    define grid/t=tt gg    
!    file/var=oo/grid=gg "../../sst-data/PC1.${TRI}.txt"
!    file/var=mm/grid=gg "${MODEL}/run1/PC1.$TRI.$MODEL.txt"
!    l/q p=oo[d=3]
!    l/q q=mm[d=4]
!    go variance
!    list/nohead/clobber/file=time.correl.$MODEL.$TRI.txt correl
!endif

define axis/t=1:1125:1 xt
define grid/t=xt gg
file/var=obs/grid=gg "../../sst-data/ersst.${TRI}.space2.txt" 
file/var=mod/grid=gg "${MODEL}/run1/${MODEL}.${TRI}.space2.txt" 
l/bad=999.0000/q p=obs[d=5]
l/bad=999.0000/q q=mod[d=6]
go variance
list/nohead/append/file=spc.correl.$MODEL.$TRI.txt correl

!if \`correl ge 0.80\` then
    define axis/t=1:87:1 tt
    define grid/t=tt gg
    file/var=oo/grid=gg "../../sst-data/PC2.${TRI}.txt"
    file/var=mm/grid=gg "${MODEL}/run1/PC2.$TRI.$MODEL.txt"
    l/q p=oo[d=7]
    l/q q=mm[d=8]
    go variance
    list/nohead/append/file=time.correl.$MODEL.$TRI.txt correl

!elif \`correl le (-0.80)\` then
!    file/var=oo/grid=gg "../../sst-data/PC2.${TRI}.txt"
!    file/var=mm/grid=gg "${MODEL}/run1/PC2.$TRI.$MODEL.txt"
!    l/q p=oo[d=7]
!    l/q q=mm[d=8]
!    go variance
!    list/nohead/append/file=time.correl.$MODEL.$TRI.txt correl

!endif

EOF

ferret -script test.jnl

echo $MODEL $TRI
cat spc.correl.$MODEL.$TRI.txt time.correl.$MODEL.$TRI.txt
read
done


done
