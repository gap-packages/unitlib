#############################################################################
##  
#W  genpar.g               The UnitLib package            Alexander Konovalov
#W                                                            Elena Yakimenko
##
#H  $Id$
##
#############################################################################

# Example of usage:
#
# gap> Read("~/gap4r4/pkg/unitlib/lib/genpar.g"); 
# gap> ParCreatePcNormalizedUnitGroupsLibrary(8,1,NrSmallGroups(8));
# Generating library for 5 groups of order 8 ... 
# Generating library for 5 groups of order 8 ... 
# Generating library for 5 groups of order 8 ... 
# master -> 1:  1
# master -> 2:  2
# 2 -> master: true
# master -> 2:  3
# 1 -> master: true
# master -> 1:  4
# 2 -> master: true
# master -> 2:  5
# 1 -> master: true
# 2 -> master: true
# [ true, true, true, true, true ]


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