gap> START_TEST("dataformat.tst");

# userdata written by UnitLib 5.1.0 or earlier
gap> G := SmallGroup( 256, 56092 );;
gap> V := PcNormalizedUnitGroup( GroupRing( GF( 2 ), G ) );;
gap> file := Filename( DirectoriesPackageLibrary( "unitlib", "userdata" )[1],
>                      "u256_56092.g" );;
gap> output := OutputTextFile( file, false );;
gap> SetPrintFormattingStatus( output, false );
gap> PrintTo( output, "return [ \"", HexStringInt( CodePcGroup( V ) ), "\", ",
>      [ List( DimensionBasis( G ).dimensionBasis, ExtRepOfObj ),
>        DimensionBasis( G ).weights ], " ];" );
gap> CloseStream( output );
gap> W := PcNormalizedUnitGroupSmallGroup( 256, 56092 );;
WARNING : the library of V(KG) for groups of order
256 is not available yet !!!
You can use only groups from the unitlib/userdata directory
in case if you already computed their descriptions
(See the manual for SavePcNormalizedUnitGroup).
#I  Description of V(KG) for G=SmallGroup(256,
56092) accepted, started its generation...
gap> CodePcGroup( W ) = CodePcGroup( V );
true
gap> RemoveFile( file );
true

# groups stored as a chain of differences
gap> ForAll( [ 82, 154, 160 ], i ->
>      CodePcGroup( PcNormalizedUnitGroupSmallGroup( 64, i ) ) =
>      CodePcGroup( PcNormalizedUnitGroup( GroupRing( GF( 2 ), SmallGroup( 64, i ) ) ) ) );
true

#
gap> STOP_TEST("dataformat.tst", 1);
