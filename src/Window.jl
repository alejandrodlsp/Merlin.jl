include("WindowInput.jl")

import GLFW, ModernGL
import Base:String, UInt
using FileIO

struct WindowException <: Exception
    var::String
end

struct WindowProps
    windowSize::Vector2{Int}
    maxWindowSize::Vector2{Int}
    minWindowSize::Vector2{Int}
    fullscreen::Bool
    name::String
end

WindowProps(  ;WindowSize::Vector2{Int}=Vector2(800, 800), 
              MaxWindowSize::Vector2{Int}=Vector2(0, 0),
              MinWindowSize::Vector2{Int}=Vector2(0, 0),
              Fullscreen::Bool=false,
              Name::String="Merlin Engine application" ) = WindowProps(
                WindowSize, MaxWindowSize, MinWindowSize, Fullscreen, Name
              )

struct WindowData
    NativeWindow::GLFW.Window
end

# Define window data only if not already defined
(@isdefined WINDOW_DATA) || ( WINDOW_DATA = nothing )

function Window_Get()::WindowData 
    (@isdefined WINDOW_DATA) ||  @error "Trying to access window when it is not defined"
    WINDOW_DATA
end

function Window_GetNative()::GLFW.Window
    Window_Get().NativeWindow
end

function Window_Init(props::WindowProps, eventCallback::Function)::WindowData
    nativeWindow = C_NULL
    @debug "Initializating window context"
    GLFW.Init() != true && thrown(WindowException("Failed to initialize GLFW"))

    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 3)
    GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)
    GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, true)
  
    @debug "Creating GLFW window context"

    if props.fullscreen
        nativeWindow = GLFW.CreateWindow(props.windowSize.x, props.windowSize.y, props.name, GLFW.GetPrimaryMonitor())
    else
        nativeWindow = GLFW.CreateWindow(props.windowSize.x, props.windowSize.y, props.name)
    end
        
    nativeWindow == C_NULL && thrown(WindowException("Failed to create GLFW window context"))

    GLFW.MakeContextCurrent(nativeWindow)

    GLFW.SetWindowSizeLimits(nativeWindow, 
          iszero(props.minWindowSize.x) ? GLFW.DONT_CARE : props.minWindowSize.x, 
          iszero(props.minWindowSize.y) ? GLFW.DONT_CARE : props.minWindowSize.y, 
          iszero(props.maxWindowSize.x) ? GLFW.DONT_CARE : props.maxWindowSize.x, 
          iszero(props.maxWindowSize.y) ? GLFW.DONT_CARE : props.maxWindowSize.y);
    
    
    @debug "Window initialization complete"
    global WINDOW_DATA = WindowData(nativeWindow)

    WindowInput_RegisterInputCallbacks(nativeWindow, eventCallback)
    # Window_SetIcon() TODO: Fix texture to work

    
    WINDOW_DATA
end

function Window_Update()
    GLFW.PollEvents()
    GLFW.SwapBuffers(Window_GetNative())
end
    
function Window_Shutdown()
@debug "Shutting down GLFW window context"
    GLFW.DestroyWindow(Window_GetNative())
end

function Window_ShouldClose()::Bool
    GLFW.WindowShouldClose(Window_GetNative())
end

function Window_SetIcon()
    @assert haskey(ENV, "MERLIN_RESOURCES_FOLDER_PATH") "Did not load window icon, resources folder not defined. Try setting ENV[MERLIN_RESOURCES_FOLDER_PATH]"

    @assert isdir(ENV["MERLIN_RESOURCES_FOLDER_PATH"] * "/Icon") "Did not load window icon, resources folder not found. Did you create a /Icon/icon.png folder in your resources directory?"

    icon = TextureResource_Load(ENV["MERLIN_RESOURCES_FOLDER_PATH"] * "/Icon" * "/icon.png").data
    
    buffs = reinterpret(NTuple{4,UInt8}, icon)
    
    GLFW.SetWindowIcon(Window_GetNative(), buffs)
    GLFW.PollEvents()
    end

function SetCursorMode(mode::UInt32)
    @debug "Window cursor mode changed to: " mode
    GLFW.SetInputMode(Window_GetNative(), GLFW.CURSOR, mode)
end

export WindowException, WindowProps, Window_SetIcon, SetCursorMode, Window_Get, Window_GetNative