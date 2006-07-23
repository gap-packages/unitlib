#############################################################################
##  
#W  testlib.g              The UnitLib package            Alexander Konovalov
#W                                                            Elena Yakimenko
##
#H  $Id$
##
#############################################################################

#############################################################################
##
##  UNITLIBTestLibrary()
##
##  This is a function to check the completeness of the library
##  (requires a UNIX environment)
##
UNITLIBTestLibrary := function()
local datapath, size, n, libfile;
  datapath := Concatenation(
                GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath, 
	        "/data/" );
  for size in Filtered( [ 2 .. 128 ], IsPrimePowerInt) do
    Print( NrSmallGroups(size), " group(s) of order ", size, "\n" );
    for n in [ 1 .. NrSmallGroups( size ) ] do
      libfile := Concatenation( 
                   datapath, 
		   String(size), 
		   "/u", 
		   String(size), 
		   "_", 
		   String(n), 
		   ".g" );
      if size=128 then
        libfile := Concatenation( libfile, ".gz");
      fi;
      if not IsExistingFile(libfile) then
        Error("The file ", libfile, " does not exist !!! \n");
      fi;
      Print( n, " ", IsExistingFile( libfile ), "\r");
    od;
  od;
  Print("Test passed successfully \n");
end;


#############################################################################
##
#E
##