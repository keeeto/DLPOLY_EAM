

	IMPLICIT none
	INTEGER i,ngrid,Int_q
	REAL :: rho(10000),U(10000),rho_e,rho_o
	REAL :: eta,F_n1,F_n2,F_n3,F_1,F_2,F_3,F_e
	REAL :: F_0,F_n0,Rel_q
	REAL :: lim_min,lim_max,grid_space
	character(len=2)::ATOM_TYPE

	open(unit=1,file='embed_mod.dat',status='unknown')
	open(unit=2,file='TABEAM.embedding.Ag',status='unknown')
	READ(1,*) ATOM_TYPE
	READ(1,*) lim_min, lim_max
        READ(1,*) F_n1,F_n2,F_n3,F_1,F_2,F_3,F_e
	READ(1,*) F_n0,F_0 
        READ(1,*) rho_e,eta
	READ(1,*) grid_space
!	Begin to write the TABEAM file
	ngrid = INT((lim_max-lim_min)/grid_space)
        WRITE(2,*) "embe  ",ATOM_TYPE, ngrid, lim_min, lim_max
	ngrid = INT((lim_max-lim_min)/grid_space)
!       Calculate the values of rho(i)
        DO i=0,INT((lim_max-lim_min)/grid_space)
           rho(i)=lim_min+i*grid_space
        ENDDO
!	Calculate the values of U(i)
 	DO i=0,INT((lim_max-lim_min)/grid_space)
!	Lower values of rho
	   IF(rho(i).lt.0.85*rho_e)THEN
	      U(i)=F_n0 +
     .	           F_n1*(rho(i)/(0.85*rho_e) - 1) +
     .	           F_n2*(rho(i)/(0.85*rho_e) - 1)**2 +
     .	           F_n3*(rho(i)/(0.85*rho_e) - 1)**3
	   ENDIF
!	Intermediate values of rho
	   IF(rho(i).ge.0.85*rho_e)THEN
	   IF(rho(i).lt.1.15*rho_e)THEN
	      U(i)=F_0 +
     .	           F_1*(rho(i)/(rho_e) - 1) +
     .	           F_2*(rho(i)/(rho_e) - 1)**2 +
     .	           F_3*(rho(i)/(rho_e) - 1)**3
	   ENDIF
	   ENDIF
!	High values of rho
	   IF(rho(i).ge.1.15*rho_e)THEN
	      U(i)=F_e*(1 - ALOG((rho(i)/rho_e)**eta))*
     .	           (rho(i)/rho_e)**eta
	   ENDIF
	ENDDO
        Int_q=INT(ngrid/4)
        Rel_q=(ngrid/4)
        if(Rel_q.gt.Int_q)ngrid=ngrid+1
        if(Rel_q.eq.Int_q)ngrid=ngrid
        DO i=1,ngrid,4
           WRITE(2,10) U(i),U(i+1),U(i+2),U(i+3)
        ENDDO	

10      FORMAT(E12.6,2x,E12.6,2x,E12.6,2x,E12.6)
	END PROGRAM
