
import numpy as np

from glob import glob 
np.set_printoptions(precision=1)
#onlyfiles = listdir('grad.mensal.*.txt')
onlyfiles = sorted(glob('./grad.default*.txt'))
#print onlyfiles

for fname in onlyfiles:
        ped = fname.split('.')
	model = np.loadtxt(fname)
	obs = np.loadtxt("grad.mensal.ERSST.1970.1999.txt")

	atn = model[:,0]
	ats = model[:,1]

	aon = obs[:,0]
	aos = obs[:,1]

	mn = np.reshape(atn,[30,12])
	ms = np.reshape(ats,[30,12])

	on = np.reshape(aon,[30,12])
	os = np.reshape(aos,[30,12])

	clin = np.mean(mn,axis=0)
	clis = np.mean(ms,axis=0)

	clon = np.mean(on,axis=0)
	clos = np.mean(os,axis=0)

	ann = mn - clin
	ans = ms - clis

	onn = on - clon
	ons = os - clos

	grad = ann - ans
	obs = onn - ons

#	print grad.shape
#	print obs.shape

	fma_m = np.mean(grad[:,1:4],axis=1)
	fma_o = np.mean(obs[:,1:4],axis=1)

#	for ii in range(30):
#		print fma_m[ii], fma_o[ii] 
        a= np.corrcoef(fma_m,fma_o)[1,0]
        print ped[4] ,' ', np.array(a)

	
