#############################################################################
##  
#W  init.g                 The UnitLib package            Alexander Konovalov
#W                                                            Elena Yakimenko
##
#############################################################################

# read function declarations
ReadPackage("unitlib", "lib/unitlib.gd");

# read actual code function(s)
ReadPackage("unitlib", "lib/unitlib.g");

if IsPackageMarkedForLoading( "scscp", "2.0" ) then
  ReadPackage("unitlib", "lib/parunits.g");
fi;
