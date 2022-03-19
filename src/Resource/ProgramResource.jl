using Base: String

include("../Renderer/Program.jl")

struct ProgramResourceData <: ResourceData
  path::String
  source::String
  program::ProgramData
end

function Program_DefaultProgramPath()::String
  haskey(ENV, "MERLIN_DEFAULT_PROGRAM_PATH") ? ENV["MERLIN_DEFAULT_PROGRAM_PATH"] : "Resources/Program/default.glsl"
end

function ProgramResource_Load(program_path::String)::ProgramResourceData
  if (ResourcePool_Exists(program_path))
    return (ResourcePool_GetElement(program_path)::ProgramResourceData)
  end

  source = read(program_path, String)

  vertex_source = source[findfirst("**VERTEX**", source).stop+1:findfirst("**/VERTEX**", source).start-1]
  frag_source = source[findfirst("**FRAGMENT**", source).stop+1:findfirst("**/FRAGMENT**", source).start-1]

  vertex = Shader_Create(vertex_source, SHADER_TYPE_VERTEX)
  fragment = Shader_Create(frag_source, SHADER_TYPE_FRAGMENT)

  program = Program_Create(vertex, fragment)

  Shader_Destroy(vertex)
  Shader_Destroy(fragment)

  program_data = ProgramResourceData(program_path, source, program)

  ResourcePool_Register(program_path, program_data)
  program_data
end

function ProgramResource_Unload(program::ProgramResourceData)
  Program_Destroy(program.program)
  ResourcePool_Unregister(program.path)
end

export ProgramResource_Load, ProgramResource_Unload