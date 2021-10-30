**VERTEX**
#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aCol;

out vec4 vertexColor; 

void main()
{
    gl_Position = vec4(aPos, 1.0); 
    vertexColor = vec4(aCol, 1.0); 
}
**/VERTEX**


**FRAGMENT**
#version 330 core
out vec4 FragColor;
  
in vec4 vertexColor; 

void main()
{
    FragColor = vertexColor;
} 
**/FRAGMENT**


