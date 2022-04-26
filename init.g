#############################################################################
##  
#W  init.g                 The UnitLib package             Olexandr Konovalov
#W                                                            Olena Yakimenko
##
#############################################################################

# read function declarations
ReadPackage("unitlib", "lib/unitlib.gd");

# read actual code function(s)
ReadPackage("unitlib", "lib/unitlib.g");

if IsPackageMarkedForLoading( "scscp", "2.0" ) then
  ReadPackage("unitlib", "lib/parunits.g");
fi;
