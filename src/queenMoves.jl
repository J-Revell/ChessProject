queenMoves(sqr::T, occupied::UInt) where T <: Union{Int, UInt} = rookMoves(sqr, occupied) | bishopMoves(sqr, occupied)
