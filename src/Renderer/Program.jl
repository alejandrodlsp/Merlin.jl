struct ProgramData
    id::GLuint
end

function Program_GetInfoLog(program::ProgramData)::Vector{GLchar}
    max_length = GLint(0)
    @c glGetShaderiv(program.id, GL_INFO_LOG_LENGTH, &max_length)

    actual_length = GLsizei(0)
    log = Vector{GLchar}(undef, max_length)
    @c glGetShaderInfoLog(program.id, max_length, &actual_length, log)
    @debug "program info log for GL index $program.id: $(String(log))"
    log
end

function Program_IsValid(program::ProgramData)::Bool
    params = GLint(-1)
    glValidateProgram(program.id)
    @c glGetProgramiv(program.id, GL_VALIDATE_STATUS, &params)
    @debug "program $program.id GL_VALIDATE_STATUS = $params"
    params == GL_TRUE
end

function Program_Create(vertex_shader::ShaderData, fragment_shader::ShaderData)
    prog = glCreateProgram()
    glAttachShader(prog, vertex_shader.id)
    glAttachShader(prog, fragment_shader.id)
    glLinkProgram(prog)

    prog_data = ProgramData(prog)

    Program_IsValid(prog_data) || @error Program_GetInfoLog(prog_data)
    prog_data
end

function Program_Destroy(program::ProgramData)
    glDeleteProgram(program.id)
end

function Program_Use(program::ProgramData)
    glUseProgram(program.id)
end