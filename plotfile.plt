reset
set datafile separator ","
set xrange [0:240]
set xlabel "Pump power P /mW"
set ylabel "Noise V /dB"
set key top left
file = "data.csv"

# start parameters for fit
eta = 1
Pth = 1000

# fit functions and fit
Vminus(x) = 1 - eta * 4 * sqrt(x/Pth ) / ( 1 + sqrt(x/Pth) )**2
Vplus(x) = 1 + eta * 4 * sqrt(x/Pth) / ( 1 - sqrt(x/Pth) )**2

fitfunc(x,y) = (y > 0) ? Vplus(x) : Vminus(x)

fit fitfunc(x,y) file using 1:3:2 via eta, Pth

# fit results
set label 1 sprintf("eta = %3.2f", eta) at 150, 1.5
set label 2 sprintf("Pth = %3.0f mW", Pth) at 150, 1.2

plot file using 1:(10*log10($2)) every ::6::12 title "data Vplus",\
     file using 1:(10*log10($2)) every ::0::5 title "data Vminus",\
     10 * log10(Vplus(x)) title "fit Vplus",\
     10 * log10(Vminus(x)) title "fit Vminus"

# export to png
set terminal pngcairo enhanced size 800,600 font 'Verdana,16'
set output "plot.png"
replot
unset output
unset terminal
