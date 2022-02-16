using Quaternions
using LinearAlgebra
using StaticArrays

abstract type Camera end

mutable struct PerspectiveCamera <: Camera
  position::Vector3{Float64}
  rotation::Rotation

  fov::Float64
  near::Float64
  far::Float64

  forward::Vector3{Float64}
  right::Vector3{Float64}
  up::Vector3{Float64}

  viewMatrix::Matrix{GLfloat}
  quaternion::Quaternion{Float64}

  PerspectiveCamera(; Position::Vector3{Float64} = Vector3{Float64}(0.0, 0.0, 0.0), Rotation::Rotation = Rotation(Vector3{Float64}(0.0, 0.0, 0.0), 0.0),
    Fov::Float64 = 70.0, Near::Float64 = 0.1, Far::Float64 = 100.0) =
    new(Position, Rotation, Fov, Near, Far, Vector3{Float64}(0.0, 0.0, -1.0), Vector3{Float64}(1.0, 0.0, 0.0), Vector3{Float64}(0.0, 1.0, 0.0), Matrix(I, 4, 4), qrotation([Rotation.axis.x, Rotation.axis.y, Rotation.axis.z], Rotation.theta))
end

function Update!(camera::Camera)
  translation = Translate(camera.position)

  camera.quaternion = qrotation([camera.rotation.axis.x, camera.rotation.axis.y, camera.rotation.axis.z], deg2rad(camera.rotation.theta))
  rotationMatrix = rotationmatrix(camera.quaternion)
  rotation = convert(Matrix{GLfloat}, vcat([rotationMatrix [0; 0; 0]], SMatrix{1,4,GLfloat,4}(0, 0, 0, 1)))

  camera.forward = rotationMatrix * Vector3_Forward()
  camera.right = rotationMatrix * Vector3_Right()
  camera.up = rotationMatrix * Vector3_Up()

  camera.viewMatrix = rotation * translation
end

function ProjectionMatrix(camera::Camera)
  if camera isa PerspectiveCamera
    PerspectiveProjectionMatrix(camera)
  else
    @error "Invalid camera type! Camera must be a perspective camera"
  end
end

function PerspectiveProjectionMatrix(camera::PerspectiveCamera)
  fov = deg2rad(camera.fov)
  width, height = GLFW.GetFramebufferSize(Window_Get().NativeWindow)
  aspect_ratio = width / height
  range = tan(0.5 * fov) * camera.near
  Sx = 2.0 * camera.near / (range * aspect_ratio + range * aspect_ratio)
  Sy = camera.near / range
  Sz = -(camera.far + camera.near) / (camera.far - camera.near)
  Pz = -(2.0 * camera.far * camera.near) / (camera.far - camera.near)

  GLfloat[Sx 0.0 0.0 0.0
    0.0 Sy 0.0 0.0
    0.0 0.0 Sz Pz
    0.0 0.0 -1.0 0.0]
end

function setposition!(camera::Camera, x::Vector3{Float64})
  camera.position = x
end

export Camera, PerspectiveCamera, rotate!