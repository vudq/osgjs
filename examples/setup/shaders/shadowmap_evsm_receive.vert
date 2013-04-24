#ifdef GL_ES
precision highp float;
#endif

attribute vec3 Vertex;
attribute vec4 Color;
attribute vec3 Normal;

uniform float ArrayColorEnabled;

 uniform mat4 ViewMatrix;
 uniform mat4 ModelMatrix;
uniform mat4 ModelViewMatrix;
uniform mat4 ProjectionMatrix;
uniform mat4 NormalMatrix;

varying vec4 VertexColor;


attribute vec2 TexCoord0;
varying vec2 FragTexCoord0;


// shadow stuff
uniform int Light0_uniform_enable;
// shadow 0
uniform mat4 Shadow_Projection0;
uniform mat4 Shadow_View0;
uniform vec4 Shadow_DepthRange0;

varying vec4  Shadow_VertexProjected0;
varying vec4 Shadow_Z0;

uniform int Light1_uniform_enable;
// shadow 1
uniform mat4 Shadow_Projection1;
uniform mat4 Shadow_View1;
uniform vec4 Shadow_DepthRange1;

varying vec4  Shadow_VertexProjected1;
varying vec4 Shadow_Z1;

uniform int Light2_uniform_enable;
// shadow 2
uniform mat4 Shadow_Projection2;
uniform mat4 Shadow_View2;
uniform vec4 Shadow_DepthRange2;

varying vec4  Shadow_VertexProjected2;
varying vec4 Shadow_Z2;

varying vec3 FragNormal;
varying vec3 FragEyeVector;

#pragma include "common.vert"

void main(void) {
	gl_Position = ftransform();
	if (ArrayColorEnabled == 1.0)
		VertexColor = Color;
	else
		VertexColor = vec4(1.0,1.0,1.0,1.0);
	gl_PointSize = 1.0;

	FragEyeVector = computeEyeVertex();
	FragNormal = computeNormal();

	//reuse var accross lights
	vec4 shadowPosition;
	vec4 worldPosition =  ModelMatrix *  vec4(Vertex,1.0);
	//#define NUM_STABLE
	if (Light0_uniform_enable == 1) {
	    #ifndef NUM_STABLE
			Shadow_Z0 = Shadow_View0 *  worldPosition;
			Shadow_VertexProjected0 = Shadow_Projection0 * Shadow_Z0;
		#else
			Shadow_Z0 =  worldPosition;
			Shadow_VertexProjected0 = Shadow_Projection0 * Shadow_View0 * Shadow_Z0;
	    #endif
	}
	if (Light1_uniform_enable == 1) {
	    #ifndef NUM_STABLE
			Shadow_Z1 = Shadow_View1 *  worldPosition;
			Shadow_VertexProjected1 = Shadow_Projection1 * Shadow_Z1;
		#else
			Shadow_Z1 =  worldPosition;
			Shadow_VertexProjected1 = Shadow_Projection1 * Shadow_View1 * Shadow_Z1;
	    #endif
	}
	if (Light2_uniform_enable == 1) {
	    #ifndef NUM_STABLE
			Shadow_Z2 = Shadow_View2 *  worldPosition;
			Shadow_VertexProjected2 = Shadow_Projection2 * Shadow_Z2;
		#else
			Shadow_Z2 =  worldPosition;
			Shadow_VertexProjected2 = Shadow_Projection2 * Shadow_View2 * Shadow_Z2;
	    #endif
	}

	FragTexCoord0 = TexCoord0;
} 



