#############################################################################
##  
#W  unitlib.gi             The UnitLib package             Olexandr Konovalov
#W                                                            Olena Yakimenko
##
#############################################################################


#############################################################################
#
# Data format
#
# The relations of V(KG), with pcgs g_1, ..., g_l, are numbered as slots:
# first the powers g_i^p for i in [1..l], then the commutators
# Comm( g_j, g_i ) for i in [1..l-1], j in [i+1..l]. A slot holds the ext
# rep [ gen1, exp1, gen2, exp2, ... ] of the right-hand side, or [ ] if the
# relation is trivial.
#
# A data file returns a list with one line per group:
#   [ id, ref, relations, exponents, dimensionBasis, weights ]
# If ref = 0, <relations> lists the nontrivial slots. Otherwise it lists
# the slots that differ from those of the line with id <ref>: an entry
# marked with '!' replaces the slot, any other entry is added to it mod p.
# Each entry consists of the slot number as the gap to the previous entry,
# the optional '!', and the generators as gaps to the previous generator.
# <exponents> holds the exponents of all generators in order, and is empty
# for p = 2, where they are all 1.
#
# Numbers are written in base 26, most significant digit first, with the
# digits 'a' to 'z', except for the last digit, which is 'A' to 'Z'.
#
BindGlobal( "UNITLIB_BASE", 26 );
BindGlobal( "UNITLIB_REPLACE", '!' );


BindGlobal( "UNITLIB_EncodeInt", function( str, n )
local digits;
digits := [ CharInt( IntChar( 'A' ) + RemInt( n, UNITLIB_BASE ) ) ];
n := QuoInt( n, UNITLIB_BASE );
while n > 0 do
  Add( digits, CharInt( IntChar( 'a' ) + RemInt( n, UNITLIB_BASE ) ) );
  n := QuoInt( n, UNITLIB_BASE );
od;
Append( str, Reversed( digits ) );
end );


BindGlobal( "UNITLIB_DecodeInts", function( str )
local result, v, c;
result := [ ];
v := 0;
for c in str do
  if IsLowerAlphaChar( c ) then
    v := v * UNITLIB_BASE + IntChar( c ) - IntChar( 'a' );
  else
    Add( result, v * UNITLIB_BASE + IntChar( c ) - IntChar( 'A' ) );
    v := 0;
  fi;
od;
return result;
end );


# the ext rep of the word with exponents those of <a> plus <c> times those
# of <b>, mod <p>
BindGlobal( "UNITLIB_AddWords", function( a, b, c, p )
local v, k;
if IsEmpty( a ) and c = 1 then
  return b;
fi;
v := [ ];
for k in [ 1, 3 .. Length( a ) - 1 ] do
  v[ a[k] ] := a[k+1];
od;
for k in [ 1, 3 .. Length( b ) - 1 ] do
  if IsBound( v[ b[k] ] ) then
    v[ b[k] ] := ( v[ b[k] ] + c * b[k+1] ) mod p;
  else
    v[ b[k] ] := ( c * b[k+1] ) mod p;
  fi;
od;
return Concatenation( List( Filtered( [ 1 .. Length( v ) ],
                                      k -> IsBound( v[k] ) and v[k] <> 0 ),
                            k -> [ k, v[k] ] ) );
end );


#############################################################################
#
# UNITLIB_SlotsOfPcgs( pcgs )
#
BindGlobal( "UNITLIB_SlotsOfPcgs", function( pcgs )
local l, ro, word, slots, i, j;
l := Length( pcgs );
ro := RelativeOrders( pcgs );
word := function( x )
  local v;
  v := ExponentsOfPcElement( pcgs, x );
  return Concatenation( List( Filtered( [ 1 .. l ], k -> v[k] <> 0 ),
                              k -> [ k, v[k] ] ) );
end;
slots := List( [ 1 .. l ], i -> word( pcgs[i]^ro[i] ) );
for i in [ 1 .. l-1 ] do
  for j in [ i+1 .. l ] do
    Add( slots, word( Comm( pcgs[j], pcgs[i] ) ) );
  od;
od;
return slots;
end );


#############################################################################
#
# UNITLIB_EncodeLine( id, ref, slots, refSlots, p, basis )
#
# Returns the data line for <slots>, as the difference to <refSlots> if
# <ref> is not 0. <basis> is [ dimensionBasis, weights ].
#
BindGlobal( "UNITLIB_EncodeLine", function( id, ref, slots, refSlots, p, basis )
local relations, exponents, prev, s, word, replace, gen, k;
relations := "";
exponents := "";
prev := 0;
for s in [ 1 .. Length( slots ) ] do
  if ref = 0 then
    if IsEmpty( slots[s] ) then
      continue;
    fi;
    word := slots[s];
    replace := false;
  else
    if slots[s] = refSlots[s] then
      continue;
    fi;
    # store the shorter of the new value and the difference
    word := UNITLIB_AddWords( slots[s], refSlots[s], -1, p );
    replace := Length( word ) > Length( slots[s] );
    if replace then
      word := slots[s];
    fi;
  fi;
  if prev > 0 then
    Add( relations, ' ' );
  fi;
  UNITLIB_EncodeInt( relations, s - prev );
  prev := s;
  if replace then
    Add( relations, UNITLIB_REPLACE );
  fi;
  gen := 0;
  for k in [ 1, 3 .. Length( word ) - 1 ] do
    UNITLIB_EncodeInt( relations, word[k] - gen );
    gen := word[k];
    if p > 2 then
      UNITLIB_EncodeInt( exponents, word[k+1] );
    fi;
  od;
od;
return Concatenation( "[", String( id ), ",", String( ref ),
                      ",\"", relations, "\",\"", exponents, "\",",
                      Filtered( String( basis[1] ), c -> c <> ' ' ), ",",
                      Filtered( String( basis[2] ), c -> c <> ' ' ), "]" );
end );


#############################################################################
#
# UNITLIB_SlotsOfLine( lines, id, p, l )
#
# Decodes the slots of the group <id> from the data <lines>.
#
BindGlobal( "UNITLIB_SlotsOfLine", function( lines, id, p, l )
local chain, line, slots, exponents, e, slot, entry, bang, ints, word, gen, k;

# follow the references back to a line with ref = 0
chain := [ ];
repeat
  line := First( lines, x -> x[1] = id );
  Add( chain, line );
  id := line[2];
until id = 0;

slots := ListWithIdenticalEntries( l * ( l+1 ) / 2, [ ] );
for line in Reversed( chain ) do
  exponents := UNITLIB_DecodeInts( line[4] );
  e := 0;
  slot := 0;
  for entry in SplitString( line[3], " " ) do
    bang := Position( entry, UNITLIB_REPLACE );
    if bang = fail then
      ints := UNITLIB_DecodeInts( entry );
    else
      ints := Concatenation(
                UNITLIB_DecodeInts( entry{[ 1 .. bang-1 ]} ),
                UNITLIB_DecodeInts( entry{[ bang+1 .. Length( entry ) ]} ) );
    fi;
    slot := slot + ints[1];
    word := [ ];
    gen := 0;
    for k in [ 2 .. Length( ints ) ] do
      gen := gen + ints[k];
      if p = 2 then
        Append( word, [ gen, 1 ] );
      else
        e := e + 1;
        Append( word, [ gen, exponents[e] ] );
      fi;
    od;
    if bang = fail then
      slots[slot] := UNITLIB_AddWords( slots[slot], word, 1, p );
    else
      slots[slot] := word;
    fi;
  od;
od;
return slots;
end );


#############################################################################
#
# UNITLIB_PcGroupFromSlots( p, l, slots )
#
# The relations come from a consistent presentation, so GroupByRwsNC skips
# the consistency check.
#
BindGlobal( "UNITLIB_PcGroupFromSlots", function( p, l, slots )
local F, fam, gens, coll, s, i, j;
F := FreeGroup( IsSyllableWordsFamily, l );
fam := ElementsFamily( FamilyObj( F ) );
gens := GeneratorsOfGroup( F );
coll := SingleCollector( F, ListWithIdenticalEntries( l, p ) );
s := 0;
for i in [ 1 .. l ] do
  s := s + 1;
  if not IsEmpty( slots[s] ) then
    SetPower( coll, i, ObjByExtRep( fam, slots[s] ) );
  fi;
od;
for i in [ 1 .. l-1 ] do
  for j in [ i+1 .. l ] do
    s := s + 1;
    if not IsEmpty( slots[s] ) then
      SetConjugate( coll, j, i, gens[j] * ObjByExtRep( fam, slots[s] ) );
    fi;
  od;
od;
return GroupByRwsNC( coll );
end );


#############################################################################
#
# UNITLIB_WriteUserData( G, V )
#
# Stores V = V(KG) in unitlib/userdata.
#
BindGlobal( "UNITLIB_WriteUserData", function( G, V )
local id, libfile, basis, line, output;
id := IdGroup( G );
libfile := Concatenation(
             GAPInfo.PackagesInfo.( "unitlib" )[1].InstallationPath,
             "/userdata/u", String( id[1] ), "_", String( id[2] ), ".g" );
basis := [ List( DimensionBasis( G ).dimensionBasis, ExtRepOfObj ),
           DimensionBasis( G ).weights ];
line := UNITLIB_EncodeLine( id[2], 0, UNITLIB_SlotsOfPcgs( Pcgs( V ) ), fail,
                            PrimePGroup( G ), basis );
output := OutputTextFile( libfile, false );
SetPrintFormattingStatus( output, false );
WriteAll( output, Concatenation( "return [\n", line, "\n];\n" ) );
CloseStream( output );
return true;
end );


#############################################################################
#
# PcNormalizedUnitGroupSmallGroup( n, nLibNumber )
#
InstallGlobalFunction( PcNormalizedUnitGroupSmallGroup,
function( n, nLibNumber )
local G, p, K, KG, libfile, code, basis, V, i, fam;
if not IsPrimePowerInt( n ) then
  Error( "Underlying group is not a p-group !!! \n" );
fi;
if n > 243 and not IsPrimeInt( n ) then
  Print( "WARNING : the library of V(KG) for groups of order ", n, 
         " is not available yet !!! \n", 
	 "You can use only groups from the unitlib/userdata directory \n",
	 "in case if you already computed their descriptions \n",
	 "(See the manual for SavePcNormalizedUnitGroup).\n" );
fi;
G := SmallGroup( n, nLibNumber );
p := PrimePGroup( G );
fam := FamilyObj( One( G ) );
K := GF( p );
KG:= GroupRing( K, G );
if IsPrimeInt( n ) then

  # V(KG) is elementary abelian: KG = K[y]/(y^p) with y = g-1, and the pc
  # generators 1+y^i satisfy (1+y^i)^p = 1+y^(ip) = 1
  basis := [ [ [ 1, 1 ] ], [ 1 ] ];
  V := GroupByRwsNC( SingleCollector( FreeGroup( IsSyllableWordsFamily, n-1 ),
                                      ListWithIdenticalEntries( n-1, p ) ) );

else

  if n <= 243 then
    libfile := Concatenation(
                 GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath,
                 "/data/u", String(n), ".g" );
  else
    # Probably the group was computed and saved by the user.
    # If not, the error will occur later
    libfile := Concatenation(
                 GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath,
                 "/userdata/u", String(n), "_", String(nLibNumber), ".g" );
  fi;

  code := ReadAsFunction(libfile)();

  if n>243 then

    Info( LAGInfo, 1, "Description of V(KG) for G=SmallGroup(",n,",",nLibNumber,
                      ") accepted, started its generation...");

  fi;

  if IsString( code[1] ) then
    # userdata written by UnitLib 5.1.0 or earlier
    basis := code[2];
    V := PcGroupCode( IntHexString(code[1]), p^(n-1) );
  else
    basis := First( code, line -> line[1] = nLibNumber ){[ 5, 6 ]};
    V := UNITLIB_PcGroupFromSlots( p, n-1,
           UNITLIB_SlotsOfLine( code, nLibNumber, p, n-1 ) );
  fi;

fi;

SetDimensionBasis(G, rec( dimensionBasis := List( basis[1],
                                              i -> ObjByExtRep( fam, i ) ),
                          weights := basis[2] ) );
ResetFilterObj( V, IsGroupOfUnitsOfMagmaRing );
SetFilterObj( V, IsNormalizedUnitGroupOfGroupRing );
SetIsPGroup( V, true );
SetPrimePGroup( V, p );
SetPcNormalizedUnitGroup( KG, V );
SetUnderlyingGroupRing( V, KG );
return V;
end );


#############################################################################
#
# SavePcNormalizedUnitGroup( G )
#
InstallGlobalFunction( SavePcNormalizedUnitGroup,
function( G )
local p, K, KG, V;
if not IsPGroup( G ) then
  Error( "<G> is not a p-group !!! \n" );
fi;
if Size(G) < 243 then
  Print( "WARNING : the normalized unit group V(KG) of the modular group algebra \n",
         " of the given group <G> is already included in the library and \n", 
	 "You can access it using the function PcNormalizedUnitGroupSmallGroup.\n",
	 "The description you are going to generate will be stored in the directory \n",
	 "unitlib/userdata, but will be not used by PcNormalizedUnitGroupSmallGroup. \n" );
fi;
p := PrimePGroup( G );
K := GF( p );
KG:= GroupRing( K, G );
V := PcNormalizedUnitGroup( KG );
return UNITLIB_WriteUserData( G, V );
end );


#############################################################################
##
#E
##
