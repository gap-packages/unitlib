#############################################################################
##  
#W  genpar.g               The UnitLib package            Alexander Konovalov
#W                                                            Elena Yakimenko
##
#H  $Id$
##
#############################################################################

#############################################################################
#
# ParCreatePcNormalizedUnitGroupsLibrary( unitlibsize, n1, n2 )
#
ParInstallTOPCGlobalFunction( "ParCreatePcNormalizedUnitGroupsLibrary",
function( unitlibsize, n1, n2 )
local result;

if not IsPrimePowerInt( unitlibsize ) then
  Error("The first argument is not a power of a prime !!!");
fi;

if n1 > NrSmallGroups(unitlibsize) or n2 > NrSmallGroups(unitlibsize) then
  Error("There are only ", NrSmallGroups(unitlibsize), 
       " groups of order ", unitlibsize, " !!! \n");
fi;

Print( "Generating library for ", n2-n1+1, " groups of order ", 
                                  unitlibsize, " ... \n" );

   result := [];
   MasterSlave( TaskInputIterator( [ n1 .. n2 ]),
		
                n -> SavePcNormalizedUnitGroup( SmallGroup( unitlibsize, n ) ),
                
		function( input, output )
		  result[input] := output;
                  return NO_ACTION; 
		end,
                
		Error
              );
   return result;
end );

#############################################################################
##
#E
##