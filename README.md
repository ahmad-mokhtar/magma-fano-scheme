<note>This page is automatically generated from the source code FanoScheme.m by a prototype MAGMA documentation generator created by Ahmad Mokhtar.</note>
# FanoScheme
![Static Badge](https://img.shields.io/badge/MAGMA_Package-8A2BE2)
![Static Badge](https://img.shields.io/badge/Author-Ahmad_Mokhtar-blue)
![Static Badge](https://img.shields.io/badge/Updated-Feb_26,_2024-blue)



FanoScheme is a package in MAGMA for computation with Fano schemes of embedded projective varieties.
Let $X\subset \mathbb{P}^n$ be an embedded projective variety.
Then the Fano scheme $\mathbf{F}_k (X)$ of $k$-planes in $X$ is the fine moduli space that parametrizes those $k$-planes contained in $X$.
The scheme $\mathbf{F}_k (X)$ is a subscheme of the Grassmannian $\mathbb{G}(k,n)$.

Moreover, a Grassmannian $\mathbb{G}(k,n)$ is the same as the Fano scheme $\mathbf{F}_k(\mathbb{P}^n)$.

## List of intrinsics

[<intrinsic>FanoScheme(X, k, grassAmbient) : Sch,RngIntElt,Prj -> Sch</intrinsic>](#intrinsic-1)  
[<intrinsic>FanoScheme(X , k) : Sch,RngIntElt -> Sch</intrinsic>](#intrinsic-2)  
[<intrinsic>Grassmannian(k, n, grassAmbient) : RngIntElt,RngIntElt,Prj -> Sch</intrinsic>](#intrinsic-3)  
[<intrinsic>Grassmannian(k, P) : RngIntElt,Prj -> Sch</intrinsic>](#intrinsic-4)  
[<intrinsic>Grassmannian(k, P, grassAmbient) : RngIntElt,Prj,Prj -> Sch</intrinsic>](#intrinsic-5)  

## Description

<a name="intrinsic-1"></a>
<intrinsic>FanoScheme(X, k, grassAmbient) : Sch,RngIntElt,Prj -> Sch</intrinsic>

Returns the Fano scheme $\mathbf{F}_k(X)$ as a subscheme of a Grassmannian $\mathbb{G}(k, r)$ embedded in the projective space `grassAmbient`. The dimension of `grassAmbient` must be equal to $\binom{r+1}{k+1}$ where $r$ is the dimension of the ambient projective space of $X$, otherwise an error occurs. The returned Fano scheme is a subscheme of `grassAmbient`.

---

<a name="intrinsic-2"></a>
<intrinsic>FanoScheme(X , k) : Sch,RngIntElt -> Sch</intrinsic>

Returns the Fano scheme $\mathbf{F}_k(X)$ as a subscheme of a Grassmannian $\mathbb{G}(k, r)$ embedded in a projective space of dimension $\binom{r+1}{k+1}$. It creates a projective space `ambientSpace` of dimension $\binom{r+1}{k+1}$ and then calls `FanoScheme(X, k, grassAmbient)`.


>**Example 1** : The famous Cayley-Salmon theorem asserts that a smooth cubic surface in $\mathbb{P}^3$ contains exactly 27 lines. We will use `FanoScheme` to demonstrate the theorem.
>     
>     > KK:=Rationals();
>     > KK;
>     Rational Field
>     > P<x,y,z,w>:=ProjectiveSpace(KK,3);
>     > P;
>     Projective Space of dimension 3 over Rational Field
>     Variables: x, y, z, w
>     > grassAmbient<p_0,p_1,p_2,p_3,p_4,p_5>:=ProjectiveSpace(KK,5);
>     > grassAmbient;
>     Projective Space of dimension 5 over Rational Field
>     Variables: p_0, p_1, p_2, p_3, p_4, p_5
>     > X:=Scheme(P, x^3+y^3+z^3+w^3);
>     > X;
>     Scheme over Rational Field defined by
>     x^3 + y^3 + z^3 + w^3
>     > Y:=FanoScheme(X,1,grassAmbient);
>     > Dimension(Y);
>     0
>     > Degree(Y);
>     27


>**Example 2** : The smooth quadric $X\subset \mathbb{P}^3$ defined by $xy-zw=0$  has two disjoint family of lines, namely its two sets of rulings. Let's examine the Fano scheme $\mathbf{F}_1(X)$. We will see that the Fano scheme $\mathbf{F}_1(X)$ has two irreducible components. They are curves of degree 2. Upon inspecting the equations for each compnent, we see that they are two disjoint conics in the Grassmannian $\mathbb{G}(1,3)$.
>     
>     KK;
>     Rational Field
>     > P<x,y,z,w>:=ProjectiveSpace(KK,3);
>     > P;
>     Projective Space of dimension 3 over Rational Field
>     Variables: x, y, z, w
>     > grassAmbient<p_0,p_1,p_2,p_3,p_4,p_5>:=ProjectiveSpace(KK,5);
>     > grassAmbient;
>     Projective Space of dimension 5 over Rational Field
>     Variables: p_0, p_1, p_2, p_3, p_4, p_5
>     X:=Scheme(P, x*y-z*w);
>     X;
>     Scheme over Rational Field defined by
>     x*y - z*w
>     > Y:=FanoScheme(X,1,grassAmbient);
>     for component in IrreducibleComponents(Y) do
>         component;
>         printf "Dimension of component = %o\n", Dimension(component);
>         printf "Degree of component = %o\n", Degree(component);
>         print "-----";
>     end for;
>     Scheme over Rational Field defined by
>     p_2*p_3 + p_5^2,
>     p_0 - p_5,
>     p_1,
>     p_4
>     Dimension of component = 1
>     Degree of component = 2
>     -----
>     Scheme over Rational Field defined by
>     p_1*p_4 + p_5^2,
>     p_0 + p_5,
>     p_2,
>     p_3
>     Dimension of component = 1
>     Degree of component = 2
>     -----

---

<a name="intrinsic-3"></a>
<intrinsic>Grassmannian(k, n, grassAmbient) : RngIntElt,RngIntElt,Prj -> Sch</intrinsic>

Returns the Grassmannian $\mathbb{G}(k, r)$ of $k$-planes in an $n$-projective space $P$. It works by calling `FanoScheme(P, k, grassAmbient)`. The returned Grassmannian is a subscheme of the ambient projective space `grassAmbient` which must have dimension $\binom{n+1}{k+1}-1$, otherwise an error occurs.

---

<a name="intrinsic-4"></a>
<intrinsic>Grassmannian(k, P) : RngIntElt,Prj -> Sch</intrinsic>

Returns the Grassmannian $\mathbb{G}(k,P)$ of $k$-planes in the $n$-projective space $P$ by calling `FanoScheme(P, k)`. The returned Grassmannian is a subscheme of an ambient projective space of dimension $\binom{n+1}{k+1}-1$.

---

<a name="intrinsic-5"></a>
<intrinsic>Grassmannian(k, P, grassAmbient) : RngIntElt,Prj,Prj -> Sch</intrinsic>

Returns the Grassmannian $\mathbb{G}(k,P)$ of $k$-planes in the $n$-projective space $P$ by calling `FanoScheme(P, k, grassAmbient)`. The returned Grassmannian is a subscheme of the ambient projective space `grassAmbient` which must have dimension $\binom{n+1}{k+1}-1$, otherwise an error occurs.

>**Example 3** : We create the Grassmannian $\mathbb{G}(1,3)$ and display its Plücker relation.
>
>     > KK:=Rationals();
>     > KK;
>     Rational Field
>     > grassAmbient<p_0,p_1,p_2,p_3,p_4,p_5>:=ProjectiveSpace(KK,5);
>     > grassAmbient;
>     Projective Space of dimension 5 over Rational Field
>     Variables: p_0, p_1, p_2, p_3, p_4, p_5
>     > G:=Grassmannian(1,3,grassAmbient);
>     > G;
>     Scheme over Rational Field defined by
>     p_2*p_3 - p_1*p_4 + p_0*p_5
