# Magic numbers for rooks
const ROOK_MAGIC = @SVector [0x8000400020801a, 0x840004020001003, 0x8880200010018108, 0x480040800801001, 0x900080002050010, 0x200100804010200, 0x200010084080200, 0x200024100821224,
	0x8a0802080004000, 0x6401004402000, 0x800802000100080, 0x4004800803100081, 0x106000810200600, 0x2981000802040100, 0x4000804018210, 0x201000192026300,
	0x1038218000804000, 0x1010004000200040, 0x108420012002881, 0x2098008008100080, 0x4088010004090010, 0x2000808002000400, 0x28a0c0008021025, 0x220000810064,
	0x40400480208000, 0x8040200040100042, 0x2000100080802000, 0x3090004040080401, 0x100080080800400, 0x8230020080800400, 0x2000200080104, 0xc00010200004084,
	0x400082800020, 0x400200080804007, 0x8400801000802001, 0x18100080800800, 0x810310005004800, 0x8000020080800400, 0x2000302134000208, 0x298402000645,
	0x800140018022, 0x184020100c4000, 0x6210002804002000, 0x1000c10010020, 0x4201000800110004, 0x2002000810020004, 0xa40c21480a040090, 0x4081020004,
	0x3302410080002300, 0x9210002000401040, 0x92110041200300, 0x100100109002300, 0xa800800240280, 0x100040080020080, 0x506201080400, 0x1002209110440600,
	0x140800300182241, 0x8280184280220102, 0x5118042000a22, 0x8a000890204006, 0x200304844204a, 0x108200080930041a, 0x482000100840842, 0x12192404430182]

# Rook move masks
const ROOK_MASK = @SVector [0x000101010101017e, 0x000202020202027c, 0x000404040404047a, 0x0008080808080876, 0x001010101010106e, 0x002020202020205e, 0x004040404040403e, 0x008080808080807e,
	0x0001010101017e00, 0x0002020202027c00, 0x0004040404047a00, 0x0008080808087600, 0x0010101010106e00, 0x0020202020205e00, 0x0040404040403e00, 0x0080808080807e00,
	0x00010101017e0100, 0x00020202027c0200, 0x00040404047a0400, 0x0008080808760800, 0x00101010106e1000, 0x00202020205e2000, 0x00404040403e4000, 0x00808080807e8000,
	0x000101017e010100, 0x000202027c020200, 0x000404047a040400, 0x0008080876080800, 0x001010106e101000, 0x002020205e202000, 0x004040403e404000, 0x008080807e808000,
	0x0001017e01010100, 0x0002027c02020200, 0x0004047a04040400, 0x0008087608080800, 0x0010106e10101000, 0x0020205e20202000, 0x0040403e40404000, 0x0080807e80808000,
	0x00017e0101010100, 0x00027c0202020200, 0x00047a0404040400, 0x0008760808080800, 0x00106e1010101000, 0x00205e2020202000, 0x00403e4040404000, 0x00807e8080808000,
	0x007e010101010100, 0x007c020202020200, 0x007a040404040400, 0x0076080808080800, 0x006e101010101000, 0x005e202020202000, 0x003e404040404000, 0x007e808080808000,
	0x7e01010101010100, 0x7c02020202020200, 0x7a04040404040400, 0x7608080808080800, 0x6e10101010101000, 0x5e20202020202000, 0x3e40404040404000, 0x7e80808080808000]

# rook table offsets
const ROOK_OFFSET = @SVector [0, 4096, 6144, 8192, 10240, 12288, 14336, 16384, 20480, 22528, 23552, 24576, 25600, 26624, 27648, 28672, 30720, 32768, 33792,
	34816, 35840, 36864, 37888, 38912, 40960, 43008, 44032, 45056, 46080, 47104, 48128, 49152, 51200, 53248, 54272, 55296, 56320, 57344, 58368, 59392, 61440,
	63488, 64512, 65536, 66560, 67584, 68608, 69632, 71680, 73728, 74752, 75776, 76800, 77824, 78848, 79872, 81920, 86016, 88064, 90112, 92160, 94208, 96256, 98304]

rookMove_N(rook::UInt64) = rook << 8
rookMove_S(rook::UInt64) = rook >> 8
rookMove_E(rook::UInt64) = ~FILE_A & (rook >> 1)
rookMove_W(rook::UInt64) = ~FILE_H & (rook << 1)
const ROOK_MOVE_FUNCTIONS = @SVector Function[rookMove_N, rookMove_S, rookMove_E, rookMove_W]

# initialise the tables on startup
const ROOK_TABLE = initSlidingTable(Vector{UInt}(undef, 102400), ROOK_MAGIC, ROOK_MASK, ROOK_OFFSET, ROOK_MOVE_FUNCTIONS)

rookMoves(sqr::Int, occupied::UInt64) = @inbounds ROOK_TABLE[tableIndex(occupied, ROOK_MAGIC[sqr], ROOK_MASK[sqr], ROOK_OFFSET[sqr])]
rookMoves(sqr::UInt, occupied::UInt64) = getRookMoves(getSquare(sqr), occupied)
