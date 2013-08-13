
	IMPLICIT none
	REAL :: alpha,beta,r_eq,A,B
	REAL :: kappa, lambda, m, n, fe
	REAL :: r(10000),U(10000),lim_min,lim_max
	REAL :: grid_space,Rel_q                                   ! The spacing between intervals of the potential
	INTEGER i,j,k,ngrid,Int_q
	character(len=2)::ATOM_TYPE
	open(unit=1,file='morse_mod.dat',status='unknown')
	open(unit=2,file='TABEAM.Pair.Ag',status='unknown')


	m=20
	n=20
	READ(1,*) ATOM_TYPE
	READ(1,*) lim_min, lim_max
	READ(1,*) A, alpha, r_eq, kappa
	READ(1,*) B, beta, lambda
	READ(1,*) grid_space

	ngrid = INT((lim_max-lim_min)/grid_space)
        WRITE(2,*) "pair   ",ATOM_TYPE,"    ", ATOM_TYPE, ngrid, 
     .  lim_min, lim_max
!	Calculate the values of r(i)

	DO i=0,INT((lim_max-lim_min)/grid_space)
	   r(i)=lim_min+i*grid_space
	ENDDO

!	Calculate the potential
	DO i=0,INT((lim_max-lim_min)/grid_space)


	   U(i)=(A*EXP(-alpha*(r(i)/r_eq - 1)))/
     .	        (1 + (r(i)/r_eq - kappa)**m)
     .	        -(B*EXP(-beta*(r(i)/r_eq - 1)))/
     .	        (1 + (r(i)/r_eq - lambda)**n)     
	ENDDO
        Int_q=INT(ngrid/4)
        Rel_q=(ngrid/4)
        if(Rel_q.gt.Int_q)ngrid=ngrid+1
        if(Rel_q.eq.Int_q)ngrid=ngrid
        DO i=1,ngrid,4
           WRITE(2,10) U(i),U(i+1),U(i+2),U(i+3)
        ENDDO
	
10      FORMAT(E12.6,2x,E12.6,2x,E12.6,2x,E12.6)
	END
