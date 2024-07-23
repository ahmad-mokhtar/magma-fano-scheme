//Author: Ahmad Mokhtar
//Updated: Feb 26, 2024

/** MagDoc
FanoScheme is a package in MAGMA for computation with Fano schemes of embedded projective varieties.
Let $X\subset \mathbb{P}^n$ be an embedded projective variety.
Then the Fano scheme $\mathbf{F}_k (X)$ of $k$-planes in $X$ is the fine moduli space that parametrizes those $k$-planes contained in $X$.
The scheme $\mathbf{F}_k (X)$ is a subscheme of the Grassmannian $\mathbb{G}(k,n)$.

Moreover, a Grassmannian $\mathbb{G}(k,n)$ is the same as the Fano scheme $\mathbf{F}_k(\mathbb{P}^n)$.
*/

intrinsic FanoScheme(X::Sch , k::RngIntElt , grassAmbient::Prj) -> Sch
{This intrinsic returns the fano scheme F_k(X) as a subscheme of a Grassmannian Gr(k, r) embedded in the projective space grassAmbient. The dimension of grassAmbient should be equal to Binomial(r+1,k+1) where r is the dimension of the ambient projective space of X. The returned Fano scheme is a subscheme of grassAmbient.}
/** MagDoc
Returns the Fano scheme $\mathbf{F}_k(X)$ as a subscheme of a Grassmannian $\mathbb{G}(k, r)$ embedded in the projective space `grassAmbient`. The dimension of `grassAmbient` must be equal to $\binom{r+1}{k+1}$ where $r$ is the dimension of the ambient projective space of $X$, otherwise an error occurs. The returned Fano scheme is a subscheme of `grassAmbient`.
*/

//making sure X is a projective space
if not(IsProjective(X)) then
   error "The scheme X must be projective:", Error(X);
end if;

P:=AmbientSpace(X); //P is the projective space in which X is embedded
R:=CoordinateRing(P); //R is the homogeneous coordinate ring of P
KK:=BaseRing(R); //KK is the field over which P is defined
n:=Rank(R); //n is equal to the dimension of P plus 1.

//making sure grassAmbient is a projective space and has the correct dimension: Binomial(n,k+1)
if Type(grassAmbient) ne Prj then
   error "The Grassmannian ambient space grassAmbient must be a projective space:", Error(grassAmbient);
else
   N:= Dimension(grassAmbient);
   if N+1 ne Binomial(n,k+1) then
      error "The dimension of the Grassmannian ambient space grassAmbient is incorrect:", N;
   end if;
end if;


//S is the homogenous coordinate ring of a generic k-plane in P. It has (k+1) coordinates s_1,..,s_(k+1) for the k-plane (stored in LinSpaceVariables) as well as n*(k+1) coordinates p_j1,...,p_jn (1<=j<=k+1) for k+1 points in P.
S:=PolynomialRing(KK,(k+1)*(n+1));
LinSpaceVariables:=[S.i: i in {1..k+1}];


genericLinCoordinates:=[&+[LinSpaceVariables[j]*S.(k+1+i+(j-1)*n): j in {1..k+1}]: i in {1..n}];
F:=hom <R -> S | genericLinCoordinates>;
J:=Extension(F, DefiningIdeal(X)); //J is the ideal of those k-planes that lie on X

//The ideal J has equations in the coordinates of a generic k-plane s_i and p_jl. The Fano scheme is defined by the vanishing of these polynomials for all values of s_i. We extract the coefficient of the variables s_i which are polynomials in the p_jl.
coeffList := Basis(J);
for var in LinSpaceVariables do
    coeffList2 :=[];
    for f in coeffList do
        coeffList2:= coeffList2 cat Coefficients(f, var);
    end for;
    coeffList := coeffList2;
end for;
coeffList:=SequenceToSet(coeffList) diff {0};
J2:=ideal<S|coeffList,LinSpaceVariables>;

//S2 is the homogenous coordinate ring of the Fano scheme. The last step is to move the equations defining the Fano scheme to a Grassmannian embedded in grassAmbient.
S2:=S/J2;
M2:=Matrix(S2,[[S2!(S.(k+1+i+(j-1)*n)): i in {1..n}]: j in {1..k+1}]);
GR:=CoordinateRing(grassAmbient);
M:=Minors(M2,k+1);
gr:=hom< GR -> S2| M>;
fano:=Scheme(grassAmbient,AffineAlgebraMapKernel(gr));

//The Fano scheme is now computed in fano and we return it.
return fano;

end intrinsic;


intrinsic FanoScheme(X::Sch , k::RngIntElt) -> Sch
{This intrinsic returns the fano scheme F_k(X) as a subscheme of a Grassmannian Gr(k, r) embedded in a projective space grassAmbient containing Gr(k,r). The returned scheme is a subschem of grassAmbient.}
/** MagDoc
Returns the Fano scheme $\mathbf{F}_k(X)$ as a subscheme of a Grassmannian $\mathbb{G}(k, r)$ embedded in a projective space of dimension $\binom{r+1}{k+1}$. It creates a projective space `ambientSpace` of dimension $\binom{r+1}{k+1}$ and then calls `FanoScheme(X, k, grassAmbient)`.
*/

//Creating the projective space grassAmbient with the correct dimension.
R:=CoordinateRing(AmbientSpace(X));
KK:=BaseRing(R);
n:=Rank(R);
N:=Binomial(n,k+1);
grassAmbient:= ProjectiveSpace(KK,N-1);

return FanoScheme(X,k, grassAmbient); //calling an overloaded version of the intrinsic

end intrinsic;

/** MagDoc Example
The famous Cayley-Salmon theorem asserts that a smooth cubic surface in $\mathbb{P}^3$ contains exactly 27 lines. We will use `FanoScheme` to demonstrate the theorem.

     > KK:=Rationals();
     > KK;
     Rational Field
     > P<x,y,z,w>:=ProjectiveSpace(KK,3);
     > P;
     Projective Space of dimension 3 over Rational Field
     Variables: x, y, z, w
     > grassAmbient<p_0,p_1,p_2,p_3,p_4,p_5>:=ProjectiveSpace(KK,5);
     > grassAmbient;
     Projective Space of dimension 5 over Rational Field
     Variables: p_0, p_1, p_2, p_3, p_4, p_5
     > X:=Scheme(P, x^3+y^3+z^3+w^3);
     > X;
     Scheme over Rational Field defined by
     x^3 + y^3 + z^3 + w^3
     > Y:=FanoScheme(X,1,grassAmbient);
     > Dimension(Y);
     0
     > Degree(Y);
     27
*/

/** MagDoc Example
The smooth quadric $X\subset \mathbb{P}^3$ defined by $xy-zw=0$  has two disjoint family of lines, namely its two sets of rulings. Let's examine the Fano scheme $\mathbf{F}_1(X)$. We will see that the Fano scheme $\mathbf{F}_1(X)$ has two irreducible components. They are curves of degree 2. Upon inspecting the equations for each compnent, we see that they are two disjoint conics in the Grassmannian $\mathbb{G}(1,3)$.

     KK;
     Rational Field
     > P<x,y,z,w>:=ProjectiveSpace(KK,3);
     > P;
     Projective Space of dimension 3 over Rational Field
     Variables: x, y, z, w
     > grassAmbient<p_0,p_1,p_2,p_3,p_4,p_5>:=ProjectiveSpace(KK,5);
     > grassAmbient;
     Projective Space of dimension 5 over Rational Field
     Variables: p_0, p_1, p_2, p_3, p_4, p_5
     X:=Scheme(P, x*y-z*w);
     X;
     Scheme over Rational Field defined by
     x*y - z*w
     > Y:=FanoScheme(X,1,grassAmbient);
     for component in IrreducibleComponents(Y) do
         component;
        printf "Dimension of component = %o\n", Dimension(component);
         printf "Degree of component = %o\n", Degree(component);
         print "-----";
     end for;
     Scheme over Rational Field defined by
     p_2*p_3 + p_5^2,
     p_0 - p_5,
     p_1,
     p_4
     Dimension of component = 1
     Degree of component = 2
     -----
     Scheme over Rational Field defined by
     p_1*p_4 + p_5^2,
     p_0 + p_5,
     p_2,
     p_3
     Dimension of component = 1
     Degree of component = 2
     -----
*/

intrinsic Grassmannian(k::RngIntElt, n::RngIntElt, grassAmbient::Prj) -> Sch
{This intrinsic returns a Grassmannian Gr(k,n) of k-planes in an n-projective space P by calling FanoScheme on P. The returned Grassmannian is a subscheme of the ambient projective space grassAmbient which must have dimension Binomial(n+1,k+1)-1.}
/** MagDoc
Returns the Grassmannian $\mathbb{G}(k, r)$ of $k$-planes in an $n$-projective space $P$. It works by calling `FanoScheme(P, k, grassAmbient)`. The returned Grassmannian is a subscheme of the ambient projective space `grassAmbient` which must have dimension $\binom{n+1}{k+1}-1$, otherwise an error occurs.
*/

//creating a projective space of dimension n and returning its Fano scheme of k-planes which is the Grassmannian Gr(k,n).
KK:=BaseRing(CoordinateRing(grassAmbient));
P:= ProjectiveSpace(KK, n);
return FanoScheme(P,k,grassAmbient);

end intrinsic;

intrinsic Grassmannian(k::RngIntElt, P::Prj) -> Sch
{This intrinsic returns a Grassmannian Gr(k,P) of k-planes in the n-projective space P by computing the Fano scheme of k planes in P. The returned Grassmannian is a subscheme of an ambient projective space of dimension Binomial(n+1,k+1)-1.}
/** MagDoc
Returns the Grassmannian $\mathbb{G}(k,P)$ of $k$-planes in the $n$-projective space $P$ by calling `FanoScheme(P, k)`. The returned Grassmannian is a subscheme of an ambient projective space of dimension $\binom{n+1}{k+1}-1$.
*/

return FanoScheme(P, k);

end intrinsic;

intrinsic Grassmannian(k::RngIntElt, P::Prj, grassAmbient::Prj) -> Sch
{This intrinsic returns a Grassmannian Gr(k,P) of k-planes in the n-projective space P by computing the Fano scheme of k planes in P. The returned Grassmannian is a subscheme of the ambient projective space grassAmbient which must have dimension Binomial(n+1,k+1)-1.}
/** MagDoc
Returns the Grassmannian $\mathbb{G}(k,P)$ of $k$-planes in the $n$-projective space $P$ by calling `FanoScheme(P, k, grassAmbient)`. The returned Grassmannian is a subscheme of the ambient projective space `grassAmbient` which must have dimension $\binom{n+1}{k+1}-1$, otherwise an error occurs.
*/

return FanoScheme(P, k, grassAmbient);

end intrinsic;

/** MagDoc Example
We create the Grassmannian $\mathbb{G}(1,3)$ and display its Plücker relation.

     > KK:=Rationals();
     > KK;
     Rational Field
     > grassAmbient<p_0,p_1,p_2,p_3,p_4,p_5>:=ProjectiveSpace(KK,5);
     > grassAmbient;
     Projective Space of dimension 5 over Rational Field
     Variables: p_0, p_1, p_2, p_3, p_4, p_5
     > G:=Grassmannian(1,3,grassAmbient);
     > G;
     Scheme over Rational Field defined by
     p_2*p_3 - p_1*p_4 + p_0*p_5
*/
