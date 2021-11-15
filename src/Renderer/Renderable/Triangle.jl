using CSyntax, ModernGL

struct TriangleData <: Renderable
    vbo::GLuint
    vao::GLuint
    program::ProgramData
end

function Triangle():TriangleData
    program = ProgramResource_Load(Program_DefaultProgramPath()).program

    vertices = GLfloat[ 0.0,  0.5, 0.0,
                      0.5, -0.5, 0.0,
                     -0.5, -0.5, 0.0]

    # create buffers located in the memory of graphic card
    vbo = GLuint(0)
    @c glGenBuffers(1, &vbo)
    glBindBuffer(GL_ARRAY_BUFFER, vbo)
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW)

    # create VAO
    vao = GLuint(0)
    @c glGenVertexArrays(1, &vao)
    glBindVertexArray(vao)
    glBindBuffer(GL_ARRAY_BUFFER, vbo)
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, C_NULL)

    glEnableVertexAttribArray(0)

    TriangleData(vbo, vao, program)
end


function Render(triangle::TriangleData, transform::Transform)
    Program_SetMat4(triangle.program, "uModel", GetModelMatrix(transform))
    Program_Use(triangle.program)
    glBindVertexArray(triangle.vao)
    glDrawArrays(GL_TRIANGLES, 0, 3)
end

export Triangle, Render