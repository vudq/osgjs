#ifdef GL_ES
precision highp float;
#endif

uniform vec4 Shadow_DepthRange;
uniform mat4 Shadow_View;

varying vec4 WorldPos;

#pragma include "floatrgbacodec.glsl"



void main(void) {
    float depth;
    // linerarize (aka map z to near..far to 0..1)
 //#define NUM_STABLE
    #ifndef NUM_STABLE
        depth =  - WorldPos.z;
        // linerarize (aka map z to near..far to 0..1)
        depth = (depth - Shadow_DepthRange.x )* Shadow_DepthRange.w;
        //depth = WorldPos.z / WorldPos.w;
         depth = clamp(depth, 0.0, 1.0);
    #else
        depth =  length(WorldPos.xyz);
        depth = (depth - Shadow_DepthRange.x )* Shadow_DepthRange.w;
        //depth = WorldPos.z / WorldPos.w;
         depth = clamp(depth, 0.0, 1.0);

    #endif

 // #define _VSM
    #ifndef _FLOATTEX
	    #ifdef _VSM
	    	gl_FragColor = EncodeHalfFloatRGBA(vec2(depth, depth*depth));
	    #else
	    	// _ESM, _PCF, _NONE 
           /* #ifdef _ESM
            float c = 40.0;
            depth = clamp(exp(-c * (depth)), 0.0, 1.0);
            #endif*/
	    	gl_FragColor = EncodeFloatRGBA(depth);
	    #endif
	#else
	    #ifdef _VSM
	    	gl_FragColor = vec4(depth, depth*depth, 0.0, 1.0);
	    #else
	    	// _ESM, _PCF, _NONE
	    	gl_FragColor = vec4(depth, 0.0, 0.0, 1.0);
	    #endif
	#endif
}