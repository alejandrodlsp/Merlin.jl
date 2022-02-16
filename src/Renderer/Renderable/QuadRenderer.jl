using CSyntax, ModernGL

struct QuadData <: Renderable
  vbo::GLuint
  texcoords_vbo::GLuint
  vao::GLuint
  ebo::GLuint
  program::ProgramData
  texture::TextureData
end

vertices = GLfloat[0.5, 0.5, 0.0,   # top right
  0.5, -0.5, 0.0,   # bottom right
  -0.5, -0.5, 0.0,   # bottom left
  -0.5, 0.5, 0.0,   # top left 
]

tex_coords = GLfloat[1.0, 1.0,
  1.0, 0.0,
  0.0, 0.0,
  0.0, 1.0]

indices = GLuint[0, 1, 3,    # first triangle
  1, 2, 3]    # second triangle

function Quad(texture::TextureData)
  :QuadData
  program = ProgramResource_Load(Program_DefaultProgramPath()).program

  # create buffers located in the memory of graphic card
  vbo = GLuint(0)
  @c glGenBuffers(1, &vbo)

  texcoords_vbo = GLuint(0)
  @c glGenBuffers(1, &texcoords_vbo)

  ebo = GLuint(0)
  @c glGenBuffers(1, &ebo)

  vao = GLuint(0)
  @c glGenVertexArrays(1, &vao)

  # create VAO
  glBindVertexArray(vao)

  glBindBuffer(GL_ARRAY_BUFFER, vbo)
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW)

  glBindBuffer(GL_ARRAY_BUFFER, texcoords_vbo)
  glBufferData(GL_ARRAY_BUFFER, sizeof(tex_coords), tex_coords, GL_STATIC_DRAW)

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo)
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW)


  glBindBuffer(GL_ARRAY_BUFFER, vbo)
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, C_NULL)
  glBindBuffer(GL_ARRAY_BUFFER, texcoords_vbo)
  glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, C_NULL)

  glEnableVertexAttribArray(0)
  glEnableVertexAttribArray(1)

  glBindVertexArray(0)

  QuadData(vbo, texcoords_vbo, vao, ebo, program, texture)
end


function Render(quad::QuadData, transform::Transform, scene)
  Program_Use(quad.program)
  Program_SetMat4(quad.program, "uModel", GetModelMatrix(transform))
  Program_SetMat4(quad.program, "uView", scene.camera.viewMatrix)
  Program_SetMat4(quad.program, "uProjection", ProjectionMatrix(scene.camera))
  Texture_Bind(quad.texture)
  glBindVertexArray(quad.vao)
  glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, Ptr{Cvoid}(0))
end

export Quad, Render