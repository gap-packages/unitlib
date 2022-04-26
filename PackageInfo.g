#############################################################################
##
#W  PackageInfo.g              The UnitLib package         Olexandr Konovalov
#W                                                            Olena Yakimenko
##
#############################################################################

SetPackageInfo( rec(

PackageName := "UnitLib",
Subtitle := "Library of normalized unit groups of modular group algebras",
Version := "4.1.0",
Date := "26/04/2022", # dd/mm/yyyy format
License := "GPL-2.0-or-later",
##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "4.1.0">
##  <!ENTITY RELEASEDATE "26 April 2022">
##  <!ENTITY RELEASEYEAR "2022">
##  <#/GAPDoc>

SourceRepository := rec(
    Type := "git",
    URL := Concatenation( "https://github.com/gap-packages/", LowercaseString(~.PackageName) ),
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := Concatenation( "https://gap-packages.github.io/", LowercaseString(~.PackageName) ),
README_URL      := Concatenation( ~.PackageWWWHome, "/README.md" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", LowercaseString(~.PackageName), "-", ~.Version ),

ArchiveFormats := ".tar.gz",

Persons := [
  rec(
    LastName      := "Konovalov",
    FirstNames    := "Olexandr",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "obk1@st-andrews.ac.uk",
    WWWHome       := "https://alex-konovalov.github.io/",
    PostalAddress := Concatenation( [
                     "School of Computer Science\n",
                     "University of St Andrews\n",
                     "Jack Cole Building, North Haugh,\n",
                     "St Andrews, Fife, KY16 9SX, Scotland" ] ),
    Place         := "St Andrews",
    Institution   := "University of St Andrews"
     ),
  rec(
    LastName      := "Yakimenko",
    FirstNames    := "Olena",
    IsAuthor      := true,
    IsMaintainer  := false,
    Place         := "Zaporizhzhia",
    Institution   := "Zaporizhzhia National University"
     )
],

Status := "accepted",
CommunicatedBy := "Bettina Eick (Braunschweig)",
AcceptDate := "03/2007",

AbstractHTML := "The <span class=\"pkgname\">UnitLib</span> package extends the <span class=\"pkgname\">LAGUNA</span> package and provides the library of normalized unit groups of modular group algebras of all finite p-groups of order less than 243 over the field of p elements.",
                  
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
  GAP := ">=4.11",
  NeededOtherPackages := [ ["GAPDoc", ">= 1.6"], 
                           ["IO", "4.5"],
                           ["LAGUNA", ">= 3.9.4"] ],
  SuggestedOtherPackages := [ ["SCSCP", ">=2.2"] ],
  ExternalConditions := [],
),

AvailabilityTest := ReturnTrue,
TestFile := "tst/testall.g",

Keywords := ["group ring", "modular group algebra", "normalized unit group"]

));
