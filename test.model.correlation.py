import numpy as np

models = [ "bccr_bcm2_0", "cccma_cgcm3_1", "cccma_cgcm3_1_t63","cnrm_cm3",
  "csiro_mk3_0", "csiro_mk3_5" , "gfdl_cm2_0",  "gfdl_cm2_1", "giss_aom",
  "giss_model_e_h", "giss_model_e_r", "iap_fgoals1_0_g", "ingv_echam4",
   "inmcm3_0", "ipsl_cm4", "miroc3_2_hires", "miroc3_2_medres",
   "miub_echo_g", "mpi_echam5", "mri_cgcm2_3_2a", "ncar_ccsm3_0", "ncar_pcm1"
   ,"ukmo_hadcm3", "ukmo_hadgem1"]

np.set_printoptions(precision=2)

def correl():
	for eof in [ 1, 2 ]:
		cook=[]
		glue=[]
		for model in models:
			fmod = '{0}/run1/dtred/{0}.space{1}.txt'.format(model,eof)
			fobs = '../../sst-data/detrend/ersst.space{0}.txt'.format(eof)
			eof_mod = np.loadtxt(fmod)
			print fmod
			eof_obs = np.loadtxt(fobs)
			#print eof_mod[0:40]
			idm = np.where(eof_mod == 999.)
			ido = np.where(eof_obs == 999.)
			eof_mod = np.delete(eof_mod, idm)
			eof_obs = np.delete(eof_obs, idm)
			cook.append([ model, np.corrcoef(eof_mod, eof_obs)[0, 1]] )
			
			fmodpc = '{0}/run1/dtred/PC{1}.{0}.txt'.format(model,eof)
			fobspc = '../../sst-data/detrend/PC{0}.annual.txt'.format(eof)
			pc_mod = np.loadtxt(fmodpc)
			pc_obs = np.loadtxt(fobspc)
			#print pc_mod.shape, pc_obs.shape
			glue.append([model, np.corrcoef(pc_mod, pc_obs)[0, 1]] )

	# --- Writing spatial correlation from models and Observation - EOF
		npcook = np.array(cook)
		np.savetxt('eof{0}.ar4.correl.txt'.format(eof), npcook, fmt= '%s     %6s')

	# --- Writing time correlation from models and Observation - PC
		npglue = np.array(glue)
		np.savetxt('pc{0}.ar4.correl.txt'.format(eof), npglue, fmt= '%s     %6s')
#correl()

def test_signal_correl():
	for eof in [ 1, 2 ]:
		cook=[]
		#glue=[]
		feof = 'eof{0}.ar4.correl.txt'.format(eof)
		fpc  = 'pc{0}.ar4.correl.txt'.format(eof)
		cor_eof = np.loadtxt(feof, usecols = (1,))
		cor_pc  = np.loadtxt(fpc, usecols = (1,))
		for ii in range(len(cor_eof)):
			#if cor_eof[ii] >=  0.5 and cor_eof[ii] > 0:
			#	cook.append(['{1} - EOF {0}'.format(eof, models[ii])])
			#	print models[ii], cor_eof[ii]
			#if cor_eof[ii] <= -0.5 and cor_eof[ii] < 0:
				
			cook.append(['{1} - EOF {0}'.format(eof, models[ii])])
			print models[ii], cor_eof[ii]
		cook = np.array(cook)
		#np.savetxt('modelstobeanalyzed_EOF{0}.txt'.format(eof), cook, fmt='%s')
		np.savetxt('allmodel_EOF{0}.txt'.format(eof), cook, fmt='%s')
		
		print '\nEOF {0}'.format(eof)
		
test_signal_correl()

#~ define grid/t=xt gg
#~ file/var=obs/grid=gg "../../sst-data/ersst.${TRI}.space2.txt" 
#~ file/var=mod/grid=gg "${MODEL}/run1/${MODEL}.${TRI}.space2.txt" 
#~ l/bad=999.0000/q p=obs[d=5]
#~ l/bad=999.0000/q q=mod[d=6]
#~ go variance
#~ list/nohead/append/file=spc.correl.$MODEL.$TRI.txt correl
#~ 
#~ !if \`correl ge 0.80\` then
    #~ define axis/t=1:87:1 tt
    #~ define grid/t=tt gg
    #~ file/var=oo/grid=gg "../../sst-data/PC2.${TRI}.txt"
    #~ file/var=mm/grid=gg "${MODEL}/run1/PC2.$TRI.$MODEL.txt"
    #~ l/q p=oo[d=7]
    #~ l/q q=mm[d=8]
    #~ go variance
    #~ list/nohead/append/file=time.correl.$MODEL.$TRI.txt correl
#~ 
#~ !elif \`correl le (-0.80)\` then
#~ !    file/var=oo/grid=gg "../../sst-data/PC2.${TRI}.txt"
#~ !    file/var=mm/grid=gg "${MODEL}/run1/PC2.$TRI.$MODEL.txt"
#~ !    l/q p=oo[d=7]
#~ !    l/q q=mm[d=8]
#~ !    go variance
#~ !    list/nohead/append/file=time.correl.$MODEL.$TRI.txt correl
#~ 
#~ !endif
#~ 
#~ EOF
#~ 
#~ ferret -script test.jnl
#~ 
#~ echo $MODEL $TRI
#~ cat spc.correl.$MODEL.$TRI.txt time.correl.$MODEL.$TRI.txt
#~ read
#~ done
#~ 
#~ 
#~ done
