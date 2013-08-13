#!/bin/csh


	set NoAtoms=$1
	set n=1

#  CREATE THE STANDARD SET OF EAMs (Pair, Density, Embedding)
	while ($n < $NoAtoms)
	cp morse_mod.dat.$n morse_mod.dat
	./morse.exe
#	awk '{if($1 != "0.000000E+00"){print $0}}' 
	cat TABEAM.Pair.Ag > PAIR.$n
	cp dens_mod.dat.$n dens_mod.dat
	./density.exe
#	awk '{if($1 != "0.000000E+00"){print $0}}' 
	cat TABEAM.density.Ag > DENSITY.$n

	cp embed_mod.dat.$n embed_mod.dat
	./embedding.exe
#	awk '{if($1 != "0.000000E+00"){print $0}}' 
        cat TABEAM.embedding.Ag > EMBEDDING.$n
	@ n = ( $n + 1 )
        end

	
# CREATE THE CROSS PAIRS
	set n=1
	set j=0
	set k=1
        @ x = ( $NoAtoms - 1 )

	while ($n < $x)
	 cp PAIR.$n PAIR_U.1
	 cp DENSITY.$n EMBE_U.1
	 @ j = ( $n + 1 )
	  while ($j < $NoAtoms)
	   cp PAIR.$j PAIR_U.2
	   cp DENSITY.$j EMBE_U.2
           ./cross_pair.exe
           awk '{if($1 != "0.000000E+00"){print $0}}' PAIR.CROSS > CROSS.$k 
  	   @ k = ( $k + 1 )
  	   @ j = ( $j + 1 )
	  end
	@ n = ( $n + 1 )
	end

	
	set number1=0
	@ j = ( $NoAtoms - 1 )
	@ number1 = ( $j * ( $j + 5 ) )
	@ number = ( $number1 / 2 )
	echo CREATED BY SHEER LUCK > TABEAM
	echo $number >> TABEAM

   	set n=1
	while ($n < $NoAtoms)
	 cat PAIR.$n >> TABEAM
	 cat DENSITY.$n >> TABEAM
	 cat EMBEDDING.$n >> TABEAM
	 @ n = ( $n + 1 )
	end

	set n=1
	while($n < $k)
	 cat CROSS.$n >> TABEAM
	 @ n = ( $n + 1 )
	end	
	rm PAIR.*
	rm DENSI*
	rm EMBED*
	rm TABEAM.*
	rm CROSS.*
	rm PAIR_U*
	rm EMBE_U.*

	echo DONE	
