# wrappers of the fathom c library
# currently only Linux support for Astellarn

const FATHOM_PATH = "./Fathom/src/apps/fathom.linux"


# constants defined in fathom
const TB_LOSS = 0
const TB_BLESSED_LOSS = 1
const TB_DRAW = 2
const TB_CURSED_WIN = 3
const TB_WIN = 4

const TB_PROMOTES_NONE = 0
const TB_PROMOTES_QUEEN = 1
const TB_PROMOTES_ROOK = 2
const TB_PROMOTES_BISHOP = 3
const TB_PROMOTES_KNIGHT = 4

const TB_RESULT_WDL_MASK = 0x0000000F
const TB_RESULT_TO_MASK = 0x000003F0
const TB_RESULT_FROM_MASK = 0x0000FC00
const TB_RESULT_PROMOTES_MASK = 0x00070000
const TB_RESULT_EP_MASK = 0x00080000
const TB_RESULT_DTZ_MASK = 0xFFF00000
const TB_RESULT_WDL_SHIFT = 0
const TB_RESULT_TO_SHIFT = 4
const TB_RESULT_FROM_SHIFT = 10
const TB_RESULT_PROMOTES_SHIFT = 16
const TB_RESULT_EP_SHIFT = 19
const TB_RESULT_DTZ_SHIFT = 20


function TB_GET_WDL(res::UInt32)
    (res & TB_RESULT_WDL_MASK) >> TB_RESULT_WDL_SHIFT
end


function TB_GET_TO(res::UInt32)
    (res & TB_RESULT_TO_MASK) >> TB_RESULT_TO_SHIFT
end


function TB_GET_FROM(res::UInt32)
    (res & TB_RESULT_FROM_MASK) >> TB_RESULT_FROM_SHIFT
end


function TB_GET_PROMOTES(res::UInt32)
    (res & TB_RESULT_PROMOTES_MASK) >> TB_RESULT_PROMOTES_SHIFT
end


function TB_GET_EP(res::UInt32)
    (res & TB_RESULT_EP_MASK) >> TB_RESULT_EP_SHIFT
end


function TB_GET_DTZ(res::UInt32)
    (res & TB_RESULT_DTZ_MASK) >> TB_RESULT_DTZ_SHIFT
end


function tb_init(syzygypath::String)::Bool
    return ccall((:tb_init, FATHOM_PATH), UInt8, (Ptr{UInt8},), syzygypath)
end


function tb_free()
    ccall((:tb_free, FATHOM_PATH), Cvoid, ())
end


function tb_probe_wdl(board::Board)
    return ccall((:tb_probe_wdl_impl, FATHOM_PATH), Cuint, (UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt32, UInt8,),
        board[WHITE].val, board[BLACK].val, board[KING].val, board[QUEEN].val, board[ROOK].val, board[BISHOP].val, board[KNIGHT].val, board[PAWN].val,
        0, board.turn == WHITE ? 1 : 0)
end


function tb_probe_root(board::Board)
    result = Ref{UInt32}(0)
    return ccall((:tb_probe_root_impl, FATHOM_PATH), Cuint, (UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt32, UInt32, UInt8, Ref{UInt32}, ),
        board[WHITE].val, board[BLACK].val, board[KING].val, board[QUEEN].val, board[ROOK].val, board[BISHOP].val, board[KNIGHT].val, board[PAWN].val,
        0, 0, board.turn == WHITE ? 1 : 0, result)
end
