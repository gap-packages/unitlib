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
##
#E
##