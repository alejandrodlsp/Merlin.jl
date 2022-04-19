include("Shader.jl")

struct ProgramData
  id::GLuint
end

# Get info log for program
function Program_GetInfoLog(program::ProgramData)::Vector{GLchar}
  max_length = GLint(0)
  @c glGetShaderiv(program.id, GL_INFO_LOG_LENGTH, &max_length)

  actual_length = GLsizei(0)
  log = Vector{GLchar}(undef, max_length)
  @c glGetShaderInfoLog(program.id, max_length, &actual_length, log)
  @debug "program info log for GL index $program.id: $(String(log))"
  log
end

# Check if program is valid
function Program_IsValid(program::ProgramData)::Bool
  params = GLint(-1)
  glValidateProgram(program.id)
  @c glGetProgramiv(program.id, GL_VALIDATE_STATUS, &params)
  @debug "program $program.id GL_VALIDATE_STATUS = $params"
  params == GL_TRUE
end

# Create program based on shader data
function Program_Create(vertex_shader::ShaderData, fragment_shader::ShaderData)
  prog = glCreateProgram()
  glAttachShader(prog, vertex_shader.id)
  glAttachShader(prog, fragment_shader.id)
  glLinkProgram(prog)

  prog_data = ProgramData(prog)

  Program_IsValid(prog_data) || @error Program_GetInfoLog(prog_data)
  prog_data
end

# Destroy program
function Program_Destroy(program::ProgramData)
  glDeleteProgram(program.id)
end

# Activate program
function Program_Use(program::ProgramData)
  glUseProgram(program.id)
end

# Set boolean type uniform
function Program_SetBool(program::ProgramData, name::String, value::Bool)
  Program_Use(program)
  glUniform1i(glGetUniformLocation(program.id, name), value)
end

# Set integer type uniform
function Program_SetInt(program::ProgramData, name::String, value::Int)
  Program_Use(program)
  glUniform1i(glGetUniformLocation(program.id, name), value)
end

# Set float type uniform
function Program_SetFloat(program::ProgramData, name::String, value::Float32)
  Program_Use(program)
  glUniform1f(glGetUniformLocation(program.id, name), value)
end

# Set vector3 type uniform
function Program_SetVector3(program::ProgramData, name::String, value::Vector3{Float64})
  Program_Use(program)
  glUniform3f(glGetUniformLocation(program.id, name), value.x, value.y, value.z)
end

# Set mat4 type uniform
function Program_SetMat4(program::ProgramData, name::String, value)
  Program_Use(program)
  glUniformMatrix4fv(glGetUniformLocation(program.id, name), 1, GL_FALSE, value)
end