module Flux

using Base: tail
using LinearAlgebra, Statistics, Random  # standard lib
using MacroTools, Reexport, ProgressLogging, SpecialFunctions
using MacroTools: @forward

@reexport using NNlib
using MLUtils
import Optimisers: Optimisers, trainable, destructure  # before v0.13, Flux owned these functions

using Zygote, ChainRulesCore
using Zygote: Params, @adjoint, gradient, pullback, @nograd
export gradient

# Pirate error to catch a common mistake. (Internal function `base` because overloading `update!` is more likely to give ambiguities.)
Optimisers.base(dx::Zygote.Grads) = error("Optimisers.jl cannot be used with Zygote.jl's implicit gradients, `Params` & `Grads`")

export Chain, Dense, Maxout, SkipConnection, Parallel,
       RNN, LSTM, GRU, GRUv3,
       SamePad, Conv, CrossCor, ConvTranspose, DepthwiseConv,
       AdaptiveMaxPool, AdaptiveMeanPool, GlobalMaxPool, GlobalMeanPool, MaxPool, MeanPool,
       Dropout, AlphaDropout, LayerNorm, BatchNorm, InstanceNorm, GroupNorm,
       Upsample, PixelShuffle,
       fmap, cpu, gpu, f32, f64,
       testmode!, trainmode!

include("optimise/Optimise.jl")
using .Optimise
using .Optimise: @epochs
using .Optimise: skip
export Descent, ADAM, Momentum, Nesterov, RMSProp,
  ADAGrad, AdaMax, ADADelta, AMSGrad, NADAM, OADAM,
  ADAMW, RADAM, AdaBelief, InvDecay, ExpDecay,
  WeightDecay, ClipValue, ClipNorm

using CUDA
const use_cuda = Ref{Union{Nothing,Bool}}(nothing)

include("utils.jl")
include("onehot.jl")
include("functor.jl")

# Pirate error to catch a common mistake.
Functors.functor(::Type{<:MLUtils.DataLoader}, x) = error("`DataLoader` does not support Functors.jl, thus functions like `Flux.gpu` will not act on its contents.")

include("layers/stateless.jl")
include("layers/basic.jl")
include("layers/conv.jl")
include("layers/recurrent.jl")
include("layers/normalise.jl")
include("layers/upsample.jl")
include("layers/show.jl")

include("loading.jl")

include("outputsize.jl")

include("data/Data.jl")
using .Data


include("losses/Losses.jl")
using .Losses # TODO: stop importing Losses in Flux's namespace in v0.12

include("deprecations.jl")

include("cuda/cuda.jl")

end # module
