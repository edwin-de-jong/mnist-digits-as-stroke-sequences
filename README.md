## Summary
Code project to transform the well known [MNIST](http://yann.lecun.com/exdb/mnist/) handwritten digit images to sequences of pen strokes, in order to obtain a benchmark data set for sequence learning. 

The resulting sequence data set, containing sequences for all 60000 MNIST training images and 10000 test images, is available for direct download [here](https://github.com/edwin-de-jong/mnist-digits-stroke-sequence-data). See that same page for some examples.

## Project description

Below, we provide details of how the sequences were constructed. The project consists of two parts:

#### Part 1: thinning the MNIST images to obtain a single-pixel-width skeleton. 

This is done in C++ by applying incremental thresholding followed by [Zhang-Suen thinning](https://rosettacode.org/wiki/Zhang-Suen_thinning_algorithm). 

#### Part 2: translating the skeleton to inferred strokes. 

This part is done in [R](https://www.r-project.org/). Briefly, the procedure does the following:
- To ensure the transformation is consistent, all sequences start from the top left endpoint. If no endpoints exist (this happens for zeroes), the top-left point is used as the starting point.
- A Traveling Salesman Problem (TSP) solver from the [TSP package](https://cran.r-project.org/web/packages/TSP/TSP.pdf) is used to identify an order for visiting the points that minimizes the distance travelled by the pen.

## Installation and usage

The instructions below describe how the sequences can be generated from the original MNIST images. 

### Part I: thinning the MNIST images

This project requires the [MNIST handwritten digit data set](http://yann.lecun.com/exdb/mnist/) as input.

Download the files and unpack them into a folder of your choice:

```
wget http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz #training set images

wget http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz #training set labels

wget http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz #test set images

wget http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz #test set labels

gzip -d *.gz
```

Download or fork the code for this project from github. The project contains a submodule, so use --recursive:

```
git clone --recursive https://github.com/edwin-de-jong/mnist-digits-as-stroke-sequences
```

#### Requirements:

This project requires [cmake](https://cmake.org/) and [opencv](http://opencv.org/), here are instructions to install these if needed:

1. cmake

```
sudo apt-get install cmake

sudo apt-get install build-essential
```

2. opencv

```
sudo apt-get install libopencv-dev
```

#### Compilation:

Go to the project folder and compile:

```
./runcmake #Or edit the paths in the Makefile
make
```

This should create an executable named createdata.

#### Running:

```
./createdata << path to your MNIST data folder >>
```

This will generate thinned images. The results will appear in the subfolder named "digit-images-thinned".

By default, png images will be saved of the results of the first 100 images; this number can be changed by setting maxnrimages in createInputData/createInputData.cpp.

#### Modifying the code:
In case you want to modify the code project, you can use cmake. Edit the contents of CMakeLists.txt, and use ./runcmake to generate the updated Makefile.

### Part II: extracting strokes

Open R (e.g. rstudio can be downloaded). Change to the project folder and run the extraction. This requires the TSP package:

```
install.packages( 'TSP' )
setwd( '~/code/mnist-digits-as-stroke-sequences') #Change this path to your local folder
source( 'R/runExtraction.R' )
```

## Contributors 

This code project was created by Edwin D. de Jong for the purpose of creating a data set for evaluating sequence learning algorithms.

## Acknowledgements

The C++ code for thinning the images makes use of the following existing code projects:

### Reading MNIST images
For reading the MNIST images, [code](http://eric-yuan.me/cpp-read-mnist/) provided by Eric Yuan was used; see the readImages subfolder.

### Image thinning
For Zhang-Suen thinning, Arnaud Ramey's [Voronoi project](https://sites.google.com/site/rameyarnaud/research/c/voronoi) was used and included as a git submodule in the subfolder named 'voronoi'.

## License

This project is provided under the [GNU GPL License version 3](LICENSE).

## Contact

Please feel free to contact me for any questions or comments. My email is the 3 parts of my name in *reverse order*:

<img src="fig/contact-info.png" width="700">
