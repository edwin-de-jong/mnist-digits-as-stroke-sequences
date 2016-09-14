
source( 'R/extractStrokes_TSP.R' )
source( 'R/findEndpoints_rowcol.R' )
source( 'R/turn.R' )
source( 'R/constructInputData.R' )
source( 'R/removeSmallComponents.R' )
source( 'R/processImages.R' )
source( 'R/plotstrokes.R' )
source( 'R/getPointList.R' )
library( TSP )

imagefolder = 'digit-images-thinned/'
resultfolder = 'sequences/'

fn = paste( imagefolder, 'trainlabels.txt', sep = '' )
trainlabels = as.matrix( read.table( fn ))
processImages( imagefolder, resultfolder, trainlabels, "train" )
    
fn = paste( imagefolder, 'testlabels.txt', sep = '' )
testlabels = as.matrix( read.table( fn ) )
processImages( imagefolder, resultfolder, testlabels, "test" )

