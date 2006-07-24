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
local datapath, testresult, size, missing, n, libfile;
  datapath := Concatenation(
                GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath, 
	        "/data/" );
  testresult := true;		
  for size in Filtered( [ 2 .. 243 ], IsPrimePowerInt) do
    missing := [];
    Print( NrSmallGroups(size), " group(s) of order ", size, "\n" );
    for n in [ 1 .. NrSmallGroups( size ) ] do
      Print( n, "\r");
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
        Add( missing, n );
	testresult := false;
      fi;
    od;
    if Length(missing) > 0 then
      Print( "Missing groups for order ", size, " : ", missing, "\n");
    fi;
  od;
  if testresult then
    Print("Test finished successfully !!! \n");
  else
    Print("Test finished with problems !!! \n");
  fi;
end;


#############################################################################
##
#E
##