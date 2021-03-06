using Printf

mutable struct Vector3{R<:Real} <: AbstractVector{3,R}
  x::R
  y::R
  z::R
end

# Vector3 constructors and helper methods
Vector3() = Vector3(0.0, 0.0, 0.0)
Vector3(t::Tuple) = VecE3(promote(t...)...)
toArray(v::Vector3) = ([v.x; v.y; v.z])

# Vector constants
Vector3_Right() = Vector3(1.0, 0.0, 0.0)
Vector3_Up() = Vector3(0.0, 1.0, 0.0)
Vector3_Forward() = Vector3(0.0, 0.0, 1.0)
Vector3_Zero() = Vector3(0.0, 0.0, 0.0)
Vector3_One() = Vector3(1.0, 1.0, 1.0)

# Print vector
Base.show(io::IO, a::Vector3) = @printf(io, "Vector3(%.4f, %.4f, %.4f)", a.x, a.y, a.z)

# Return distance squared between two vectors
function distance2(a::Vector3, b::Vector3)
  dx = a.x - b.x
  dy = a.y - b.y
  dz = a.z - b.z
  (dx * dx + dy * dy + dz * dz)
end

# Return distance between two vectors
function distance(a::Vector3, b::Vector3)
  sqrt(distance2(a, b))
end

function lerp(a::Vector3, b::Vector3, t::Real)
  Vector3(lerp(a.x, b.x, t), lerp(a.y, b.y, t), lerp(a.z, b.z, t))
end

export Vector3, distance2, distance, lerp, toArray

