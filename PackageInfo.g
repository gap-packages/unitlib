#############################################################################
##
#W  PackageInfo.g              The UnitLib package        Alexander Konovalov
#W                                                            Elena Yakimenko
##
#H  $Id$
##
#############################################################################

SetPackageInfo( rec(

PackageName := "UnitLib",
Subtitle := "Library of normalized unit groups of modular group algebras",
Version := "2.0",
Date := "18/08/2006",
ArchiveURL := "http://homepages.vub.ac.be/~okonoval/unitlib/unitlib-2.0",
ArchiveFormats := ".tar.gz .tar.bz2 -win.zip",

#TextFiles := ["init.g", ......],
#BinaryFiles := ["doc/manual.dvi", ......],

Persons := [
  rec(
    LastName      := "Konovalov",
    FirstNames    := "Alexander",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "konovalov@member.ams.org",
    WWWHome       := "http://homepages.vub.ac.be/~okonoval/",
    PostalAddress := Concatenation( [
                     "Department of Mathematics\n",
                     "Vrije Universiteit Brussel\n", 
                     "Pleinlaan 2, Brussels, B-1050 Belgium" ] ),
    Place         := "Brussels",
    Institution   := "Vrije Universiteit Brussel"
     ),
  rec(
    LastName      := "Yakimenko",
    FirstNames    := "Elena",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "k-algebra@zsu.zp.ua",
    PostalAddress := Concatenation( [
                     "Department of Mathematics\n",
                     "Zaporozhye National University\n", 
                     "Zaporozhye, 69600 Ukraine" ] ),
    Place         := "Zaporozhye",
    Institution   := "Zaporozhye National University"
     )
],

Status := "deposited",
# CommunicatedBy := "",
# AcceptDate := "",

README_URL := "http://homepages.vub.ac.be/~okonoval/unitlib/README.unitlib",
PackageInfoURL := "http://homepages.vub.ac.be/~okonoval/unitlib/PackageInfo.g",
AbstractHTML := "The <span class=\"pkgname\">UnitLib</span> package extends the <span class=\"pkgname\">LAGUNA</span> package and provides the library of normalized unit groups of modular group algebras of all finite p-groups of order not greater than 243 over the field of p elements.",
PackageWWWHome := "http://homepages.vub.ac.be/~okonoval/unitlib.htm",
                  
PackageDoc := rec(
  BookName := "UnitLib",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile := "doc/manual.pdf",
  SixFile := "doc/manual.six",
  LongTitle := "The library of normalized unit groups of modular group algebras",
  Autoload := true
),

Dependencies := rec(
  GAP := ">=4.4",
  NeededOtherPackages := [ ["GAPDoc", ">= 0.999"], ["LAGUNA", ">= 3.3.3"] ],
  SuggestedOtherPackages := [ ["qaos", ">= main-1.0.19"] ],
  ExternalConditions := [ "partially needs cURL (http://curl.haxx.se)" ]
),

AvailabilityTest := ReturnTrue,
Autoload := false,
#TestFile := "tst/testall.g",

Keywords := ["group ring", "modular group algebra", "normalized unit group"]

));