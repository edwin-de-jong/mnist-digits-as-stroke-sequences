#remove connected components ( cliques ) that contain only 1 or 2 points
removeSmallComponents <- function( image )
{
    points = NULL
    nrpoints = 0
    orgendpoints = NULL
    alldone = F
    nrrows = dim( image )[1]
    nrcols = dim( image )[2]

    endpoints = findEndpoints_rowcol( image )

    if ( !is.null( endpoints ))
    {
        nrendpoints = dim( endpoints )[1]
        enoughpoints = matrix( 0, nrendpoints, 1 )
        
        for ( p in 1:nrendpoints )
        {
            component = matrix( 0, nrrows, nrcols )
            row = endpoints[ p, 1 ]
            col = endpoints[ p, 2 ]
            
            rowfrom = max( 1, row - 1 )
            rowto = min( nrrows, row + 1 )
            colfrom = max( 1, col - 1 )
            colto = min( nrcols, col + 1 )
            nrr = rowto - rowfrom + 1
            nrc = colto - colfrom + 1
            neighbors = image[ rowfrom:rowto, colfrom:colto ]
            component[ rowfrom:rowto, colfrom:colto ] = component[ rowfrom:rowto, colfrom:colto ] + neighbors
            
            if ( sum( component > 0 ) == 1 )
            {
                enoughpoints[ p ] = 0
            }
            else if ( sum( component > 0 ) > 2 )
            {
                enoughpoints[ p ] = 1
            }
            else
            {
                for ( row in rowfrom:rowto )
                {
                    for ( col in colfrom:colto )
                    {
                        if ( image[ row, col ])
                        {
                            rowfrom = max( 1, row - 1 )
                            rowto = min( nrrows, row + 1 )
                            colfrom = max( 1, col - 1 )
                            colto = min( nrcols, col + 1 )
                            nrr = rowto - rowfrom + 1
                            nrc = colto - colfrom + 1
                            neighbors = image[ rowfrom:rowto, colfrom:colto ]
                            component[ rowfrom:rowto, colfrom:colto ] = component[ rowfrom:rowto, colfrom:colto ] + neighbors
                        }
                    }
                }
            }
            if ( sum( component > 0 ) <= 2 && sum( component > 0 ))
            {
                image = image * ( component == 0 )
            }
        }
    }
    return( image )
}
