plotstrokes <- function( data, title ){
    mu1 = data[,1]
    mu2 = -data[,2]
    xvals = cumsum( mu1 )
    yvals = cumsum( mu2 )
    xvals = c( xvals, 0 )
    yvals = c( yvals, 0 )
    xrange = range( xvals )
    yrange = range( yvals )
    vals = c( xvals, yvals )
    colors = c( 'blue', 'green', 'black', 'red', 'magenta' )
    
    x = 0
    y = 0
    result = NULL
    eod_found = F
    strokenr = 1
    colornr = (strokenr %% length( colors ) ) + 1
    pointnr=0
    for ( row in 1:dim( data )[1] )
    {
        dx = mu1[ row ]
        dy = mu2[ row ]
        if ( data[ row, 4 ])
        {
            eod_found = T
        }
        if ( row == 2 )
        {
            plot( c( x, x + dx ), c( y, y + dy ), t = 'l', col = colors[ colornr ], xlim =  c( xrange[1] - 1, xrange[2] + 1 ), ylim = c( yrange[1] - 1, yrange[2] + 1),, main = title, xlab = '', ylab = '', xaxt = 'n', yaxt = 'n' )
        }
        else if ( row > 1 )
        {
            if ( data[ row - 1, 3 ])
            {
                strokenr = strokenr + 1
                colornr = ( strokenr %% length( colors ) ) + 1
            }
            else{ #unless EOS was encountered
                points( c( x, x + dx ), c( y, y + dy ), t = 'l', col = colors[ colornr ] ) 
            }
        }
        if ( !data[row, 3] && row >= 2)
        {
            text( x, y, pointnr )
            pointnr = pointnr + 1
        }
        x = x + dx
        y = y + dy
    }
}
