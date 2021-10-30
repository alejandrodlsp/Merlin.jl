using CSyntax, ModernGL

struct TriangleData
    vbo_vertices::GLuint
    vbo_colors::GLuint
    vao::GLuint
    program::ProgramData
end

function Triangle_Create(vertices, colors):TriangleData
    program = ProgramResource_Load(Program_DefaultProgramPath()).program

    # create buffers located in the memory of graphic card
    vbo_vertices = GLuint(0)
    @c glGenBuffers(1, &vbo_vertices)
    glBindBuffer(GL_ARRAY_BUFFER, vbo_vertices)
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW)

    # create VAO
    vao = GLuint(0)
    @c glGenVertexArrays(1, &vao)
    glBindVertexArray(vao)
    glBindBuffer(GL_ARRAY_BUFFER, vbo_vertices)
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, C_NULL)

    glEnableVertexAttribArray(0)

    vbo_colors = GLuint(0)

    if colors != nothing
        @c glGenBuffers(1, &vbo_colors)
        glBindBuffer(GL_ARRAY_BUFFER, vbo_colors)
        glBufferData(GL_ARRAY_BUFFER, sizeof(colors), colors, GL_STATIC_DRAW)
        glBindBuffer(GL_ARRAY_BUFFER, vbo_colors)
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, C_NULL)
        glEnableVertexAttribArray(1)
    end

    TriangleData(vbo_vertices, vbo_colors, vao, program)
end

function Triangle_Render(triangle::TriangleData)
    Program_Use(triangle.program)
    glBindVertexArray(triangle.vao)
    glDrawArrays(GL_TRIANGLES, 0, 3)
end

export Triangle_Create, Triangle_Render