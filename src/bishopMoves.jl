# magic numbers for bishops
const BISHOP_MAGIC = @SVector [0x4404700420508600, 0x9120018401104008, 0x4004010401100084, 0x51040080062000, 0x1124042010010092, 0x1100882108001000, 0x180a280248040000, 0x38440210900400,
	0x80074210e1010301, 0x20101012004e42, 0x8210100110411001, 0x8404108010a0, 0x2060071040002804, 0x6400020202211011, 0xc0d0111202000, 0x8004050118020221,
	0x8005804088080910, 0x6004a82001020200, 0x101001004002041, 0x8a1800a082004282, 0x8806001012100098, 0x22810040504000, 0x4040800048480801, 0xa42041304824120,
	0x204106085200814, 0x890110682040111, 0x4000500001040080, 0x808018020102, 0x2401010010104008, 0x1052008004100080, 0x950104090801, 0x1200808000220864,
	0x8188421201082050, 0x35011001a05c00, 0x51480201104400, 0x4110040400180210, 0x414140400001100, 0x4e60008100688040, 0x121022ac40200, 0x40042904a0094,
	0x2948010421001040, 0x4060821011020200, 0x1004030008202, 0x18020122080401, 0x42ca41a2000400, 0x1c0212040810100, 0x1060480f41020041, 0x20102020a040040,
	0x1082008220100402, 0x102020202828102, 0x4022108848080004, 0x20400508480000, 0x1010108590440010, 0xd812040810a10140, 0x191043000a20038, 0x8010020200620000,
	0x1008801084280, 0x60882015050, 0x8120000100809001, 0x200100002104420, 0x10d100200821010a, 0x3002c0448100110, 0x14004005045c0042, 0x4002901008831040]

# Bishop move masks
const BISHOP_MASK = @SVector [0x0040201008040200, 0x0000402010080400, 0x0000004020100a00, 0x0000000040221400, 0x0000000002442800, 0x0000000204085000, 0x0000020408102000, 0x0002040810204000,
	0x0020100804020000, 0x0040201008040000, 0x00004020100a0000, 0x0000004022140000, 0x0000000244280000, 0x0000020408500000, 0x0002040810200000, 0x0004081020400000,
	0x0010080402000200, 0x0020100804000400, 0x004020100a000a00, 0x0000402214001400, 0x0000024428002800, 0x0002040850005000, 0x0004081020002000, 0x0008102040004000,
	0x0008040200020400, 0x0010080400040800, 0x0020100a000A1000, 0x0040221400142200, 0x0002442800284400, 0x0004085000500800, 0x0008102000201000, 0x0010204000402000,
	0x0004020002040800, 0x0008040004081000, 0x00100a000A102000, 0x0022140014224000, 0x0044280028440200, 0x0008500050080400, 0x0010200020100800, 0x0020400040201000,
	0x0002000204081000, 0x0004000408102000, 0x000a000A10204000, 0x0014001422400000, 0x0028002844020000, 0x0050005008040200, 0x0020002010080400, 0x0040004020100800,
	0x0000020408102000, 0x0000040810204000, 0x00000A1020400000, 0x0000142240000000, 0x0000284402000000, 0x0000500804020000, 0x0000201008040200, 0x0000402010080400,
	0x0002040810204000, 0x0004081020400000, 0x000A102040000000, 0x0014224000000000, 0x0028440200000000, 0x0050080402000000, 0x0020100804020000, 0x0040201008040200]

# bishop table offsets
const BISHOP_OFFSET = @SVector [0, 64, 96, 128, 160, 192, 224, 256, 320, 352, 384, 416, 448,
	480, 512, 544, 576, 608, 640, 768, 896, 1024, 1152, 1184, 1216, 1248, 1280,
	1408, 1920, 2432, 2560, 2592, 2624, 2656, 2688, 2816, 3328, 3840, 3968, 4000,
	4032, 4064, 4096, 4224, 4352, 4480, 4608, 4640, 4672, 4704, 4736, 4768, 4800,
	4832, 4864, 4896, 4928, 4992, 5024, 5056, 5088, 5120, 5152, 5184]

bishopMove_NE(bishop::UInt64) = ~FILE_A & (bishop << 7)
bishopMove_SE(bishop::UInt64) = ~FILE_A & (bishop >> 9)
bishopMove_SW(bishop::UInt64) = ~FILE_H & (bishop >> 7)
bishopMove_NW(bishop::UInt64) = ~FILE_H & (bishop << 9)

const BISHOP_MOVE_FUNCTIONS = @SVector Function[bishopMove_NE, bishopMove_SE, bishopMove_SW, bishopMove_NW]

# initialise the tables on startup
const BISHOP_TABLE = initSlidingTable(Vector{UInt}(undef, 5248), BISHOP_MAGIC, BISHOP_MASK, BISHOP_OFFSET, BISHOP_MOVE_FUNCTIONS)

bishopMoves(sqr::Int, occupied::UInt64) = @inbounds BISHOP_TABLE[tableIndex(occupied, BISHOP_MAGIC[sqr], BISHOP_MASK[sqr], BISHOP_OFFSET[sqr])]
bishopMoves(sqr::UInt, occupied::UInt64) = getBishopMoves(getSquare(sqr), occupied)
