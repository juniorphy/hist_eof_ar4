#!/bin/bash 
#-------------------------------------------------
# Universidade Federal do Ceará- UFC
# Pós-Graduação em Engenharia Hidraúlica e Ambiental
#
# Script: Fazendo ftp do ipcc
#          "Este script faz ftp dos dados do ipcc"
#
# Por: M.Sc.Cleiton Silveira
#
# Última Modificação: 10 de novembro de 2010
#
# -----------------------------------------------
#
# Adapted by Junior Vasconcelos juniorphy@gmail.com
# To convert netcdf to Grib. 
# November-19-2013
#------------------------------------------------

DIR=`pwd`

#if [ -z $1 ] ;then
#echo Defina um caminho de saídas para os dados.
#exit 1
#fi  

#echo "SITE -  ftp:/ftp-esg.ucllnl.org     "
#echo "    USUARIO = 'assis'               "
#echo "    PASSWORD='19081966'             " 

faz_ftp(){
#for MODEL in  bccr_bcm2_0 cccma_cgcm3_1 cccma_cgcm3_1_t63 cnrm_cm3 csiro_mk3_0 csiro_mk3_5 gfdl_cm2_0 gfdl_cm2_1 giss_aom giss_model_e_h giss_model_e_r iap_fgoals1_0_g ingv_echam4 inmcm3_0 ipsl_cm4 miroc3_2_hires miroc3_2_medres miub_echo_g mpi_echam5 mri_cgcm2_3_2a ncar_ccsm3_0 ncar_pcm1 ukmo_hadcm3 ukmo_hadgem1; do 		
for MODEL in  ingv_echam4 inmcm3_0 ipsl_cm4 miroc3_2_hires miroc3_2_medres miub_echo_g mpi_echam5 mri_cgcm2_3_2a ncar_ccsm3_0 ncar_pcm1 ukmo_hadcm3 ukmo_hadgem1; do 		
#for MODEL in ukmo_hadgem1; do 		

	cd $DIR
	mkdir $MODEL
	cd $MODEL
	mkdir run1

	USUARIO=assis
	PASS=19081966
	SITE=ftp-esg.ucllnl.org     
	DIRLC=$DIR/$MODEL/run1
	DIREM=/20c3m/ocn/mo/tos/$MODEL/run1
	ARQ=*
	ncftpget -u $USUARIO -p $PASS $SITE $DIRLC ${DIREM}/${ARQ} 

	cd $DIR/$MODEL
	for RUN in run1 ; do
		chmod 777 *
		cd $DIR/$MODEL/$RUN
		chmod 777 *
		for ARQ in `ls -1 *nc`; do
			if [ -z $ARQ ]; then
   				clear
   				echo " "
   				echo "Nao existe" 		
   				echo " "
				cd $DIR/$MODEL
				rm -rfv $RUN

			fi
			#echo "existe"
            #            echo Criando grib!!!
            #             ncatted -a calendar,time,o,c,"gregorian" $ARQ
            #            lats4d.sh -format grads_grib -i $ARQ -o $ARQ -mxtimes 45000
		done
	done
done
}
faz_ftp
	
exit


