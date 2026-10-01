#############################################################################
##  
#W  testlib.g              The UnitLib package             Olexandr Konovalov
#W                                                            Olena Yakimenko
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
local datapath, testresult, size, libfile, missing;

  datapath := Concatenation(
                GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath, 
            "/data/" );
  testresult := true;       

  # groups of prime order need no data
  for size in Filtered( [ 2 .. 243 ], n -> IsPrimePowerInt(n) and not IsPrimeInt(n) ) do

    libfile := Concatenation( datapath, "u", String(size), ".g" );

    if not IsExistingFile( libfile ) and
       not IsExistingFile( Concatenation( libfile, ".gz" ) ) then
      Print( "missing file for order ", size, "\n" );
      testresult := false;
      continue;
    fi;

    missing := Difference( [ 1 .. NrSmallGroups( size ) ],
                           List( ReadAsFunction( libfile )(), line -> line[1] ) );

    if Length(missing) > 0 then
      Print( Length(missing), " missing groups for order ", size, " : ", missing, "\n");
      testresult := false;
    fi;
  od;
  if testresult then
    Print("UnitLib library is complete - no missing files!!!\n");
    return true;
  else
    Print("UnitLib library is incomplete - some files are not available!!!\n");
    return false;
  fi;
end;


#############################################################################
##
#E
##
