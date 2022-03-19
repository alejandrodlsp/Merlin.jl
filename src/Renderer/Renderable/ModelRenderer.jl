using CSyntax, ModernGL, GLTF

mutable struct ModelData <: Renderable
  pos_vbo::GLuint
  normal_vbo::GLuint
  tex_vbo::GLuint
  idx_ebo::GLuint
  idx_bv
  indices
  vao::GLuint
  program::ProgramData
end

function Model(path::String, program_path::String)
  :ModelData
  program = ProgramResource_Load(program_path)

  Model(ModelResource_Load(path), program)
end

function Model(model_resource::ModelResourceData, program_resource::ProgramResourceData)
  :ModelData

  # create VBO and EBO
  pos_vbo = GLuint(0)
  @c glGenBuffers(1, &pos_vbo)
  glBindBuffer(model_resource.pos_bv.target, pos_vbo)
  glBufferData(model_resource.pos_bv.target, model_resource.pos_bv.byteLength, C_NULL, GL_STATIC_DRAW)
  pos_data = model_resource.data[model_resource.pos_bv.buffer]
  @c glBufferSubData(model_resource.pos_bv.target, 0, model_resource.pos_bv.byteLength, &pos_data[model_resource.pos_bv.byteOffset])

  normal_vbo = GLuint(0)
  @c glGenBuffers(1, &normal_vbo)
  glBindBuffer(model_resource.normal_bv.target, normal_vbo)
  glBufferData(model_resource.normal_bv.target, model_resource.normal_bv.byteLength, C_NULL, GL_STATIC_DRAW)
  normal_data = model_resource.data[model_resource.normal_bv.buffer]
  @c glBufferSubData(model_resource.normal_bv.target, 0, model_resource.normal_bv.byteLength, &normal_data[model_resource.normal_bv.byteOffset])

  tex_vbo = GLuint(0)
  @c glGenBuffers(1, &tex_vbo)
  glBindBuffer(model_resource.tex_bv.target, tex_vbo)
  glBufferData(model_resource.tex_bv.target, model_resource.tex_bv.byteLength, C_NULL, GL_STATIC_DRAW)
  tex_data = model_resource.data[model_resource.tex_bv.buffer]
  @c glBufferSubData(model_resource.tex_bv.target, 0, model_resource.tex_bv.byteLength, &tex_data[model_resource.tex_bv.byteOffset])

  idx_ebo = GLuint(0)
  @c glGenBuffers(1, &idx_ebo)
  glBindBuffer(model_resource.idx_bv.target, idx_ebo)
  glBufferData(model_resource.idx_bv.target, model_resource.idx_bv.byteLength, C_NULL, GL_STATIC_DRAW)
  idx_data = model_resource.data[model_resource.idx_bv.buffer]
  @c glBufferSubData(model_resource.idx_bv.target, 0, model_resource.idx_bv.byteLength, &idx_data[model_resource.idx_bv.byteOffset])

  # create VAO
  vao = GLuint(0)
  @c glGenVertexArrays(1, &vao)
  glBindVertexArray(vao)
  # bind position vbo
  glBindBuffer(model_resource.pos_bv.target, pos_vbo)
  glVertexAttribPointer(0, 3, model_resource.pos.componentType, model_resource.pos.normalized, model_resource.pos_bv.byteStride, Ptr{Cvoid}(model_resource.pos.byteOffset))
  glEnableVertexAttribArray(0)
  # bind normal vbo
  glBindBuffer(model_resource.normal_bv.target, normal_vbo)
  glVertexAttribPointer(1, 3, model_resource.normals.componentType, model_resource.normals.normalized, model_resource.normal_bv.byteStride, Ptr{Cvoid}(model_resource.normals.byteOffset))
  glEnableVertexAttribArray(1)
  # bind texture coordinate vbo
  glBindBuffer(model_resource.tex_bv.target, tex_vbo)
  glVertexAttribPointer(2, 2, model_resource.texcoords.componentType, model_resource.texcoords.normalized, model_resource.tex_bv.byteStride, Ptr{Cvoid}(model_resource.texcoords.byteOffset))
  glEnableVertexAttribArray(2)

  ModelData(pos_vbo, normal_vbo, tex_vbo, idx_ebo, model_resource.idx_bv, model_resource.indices, vao, program_resource.program)
end


function Render(model::ModelData, transform::Transform, scene)
  Program_Use(model.program)                       # Use program
  # Set program data
  Program_SetMat4(model.program, "uModel", GetModelMatrix(transform))
  Program_SetMat4(model.program, "uView", scene.camera.viewMatrix)
  Program_SetMat4(model.program, "uProjection", scene.camera.projectionMatrix)

  glBindVertexArray(model.vao)                     # Bind vao
  glBindBuffer(model.idx_bv.target, model.idx_ebo)  # Bind EBO for indices
  # Draw indices
  glDrawElements(GL_TRIANGLES, model.indices.count, model.indices.componentType, Ptr{Cvoid}(0))
end

export Quad, Render