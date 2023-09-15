push!(LOAD_PATH, "../lib")
using Experiments
using Benchmarks
using ControlVariates

H = 100
period = 0.02
sys = benchmarks[:F1T]
x0 = 1.
u0 = 0.
z0 = [fill(x0, size(sys.A, 1)); u0]

using ControlSystemsBase
using ControlTimingSafety
a = hold_kill(c2d(sys, period), delay_lqr(sys, period))

sp = SamplerPWCET(0.9, 100)

@info Threads.nthreads()

n = 1_000_000
@time res99 = generate_samples(a, z0, 0.99, n)
@time res90 = generate_samples(a, z0, 0.90, n)
@time res50 = generate_samples(a, z0, 0.50, n)
@time res10 = generate_samples(a, z0, 0.10, n)

using Serialization
@time serialize("../data/res99-$n.jls", res99)
@time serialize("../data/res90-$n.jls", res90)
@time serialize("../data/res50-$n.jls", res50)
@time serialize("../data/res10-$n.jls", res10)
