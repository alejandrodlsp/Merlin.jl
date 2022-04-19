using CSyntax, ModernGL

struct QuadData <: Renderable
  vbo::GLuint
  texcoords_vbo::GLuint
  vao::GLuint
  ebo::GLuint
  program::ProgramData
  texture::TextureData
end

QUAD_VERTICES = GLfloat[0.5, 0.5, 0.0,   # top right
  0.5, -0.5, 0.0,   # bottom right
  -0.5, -0.5, 0.0,   # bottom left
  -0.5, 0.5, 0.0,   # top left 
]

QUAD_TEXT_COORDS = GLfloat[1.0, 1.0,
  1.0, 0.0,
  0.0, 0.0,
  0.0, 1.0]

QUAD_INDICES = GLuint[0, 1, 3,    # first triangle
  1, 2, 3]    # second triangle

QUAD_NORMALS = GLfloat[
  0.0, 0.0, -1.0,
  0.0, 0.0, -1.0,
  0.0, 0.0, -1.0,
  0.0, 0.0, -1.0
]

function Quad(texture::TextureData, program::ProgramData)
  :QuadData

  # create buffers located in the memory of graphic card
  vbo = GLuint(0)
  @c glGenBuffers(1, &vbo)

  texcoords_vbo = GLuint(0)
  @c glGenBuffers(1, &texcoords_vbo)

  normal_vbo = GLuint(0)
  @c glGenBuffers(1, &normal_vbo)

  ebo = GLuint(0)
  @c glGenBuffers(1, &ebo)

  vao = GLuint(0)
  @c glGenVertexArrays(1, &vao)

  # create VAO
  glBindVertexArray(vao)

  glBindBuffer(GL_ARRAY_BUFFER, vbo)
  glBufferData(GL_ARRAY_BUFFER, sizeof(QUAD_VERTICES), QUAD_VERTICES, GL_STATIC_DRAW)

  glBindBuffer(GL_ARRAY_BUFFER, texcoords_vbo)
  glBufferData(GL_ARRAY_BUFFER, sizeof(QUAD_TEXT_COORDS), QUAD_TEXT_COORDS, GL_STATIC_DRAW)

  glBindBuffer(GL_ARRAY_BUFFER, normal_vbo)
  glBufferData(GL_ARRAY_BUFFER, sizeof(QUAD_NORMALS), QUAD_NORMALS, GL_STATIC_DRAW)

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo)
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(QUAD_INDICES), QUAD_INDICES, GL_STATIC_DRAW)


  glBindBuffer(GL_ARRAY_BUFFER, vbo)
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, C_NULL)
  glBindBuffer(GL_ARRAY_BUFFER, normal_vbo)
  glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, C_NULL)
  glBindBuffer(GL_ARRAY_BUFFER, texcoords_vbo)
  glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 0, C_NULL)

  glEnableVertexAttribArray(0)
  glEnableVertexAttribArray(1)
  glEnableVertexAttribArray(2)

  glBindVertexArray(0)

  QuadData(vbo, texcoords_vbo, vao, ebo, program, texture)
end


function Render(quad::QuadData, transform::Transform, scene)
  Program_Use(quad.program)
  Program_SetMat4(quad.program, "uModel", GetModelMatrix(transform))                  # Set model uniform for program
  Program_SetMat4(quad.program, "uView", scene.camera.viewMatrix)                     # Set view uniform for program
  Program_SetMat4(quad.program, "uProjection", scene.camera.projectionMatrix)         # Set projection uniform for program
  Program_SetVector3(quad.program, "uViewPos", scene.camera.position)                 # Set view position uniform for program
  # Bind texture
  Texture_Bind(quad.texture)
  # Bind VAO
  glBindVertexArray(quad.vao)
  # Draw quad
  glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, Ptr{Cvoid}(0))
  # Unbind vao
  glBindVertexArray(0)
end

export Quad, Render