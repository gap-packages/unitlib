#############################################################################
##  
#W  unitlib.gi             The UnitLib package            Alexander Konovalov
#W                                                            Elena Yakimenko
##
#H  $Id$
##
#############################################################################


#############################################################################
#
# PcNormalizedUnitGroupSmallGroup( n, nLibNumber )
#
InstallGlobalFunction( PcNormalizedUnitGroupSmallGroup,
function( n, nLibNumber )
local G, p, K, KG, filename, libfile, gzfile, code, V, i, fam;
if not IsPrimePowerInt( n ) then
  Error( "Underlying group is not a p-group !!! \n" );
fi;
if n > 128 then
  Print( "WARNING : the library of V(KG) for groups of order ", n, 
         " is not available yet !!! \n", 
	 "You can use only groups from the unitlib/userdata directory \n",
	 "in case if you already computed their descriptions \n",
	 "(See the manual for GeneratePcNormalizedUnitGroupDescriptions) \n" );
fi;
G := SmallGroup( n, nLibNumber );
p := PrimePGroup( G );
fam := FamilyObj( One( G ) );
K := GF( p );
KG:= GroupRing( K, G );
filename:=Concatenation( "u", String(n), "_", String(nLibNumber), ".g");
if n<128 then
  libfile := Concatenation( 
               GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath,
               "/data/", String(n), "/", filename );
elif n=128 then
  if not ARCH_IS_UNIX() then
    Error("UnitLib package : the library of normalized unit groups \n", 
          "of modular group algebras of groups of order 128 \n",
  	  "is not available because of non-UNIX operating system !!! \n");
  fi;
  gzfile := Concatenation( 
               GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath,
               "/data/", String(n), "/", filename, ".gz" );
  libfile := Filename( DirectoryTemporary(), "filename");
  Exec( Concatenation( "gunzip -c ", gzfile, " > ", libfile ) );
else
  libfile := Concatenation(                                                         
               GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath,                
	       "/userdata/", filename );
fi;
code := ReadAsFunction(libfile)();
if n=128 then
  Exec( Concatenation("rm ", libfile ) );
fi;
if n>128 then
  Print("\n", "Description of V(KG) for G=SmallGroup(",n,",",nLibNumber,
        ") accepted, started its generation \n");
fi;
SetDimensionBasis(G, rec(
                       dimensionBasis := List( code[2][1], 
                                           i -> ObjByExtRep( fam, i ) ), 
                       weights := code[2][2] ) );
V := PcGroupCode( IntHexString(code[1]), p^(n-1) );
SetIsGroupOfUnitsOfMagmaRing( V, false );
SetIsNormalizedUnitGroupOfGroupRing( V, true );
SetIsPGroup( V, true );
SetPcNormalizedUnitGroup( KG, V );
SetUnderlyingGroupRing( V, KG );
return V;
end );


#############################################################################
#
# SavePcNormalizedUnitGroup( G )
#
InstallGlobalFunction( SavePcNormalizedUnitGroup,
function( G )
local p, K, KG, V, codestring, libfile, output, d, x;
if not IsPGroup( G ) then
  Error( "<G> is not a p-group !!! \n" );
fi;
if Size(G) <= 128 then
  Print( "WARNING : the normalized unit group V(KG) of the modular group algebra \n",
         " of the given group <G> is already included in the library and \n", 
	 "You can access it using the function PcNormalizedUnitGroupSmallGroup.\n",
	 "The description you are going to generate will be stored in the directory \n",
	 "unitlib/userdata, but will be not used by PcNormalizedUnitGroupSmallGroup. \n" );
fi;
p := PrimePGroup( G );
K := GF( p );
KG:= GroupRing( K, G );
V := PcNormalizedUnitGroup( KG );
codestring := HexStringInt( CodePcGroup( V ) );
libfile := Concatenation( 
             GAPInfo.PackagesInfo.( "unitlib" )[1].InstallationPath,
             "/userdata/u",
             String( IdGroup( G )[1] ), "_",
             String( IdGroup( G )[2] ), ".g");
output := OutputTextFile( libfile, false );
SetPrintFormattingStatus( output, false );
PrintTo(  output, "return [ " );
AppendTo( output, "\042", codestring, "\042" );
AppendTo( output, ", ");
AppendTo( output, [ List( DimensionBasis( G ).dimensionBasis, ExtRepOfObj), 
                    DimensionBasis( G ).weights ] );
AppendTo( output, " ];" );
CloseStream( output );
return true; 
end );


#############################################################################
##
#E
##