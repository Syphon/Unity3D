Shader "Syphon/Transparent/Cutout/Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
}

SubShader {
	Tags {"IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	LOD 200
	
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		AlphaToMask True
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 6 to 63
//   d3d9 - ALU: 6 to 63
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [_MainTex_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[18] = { { 1 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[9].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.x, R1, c[5];
MOV R0.y, R3.w;
MOV R0.z, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R3.w, R3.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
MAD R0.y, R0.x, R0.x, -R0;
MUL R1.xyz, R0.y, c[16];
ADD R2.xyz, R2, R3;
ADD result.texcoord[2].xyz, R2, R1;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 27 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Vector 16 [_MainTex_ST]
"vs_2_0
; 27 ALU
def c17, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c8.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c17.x
dp4 r2.z, r0, c11
dp4 r2.y, r0, c10
dp4 r2.x, r0, c9
mul r0.y, r3.w, r3.w
dp4 r3.z, r1, c14
dp4 r3.y, r1, c13
dp4 r3.x, r1, c12
mad r0.y, r0.x, r0.x, -r0
mul r1.xyz, r0.y, c15
add r2.xyz, r2, r3
add oT2.xyz, r2, r1
mov oT1.z, r2.w
mov oT1.y, r3.w
mov oT1.x, r0
mad oT0.xy, v2, c16, c16.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  mat3 tmpvar_55;
  tmpvar_55[0] = _Object2World[0].xyz;
  tmpvar_55[1] = _Object2World[1].xyz;
  tmpvar_55[2] = _Object2World[2].xyz;
  vec3 tmpvar_59;
  tmpvar_59 = (tmpvar_55 * (gl_Normal.xyz * unity_Scale.w));
  vec4 tmpvar_61;
  tmpvar_61.xyz = tmpvar_59.xyz;
  tmpvar_61.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_61);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_61))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_61))).z;
  vec4 tmpvar_70;
  tmpvar_70 = (tmpvar_61.xyzz * tmpvar_61.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_70);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_70))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_70))).z;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = tmpvar_59.xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_61.x * tmpvar_61.x) - (tmpvar_61.y * tmpvar_61.y)))).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 c;
  vec4 tmpvar_32;
  tmpvar_32 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_33;
  tmpvar_33 = tmpvar_32.xyz;
  float tmpvar_34;
  tmpvar_34 = tmpvar_32.w;
  float x;
  x = (tmpvar_34 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_33 * _LightColor0.xyz) * (max (0.0, dot (tmpvar_4, _WorldSpaceLightPos0.xyz)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_34)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_33 * tmpvar_6)).xyz;
  c.w = (vec4(tmpvar_34)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [unity_LightmapST]
Vector 10 [_MainTex_ST]
"!!ARBvp1.0
# 6 ALU
PARAM c[11] = { program.local[0],
		state.matrix.mvp,
		program.local[5..10] };
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 6 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"vs_2_0
; 6 ALU
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
mad oT0.xy, v2, c9, c9.zwzw
mad oT2.xy, v3, c8, c8.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_LightmapST;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xy = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw).xy;
  tmpvar_19.z = 0.0;
  tmpvar_19.w = 0.0;
  gl_TexCoord[2] = tmpvar_19;
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec2 tmpvar_4;
  tmpvar_4 = gl_TexCoord[2].xy;
  vec4 c;
  vec4 tmpvar_24;
  tmpvar_24 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_25;
  tmpvar_25 = tmpvar_24.xyz;
  float tmpvar_26;
  tmpvar_26 = tmpvar_24.w;
  float x;
  x = (tmpvar_26 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  c.xyz = (tmpvar_25 * (2.0 * texture2D (unity_Lightmap, tmpvar_4).xyz)).xyz;
  c.w = (vec4(tmpvar_26)).w;
  c.w = (vec4(tmpvar_26)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Matrix 5 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"!!ARBvp1.0
# 32 ALU
PARAM c[19] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal, c[10].w;
DP3 R3.w, R0, c[6];
DP3 R2.w, R0, c[7];
DP3 R1.w, R0, c[5];
MOV R1.x, R3.w;
MOV R1.y, R2.w;
MOV R1.z, c[0].x;
MUL R0, R1.wxyy, R1.xyyw;
DP4 R2.z, R1.wxyz, c[13];
DP4 R2.y, R1.wxyz, c[12];
DP4 R2.x, R1.wxyz, c[11];
DP4 R1.z, R0, c[16];
DP4 R1.y, R0, c[15];
DP4 R1.x, R0, c[14];
MUL R3.x, R3.w, R3.w;
MAD R0.x, R1.w, R1.w, -R3;
ADD R3.xyz, R2, R1;
MUL R2.xyz, R0.x, c[17];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R1.w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 32 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Matrix 4 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"vs_2_0
; 32 ALU
def c19, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c10.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c19.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c13
dp4 r2.y, r1.wxyz, c12
dp4 r2.x, r1.wxyz, c11
dp4 r1.z, r0, c16
dp4 r1.y, r0, c15
dp4 r1.x, r0, c14
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c17
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c19.y
mul r1.y, r1, c8.x
add oT2.xyz, r3, r2
mad oT3.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mov oT1.z, r2.w
mov oT1.y, r3.w
mov oT1.x, r1.w
mad oT0.xy, v2, c18, c18.zwzw
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_55;
  tmpvar_55 = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw);
  mat3 tmpvar_62;
  tmpvar_62[0] = _Object2World[0].xyz;
  tmpvar_62[1] = _Object2World[1].xyz;
  tmpvar_62[2] = _Object2World[2].xyz;
  vec3 tmpvar_66;
  tmpvar_66 = (tmpvar_62 * (gl_Normal.xyz * unity_Scale.w));
  vec4 tmpvar_68;
  tmpvar_68.xyz = tmpvar_66.xyz;
  tmpvar_68.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_68);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_68))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_68))).z;
  vec4 tmpvar_77;
  tmpvar_77 = (tmpvar_68.xyzz * tmpvar_68.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_77);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_77))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_77))).z;
  vec4 o_i0;
  vec4 tmpvar_90;
  tmpvar_90 = (tmpvar_55 * 0.5);
  o_i0 = tmpvar_90;
  vec2 tmpvar_91;
  tmpvar_91.x = tmpvar_90.x;
  tmpvar_91.y = (vec2((tmpvar_90.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_91 + tmpvar_90.w);
  o_i0.zw = tmpvar_55.zw;
  gl_Position = tmpvar_55.xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = tmpvar_66.xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_68.x * tmpvar_68.x) - (tmpvar_68.y * tmpvar_68.y)))).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  gl_TexCoord[3] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyzw;
  vec4 c;
  vec4 tmpvar_36;
  tmpvar_36 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_37;
  tmpvar_37 = tmpvar_36.xyz;
  float tmpvar_38;
  tmpvar_38 = tmpvar_36.w;
  float x;
  x = (tmpvar_38 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_37 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_4, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, tmpvar_8).x) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_38)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_37 * tmpvar_6)).xyz;
  c.w = (vec4(tmpvar_38)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 11 ALU
PARAM c[12] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_2_0
; 11 ALU
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mul r1.y, r1, c8.x
mad oT3.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mad oT0.xy, v2, c11, c11.zwzw
mad oT2.xy, v3, c10, c10.zwzw
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_LightmapST;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_37;
  tmpvar_37 = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw);
  vec4 o_i0;
  vec4 tmpvar_52;
  tmpvar_52 = (tmpvar_37 * 0.5);
  o_i0 = tmpvar_52;
  vec2 tmpvar_53;
  tmpvar_53.x = tmpvar_52.x;
  tmpvar_53.y = (vec2((tmpvar_52.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_53 + tmpvar_52.w);
  o_i0.zw = tmpvar_37.zw;
  gl_Position = tmpvar_37.xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xy = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw).xy;
  tmpvar_19.z = 0.0;
  tmpvar_19.w = 0.0;
  gl_TexCoord[2] = tmpvar_19;
  gl_TexCoord[3] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec2 tmpvar_4;
  tmpvar_4 = gl_TexCoord[2].xy;
  vec4 tmpvar_6;
  tmpvar_6 = gl_TexCoord[3].xyzw;
  vec4 c;
  vec4 tmpvar_28;
  tmpvar_28 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_29;
  tmpvar_29 = tmpvar_28.xyz;
  float tmpvar_30;
  tmpvar_30 = tmpvar_28.w;
  float x;
  x = (tmpvar_30 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  c.xyz = (tmpvar_29 * min ((2.0 * texture2D (unity_Lightmap, tmpvar_4).xyz), vec3((texture2DProj (_ShadowMapTexture, tmpvar_6).x * 2.0)))).xyz;
  c.w = (vec4(tmpvar_30)).w;
  c.w = (vec4(tmpvar_30)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Vector 25 [_MainTex_ST]
"!!ARBvp1.0
# 57 ALU
PARAM c[26] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..25] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[9].w;
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[11];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[10];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[12];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[13];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[20];
DP4 R2.y, R4, c[19];
DP4 R2.x, R4, c[18];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[15];
MAD R1.xyz, R0.x, c[14], R1;
MAD R0.xyz, R0.z, c[16], R1;
MAD R1.xyz, R0.w, c[17], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R4.w, R0, c[23];
DP4 R4.z, R0, c[22];
DP4 R4.y, R0, c[21];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[24];
ADD R2.xyz, R2, R4.yzww;
ADD R0.xyz, R2, R0;
ADD result.texcoord[2].xyz, R0, R1;
MOV result.texcoord[1].z, R3.x;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R4;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[25], c[25].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 57 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [_MainTex_ST]
"vs_2_0
; 57 ALU
def c25, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c8.w
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp3 r3.x, r3, c6
dp4 r0.x, v0, c5
add r1, -r0.x, c10
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c9
mul r1, r1, r1
mov r4.z, r3.x
mov r4.w, c25.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c11
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c12
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c25.x
dp4 r2.z, r4, c19
dp4 r2.y, r4, c18
dp4 r2.x, r4, c17
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c25.y
mul r0, r0, r1
mul r1.xyz, r0.y, c14
mad r1.xyz, r0.x, c13, r1
mad r0.xyz, r0.z, c15, r1
mad r1.xyz, r0.w, c16, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r4.w, r0, c22
dp4 r4.z, r0, c21
dp4 r4.y, r0, c20
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c23
add r2.xyz, r2, r4.yzww
add r0.xyz, r2, r0
add oT2.xyz, r0, r1
mov oT1.z, r3.x
mov oT1.y, r3.w
mov oT1.x, r4
mad oT0.xy, v2, c24, c24.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec3 unity_LightColor3;
uniform vec3 unity_LightColor2;
uniform vec3 unity_LightColor1;
uniform vec3 unity_LightColor0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightAtten0;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_78;
  tmpvar_78[0] = _Object2World[0].xyz;
  tmpvar_78[1] = _Object2World[1].xyz;
  tmpvar_78[2] = _Object2World[2].xyz;
  vec3 tmpvar_82;
  tmpvar_82 = (tmpvar_78 * (gl_Normal.xyz * unity_Scale.w));
  vec4 tmpvar_84;
  tmpvar_84.xyz = tmpvar_82.xyz;
  tmpvar_84.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_84);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_84))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_84))).z;
  vec4 tmpvar_93;
  tmpvar_93 = (tmpvar_84.xyzz * tmpvar_84.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_93);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_93))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_93))).z;
  vec3 tmpvar_104;
  tmpvar_104 = (_Object2World * tmpvar_1).xyz;
  vec4 tmpvar_107;
  tmpvar_107 = (unity_4LightPosX0 - tmpvar_104.x);
  vec4 tmpvar_108;
  tmpvar_108 = (unity_4LightPosY0 - tmpvar_104.y);
  vec4 tmpvar_109;
  tmpvar_109 = (unity_4LightPosZ0 - tmpvar_104.z);
  vec4 tmpvar_113;
  tmpvar_113 = (((tmpvar_107 * tmpvar_107) + (tmpvar_108 * tmpvar_108)) + (tmpvar_109 * tmpvar_109));
  vec4 tmpvar_123;
  tmpvar_123 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_107 * tmpvar_82.x) + (tmpvar_108 * tmpvar_82.y)) + (tmpvar_109 * tmpvar_82.z)) * inversesqrt (tmpvar_113))) * 1.0/((1.0 + (tmpvar_113 * unity_4LightAtten0))));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = tmpvar_82.xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_84.x * tmpvar_84.x) - (tmpvar_84.y * tmpvar_84.y)))) + ((((unity_LightColor0 * tmpvar_123.x) + (unity_LightColor1 * tmpvar_123.y)) + (unity_LightColor2 * tmpvar_123.z)) + (unity_LightColor3 * tmpvar_123.w))).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 c;
  vec4 tmpvar_32;
  tmpvar_32 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_33;
  tmpvar_33 = tmpvar_32.xyz;
  float tmpvar_34;
  tmpvar_34 = tmpvar_32.w;
  float x;
  x = (tmpvar_34 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_33 * _LightColor0.xyz) * (max (0.0, dot (tmpvar_4, _WorldSpaceLightPos0.xyz)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_34)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_33 * tmpvar_6)).xyz;
  c.w = (vec4(tmpvar_34)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Matrix 5 [_Object2World]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Vector 26 [_MainTex_ST]
"!!ARBvp1.0
# 63 ALU
PARAM c[27] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[10].w;
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[12];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[11];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[13];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[14];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[21];
DP4 R2.y, R4, c[20];
DP4 R2.x, R4, c[19];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[16];
MAD R1.xyz, R0.x, c[15], R1;
MAD R0.xyz, R0.z, c[17], R1;
MAD R1.xyz, R0.w, c[18], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R4.w, R0, c[24];
DP4 R4.z, R0, c[23];
DP4 R4.y, R0, c[22];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[25];
ADD R2.xyz, R2, R4.yzww;
ADD R4.yzw, R2.xxyz, R0.xxyz;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].z;
ADD result.texcoord[2].xyz, R4.yzww, R1;
MOV R1.x, R2;
MUL R1.y, R2, c[9].x;
ADD result.texcoord[3].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MOV result.texcoord[1].z, R3.x;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R4;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[26], c[26].zwzw;
END
# 63 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Matrix 4 [_Object2World]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Vector 26 [_MainTex_ST]
"vs_2_0
; 63 ALU
def c27, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c10.w
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp3 r3.x, r3, c6
dp4 r0.x, v0, c5
add r1, -r0.x, c12
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c11
mul r1, r1, r1
mov r4.z, r3.x
mov r4.w, c27.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c13
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c14
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c27.x
dp4 r2.z, r4, c21
dp4 r2.y, r4, c20
dp4 r2.x, r4, c19
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c27.y
mul r0, r0, r1
mul r1.xyz, r0.y, c16
mad r1.xyz, r0.x, c15, r1
mad r0.xyz, r0.z, c17, r1
mad r1.xyz, r0.w, c18, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r4.w, r0, c24
dp4 r4.z, r0, c23
dp4 r4.y, r0, c22
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c25
add r2.xyz, r2, r4.yzww
add r4.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c27.z
add oT2.xyz, r4.yzww, r1
mov r1.x, r2
mul r1.y, r2, c8.x
mad oT3.xy, r2.z, c9.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mov oT1.z, r3.x
mov oT1.y, r3.w
mov oT1.x, r4
mad oT0.xy, v2, c26, c26.zwzw
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_SHC;
uniform vec4 unity_SHBr;
uniform vec4 unity_SHBg;
uniform vec4 unity_SHBb;
uniform vec4 unity_SHAr;
uniform vec4 unity_SHAg;
uniform vec4 unity_SHAb;
uniform vec3 unity_LightColor3;
uniform vec3 unity_LightColor2;
uniform vec3 unity_LightColor1;
uniform vec3 unity_LightColor0;
uniform vec4 unity_4LightPosZ0;
uniform vec4 unity_4LightPosY0;
uniform vec4 unity_4LightPosX0;
uniform vec4 unity_4LightAtten0;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  vec4 tmpvar_78;
  tmpvar_78 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  mat3 tmpvar_85;
  tmpvar_85[0] = _Object2World[0].xyz;
  tmpvar_85[1] = _Object2World[1].xyz;
  tmpvar_85[2] = _Object2World[2].xyz;
  vec3 tmpvar_89;
  tmpvar_89 = (tmpvar_85 * (gl_Normal.xyz * unity_Scale.w));
  vec4 tmpvar_91;
  tmpvar_91.xyz = tmpvar_89.xyz;
  tmpvar_91.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_91);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_91))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_91))).z;
  vec4 tmpvar_100;
  tmpvar_100 = (tmpvar_91.xyzz * tmpvar_91.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_100);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_100))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_100))).z;
  vec3 tmpvar_111;
  tmpvar_111 = (_Object2World * tmpvar_1).xyz;
  vec4 tmpvar_114;
  tmpvar_114 = (unity_4LightPosX0 - tmpvar_111.x);
  vec4 tmpvar_115;
  tmpvar_115 = (unity_4LightPosY0 - tmpvar_111.y);
  vec4 tmpvar_116;
  tmpvar_116 = (unity_4LightPosZ0 - tmpvar_111.z);
  vec4 tmpvar_120;
  tmpvar_120 = (((tmpvar_114 * tmpvar_114) + (tmpvar_115 * tmpvar_115)) + (tmpvar_116 * tmpvar_116));
  vec4 tmpvar_130;
  tmpvar_130 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_114 * tmpvar_89.x) + (tmpvar_115 * tmpvar_89.y)) + (tmpvar_116 * tmpvar_89.z)) * inversesqrt (tmpvar_120))) * 1.0/((1.0 + (tmpvar_120 * unity_4LightAtten0))));
  vec4 o_i0;
  vec4 tmpvar_139;
  tmpvar_139 = (tmpvar_78 * 0.5);
  o_i0 = tmpvar_139;
  vec2 tmpvar_140;
  tmpvar_140.x = tmpvar_139.x;
  tmpvar_140.y = (vec2((tmpvar_139.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_140 + tmpvar_139.w);
  o_i0.zw = tmpvar_78.zw;
  gl_Position = tmpvar_78.xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = tmpvar_89.xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_91.x * tmpvar_91.x) - (tmpvar_91.y * tmpvar_91.y)))) + ((((unity_LightColor0 * tmpvar_130.x) + (unity_LightColor1 * tmpvar_130.y)) + (unity_LightColor2 * tmpvar_130.z)) + (unity_LightColor3 * tmpvar_130.w))).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  gl_TexCoord[3] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyzw;
  vec4 c;
  vec4 tmpvar_36;
  tmpvar_36 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_37;
  tmpvar_37 = tmpvar_36.xyz;
  float tmpvar_38;
  tmpvar_38 = tmpvar_36.w;
  float x;
  x = (tmpvar_38 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_37 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_4, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, tmpvar_8).x) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_38)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_37 * tmpvar_6)).xyz;
  c.w = (vec4(tmpvar_38)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 4
//   opengl - ALU: 9 to 14, TEX: 1 to 3
//   d3d9 - ALU: 9 to 14, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Float 3 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 12 ALU, 1 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[2];
SLT R1.x, R0.w, c[3];
MOV result.color.w, R0;
KIL -R1.x;
DP3 R1.x, fragment.texcoord[1], c[0];
MAX R1.w, R1.x, c[4].x;
MUL R1.xyz, R0, fragment.texcoord[2];
MUL R1.w, R1, c[4].y;
MUL R0.xyz, R0, c[1];
MUL R0.xyz, R0, R1.w;
ADD result.color.xyz, R0, R1;
END
# 12 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Float 3 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 13 ALU, 2 TEX
dcl_2d s0
def c4, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
texld r0, t0, s0
mul r1, r0, c2
mul r2.xyz, r1, t2
add r0.x, r1.w, -c3
cmp r0.x, r0, c4, c4.y
mov_pp r0, -r0.x
mul r1.xyz, r1, c1
texkill r0.xyzw
dp3_pp r0.x, t1, c0
max_pp r0.x, r0, c4
mul_pp r0.x, r0, c4.z
mul r0.xyz, r1, r0.x
add_pp r0.xyz, r0, r2
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 9 ALU, 2 TEX
PARAM c[3] = { program.local[0..1],
		{ 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1, R0, c[0];
SLT R2.x, R1.w, c[1];
MOV result.color.w, R1;
TEX R0, fragment.texcoord[2], texture[1], 2D;
KIL -R2.x;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R1, R0;
MUL result.color.xyz, R0, c[2].x;
END
# 9 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 9 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c2, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t2.xy
texld r0, t0, s0
mul r1, r0, c0
add r0.x, r1.w, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r2, -r0.x
texld r0, t2, s1
texkill r2.xyzw
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r1, r0
mul_pp r0.xyz, r0, c2.z
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Float 3 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 14 ALU, 2 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[2];
SLT R1.x, R0.w, c[3];
DP3 R1.y, fragment.texcoord[1], c[0];
MAX R1.y, R1, c[4].x;
MOV result.color.w, R0;
KIL -R1.x;
TXP R1.x, fragment.texcoord[3], texture[1], 2D;
MUL R1.w, R1.y, R1.x;
MUL R1.xyz, R0, fragment.texcoord[2];
MUL R1.w, R1, c[4].y;
MUL R0.xyz, R0, c[1];
MUL R0.xyz, R0, R1.w;
ADD result.color.xyz, R0, R1;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Float 3 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"ps_2_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3
texld r0, t0, s0
mul r1, r0, c2
add r0.x, r1.w, -c3
cmp r0.x, r0, c4, c4.y
mov_pp r0, -r0.x
dp3_pp r2.x, t1, c0
max_pp r2.x, r2, c4
texkill r0.xyzw
texldp r0, t3, s1
mul_pp r0.x, r2, r0
mul r2.xyz, r1, t2
mul_pp r0.x, r0, c4.z
mul r1.xyz, r1, c1
mul r0.xyz, r1, r0.x
add_pp r0.xyz, r0, r2
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 12 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R2.x, fragment.texcoord[3], texture[1], 2D;
MUL R1, R0, c[0];
SLT R0.x, R1.w, c[1];
MOV result.color.w, R1;
KIL -R0.x;
TEX R0, fragment.texcoord[2], texture[2], 2D;
MUL R0.xyz, R0.w, R0;
MUL R0.w, R2.x, c[2].y;
MUL R0.xyz, R0, c[2].x;
MIN R0.xyz, R0, R0.w;
MUL result.color.xyz, R1, R0;
END
# 12 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 10 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c2, 0.00000000, 1.00000000, 8.00000000, 2.00000000
dcl t0.xy
dcl t2.xy
dcl t3
texld r0, t0, s0
texld r2, t2, s2
mul r0, r0, c0
add r1.x, r0.w, -c1
cmp r1.x, r1, c2, c2.y
mov_pp r1, -r1.x
mul_pp r2.xyz, r2.w, r2
mul_pp r2.xyz, r2, c2.z
texkill r1.xyzw
texldp r1, t3, s1
mul_pp r1.x, r1, c2.w
min_pp r1.xyz, r2, r1.x
mul_pp r0.xyz, r0, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
		AlphaToMask True
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 10 to 18
//   d3d9 - ALU: 10 to 18
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 17 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 17 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c13
mad oT0.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_43;
  tmpvar_43[0] = _Object2World[0].xyz;
  tmpvar_43[1] = _Object2World[1].xyz;
  tmpvar_43[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_43 * (gl_Normal.xyz * unity_Scale.w)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_WorldSpaceLightPos0.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 c;
  vec4 tmpvar_33;
  tmpvar_33 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_34;
  tmpvar_34 = tmpvar_33.xyz;
  float tmpvar_35;
  tmpvar_35 = tmpvar_33.w;
  float x;
  x = (tmpvar_35 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_34 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_4, normalize (tmpvar_6))) * texture2D (_LightTexture0, vec2(dot (tmpvar_8, tmpvar_8))).w) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_35)).w;
  c = c_i0_i1;
  c.w = (vec4(tmpvar_35)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Vector 10 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 10 ALU
PARAM c[12] = { program.local[0],
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
MOV result.texcoord[2].xyz, c[10];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 10 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 10 [_MainTex_ST]
"vs_2_0
; 10 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c8.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
mov oT2.xyz, c9
mad oT0.xy, v2, c10, c10.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  mat3 tmpvar_41;
  tmpvar_41[0] = _Object2World[0].xyz;
  tmpvar_41[1] = _Object2World[1].xyz;
  tmpvar_41[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_41 * (gl_Normal.xyz * unity_Scale.w)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = _WorldSpaceLightPos0.xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 c;
  vec4 tmpvar_31;
  tmpvar_31 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_32;
  tmpvar_32 = tmpvar_31.xyz;
  float tmpvar_33;
  tmpvar_33 = tmpvar_31.w;
  float x;
  x = (tmpvar_33 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_32 * _LightColor0.xyz) * (max (0.0, dot (tmpvar_4, tmpvar_6)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_33)).w;
  c = c_i0_i1;
  c.w = (vec4(tmpvar_33)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 18 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].w, R0, c[12];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 18 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.w, r0, c11
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c13
mad oT0.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_43;
  tmpvar_43[0] = _Object2World[0].xyz;
  tmpvar_43[1] = _Object2World[1].xyz;
  tmpvar_43[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_43 * (gl_Normal.xyz * unity_Scale.w)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_WorldSpaceLightPos0.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  gl_TexCoord[3] = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyzw;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyzw;
  vec4 c;
  vec4 tmpvar_40;
  tmpvar_40 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_41;
  tmpvar_41 = tmpvar_40.xyz;
  float tmpvar_42;
  tmpvar_42 = tmpvar_40.w;
  float x;
  x = (tmpvar_42 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec3 LightCoord_i0;
  LightCoord_i0 = tmpvar_8.xyz;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_41 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_4, normalize (tmpvar_6))) * ((float((tmpvar_8.z > 0.0)) * texture2D (_LightTexture0, ((tmpvar_8.xy / tmpvar_8.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_42)).w;
  c = c_i0_i1;
  c.w = (vec4(tmpvar_42)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 17 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 17 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c13
mad oT0.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_43;
  tmpvar_43[0] = _Object2World[0].xyz;
  tmpvar_43[1] = _Object2World[1].xyz;
  tmpvar_43[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_43 * (gl_Normal.xyz * unity_Scale.w)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_WorldSpaceLightPos0.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 c;
  vec4 tmpvar_33;
  tmpvar_33 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_34;
  tmpvar_34 = tmpvar_33.xyz;
  float tmpvar_35;
  tmpvar_35 = tmpvar_33.w;
  float x;
  x = (tmpvar_35 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_34 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_4, normalize (tmpvar_6))) * (texture2D (_LightTextureB0, vec2(dot (tmpvar_8, tmpvar_8))).w * textureCube (_LightTexture0, tmpvar_8).w)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_35)).w;
  c = c_i0_i1;
  c.w = (vec4(tmpvar_35)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 16 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
MOV result.texcoord[2].xyz, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 16 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 16 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
mov oT2.xyz, c13
mad oT0.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_43;
  tmpvar_43[0] = _Object2World[0].xyz;
  tmpvar_43[1] = _Object2World[1].xyz;
  tmpvar_43[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_43 * (gl_Normal.xyz * unity_Scale.w)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = _WorldSpaceLightPos0.xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xy = (_LightMatrix0 * (_Object2World * tmpvar_1)).xy;
  tmpvar_23.z = 0.0;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec2 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xy;
  vec4 c;
  vec4 tmpvar_33;
  tmpvar_33 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_34;
  tmpvar_34 = tmpvar_33.xyz;
  float tmpvar_35;
  tmpvar_35 = tmpvar_33.w;
  float x;
  x = (tmpvar_35 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_34 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_4, tmpvar_6)) * texture2D (_LightTexture0, tmpvar_8).w) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_35)).w;
  c = c_i0_i1;
  c.w = (vec4(tmpvar_35)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 11 to 22, TEX: 1 to 3
//   d3d9 - ALU: 12 to 22, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 16 ALU, 2 TEX
PARAM c[4] = { program.local[0..2],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[1];
SLT R1.y, R0.w, c[2].x;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[0];
MOV result.color.w, R0;
TEX R1.w, R1.x, texture[1], 2D;
KIL -R1.y;
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R1;
MAX R1.x, R1, c[3];
MUL R1.x, R1, R1.w;
MUL R1.x, R1, c[3].y;
MUL result.color.xyz, R0, R1.x;
END
# 16 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 17 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c3, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r0, t0, s0
mul r1, r0, c1
add r0.x, r1.w, -c2
cmp r2.x, r0, c3, c3.y
mov_pp r2, -r2.x
dp3 r0.x, t3, t3
mov r0.xy, r0.x
mul r1.xyz, r1, c0
texld r0, r0, s1
texkill r2.xyzw
dp3_pp r2.x, t2, t2
rsq_pp r2.x, r2.x
mul_pp r2.xyz, r2.x, t2
dp3_pp r2.x, t1, r2
max_pp r2.x, r2, c3
mul_pp r0.x, r2, r0
mul_pp r0.x, r0, c3.z
mul r0.xyz, r1, r0.x
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 11 ALU, 1 TEX
PARAM c[4] = { program.local[0..2],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[1];
SLT R1.x, R0.w, c[2];
MUL R0.xyz, R0, c[0];
MOV result.color.w, R0;
KIL -R1.x;
MOV R1.xyz, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R1;
MAX R1.x, R1, c[3];
MUL R1.x, R1, c[3].y;
MUL result.color.xyz, R0, R1.x;
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 12 ALU, 2 TEX
dcl_2d s0
def c3, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
texld r0, t0, s0
mul r1, r0, c1
add r0.x, r1.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r0, -r0.x
mul r1.xyz, r1, c0
texkill r0.xyzw
mov_pp r0.xyz, t2
dp3_pp r0.x, t1, r0
max_pp r0.x, r0, c3
mul_pp r0.x, r0, c3.z
mul r0.xyz, r1, r0.x
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 22 ALU, 3 TEX
PARAM c[4] = { program.local[0..2],
		{ 0, 0.5, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R2, R0, c[1];
SLT R0.w, R2, c[2].x;
DP3 R0.z, fragment.texcoord[3], fragment.texcoord[3];
RCP R0.x, fragment.texcoord[3].w;
MAD R0.xy, fragment.texcoord[3], R0.x, c[3].y;
MOV result.color.w, R2;
KIL -R0.w;
TEX R0.w, R0, texture[1], 2D;
TEX R1.w, R0.z, texture[2], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R0.x, fragment.texcoord[1], R0;
SLT R0.y, c[3].x, fragment.texcoord[3].z;
MUL R0.y, R0, R0.w;
MUL R0.y, R0, R1.w;
MAX R0.x, R0, c[3];
MUL R0.x, R0, R0.y;
MUL R0.w, R0.x, c[3].z;
MUL R0.xyz, R2, c[0];
MUL result.color.xyz, R0, R0.w;
END
# 22 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_2_0
; 22 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c3, 0.00000000, 1.00000000, 0.50000000, 2.00000000
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3
texld r0, t0, s0
mul r2, r0, c1
add r0.x, r2.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r3, -r0.x
rcp r1.x, t3.w
dp3 r0.x, t3, t3
mad r1.xy, t3, r1.x, c3.z
mov r0.xy, r0.x
texkill r3.xyzw
texld r3, r0, s2
texld r0, r1, s1
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r0.x
mul_pp r1.xyz, r1.x, t2
dp3_pp r1.x, t1, r1
cmp r0.x, -t3.z, c3, c3.y
mul r0.x, r0, r0.w
max_pp r1.x, r1, c3
mul r0.x, r0, r3
mul_pp r0.x, r1, r0
mul_pp r0.x, r0, c3.w
mul r1.xyz, r2, c0
mul r0.xyz, r1, r0.x
mov_pp r0.w, r2
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[4] = { program.local[0..2],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[3], texture[2], CUBE;
MUL R2, R0, c[1];
SLT R0.y, R2.w, c[2].x;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MOV result.color.w, R2;
TEX R0.w, R0.x, texture[1], 2D;
KIL -R0.y;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R0.x, fragment.texcoord[1], R0;
MUL R0.y, R0.w, R1.w;
MAX R0.x, R0, c[3];
MUL R0.x, R0, R0.y;
MUL R0.w, R0.x, c[3].y;
MUL R0.xyz, R2, c[0];
MUL result.color.xyz, R0, R0.w;
END
# 18 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_2_0
; 18 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c3, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r0, t0, s0
mul r1, r0, c1
add r0.x, r1.w, -c2
cmp r2.x, r0, c3, c3.y
dp3 r0.x, t3, t3
mov_pp r2, -r2.x
mov r3.xy, r0.x
mul r1.xyz, r1, c0
texld r0, t3, s2
texkill r2.xyzw
texld r2, r3, s1
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, t1, r0
mul r2.x, r2, r0.w
max_pp r0.x, r0, c3
mul_pp r0.x, r0, r2
mul_pp r0.x, r0, c3.z
mul r0.xyz, r1, r0.x
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[4] = { program.local[0..2],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[3], texture[1], 2D;
MUL R0, R0, c[1];
SLT R1.x, R0.w, c[2];
MUL R0.xyz, R0, c[0];
MOV result.color.w, R0;
KIL -R1.x;
MOV R1.xyz, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R1;
MAX R1.x, R1, c[3];
MUL R1.x, R1, R1.w;
MUL R1.x, R1, c[3].y;
MUL result.color.xyz, R0, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 13 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c3, 0.00000000, 1.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
texld r0, t0, s0
mul r1, r0, c1
add r0.x, r1.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r0, -r0.x
mul r1.xyz, r1, c0
texkill r0.xyzw
texld r0, t3, s1
mov_pp r0.xyz, t2
dp3_pp r0.x, t1, r0
max_pp r0.x, r0, c3
mul_pp r0.x, r0, r0.w
mul_pp r0.x, r0, c3.z
mul r0.xyz, r1, r0.x
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 9 to 9
//   d3d9 - ALU: 9 to 9
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
Vector 10 [_MainTex_ST]
"!!ARBvp1.0
# 9 ALU
PARAM c[11] = { program.local[0],
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 9 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [_MainTex_ST]
"vs_2_0
; 9 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c8.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
mad oT0.xy, v2, c9, c9.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  mat3 tmpvar_37;
  tmpvar_37[0] = _Object2World[0].xyz;
  tmpvar_37[1] = _Object2World[1].xyz;
  tmpvar_37[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_37 * (gl_Normal.xyz * unity_Scale.w)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec4 res;
  float x;
  x = ((texture2D (_MainTex, gl_TexCoord[0].xy) * _Color).w - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  res.xyz = ((tmpvar_4 * 0.5) + 0.5).xyz;
  res.w = 0.0;
  gl_FragData[0] = res.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 6 to 6, TEX: 1 to 1
//   d3d9 - ALU: 7 to 7, TEX: 2 to 2
SubProgram "opengl " {
Keywords { }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 6 ALU, 1 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 0.5 } };
TEMP R0;
TEX R0.w, fragment.texcoord[0], texture[0], 2D;
MUL R0.x, R0.w, c[0].w;
SLT R0.x, R0, c[1];
MAD result.color.xyz, fragment.texcoord[1], c[2].y, c[2].y;
MOV result.color.w, c[2].x;
KIL -R0.x;
END
# 6 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 7 ALU, 2 TEX
dcl_2d s0
def c2, 0.00000000, 1.00000000, 0.50000000, 0
dcl t0.xy
dcl t1.xyz
texld r0, t0, s0
mul r0.x, r0.w, c0.w
add r0.x, r0, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r0, -r0.x
texkill r0.xyzw
mad_pp r0.xyz, t1, c2.z, c2.z
mov_pp r0.w, c2.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
Program "vp" {
// Vertex combos: 2
//   opengl - ALU: 10 to 13
//   d3d9 - ALU: 10 to 13
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Vector 5 [_ProjectionParams]
Vector 6 [_MainTex_ST]
"!!ARBvp1.0
# 10 ALU
PARAM c[7] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..6] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[5].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[1].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[6], c[6].zwzw;
END
# 10 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Vector 6 [_MainTex_ST]
"vs_2_0
; 10 ALU
def c7, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c7.x
mul r1.y, r1, c4.x
mad oT1.xy, r1.z, c5.zwzw, r1
mov oPos, r0
mov oT1.zw, r0
mad oT0.xy, v1, c6, c6.zwzw
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 _ProjectionParams;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_27;
  tmpvar_27 = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw);
  vec4 o_i0;
  vec4 tmpvar_31;
  tmpvar_31 = (tmpvar_27 * 0.5);
  o_i0 = tmpvar_31;
  vec2 tmpvar_32;
  tmpvar_32.x = tmpvar_31.x;
  tmpvar_32.y = (vec2((tmpvar_31.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_32 + tmpvar_31.w);
  o_i0.zw = tmpvar_27.zw;
  gl_Position = tmpvar_27.xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  gl_TexCoord[1] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform vec4 unity_Ambient;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec4 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyzw;
  vec4 light;
  vec4 tmpvar_25;
  tmpvar_25 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_26;
  tmpvar_26 = tmpvar_25.xyz;
  float tmpvar_27;
  tmpvar_27 = tmpvar_25.w;
  float x;
  x = (tmpvar_27 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 tmpvar_31;
  tmpvar_31 = -(log2 (texture2DProj (_LightBuffer, tmpvar_4)));
  light = tmpvar_31;
  light.xyz = (tmpvar_31.xyz + unity_Ambient.xyz).xyz;
  vec4 c_i0;
  c_i0.xyz = (tmpvar_26 * light.xyz).xyz;
  c_i0.w = (vec4(tmpvar_27)).w;
  gl_FragData[0] = c_i0.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [unity_LightmapFade]
Vector 12 [_MainTex_ST]
"!!ARBvp1.0
# 13 ALU
PARAM c[13] = { { 0.5 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..12] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
MOV result.position, R0;
DP4 R0.x, vertex.position, c[3];
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.texcoord[1].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[10], c[10].zwzw;
MAD result.texcoord[2].z, -R0.x, c[11], c[11].w;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [unity_LightmapFade]
Vector 12 [_MainTex_ST]
"vs_2_0
; 13 ALU
def c13, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c13.x
mul r1.y, r1, c8.x
mov oPos, r0
dp4 r0.x, v0, c2
mad oT1.xy, r1.z, c9.zwzw, r1
mov oT1.zw, r0
mad oT0.xy, v1, c12, c12.zwzw
mad oT2.xy, v2, c10, c10.zwzw
mad oT2.z, -r0.x, c11, c11.w
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_LightmapST;
uniform vec4 unity_LightmapFade;
uniform vec4 _ProjectionParams;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  vec3 tmpvar_71;
  vec4 tmpvar_29;
  tmpvar_29 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_i0;
  vec4 tmpvar_33;
  tmpvar_33 = (tmpvar_29 * 0.5);
  o_i0 = tmpvar_33;
  vec2 tmpvar_34;
  tmpvar_34.x = tmpvar_33.x;
  tmpvar_34.y = (vec2((tmpvar_33.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_34 + tmpvar_33.w);
  o_i0.zw = tmpvar_29.zw;
  tmpvar_71.xy = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  tmpvar_71.z = (vec3(((-((gl_ModelViewMatrix * tmpvar_1).z) * unity_LightmapFade.z) + unity_LightmapFade.w))).z;
  gl_Position = tmpvar_29.xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  gl_TexCoord[1] = o_i0.xyzw;
  vec4 tmpvar_21;
  tmpvar_21.xyz = tmpvar_71.xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec4 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyzw;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 light;
  vec4 tmpvar_31;
  tmpvar_31 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_32;
  tmpvar_32 = tmpvar_31.xyz;
  float tmpvar_33;
  tmpvar_33 = tmpvar_31.w;
  float x;
  x = (tmpvar_33 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 tmpvar_37;
  tmpvar_37 = -(log2 (texture2DProj (_LightBuffer, tmpvar_4)));
  light = tmpvar_37;
  light.xyz = (tmpvar_37.xyz + mix ((2.0 * texture2D (unity_LightmapInd, tmpvar_6.xy).xyz), (2.0 * texture2D (unity_Lightmap, tmpvar_6.xy).xyz), vec3(clamp (tmpvar_6.z, 0.0, 1.0)))).xyz;
  vec4 c_i0;
  c_i0.xyz = (tmpvar_32 * light.xyz).xyz;
  c_i0.w = (vec4(tmpvar_33)).w;
  gl_FragData[0] = c_i0.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 2
//   opengl - ALU: 11 to 19, TEX: 2 to 4
//   d3d9 - ALU: 11 to 17, TEX: 3 to 5
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [unity_Ambient]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 11 ALU, 2 TEX
PARAM c[3] = { program.local[0..2] };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1, R0, c[0];
SLT R0.w, R1, c[2].x;
MOV result.color.w, R1;
TXP R0.xyz, fragment.texcoord[1], texture[1], 2D;
KIL -R0.w;
LG2 R0.x, R0.x;
LG2 R0.z, R0.z;
LG2 R0.y, R0.y;
ADD R0.xyz, -R0, c[1];
MUL result.color.xyz, R1, R0;
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [unity_Ambient]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"ps_2_0
; 11 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c3, 0.00000000, 1.00000000, 0, 0
dcl t0.xy
dcl t1
texld r0, t0, s0
mul r1, r0, c0
add r0.x, r1.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r2, -r0.x
texldp r0, t1, s1
texkill r2.xyzw
log_pp r0.x, r0.x
log_pp r0.z, r0.z
log_pp r0.y, r0.y
add_pp r0.xyz, -r0, c1
mul_pp r0.xyz, r1, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 19 ALU, 4 TEX
PARAM c[3] = { program.local[0..1],
		{ 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1, fragment.texcoord[2], texture[2], 2D;
TXP R3.xyz, fragment.texcoord[1], texture[1], 2D;
MUL R2, R0, c[0];
SLT R0.x, R2.w, c[1];
MUL R1.xyz, R1.w, R1;
MOV result.color.w, R2;
KIL -R0.x;
TEX R0, fragment.texcoord[2], texture[3], 2D;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[2].x;
MAD R1.xyz, R1, c[2].x, -R0;
MOV_SAT R0.w, fragment.texcoord[2].z;
MAD R0.xyz, R0.w, R1, R0;
LG2 R1.x, R3.x;
LG2 R1.y, R3.y;
LG2 R1.z, R3.z;
ADD R0.xyz, -R1, R0;
MUL result.color.xyz, R2, R0;
END
# 19 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 17 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t1
dcl t2.xyz
texld r0, t0, s0
texldp r3, t1, s1
texld r1, t2, s2
mul r2, r0, c0
add r0.x, r2.w, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r0, -r0.x
texkill r0.xyzw
texld r0, t2, s3
mul_pp r0.xyz, r0.w, r0
mul_pp r4.xyz, r0, c2.z
mul_pp r0.xyz, r1.w, r1
mad_pp r1.xyz, r0, c2.z, -r4
mov_sat r0.x, t2.z
mad_pp r0.xyz, r0.x, r1, r4
log_pp r1.x, r3.x
log_pp r1.y, r3.y
log_pp r1.z, r3.z
add_pp r0.xyz, -r1, r0
mul_pp r0.xyz, r2, r0
mov_pp r0.w, r2
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" }
"!!GLES"
}

}
	}

#LINE 27

}

Fallback "Transparent/Cutout/VertexLit"
}
