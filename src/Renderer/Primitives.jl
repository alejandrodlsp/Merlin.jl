Merlin_PrimitiveDefaultColor = Vector3{Float64}(0.7, 0.2, 0.3)

# Create sphere based on radius, program and color
function Sphere(radius::GLfloat, program::ProgramData, color::Vector3{Float64} = Merlin_PrimitiveDefaultColor)::MeshData
  sphere = Meshes.Sphere(Meshes.Point3f(0.0, 0.0, 0.0), radius)
  bound = Meshes.triangulate(sphere)
  Mesh(bound, program, color)
end

# Create box based on bottom left corner pos, top right corner pos and color
function Box(c1::Vector3{GLfloat}, c2::Vector3{GLfloat}, program::ProgramData, color::Vector3{Float64} = Merlin_PrimitiveDefaultColor)::MeshData
  box = Meshes.Box(Meshes.Point(c1.x, c1.y, c1.z), Meshes.Point(c2.x, c2.y, c2.z))
  bound = Meshes.boundary(box)
  Mesh(Meshes.triangulate(bound), program, color)
end

export Sphere, Box