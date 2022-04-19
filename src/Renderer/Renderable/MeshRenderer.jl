struct MeshData <: Renderable
  vertices::Vector{GLfloat}
  indices::Vector{GLuint}
  normals::Vector{GLfloat}

  program::ProgramData

  VAO::GLuint

  color::Vector3{Float64}
end

"""
    Mesh(mesh::SimpleMesh, program::ProgramData, color::Vector3)::MeshData

Creates mesh data and initializes mesh based on a simple mesh object.
"""
function Mesh(mesh::Meshes.SimpleMesh, program::ProgramData, color::Vector3{Float64})::MeshData
  indices = Vector{GLuint}()
  vertices = Vector{GLfloat}()
  normals = Vector{GLfloat}()

  # Creates a list of normals
  norm_dict = Dict()
  # For each mesh vertex, add to vertex list and initialize normal dict for that vertex
  for i in 1:length(mesh.points)
    pos = mesh.points[i].coords
    append!(vertices, pos[1])
    append!(vertices, pos[2])
    append!(vertices, pos[3])
    norm_dict[i] = [0.0, 0.0, 0.0]
  end

  # For each index, append to indices list and calculate triangle normal
  for index in mesh.topology.connec
    ia = index.indices[3]
    ib = index.indices[2]
    ic = index.indices[1]

    append!(indices, ia - 1)
    append!(indices, ib - 1)
    append!(indices, ic - 1)

    # Calculate triangle normal
    e1 = mesh.points[ib].coords - mesh.points[ia].coords
    e2 = mesh.points[ic].coords - mesh.points[ia].coords
    no = cross(e1, e2)

    # Update normal dict based on triangle normal
    norm_dict[ia] += no
    norm_dict[ib] += no
    norm_dict[ic] += no
  end

  # For each vertex
  for i in 1:length(mesh.points)
    # Append calculated average normal
    norm = normalize(norm_dict[i])
    append!(normals, norm[1])
    append!(normals, norm[2])
    append!(normals, norm[3])
  end

  Mesh(vertices, indices, normals, program, color)
end

"""
    Mesh(vertices::Vector{GLfloat}, indices::Vector{GLuint}, normals::Vector{GLfloat}, program::ProgramData, color::Vector3{Float64})::MeshData

Creates mesh data object based on a list of vertices, indices and normals.
"""
function Mesh(vertices::Vector{GLfloat}, indices::Vector{GLuint}, normals::Vector{GLfloat}, program::ProgramData, color::Vector3{Float64})::MeshData
  # Generate buffers
  VAO = GLuint(0)
  NORM_VBO = GLuint(0)
  VBO = GLuint(0)
  EBO = GLuint(0)
  @c glGenVertexArrays(1, &VAO)
  @c glGenBuffers(1, &VBO)
  @c glGenBuffers(1, &NORM_VBO)
  @c glGenBuffers(1, &EBO)

  # VAO BINDING
  glBindVertexArray(VAO)

  # Buffer Data
  glBindBuffer(GL_ARRAY_BUFFER, VBO)
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW)
  glBindBuffer(GL_ARRAY_BUFFER, NORM_VBO)
  glBufferData(GL_ARRAY_BUFFER, sizeof(normals), normals, GL_STATIC_DRAW)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO)
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW)

  # Vertex attributes
  glBindBuffer(GL_ARRAY_BUFFER, VBO)
  glEnableVertexAttribArray(0)
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, C_NULL)
  glBindBuffer(GL_ARRAY_BUFFER, NORM_VBO)
  glEnableVertexAttribArray(1)
  glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, C_NULL)

  #VAO UNBINDING
  glBindVertexArray(0)

  MeshData(vertices, indices, normals, program, VAO, color)
end

function Render(mesh::MeshData, transform::Transform, scene)
  Program_Use(mesh.program)   # Use program
  Program_SetMat4(mesh.program, "uModel", GetModelMatrix(transform))            # Set model uniform for program
  Program_SetMat4(mesh.program, "uView", scene.camera.viewMatrix)               # Set view uniform for program
  Program_SetMat4(mesh.program, "uProjection", scene.camera.projectionMatrix)   # Set projection uniform for program
  Program_SetVector3(mesh.program, "uViewPos", scene.camera.position)           # Set view position uniform for program
  Program_SetVector3(mesh.program, "uColor", mesh.color)                        # Set mesh color uniform

  # Bind mesh vao
  glBindVertexArray(mesh.VAO)
  # Draw mesh
  glDrawElements(GL_TRIANGLES, sizeof(mesh.indices), GL_UNSIGNED_INT, Ptr{Cvoid}(0))
  # Unbind vao
  glBindVertexArray(0)
end

export MeshData, Mesh, Render