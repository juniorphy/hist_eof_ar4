	program correlation
	implicit real*4	(a-h,m-z)
	!dimension lat(61),lon(180)
	parameter(nt=360,nm=12)
       dimension obs1(nt),obs2(nt),mod1(nt),mod2(nt),anom1(nt),anom2(nt)
	dimension clim1(nm),clim2(nm),clio1(nm),clio2(nm),anoo1(nt)
        dimension anoo2(nt),grm(nt),gro(nt)
	character*50 fn1
        character*50 fn2
	data fn1/'grad.mensal.inmcm3_0.1970.1999.txt'/
	data fn2/'grad.mensal.ERSST.1970.1999.txt'/
	
        print*, trim(fn1)        

	open(20,file=trim(fn1))
	open(30,file=trim(fn2))

!abrindo os arquivos

	do k=1,nt
	   read(20,*)mod1(k),mod2(k)
	   read(30,*)obs1(k),obs2(k)
	enddo

!fazendo climatologia

	do l=1,nm
           sm1=0.0
           sm2=0.0
           so1=0.0
	   so2=0.0
           do iy=1,30
!	   write(*,*) 
           sm1=sm1+mod1(l+(iy-1)*12)
           sm2=sm2+mod2(l+(iy-1)*12)
	   so1=so1+obs1(l+(iy-1)*12)
           so2=so2+obs2(l+(iy-1)*12)
           
!          ic=ic+1
	   enddo
           sm1 = sm1/30.
           sm2 = sm2/30.
           so1 = so1/30.
	   so2 = so2/30.
           clim1(l) = sm1
           clim2(l) = sm2
           clio1(l) = so1
           clio2(l) = so2
           write(*,*) clim1(l),clim2(l),clio1(l),clio2(l)
       enddo
! calculo das anomalias       
       do ic=1,nt
          jj=mod(ic-1,12)+1
          anom1(ic) = mod1(ic)- clim1(jj)
          anom2(ic) = mod2(ic)- clim2(jj)
          anoo1(ic) = obs1(ic)- clio1(jj)
          anoo2(ic) = obs2(ic)- clio2(jj)
          grm(ic)   = anom1(ic) - anom2(ic)
          gro(ic)   = anoo1(ic) - anoo2(ic)    
       enddo

!!calculo da correlação

	summod=0.
	sumobs=0.
	summod2=0.
	sumobs2=0.
	sumprod=0.
	do k=1,nt
	   summod=summod+grm(k)
	   sumobs=sumobs+gro(k)
	   sumprod=sumprod+grm(k)*gro(k)
	   summod2=summod2+grm(k)*grm(k)
	   sumobs2=sumobs2+gro(k)*gro(k)
	enddo	
	write(*,*)summod,sumobs,sumprod,summod2,sumobs2

	correl1=30.*sumprod-summod*sumobs
	correl2=sqrt(30.*summod2-summod*summod)
	correl3=sqrt(30.*sumobs2-sumobs*sumobs)

	correl=correl1/correl2/correl3

!	if (sst(1).eq.-999.) correl=-999.

!escrevendo no arquivo
	write(*,'(f9.3)') correl	

!encerrando o programa      
	close(20)
        close(30)
	do ii=1,12
	print*, mod1(ii)
	enddo
	stop
	end
