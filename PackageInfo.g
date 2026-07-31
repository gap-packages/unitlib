#############################################################################
##
#W  PackageInfo.g              The UnitLib package         Olexandr Konovalov
#W                                                            Olena Yakimenko
##
#############################################################################

SetPackageInfo( rec(

PackageName := "UnitLib",
Subtitle := "Library of normalized unit groups of modular group algebras",
Version := "5.0.0",
Date := "12/06/2025", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

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
    WWWHome       := "https://olexandr-konovalov.github.io/",
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
     ),
  rec(
    LastName      := "Zabielski",
    FirstNames    := "Kamil",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "kamil@zabielscy.com",
    WWWHome       := "https://limakzi.me",
    Place         := "Białystok",
    Institution   := "Białystok University of Technology"
     )
],

Status := "accepted",
CommunicatedBy := "Bettina Eick (Braunschweig)",
AcceptDate := "03/2007",

AbstractHTML := "The <span class=\"pkgname\">UnitLib</span> package extends the <span class=\"pkgname\">LAGUNA</span> package and provides the library of normalized unit groups of modular group algebras of all finite p-groups of order up to 243 over the field of p elements.",
                  
PackageDoc := rec(
  BookName := "UnitLib",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile := "doc/manual.pdf",
  SixFile := "doc/manual.six",
  LongTitle := "The library of normalized unit groups of modular group algebras",
),

Dependencies := rec(
  GAP := ">=4.12",
  NeededOtherPackages := [ ["IO", "4.5"],
                           ["LAGUNA", ">= 3.9.4"],
                           ["SmallGrp", ">= 1.0"] ],
  SuggestedOtherPackages := [ ["SCSCP", ">=2.2"] ],
  ExternalConditions := [],
),

AvailabilityTest := ReturnTrue,
TestFile := "tst/testall.g",

Keywords := ["group ring", "modular group algebra", "normalized unit group"],

AutoDoc := rec(
    entities := rec(
        LAGUNA := "<Package>LAGUNA</Package>",
        SCSCP := "<Package>SCSCP</Package>",
        VERSION := ~.Version,
        RELEASEYEAR := ~.Date{[7..10]},
        RELEASEDATE := function(date)
          local day, month, year, allMonths;
          day := Int(date{[1,2]});
          month := Int(date{[4,5]});
          year := Int(date{[7..10]});
          allMonths := [ "January", "February", "March", "April", "May", "June", "July",
                         "August", "September", "October", "November", "December"];
          return Concatenation(String(day)," ", allMonths[month], " ", String(year));
        end(~.Date),
    ),
),

));
