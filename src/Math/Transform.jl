using Printf
using CoordinateTransformations, Rotations, StaticArrays

mutable struct Rotation
  axis::Vector3{Float64}
  theta::Float64
end

mutable struct Transform
  name::String
  position::Vector3{Float64}
  rotation::Rotation
  scale::Vector3{Float64}
  parent
  children
end

Transform(position::Vector3{Float64};
  rotation::Rotation = Rotation(Vector3(0.0, 0.0, 0.0), 0.0),
  scale::Vector3{Float64} = Vector3(1.0, 1.0, 1.0),
  name::String = "Transform",
  parent = missing,
  children = missing) = Transform(name, position, rotation, scale, parent, children)

function SetParent(transform::Transform, parent::Transform)
  if !isnothing(transform.parent)
    remove!(transform.parent.children, transform)
  end

  transform.parent = parent
  push!(parent.children, transform)
end

function GetModelMatrix(transform::Transform)
  id = Identity()
  scale = Scale(transform.scale)
  translate = Translate(transform.position)
  rot = Rotate(transform.rotation.axis, transform.rotation.theta)
  id * translate * rot * scale
end

function GetQuaternion(rotation::Rotation)
  qrotation(Vector(rotation.axis), deg2rad(rotation.theta))
end

export Transform, Rotation, SetParent, GetModelMatrix, GetQuaternion