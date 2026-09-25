#############################################################################
##  
#W  genlib.g               The UnitLib package             Olexandr Konovalov
#W                                                            Olena Yakimenko
##
#############################################################################


#############################################################################
#
# CreatePcNormalizedUnitGroupsLibrary( n, n1, n2 )
#
# The function creates library files for groups of prime-power order n,
# starting from SmallGroup( n, n1 ) and finishing with SmallGroup( n, n2 )
#
CreatePcNormalizedUnitGroupsLibrary := function( n, n1, n2 )
local i, G;
if not IsPrimePowerInt( n ) then
  Error("Size is not a power of a prime !!! \n");
fi;
if n1 > NrSmallGroups(n) then
  Error("There are only ", NrSmallGroups(n), " groups of order ", n, " !!! \n");
fi;
Print( "Generating library for ", NrSmallGroups( n ), " groups ... \n" );
for i in [ n1 .. n2 ] do
  Print( i, ":", NrSmallGroups( n ), "\n" );
  G := SmallGroup( n, i );
  SavePcNormalizedUnitGroup( G );
od;
Print( "\n" );
end;


#############################################################################
#
# CreatePcNormalizedUnitGroupsLibraryFile( n, dir )
#
# Writes the library file data/u<n>.g from the descriptions of V(KG) for
# all groups G of order n, as stored by SavePcNormalizedUnitGroup in the
# directory <dir>. A group is stored as the difference to the earlier group
# in its block of UNITLIB_BLOCK_SIZE groups with the fewest differing
# relations, unless storing it standalone is shorter. The block size bounds
# the number of lines read to load a group.
#
UNITLIB_BLOCK_SIZE := 32;

CreatePcNormalizedUnitGroupsLibraryFile := function( n, dir )
local p, l, lines, first, slots, nontrivial, i, line, basis, best, fewest,
      j, common, differ, alt, libfile, output;
if IsString( dir ) then
  dir := Directory( dir );
fi;
p := FactorsInt( n )[1];
l := n - 1;
lines := [ ];
for i in [ 1 .. NrSmallGroups( n ) ] do
  if RemInt( i-1, UNITLIB_BLOCK_SIZE ) = 0 then
    first := i;
    slots := [ ];
    nontrivial := [ ];
  fi;
  line := ReadAsFunction( Filename( dir,
            Concatenation( "u", String( n ), "_", String( i ), ".g" ) ) )()[1];
  basis := line{[ 5, 6 ]};
  slots[i] := UNITLIB_SlotsOfLine( [ line ], i, p, l );
  nontrivial[i] := Filtered( [ 1 .. Length( slots[i] ) ],
                             s -> not IsEmpty( slots[i][s] ) );
  line := UNITLIB_EncodeLine( i, 0, slots[i], fail, p, basis );
  best := 0;
  fewest := infinity;
  for j in [ first .. i-1 ] do
    common := Intersection( nontrivial[i], nontrivial[j] );
    differ := Length( nontrivial[i] ) + Length( nontrivial[j] )
              - Length( common )
              - Number( common, s -> slots[i][s] = slots[j][s] );
    if differ <= fewest then
      best := j;
      fewest := differ;
    fi;
  od;
  if best > 0 then
    alt := UNITLIB_EncodeLine( i, best, slots[i], slots[best], p, basis );
    if Length( alt ) < Length( line ) then
      line := alt;
    fi;
  fi;
  Add( lines, line );
od;
libfile := Concatenation( GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath,
                          "/data/u", String( n ), ".g" );
output := OutputTextFile( libfile, false );
SetPrintFormattingStatus( output, false );
WriteAll( output, Concatenation(
  "# UnitLib: V(KG) for the groups G of order ", String( n ), ",\n",
  "# see the chapter \"Implementation Details\" of the manual\n",
  "return [\n", JoinStringsWithSeparator( lines, ",\n" ), "\n];\n" ) );
CloseStream( output );
end;


#############################################################################
##
#E
##