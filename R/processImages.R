processImages <- function( imagefolder, resultfolder, labels, traintest )
{
    nrimages = length( labels )
    print( paste( 'nrimages', nrimages ))
    for ( imgnr in 0:( nrimages - 1 ))
    {
        if ( imgnr %% 10 == 0)
        {
            print( paste( 'processing ', traintest, ' image #', imgnr, sep = ''))
            flush.console()
        }
        fn = paste( imagefolder, traintest, 'img-', imgnr, '-thinned.txt', sep = '' )
        thinned = as.matrix( read.table( fn ))
        img = thinned > 0
        img_denoised = removeSmallComponents( img )
        
        points = extractStrokes_TSP( img_denoised ) #returns points in drawing order, following the extracted strokes in the image
        fn=paste( resultfolder, traintest, 'img-', imgnr, '-points.txt', sep = '' )
        write.csv(points, file = fn, quote = F, row.names = F )

        addClassOutputs = T
        targetdata = constructInputData( points, trainlabels[ imgnr + 1 ], addClassOutputs )
        fn = paste( resultfolder, traintest, 'img-', imgnr, '-targetdata.txt', sep = '' )
        write.table( targetdata, file = fn, quote = F, row.names = F, col.names = F )

        addClassOutputs = F
        inputdata = constructInputData( points, trainlabels[ imgnr + 1 ], addClassOutputs )
        
        fn = paste( resultfolder, traintest, 'img-', imgnr, '-inputdata.txt', sep = '' )
        write.table( inputdata, file = fn, quote = F, row.names = F, col.names = F )
    }

}
