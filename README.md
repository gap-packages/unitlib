[![Build Status](https://github.com/gap-packages/unitlib/workflows/CI/badge.svg?branch=master)](https://github.com/gap-packages/unitlib/actions?query=workflow%3ACI+branch%3Amaster)
[![Code Coverage](https://codecov.io/github/gap-packages/unitlib/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/unitlib)

# GAP package UnitLib

Let KG be  a group algebra  of  a  finite  p-group  G  over  the  field  K of 
characteristic  p,  and  let  V(KG)  be  the normalized  unit  group  of  KG. 
The  pc-presentation  of  the  group  V(KG)  can be computed  using  the  GAP 
package  LAGUNA  (https://gap-packages.github.io/laguna/),  but for groups of
orders 64 and more this computation already takes a lot of time.

The UnitLib package  is an extension  of the LAGUNA package  that is aimed on 
this problem.  It contains the library  of normalized unit groups  of modular 
group algebras of  finite p-groups  over the field of p elements. This allows 
the user  to retrieve the  pre-computed group from the library instead of the 
long-time computation.  The group  created  with  UnitLib will  have the same 
properties and attributes as the one computed with LAGUNA.

The current distribution of UnitLib contains normalized unit groups V(KG) for 
all p-groups of order up to 243.

The UnitLib package is redistributed with GAP,  but is not loaded by default. 
Therefore, to use UnitLib, first you need to load it as follows:

    gap> LoadPackage("unitlib");


Olexandr Konovalov and Olena Yakimenko
