iris.f:("iris.data";"bezdekIris.data") 1
iris.b:"http://archive.ics.uci.edu/ml/machine-learning-databases/iris/"
-1"downloading iris data set";
.util.download[iris.b;;"";""] iris.f;
iris.XY:150#/:("FFFFS";",") 0: `$iris.f
iris.X:-1_iris.XY
iris.y:first iris.Y:-1#iris.XY
iris.t:`species xcols flip `slength`swidth`plength`pwidth`species!iris.XY

