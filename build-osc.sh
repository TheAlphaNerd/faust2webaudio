#!/bin/bash
# tputcolors

# Adapted From https://gist.github.com/camupod/5640386
echo 'Compiling From Faust -> CPP'
faust -a minimal.cpp -i -uim -cn Osc  dsp/osc.dsp -o cpp/faust-osc-temp.cpp
sed -e "s/max/fmax/g" -e "s/min/fmin/g" cpp/faust-osc-temp.cpp > cpp/faust-osc.cpp
rm cpp/faust-osc-temp.cpp
echo " $(tput setaf 2)Complete$(tput sgr0)"
echo "Wrapping dat cpp"
sed -e "s/DSP/OSC/g" -e "s/Dsp/Osc/g" -e "s/dsp/osc/g" cpp/faust-wrapper.cpp >> cpp/faust-osc.cpp
echo " $(tput setaf 2)Complete$(tput sgr0)"
echo "Using emscripten to compile to JavaScript"
emcc cpp/faust-osc.cpp -o js/faust-osc-temp.js \
-s EXPORTED_FUNCTIONS="['_osc_constructor','_osc_destructor','_osc_compute', '_osc_getNumInputs', '_osc_getNumOutputs']"
echo " $(tput setaf 2)Complete$(tput sgr0)"
echo "Wrapping js"
cat js/header.js > js/faust-osc.js
cat js/faust-osc-temp.js >> js/faust-osc.js
rm js/faust-osc-temp.js
cat js/wrapper.js >> js/faust-osc.js
echo " $(tput setaf 2)Complete$(tput sgr0)"