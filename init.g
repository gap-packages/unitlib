#############################################################################
##  
#W  init.g                 The UnitLib package            Alexander Konovalov
#W                                                            Elena Yakimenko
##
#H  $Id$
##
#############################################################################

# read function declarations
ReadPackage("unitlib/lib/unitlib.gd");

# read actual code function(s)
ReadPackage("unitlib/lib/unitlib.g");
ReadPackage("unitlib/lib/buildman.g");

if not ARCH_IS_UNIX() then
  Print("UnitLib package : the library of normalized unit groups \n", 
        "of modular group algebras of groups of order 128 \n",
	"is not available because of non-UNIX operating system !!! \n");
fi;