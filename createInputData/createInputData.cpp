#include "opencv2/core/core.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <math.h>
#include <iostream>
#include <fstream>
#include "readImages/readMNISTImages.h"
#include "voronoi/src/voronoi.h"
#include "connectedComponents/connectedComponents.h"

using namespace cv;
using namespace std;


class VoronoiIterator {
public:
  VoronoiIterator() {}

  void init(const cv::Mat1b & query, std::string implementation_name_, bool crop_img_before_)
  {
    _implementation_name = implementation_name_;
    _crop_img_before = crop_img_before_;
    _first_img = query.clone();
    VoronoiThinner::copy_bounding_box_plusone(query, _first_img, true);
    _curr_skel = _first_img.clone();
    _curr_iter = 1;
    _nframes = 0;
  }

  inline cv::Mat1b first_img() {
    return _first_img.clone();
  }

  cv::Mat1b current_skel() const {
    return _thinner.get_skeleton().clone();
  }

  inline cv::Mat1b contour_brighter(const cv::Mat1b & img) {
    _contour_viz.from_image_C4(img);
    cv::Mat1b ans;
    _contour_viz.copyTo(ans);
    return ans;
  }

  inline cv::Mat3b contour_color(const cv::Mat1b & img) {
    _contour_viz.from_image_C4(img);
    return _contour_viz.illus().clone();
  }

  bool iter() {
    ++_nframes;
    bool reuse = (_implementation_name != IMPL_MORPH); // cant reuse with morph implementation
    bool success = false;
    if (reuse)
      success = _thinner.thin(_curr_skel, _implementation_name, false, 1); // already cropped
    else
      success = _thinner.thin(_first_img, _implementation_name, false, _nframes); // already cropped
    _thinner.get_skeleton().copyTo(_curr_skel);
    return success;
  }

  inline bool has_converged() const { return _thinner.has_converged(); }
  inline int cols() const { return _first_img.cols; }
  inline int rows() const { return _first_img.rows; }

  //protected:
  std::string _implementation_name;
  bool _crop_img_before;
  int _nframes;
  int _curr_iter;
  cv::Mat1b _first_img;
  cv::Mat1b _curr_skel;
  VoronoiThinner _thinner;
  ImageContour _contour_viz;
}; // end class VoronoiIterator

void writeImage( string fn, Mat binaryImage)
{
  ofstream outputFile;
  outputFile.open( fn );

  for (int r = 0; r < binaryImage.rows; r++){
    for (int c = 0; c < binaryImage.cols; c++){
      int pixel = binaryImage.at<uchar>(r,c);
      outputFile << pixel << '\t';
    }
    outputFile << endl;
  }
  outputFile.close();
}

void writeVector( string fn, vector<double> data)
{
  ofstream outputFile;
  outputFile.open( fn );
  for ( int i = 0; i < data.size(); i++)
    {
      outputFile << data[i] << endl;
  }
  outputFile.close();
}

void voronoiThinImage(const Mat& mnist_image, Mat& result, string thinning_method, string label, string prefix, string resultdir, int i)
{
  const cv::Mat1b & query = mnist_image.clone();
  VoronoiThinner thinner;
  VoronoiIterator it;

  bool crop_img_before=false;

  it.init(query, thinning_method, crop_img_before);
  bool success = thinner.thin( query, thinning_method, false, 1); // already cropped
  thinner.get_skeleton().copyTo( result );
    
}

void createImages( string traintest, string mnistdir, string resultdir, int maxnrsequences, int maxnrimages )
{
  bool usetrain = false;
  if ( traintest == "train" )
    usetrain = true;
  
  //#parameters:
  int dark_on_light=0;

  string filename;
  if (usetrain)
    {
      filename = mnistdir + "/train-images-idx3-ubyte";
    }
  else
    {
      filename = mnistdir + "/t10k-images-idx3-ubyte";
    }
  cout << "filename " << filename << endl;
  
  //read MNIST iamge into OpenCV Mat 
  vector<cv::Mat> mnist_images;
  read_Mnist( filename, mnist_images );
  cout << mnist_images.size() << endl;

  string prefix;
  int maxnrlabels;
  if ( usetrain )
    {
      prefix = "train";
      maxnrlabels = 60000;
    }
  else
    {
      prefix = "test";
      maxnrlabels = 10000;
    }

  Mat mnist_image, image_3channels, thinned, thresholded;
  int nrimages_process = mnist_images.size();   //nr train images:60000. nr test: 10000

  if ( maxnrsequences > 0 )
    {
      nrimages_process = maxnrsequences;
    }  

  cout << "nrimages_process " << nrimages_process << endl;
  string fn;
  
  for (int i = 0; i < nrimages_process; i++ )
    {
      mnist_image = mnist_images[i];    

      if ( i < maxnrimages )
	{
	  fn = resultdir + "/" + prefix + "img-" + to_string(i) + "-input.png";   
	  imwrite( fn, mnist_image);
	}
      fn = resultdir + "/" + prefix + "img-" + to_string(i) + "-input.txt";   
      writeImage( fn, mnist_image);

      std::vector<ConnectedComponent> components;
      findCC4( mnist_image.clone(), components );
      int nrcomponents_org4 = components.size();
      findCC8( mnist_image.clone(), components );
      int nrcomponents_org8 = components.size();
      int orgnrpoints = cv::countNonZero( mnist_image );

      int thr = 0;
      int stepsize = 25;
      bool done = false;
      int nrcomponents4, nrcomponents8;
      while( !done ) //keep increasing threshold until number of 4-connected or 8-connected components changes
	{
	  cv::threshold(mnist_image.clone(), thresholded, thr, 255, CV_THRESH_BINARY);

	  findCC4(thresholded.clone(), components);
	  nrcomponents4 = components.size();
	  findCC8(thresholded.clone(), components);
	  nrcomponents8 = components.size();

	  int nrpoints = cv::countNonZero( thresholded );

	  if ( nrpoints < 0.5 * orgnrpoints)
	    done = true;
	  else if (( nrcomponents4 != nrcomponents_org4 ) || ( nrcomponents8 != nrcomponents_org8 ) || ( thr >= 250 ))
	    done = true;
	  else
	    thr += stepsize;	    
	}
      thr = max( 0, thr - stepsize );
      cv::threshold(mnist_image.clone(), thresholded, thr, 255, CV_THRESH_BINARY);

      if (i < maxnrimages )
	{
	  fn = resultdir + "/" + prefix + "img-" + to_string(i) + "-thresholded.png";   
	  imwrite( fn, thresholded);
	}
      fn = resultdir + "/" + prefix + "img-" + to_string(i) + "-thresholded.txt";   
      writeImage( fn, thresholded);
      thr += stepsize;           
    
      Mat src_image=mnist_image;

      if (src_image.empty())
	{
	  cerr << "couldn't load query image" << endl;
	  return -1;
	}

      voronoiThinImage( thresholded, thinned, "zhang_suen", "thinned", prefix, resultdir, i );//zhang_suen on thresholded image     

      if (i < maxnrimages )
	{
	  fn = resultdir + "/" + prefix + "img-" + to_string(i) + "-thinned.png";   
	  imwrite( fn, thinned);
	}
      fn = resultdir + "/" + prefix + "img-" + to_string(i) + "-thinned.txt";   
      writeImage( fn, thinned);
    
    } //for i

  string labelfile;  
  if (usetrain){
    filename = mnistdir + "/train-labels-idx1-ubyte"; 
    labelfile = resultdir + "/trainlabels.txt";
  }
  else{
    filename = mnistdir + "/t10k-labels-idx1-ubyte";
    labelfile = resultdir + "/testlabels.txt";
  }
  
  vector<double> labels(maxnrlabels);
  read_Mnist_Label(filename, labels);

  vector<double> selection(&labels[0],&labels[nrimages_process]);    
  writeVector( labelfile, selection );

}

int main( int argc, char* argv[] )
{
  if ( argc < 2 )
    {
      cout << "Usage: ./createdata <path-to-MNIST-data-folder>" << endl;
      return 1;
    }
  
  string mnistdir = argv[1];
  cout << "Found MNIST data path: " << mnistdir << endl;

  string resultdir = "digit-images-thinned";

  int maxnrsequences = 0; //0 = no maximum, i.e. all 60.000 train and 10.000 test images
  int maxnrimages = 100;

  createImages( "train", mnistdir, resultdir, maxnrsequences, maxnrimages );
  createImages( "test",  mnistdir, resultdir, maxnrsequences, maxnrimages );

  return 0;
}
