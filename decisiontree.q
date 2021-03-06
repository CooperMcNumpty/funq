\c 20 100
\l funq.q
\l iris.q

/ http://www.cise.ufl.edu/~ddd/cap6635/Fall-97/Short-papers/2.htm
/ http://www.saedsayad.com/decision_tree.htm
/ Paper_3-A_comparative_study_of_decision_tree_ID3_and_C4.5.pdf
/ https://www.jair.org/media/279/live-279-1538-jair.pdf

-1"load weather data, remove the day column and move Play to front";
show t:`Play xcols (" SSSSS";1#",") 0: `:weather.csv
-1"use the id3 algorithm to build a decision tree";
-1 .ml.ptree[0] tree:.ml.id3 t;
`:tree.dot 0: .ml.pgraph tree
-1"the tree is build with pairs of values.";
-1"the first value is the decision feature,";
-1"and the second value is itself another pair:";
-1"a function (used for numeric values) to apply to the feature,";
-1"and a dictionary representing the leaves";
-1"we can then use the (d)ecission (t)ree (c)lassifier function to classify our data";
avg t.Play=.ml.dtc[tree] each t / accuracy
-1"since the test and training data are the same, it is no suprise we have 100% accuracy";
-1".ml.dtc does not fail on missing features. it digs deeper into the tree";
.util.assert[.71428571428571431] avg t.Play=.ml.dtc[.ml.id3 (1#`Outlook) _ t] each t
-1"id3 only handles discrete features.  c4.5 handles continues features";
-1".ml.q45 implements many of the features of c4.5 including:";
-1"* information gain normalized by split info";
-1"* handling of continuous features";
-1"* use of Minumum Description Length Principal (MDL) ";
-1"  to penalize features with many distinct continuous values";
-1"* pre-prunes branches that create branches with too few leaves";
-1"* post-prunes branches that overfit by given confidence value";
-1"we can test this feature by changing humidity into a continuous variable";
show s:@[t;`Humidity;:;85 90 78 96 80 70 65 95 70 80 70 90 75 80f]
-1"we can see how id3 creates a bushy tree";
-1 .ml.ptree[0] .ml.id3 s;
-1"while q45 picks a single split value";

z:$[`qml in key `;neg .qml.nicdf .0125;2.241403];
-1 .ml.ptree[0] tree:.ml.prune[.ml.perr[z]] .ml.q45[2;0W;::] s;
.util.assert[1f] avg s.Play=.ml.dtc[tree] each s / accuracy
-1"we can still handle null values by using the remaining features";
.util.assert[`Yes] .ml.dtc[tree] d:`Outlook`Temperature`Humidity`Wind!(`Rain;`Hot;85f;`)
-1"we can even can handle nulls in the training data by propegating them down the tree";
s:update Temperature:` from s where Humidity=70f
-1 .ml.ptree[0] tree:.ml.q45[2;0W;::] s;
.util.assert[`No] .ml.dtc[tree] d
-1 "we can also use the gini impurity instead of entropy (faster with similar behavior)";
-1 .ml.ptree[0] tree:.ml.ct[2;0W;::] s; / classification tree
.util.assert[`No] .ml.dtc[tree] d
-1 "we can also create a regression tree when the target is numeric";
-1 .ml.ptree[0] tree:.ml.rt[2;0W;::] update "e"$`Yes=Play from s; / regression tree
.util.assert[0f] .ml.dtc[tree] d
-1 "we can also create an aid tree when the target is numeric";
-1 .ml.ptree[0] tree:.ml.aid[2;0W;::] update "e"$`Yes=Play from s; / regression tree
.util.assert[1] "j"$.ml.dtc[tree] d


-1 "we can now split the iris data into training and test batches";
show d:`train`test!floor[.75*count iris.t] cut 0N?iris.t
-1 .ml.ptree[0] tree:.ml.ct[1;0W;::] `species xcols d`train;
-1 "testing the tree on the test set produces an accuracy of:";
avg d.test.species=p:tree .ml.dtc/: d`test
-1 "we can save the decision tree into graphviz compatible format";
`:tree.dot 0: .ml.pgraph tree

