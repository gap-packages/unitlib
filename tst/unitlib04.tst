# unitlib, chapter 4
gap> START_TEST( "unitlib04.tst");

# unitlib/doc/example.xml:16-37

gap> IdGroup(DihedralGroup(128));
[ 128, 161 ]
gap> V := PcNormalizedUnitGroupSmallGroup( 128, 161 );
<pc group of size 170141183460469231731687303715884105728 with 127 generators>
gap> C := Center( V );           
<pc group with 34 generators>
gap> gens := MinimalGeneratingSet( C );;
gap> Length(gens);
19
gap> Size(C);
17179869184
gap> AbelianInvariants(C);
[ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 8, 8, 16, 32 ]
gap> KG := UnderlyingGroupRing( V );
<algebra-with-one over GF(2), with 7 generators>
gap> f := NaturalBijectionToNormalizedUnitGroup( KG );;
gap> IsAbelian( Group( List( gens, x -> x^f ) ));
true

# unitlib/doc/example.xml:63-77

gap> for n in [ 1 .. NrSmallGroups( 64 ) ] do
> if not IsAbelian( SmallGroup( 64, n ) ) then
>   V := PcNormalizedUnitGroupSmallGroup( 64, n );
>   KG := UnderlyingGroupRing( V );
>   if LieLowerNilpotencyIndex( KG ) <>
>      LieUpperNilpotencyIndex( KG ) then
>     Print( n," - counterexample !!! \n" );
>     break;
>   fi;
> fi;
> od;

# unitlib/doc/example.xml:86-98

gap> cl := [];;
gap> for n in [ 1 .. NrSmallGroups( 64 ) ] do
> if not IsAbelian( SmallGroup( 64, n ) ) then
>   V := PcNormalizedUnitGroupSmallGroup( 64, n );  
>   AddSet( cl, NilpotencyClassOfGroup( V ) );
> fi;
> od;
gap> cl;
[ 2, 3, 4, 5, 6, 7, 8, 16 ]

gap> STOP_TEST("unitlib04.tst", 1 );
