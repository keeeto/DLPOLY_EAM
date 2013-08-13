	IMPLICIT none
	REAL :: f_e,beta,r_e,lambda,n
	REAL :: r(10000),U(10000),grid_space
	REAL :: lim_min,lim_max,Rel_q
	INTEGER i,ngrid,Int_q
	character(len=2):: ATOM_TYPE
        open(unit=1,file='dens_mod.dat',status='unknown')
        open(unit=2,file='TABEAM.density.Ag',status='unknown')
        n=20
	READ(1,*) ATOM_TYPE
        READ(1,*) lim_min, lim_max
        READ(1,*) f_e,beta,r_e,lambda
        READ(1,*) grid_space
!       Calculate the values of r(i)
        DO i=0,INT((lim_max-lim_min)/grid_space)
           r(i)=lim_min+i*grid_space
        ENDDO

	ngrid = INT((lim_max-lim_min)/grid_space)
!	Begin writing the output file
	WRITE(2,*) "dens    ",ATOM_TYPE, ngrid, lim_min, lim_max

!	Calculate the potential
        DO i=0,INT((lim_max-lim_min)/grid_space)
	   U(i)=(f_e*EXP(-beta*(r(i)/r_e - 1)))/
     .	   (1 + (r(i)/r_e - lambda)**n)
	ENDDO
!	Write Calculated potential to file
        Int_q=INT(ngrid/4)
        Rel_q=(ngrid/4)
        if(Rel_q.gt.Int_q)ngrid=ngrid+1
        if(Rel_q.eq.Int_q)ngrid=ngrid
	DO i=1,ngrid,4
	   WRITE(2,10) U(i),U(i+1),U(i+2),U(i+3)
	ENDDO


10	FORMAT(E12.6,2x,E12.6,2x,E12.6,2x,E12.6)
13	FORMAT(4X,3x,I5,E10.6,E10.6)
	END
