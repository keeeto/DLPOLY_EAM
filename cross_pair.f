

	IMPLICIT none
	INTEGER  i,j,k,nlines,mlines,Int_q
	character(len=2):: ATOM_1, ATOM_2
	REAL::PAIR_1(100000,4),PAIR_2(100000,4)
	REAL::EMBE_1(100000,4),EMBE_2(100000,4)
	REAL::PAIR_3(100000,4),lim_u,lim_l,fract_q
	REAL::mpoints,npoints,npts,Rel_q
	character(len=20)::JUNK

!	OPEN THE DATA FILES

	open(unit=1,file='PAIR_U.1',status='unknown')
	open(unit=2,file='PAIR_U.2',status='unknown')
	open(unit=3,file='EMBE_U.1',status='unknown')
	open(unit=4,file='EMBE_U.2',status='unknown')


!	READ THE HEADERS
	READ(1,*) JUNK,ATOM_1,ATOM_1,npoints,lim_l,lim_u
	READ(2,*) JUNK,ATOM_2,ATOM_2,npoints,lim_l,lim_u
	READ(3,*) JUNK,JUNK,mpoints,lim_l,lim_u
	READ(4,*) JUNK,JUNK,mpoints,lim_l,lim_u
	
	Int_q=INT(npoints/4)
	Rel_q=(npoints/4)
	if(Rel_q.gt.Int_q)nlines=(npoints/4)+1
	if(Rel_q.eq.Int_q)nlines=(npoints/4)

	Int_q=INT(mpoints/4)
	Rel_q=(mpoints/4)
	if(Rel_q.gt.Int_q)mlines=(mpoints/4)+1
	if(Rel_q.eq.Int_q)mlines=(mpoints/4)

!	READ THE DATA

	do i=1,nlines
	 READ(1,*) PAIR_1(i,1),PAIR_1(i,2),PAIR_1(i,3),PAIR_1(i,4)
	enddo
	do i=1,nlines
	 READ(2,*) PAIR_2(i,1),PAIR_2(i,2),PAIR_2(i,3),PAIR_2(i,4)
	enddo
	do i=1,mlines
	 READ(3,*) EMBE_1(i,1),EMBE_1(i,2),EMBE_1(i,3),EMBE_1(i,4)
	enddo
	do i=1,mlines
	 READ(4,*) EMBE_2(i,1),EMBE_2(i,2),EMBE_2(i,3),EMBE_2(i,4)
	enddo

!	CALCULATE THE CROSS POTENTIAL

	do i=1,nlines
	do j=1,4
	 PAIR_3(i,j)=0.5*((EMBE_2(i,j)/EMBE_1(i,j))*PAIR_1(i,j)+
     .               (EMBE_1(i,j)/EMBE_2(i,j))*PAIR_2(i,j))
	enddo
	enddo
!	GOOD TO HERE

	open(unit=3,file='PAIR.CROSS',status='unknown')
        WRITE(3,*) "pair   ",ATOM_1,"    ", ATOM_2, npoints,
     .             lim_l, lim_u 
	do i=1,nlines
	 WRITE(3,10) PAIR_3(i,1),PAIR_3(i,2),PAIR_3(i,3),PAIR_3(i,4)
	enddo

10      FORMAT(E12.6,2x,E12.6,2x,E12.6,2x,E12.6)
	END PROGRAM
