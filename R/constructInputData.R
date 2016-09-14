constructInputData <- function( points, label, addclassoutputs ){

    nrpoints = dim(points)[1]
    if ( addclassoutputs )
    {
        result = matrix( 0, nrpoints, 10 + 2 + 2 ) #column 1..10: label (one-hot), 11-12: dx dy, 13: end-of-stroke, 14: end-of-letter
    }
    else
    {
        result = matrix( 0, nrpoints, 2 + 2 ) #column 1-2: dx dy, 3: end-of-stroke, 4: end-of-letter
    }
    nrcols = dim( result )[2]
    
    xprev = 0
    yprev = 0
    if ( addclassoutputs )
    {
        result[, label + 1 ] = 1
    }
    
    for ( p in 1:nrpoints )
    {
        point = points[ p, ]
        x = point[1]
        y = point[2]
        if ( ( x >= 0 ) & ( y >= 0 ) )
        {
            dx = x - xprev
            dy = y - yprev
            xprev = x
            yprev = y
            result[ p, (nrcols-3) : (nrcols-2) ] = c(dx, dy)
        }
        else
        {
            dx = -1
            dy = -1
            result[ p, nrcols-1 ] = 1 #end of stroke
        }
    }
    
    result[ nrpoints, nrcols ] = 1 #end of sequence
    return( result )
}
