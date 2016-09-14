turn <- function( pointmatrix ) #turn point matrix into image that can be passed to image()
{
    image = t( pointmatrix )[, dim( pointmatrix )[1]:1 ]
    return( image )
}
