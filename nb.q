\l funq.q
\l iris.q

/ https://en.wikipedia.org/wiki/Naive_Bayes_classifier
X:(6 5.92 5.58 5.92 5 5.5 5.42 5.75;
 180 190 170 165 100 150 130 150f;
 12 11 12 10 6 8 7 9f)
y:`male`male`male`male`female`female`female`female / classes
Xt:(6 7f;130 190f;8 12f)                           / test data
show flip clf:.ml.fitnb[.ml.gaussml;1f;X;y]        / build classifier
show flip d:.ml.densitynb[.ml.gauss;clf] Xt        / compute densities
show flip .ml.probabilitynb d   / convert densities to probabilities
.util.assert[`female`male] .ml.predictnb d    / make classification predictions
.util.assert[`female`male] .ml.lpredictnb .ml.densitynb[.ml.gaussll;clf] Xt / use log likelihood

/ iris
clf:.ml.fitnb[.ml.gaussml;1f;iris.X;iris.y] / build classifier
d:.ml.densitynb[.ml.gauss;clf] iris.X             / compute densities
flip .ml.probabilitynb d        / convert densities to probabilities
.util.assert[.96f] avg iris.y=.ml.predictnb d / how good is classification
.util.assert[.96f] avg iris.y=.ml.lpredictnb .ml.densitynb[.ml.gaussll;clf] iris.X / use log likelihood

/ inf2b-learn-note07-2up.pdf
X:(2 0 0 1 5 0 0 1 0 0 0;       / goal
 0 0 1 0 0 0 3 1 4 0 0;         / tutor
 0 8 0 0 0 1 2 0 1 0 1;         / variance
 0 0 1 8 0 1 0 2 0 0 0;         / speed
 1 3 0 0 1 0 0 0 0 0 7;         / drink
 1 1 3 8 0 0 0 0 1 0 0;         / defence
 1 0 5 0 1 6 1 1 0 0 1;         / performance
 1 0 0 1 9 1 0 2 0 0 0)         / field
Xt:flip(8 0 0 1 7 1 0 1;0 1 3 0 3 0 1 0)
y:(6#`sport),5#`informatics
/ bernoulli
show flip clf:.ml.fitnb[.ml.binml[1];1f;0<X;y] / build classifier
show flip d:.ml.densitynb[.ml.binla[1];clf] Xt / compute densities
.util.assert[`sport`informatics] .ml.predictnb d / make classification prediction

/ bernoulli - add one smoothing
show flip clf:.ml.fitnb[.ml.binml[2];1f;1+0<X;y]
.util.assert[`sport`informatics] .ml.predictnb .ml.densitynb[.ml.binla[2];clf] Xt
.util.assert[`sport`informatics] .ml.lpredictnb .ml.densitynb[.ml.binll[2];clf] Xt / use log likelihood

/ multinomial - add one smoothing
show flip clf:.ml.fitnb[.ml.multiml[1];1f;X;y]
.util.assert[`sport`informatics] .ml.predictnb .ml.densitynb[.ml.multila;clf] Xt
.util.assert[`sport`informatics] .ml.lpredictnb .ml.densitynb[.ml.multill;clf] Xt / use log likelihood

/ https://www.youtube.com/watch?v=km2LoOpdB3A
X:(2 2 1 1; / chinese
 1 0 0 0;   / beijing
 0 1 0 0;   / shanghai
 0 0 1 0;   / macao
 0 0 0 1;   / tokyo
 0 0 0 1)   / japan
y:`c`c`c`j
Xt:flip enlist 3 0 0 0 1 1

/ multinomial - add one smoothing
show flip clf:.ml.fitnb[.ml.multiml[1];1f;X;y]
show flip d:.ml.densitynb[.ml.multila;clf] Xt
show flip .ml.probabilitynb d
.util.assert[1#`c] .ml.predictnb d

