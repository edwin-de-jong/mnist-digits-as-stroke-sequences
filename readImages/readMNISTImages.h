#ifndef READMNISTIMAGES_INCLUDE
#define READMNISTIMAGES_INCLUDE

#include "opencv2/core/core.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <math.h>
#include <iostream>
#include <fstream>

using namespace cv;
using namespace std;

int ReverseInt (int i);

void read_Mnist(string filename, vector<vector<double> > &vec);

void read_Mnist(string filename, vector<cv::Mat> &vec);

void read_Mnist_Label(string filename, vector<double> &vec);

#endif
