using CImGui
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using ImGuiGLFWBackend # CImGui.GLFWBackend
using ImGuiOpenGLBackend # CImGui.OpenGLBackend
using ImGuiGLFWBackend.LibGLFW # #CImGui.OpenGLBackend.GLFW
using ImGuiOpenGLBackend.ModernGL
using Printf

struct GuiData
    imgui_ctx
    imgui_opengl_ctx
    imgui_glfw_ctx
end

function Gui_Init(window, glsl_version)
    ctx = CImGui.CreateContext()
  
    CImGui.StyleColorsDark()

    fonts_dir = joinpath(@__DIR__, "..", "fonts")
    fonts = unsafe_load(CImGui.GetIO().Fonts)
    # @c CImGui.AddFontFromFileTTF(&fonts, joinpath(fonts_dir, "Roboto-Medium.ttf"), 16)

    gui_glfw_ctx = ImGuiGLFWBackend.create_context(window, install_callbacks=true)
    ImGuiGLFWBackend.init(gui_glfw_ctx)

    gui_opengl_ctx = ImGuiOpenGLBackend.create_context(glsl_version)
    ImGuiOpenGLBackend.init(gui_opengl_ctx)

    GuiData(ctx, gui_opengl_ctx, gui_glfw_ctx)
end

function Gui_Before(data::GuiData)
    ImGuiOpenGLBackend.new_frame(data.gui_opengl_ctx)
    ImGuiGLFWBackend.new_frame(data.gui_glfw_ctx)
    CImGui.NewFrame()
end

function Gui_After(data::GuiData)
    CImGui.Render()
    ImGuiOpenGLBackend.render(data.gui_opengl_ctx)
end

function Gui_Update(data::GuiData)
    Gui_Before(data)

    CImGui.Begin("Hello, world!")  # create a window called "Hello, world!" and append into it.
    CImGui.Text("This is some useful text.")  # display some text
    CImGui.End()

    Gui_After(data)
end