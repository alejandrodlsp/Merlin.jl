using StaticArrays
using LinearAlgebra
import LinearAlgebra: ⋅, ×

# Define custom abstract vector class for vectors of x size
abstract type AbstractVector{N,R} <: FieldVector{N,R} end

# Lerp between two real numbers
lerp(a::Real, b::Real, t::Real) = a + (a - b) * t

# Inverse lerp between two real numbers
invlerp(a::Real, b::Real, c::Real) = (c - a) / (b - a)

# Normal squared an abstract vector
normsquared(a::AbstractVector) = sum(x^2 for x in a)

# Scale vector by factor
scale(a::AbstractVector, b::Real) = b .* a

# Clamp vector by low and high factors
clamp(a::AbstractVector, low::Real, high::Real) = clamp.(a, low, high)

# Remove x element from array
remove!(array, item) = deleteat!(array, findall(x -> x == item, array))

# Dot product for vectors
dotV(a::AbstractVector, b::AbstractVector) = sum(a .* b)

# Normal plane given 3 points
function normal(a::AbstractVector, b::AbstractVector, c::AbstractVector)
  cross(toArray(b) - toArray(a), toArray(c) - toArray(a))
end

include("Vector2.jl")
include("Vector3.jl")
include("Transform.jl")
include("Mat4.jl")

export AbstractVector, lerp, invlerp, normsquared, normalize, scale, clamp, remove!, dotV
