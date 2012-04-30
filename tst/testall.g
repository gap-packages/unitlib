LoadPackage("unitlib");

dir := DirectoriesPackageLibrary("unitlib","tst");

Print("Checking UnitLib library for completeness ...\n");
Read( Filename( dir, "testlib.g" ) );
UNITLIBTestLibrary();

testsfiles := [ 
"unitlib02.tst",
"unitlib04.tst"
];

Print("=================================================================\n");
for ff in testsfiles do
  fn := Filename(dir, ff );
  Print("*** TESTING ", fn, "\n");
  ReadTest( fn );
  Print("=================================================================\n");
od;  
Print("*** FINISHED UNITLIB PACKAGE TESTS\n");
Print("=================================================================\n");