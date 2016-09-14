getPointList <- function( image )
{

    pointlist = NULL
    ind = which( image > 0 )
    nrr = dim( image )[1]
    col = floor( ( ind - 1 ) / nrr ) + 1
    row = ind - nrr * ( col - 1)
    pointlist = cbind( row, col )

    return( pointlist )
    
}
