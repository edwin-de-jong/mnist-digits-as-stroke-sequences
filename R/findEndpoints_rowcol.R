findEndpoints_rowcol <- function( image )
{
    nrcols = dim( image )[2]
    nrrows = dim( image )[1]
    nrneighbors = image
    endpoints = NULL

    for ( row in 1:nrrows )
    {
        for ( col in 1:nrcols )
        {
            if ( image[row, col])
            {
                rowfrom = max( 1, row - 1 )
                rowto = min( nrrows, row + 1 )
                colfrom = max( 1, col - 1 )
                colto = min( nrcols, col + 1 )
                neighbors = image[ rowfrom:rowto, colfrom:colto ]
                nrneighbors[ row, col ] = sum( neighbors ) - 1
                if ( nrneighbors[ row, col ] <= 1 )
                {
                    endpoints = rbind( endpoints, as.matrix( t( c(row, col) )))
                }
            }
        }
    }

    return( endpoints )

}
