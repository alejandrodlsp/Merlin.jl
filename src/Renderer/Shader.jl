@enum ShaderType SHADER_TYPE_FRAGMENT SHADER_TYPE_VERTEX

struct ShaderData
  id::GLuint
  type::ShaderType
end

function Shader_GetInfoLog(shader::ShaderData)::Vector{GLchar}
  max_length = GLint(0)
  @c glGetShaderiv(shader.id, GL_INFO_LOG_LENGTH, &max_length)

  actual_length = GLsizei(0)
  log = Vector{GLchar}(undef, max_length)
  @c glGetShaderInfoLog(shader.id, max_length, &actual_length, log)
  @debug "Shader info log for GL index $shader.id: $(String(log))"
  log
end

function Shader_GetCompileStatus(shader::ShaderData)::Bool
  success = GLint(-1)
  @c glGetShaderiv(shader.id, GL_COMPILE_STATUS, &success)
  success == GL_TRUE
end

function Shader_Create(source::String, type::ShaderType)::ShaderData
  shader = glCreateShader(type == SHADER_TYPE_VERTEX ? GL_VERTEX_SHADER : GL_FRAGMENT_SHADER)
  glShaderSource(shader, 1, Ptr{GLchar}[pointer(source)], C_NULL)
  glCompileShader(shader)

  shader_data = ShaderData(shader, type)
  Shader_GetCompileStatus(shader_data) || @error Shader_GetInfoLog(shader_data)

  shader_data
end

function Shader_Destroy(shader::ShaderData)
  glDeleteShader(shader.id)
end