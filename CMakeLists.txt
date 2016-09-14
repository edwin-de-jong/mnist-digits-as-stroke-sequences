cmake_minimum_required (VERSION 2.6)
project (mnist_digits_as_stroke_sequences)
add_executable(createdata createInputData/createInputData.cpp readImages/readMNISTImages.cpp connectedComponents/connectedComponents.cpp )

include_directories(.)
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fpermissive -w -std=c++11")
SET(CMAKE_USE_RELATIVE_PATHS ON)

find_package( OpenCV REQUIRED )
target_link_libraries( createdata ${OpenCV_LIBS} )

