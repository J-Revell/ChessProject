ThreadStats() = ThreadStats(0, 0, 0, 0)

Thread() = Thread(TimeManagement(),
    Board(),
    [MoveStack(MAX_PLY + 1) for i in 1:MAX_PLY+1],
    ThreadStats(),
    [MoveOrder() for i in 0:MAX_PLY+1],
    MoveStack(MAX_PLY + 1),
    PieceStack(MAX_PLY + 1),
    zeros(Int, MAX_PLY + 1),
    [MoveStack(MAX_QUIET_TRACK) for i in 0:MAX_PLY + 1],
    ButterflyHistTable([[zeros(Int, 64) for i in 1:64] for j in 1:2]),
    CounterHistTable([[[zeros(Int, 64) for j in 1:6] for k in 1:64] for l in 1:6]),
    CounterHistTable([[[zeros(Int, 64) for j in 1:6] for k in 1:64] for l in 1:6]),
    repeat([MoveStack([MOVE_NONE, MOVE_NONE], 2)], MAX_PLY + 1),
    CounterTable([[repeat([MOVE_NONE], 64) for j in 1:6] for k in 1:2]),
    PawnTable(),
    false)


const ThreadPool = Vector{Thread}
ThreadPool(n::Int) = [Thread() for i in 1:n]


# we can't increase the number of threads in julia while the process is running...
# so we set an atexit condition to reload the engine & process from scratch
function createthreadpool(board::Board, num_threads::Int)
    if Threads.nthreads() !== num_threads
        fen = exportfen(board)
        atexit(() -> withenv(() -> run(`julia AstellarnEngine.jl $fen "info string set Threads to $num_threads"`), "JULIA_NUM_THREADS" => num_threads))
        exit()
    end
end


function setthreadpoolboard!(threads::ThreadPool, board::Board)
    for thread in threads
        copy!(thread.board, board)
    end
end
