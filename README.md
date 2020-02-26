# gnuplot-fit-common-params
How to fit two models with shared parameters to two datasets with gnuplot

-------------------------------------------------------------------------

Sometimes, several models and their corresponding measurements depend on the same set of parameters, let's call them <img src="https://render.githubusercontent.com/render/math?math=x"> and <img src="https://render.githubusercontent.com/render/math?math=\eta">. Fitting the models via parameter <img src="https://render.githubusercontent.com/render/math?math=x"> (and/or <img src="https://render.githubusercontent.com/render/math?math=\eta">) individually leads to different parameter values, where they should be the same.

The example here are uncertainties of orthogonal quadratures of squeezed light: Both only depend on the pump parameter <img src="https://render.githubusercontent.com/render/math?math=x"> and the overall losses <img src="https://render.githubusercontent.com/render/math?math=\eta">, but follow different models:

<img src="https://render.githubusercontent.com/render/math?math=V^-=1-\eta\frac{4x}{(1%2Bx)^2}">,

<img src="https://render.githubusercontent.com/render/math?math=V^%2B=1%2B\eta\frac{4x}{(1-x)^2}">.

Through measurements we obtained data of <img src="https://render.githubusercontent.com/render/math?math=V^-"> and <img src="https://render.githubusercontent.com/render/math?math=V^%2B">, depending on the pump power <img src="https://render.githubusercontent.com/render/math?math=P">. The pump power <img src="https://render.githubusercontent.com/render/math?math=P"> is related to <img src="https://render.githubusercontent.com/render/math?math=x"> via <img src="https://render.githubusercontent.com/render/math?math=x=\sqrt{P/P_{th}}"> with the threshold power <img src="https://render.githubusercontent.com/render/math?math=P_{th}">.

### What we have
- measurement data of <img src="https://render.githubusercontent.com/render/math?math=V^-"> and <img src="https://render.githubusercontent.com/render/math?math=V^%2B"> depending on <img src="https://render.githubusercontent.com/render/math?math=P">.

### What we want
- use gnuplot to fit both models to the two measured data sets via the shared parameters <img src="https://render.githubusercontent.com/render/math?math=P_{th}"> and <img src="https://render.githubusercontent.com/render/math?math=\eta">.

### The trick
- use a 3-dimensional plot function depending on the pump power `P` and a marker `y`.

The marker indicates which of the two models to use for the respective data point. An example might look like the following.
```
Vminus(P) = 1 - eta * 4 * sqrt(P/Pth) / ( 1 + sqrt(P/Pth) )**2
Vplus(P) = 1 + eta * 4 * sqrt(P/Pth) / ( 1 - sqrt(P/Pth) )**2

fitfunc(P,y) = (y > 0)? Vplus(P) : Vminus(P)

fit fitfunc(P,y) data using 1:3:2 via eta, Pth
```
The ternary operator `a ? b : c` tells gnuplot to use function `b`, if `a` is true, else use function `c`. This can be extended to several such functions and more parameters (robustness of the fit might become an issue). For this to work, the `data` has to be arranged in a particular way. In this example, the first two columns contain the concatenated data sets, the third column the marker, which indicates to which data set the data point belongs with positive values for <img src="https://render.githubusercontent.com/render/math?math=V^-"> and other values for <img src="https://render.githubusercontent.com/render/math?math=V^%2B">. See gnuplot script and example data in this repo.
