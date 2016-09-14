extractStrokes_TSP <- function( image)
{
    pointlist = getPointList( image )
    startingpointlist = findEndpoints_rowcol( image)

    if ( length( startingpointlist ) == 0 ) #no endpoints --> collect all points
    {
        startingpointlist = pointlist
    } 

    dist = apply( startingpointlist, 1, sum) #use top left point as starting point
    ind = which( dist == min( dist ))[1]
    startingpointind = which( (pointlist[,1] == startingpointlist[ ind, 1 ]) & ( pointlist[,2] == startingpointlist[ ind,2 ]) )

    stops = pointlist[, 2:1 ]
    nrstops = dim(stops)[1]
    distmat = matrix(0, nrstops, nrstops)
    for ( s in 1:nrstops )
    {
        for( t in s:nrstops )
        {
            dist = abs( stops[s,] - stops[t,] )
            cost = sum( dist^3 ) #Encourage minimal distances
            distmat[s,t] = cost
            distmat[t,s] = cost
        }
    }

    atsp <- ATSP( distmat )
    tour <- solve_TSP(atsp, method = "nn", control = list( start = startingpointind, repetitions = 10))

    points_tsp = stops[ tour, ]

    pointlist = NULL #Separate strokes with marker lines (-1, -1)
    nrpoints = dim( points_tsp )[1]
    for ( i in 1:nrpoints )
    {
        pointlist = rbind( pointlist, points_tsp[i,] )
        if ( i < nrpoints - 1)
        {
            if ( max( abs( points_tsp[i+1,] - points_tsp[i,] )) > 1)
            {
                pointlist = rbind( pointlist, c( -1, -1 ) )
            }
        }
    }
    pointlist = rbind( pointlist, c( -2, -2 ) )

    return( pointlist )

}
