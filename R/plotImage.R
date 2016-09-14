#plot 2d bitmap image
plotImage <- function( image, color, dx = 0, dy = 0, pchval = 1 )
{
    nrrows = dim( image )[1]
    nrcols = dim( image )[2]
    for ( row in 1:nrrows )
    {
        for ( col in 1:nrcols )
        {
            if ( image[ row, col ] > 0 )
            {
                points( ( col - 1 + dx ) / ( nrcols - 1 ), 1 - ( row - 1 + dy ) / ( nrrows - 1 ), col = color, pch = pchval )
            }
        }
    }

}
