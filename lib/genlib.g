#############################################################################
##  
#W  genlib.g               The UnitLib package            Alexander Konovalov
#W                                                            Elena Yakimenko
##
#H  $Id$
##
#############################################################################

# To compress the library, use e.g. the following:
# gap> for i in [1..NrSmallGroups(256)] do
# >      filename := Concatenation( "u256_", String(i), ".g" );
# >      Exec( "gzip ", filename );
# >    od;
# gap>

#############################################################################
#
# CreatePcNormalizedUnitGroupsLibrary( n, n1 )
#
CreatePcNormalizedUnitGroupsLibrary := function( n, n1 )
local i, G;
if not IsPrimePowerInt( n ) then
  Error("Size is not a power of a prime !!!");
fi;
Print( "Generating library for ", NrSmallGroups( n ), " groups ... \n" );
for i in [ n1 .. NrSmallGroups( n ) ] do
  Print( i, "\r" );
  G := SmallGroup( n, i );
  SavePcNormalizedUnitGroup( G );
od;
Print( "\n" );
end;


#############################################################################
#
# ParCreatePcNormalizedUnitGroupsLibrary( n, n1, n2 )
#
ParCreatePcNormalizedUnitGroupsLibrary:=function(n, n1, n2 )
local i, l;
if not IsPrimePowerInt( n ) then
  Error("The order <n> is not a power of a prime !!!");
fi;
l:=ParList([ n1 .. n2 ], i -> SavePcNormalizedUnitGroup( SmallGroup( n, i ) ) );
end;


#############################################################################
##
#E
##