Shader "Syphon/Transparent/Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100

	Alphatest Greater 0 ZTest Always ZWrite Off //ColorMask RGB
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
Program "vp" {
// Vertex combos: 3
//   opengl - ALU: 6 to 57
//   d3d9 - ALU: 6 to 57
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
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
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 tmpvar_32;
  tmpvar_32 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_33;
  tmpvar_33 = tmpvar_32.xyz;
  float tmpvar_34;
  tmpvar_34 = tmpvar_32.w;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_33 * _LightColor0.xyz) * (max (0.0, dot (gl_TexCoord[1].xyz, _WorldSpaceLightPos0.xyz)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_34)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_33 * gl_TexCoord[2].xyz)).xyz;
  c.w = (vec4(tmpvar_34)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
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
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 tmpvar_24;
  tmpvar_24 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  float tmpvar_26;
  tmpvar_26 = tmpvar_24.w;
  c.xyz = (tmpvar_24.xyz * (2.0 * texture2D (unity_Lightmap, gl_TexCoord[2].xy).xyz)).xyz;
  c.w = (vec4(tmpvar_26)).w;
  c.w = (vec4(tmpvar_26)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "VERTEXLIGHT_ON" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "VERTEXLIGHT_ON" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "VERTEXLIGHT_ON" }
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
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 tmpvar_32;
  tmpvar_32 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_33;
  tmpvar_33 = tmpvar_32.xyz;
  float tmpvar_34;
  tmpvar_34 = tmpvar_32.w;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_33 * _LightColor0.xyz) * (max (0.0, dot (gl_TexCoord[1].xyz, _WorldSpaceLightPos0.xyz)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_34)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_33 * gl_TexCoord[2].xyz)).xyz;
  c.w = (vec4(tmpvar_34)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 2
//   opengl - ALU: 7 to 10, TEX: 1 to 2
//   d3d9 - ALU: 6 to 10, TEX: 1 to 2
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 10 ALU, 1 TEX
PARAM c[4] = { program.local[0..2],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[2];
DP3 R1.x, fragment.texcoord[1], c[0];
MAX R1.w, R1.x, c[3].x;
MUL R1.xyz, R0, fragment.texcoord[2];
MUL R1.w, R1, c[3].y;
MUL R0.xyz, R0, c[1];
MUL R0.xyz, R0, R1.w;
ADD result.color.xyz, R0, R1;
MOV result.color.w, R0;
END
# 10 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 10 ALU, 1 TEX
dcl_2d s0
def c3, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
texld r1, t0, s0
mul r1, r1, c2
mul r2.xyz, r1, t2
dp3_pp r0.x, t1, c0
max_pp r0.x, r0, c3
mul_pp r0.x, r0, c3.y
mul r1.xyz, r1, c1
mul r0.xyz, r1, r0.x
add_pp r0.xyz, r0, r2
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 7 ALU, 2 TEX
PARAM c[2] = { program.local[0],
		{ 8 } };
TEMP R0;
TEMP R1;
TEX R1, fragment.texcoord[2], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[0];
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R0, R1;
MUL result.color.xyz, R0, c[1].x;
MOV result.color.w, R0;
END
# 7 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 6 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c1, 8.00000000, 0, 0, 0
dcl t0.xy
dcl t2.xy
texld r0, t2, s1
texld r1, t0, s0
mul_pp r0.xyz, r0.w, r0
mul r1, r1, c0
mul_pp r0.xyz, r1, r0
mul_pp r0.xyz, r0, c1.x
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
"!!GLES"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
		Blend SrcAlpha One
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
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 c;
  vec4 tmpvar_33;
  tmpvar_33 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  float tmpvar_35;
  tmpvar_35 = tmpvar_33.w;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_33.xyz * _LightColor0.xyz) * ((max (0.0, dot (gl_TexCoord[1].xyz, normalize (gl_TexCoord[2].xyz))) * texture2D (_LightTexture0, vec2(dot (tmpvar_8, tmpvar_8))).w) * 2.0)).xyz;
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
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 tmpvar_31;
  tmpvar_31 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  float tmpvar_33;
  tmpvar_33 = tmpvar_31.w;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_31.xyz * _LightColor0.xyz) * (max (0.0, dot (gl_TexCoord[1].xyz, gl_TexCoord[2].xyz)) * 2.0)).xyz;
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
uniform vec4 _Color;
void main ()
{
  vec4 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyzw;
  vec4 c;
  vec4 tmpvar_40;
  tmpvar_40 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  float tmpvar_42;
  tmpvar_42 = tmpvar_40.w;
  vec3 LightCoord_i0;
  LightCoord_i0 = tmpvar_8.xyz;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_40.xyz * _LightColor0.xyz) * ((max (0.0, dot (gl_TexCoord[1].xyz, normalize (gl_TexCoord[2].xyz))) * ((float((tmpvar_8.z > 0.0)) * texture2D (_LightTexture0, ((tmpvar_8.xy / tmpvar_8.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w)) * 2.0)).xyz;
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
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 c;
  vec4 tmpvar_33;
  tmpvar_33 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  float tmpvar_35;
  tmpvar_35 = tmpvar_33.w;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_33.xyz * _LightColor0.xyz) * ((max (0.0, dot (gl_TexCoord[1].xyz, normalize (gl_TexCoord[2].xyz))) * (texture2D (_LightTextureB0, vec2(dot (tmpvar_8, tmpvar_8))).w * textureCube (_LightTexture0, tmpvar_8).w)) * 2.0)).xyz;
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
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 tmpvar_33;
  tmpvar_33 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  float tmpvar_35;
  tmpvar_35 = tmpvar_33.w;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_33.xyz * _LightColor0.xyz) * ((max (0.0, dot (gl_TexCoord[1].xyz, gl_TexCoord[2].xyz)) * texture2D (_LightTexture0, gl_TexCoord[3].xy).w) * 2.0)).xyz;
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
//   opengl - ALU: 9 to 20, TEX: 1 to 3
//   d3d9 - ALU: 9 to 19, TEX: 1 to 3
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 14 ALU, 2 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[1];
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[0];
MOV result.color.w, R0;
TEX R1.w, R1.x, texture[1], 2D;
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R1;
MAX R1.x, R1, c[2];
MUL R1.x, R1, R1.w;
MUL R1.x, R1, c[2].y;
MUL result.color.xyz, R0, R1.x;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 14 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r1, t0, s0
dp3 r0.x, t3, t3
mov r0.xy, r0.x
mul r1, r1, c1
mul r1.xyz, r1, c0
mov_pp r0.w, r1
texld r2, r0, s1
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, t1, r0
max_pp r0.x, r0, c2
mul_pp r0.x, r0, r2
mul_pp r0.x, r0, c2.y
mul r0.xyz, r1, r0.x
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
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 9 ALU, 1 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[1];
MOV R1.xyz, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R1;
MAX R1.x, R1, c[2];
MUL R1.x, R1, c[2].y;
MUL R0.xyz, R0, c[0];
MUL result.color.xyz, R0, R1.x;
MOV result.color.w, R0;
END
# 9 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 9 ALU, 1 TEX
dcl_2d s0
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
texld r1, t0, s0
mov_pp r0.xyz, t2
dp3_pp r0.x, t1, r0
mul r1, r1, c1
max_pp r0.x, r0, c2
mul_pp r0.x, r0, c2.y
mul r1.xyz, r1, c0
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 20 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 0.5, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2, fragment.texcoord[0], texture[0], 2D;
DP3 R0.z, fragment.texcoord[3], fragment.texcoord[3];
RCP R0.x, fragment.texcoord[3].w;
MAD R0.xy, fragment.texcoord[3], R0.x, c[2].y;
TEX R0.w, R0, texture[1], 2D;
TEX R1.w, R0.z, texture[2], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R0.x, fragment.texcoord[1], R0;
SLT R0.y, c[2].x, fragment.texcoord[3].z;
MUL R0.y, R0, R0.w;
MUL R0.y, R0, R1.w;
MAX R0.x, R0, c[2];
MUL R1.x, R0, R0.y;
MUL R0, R2, c[1];
MUL R1.x, R1, c[2].z;
MUL R0.xyz, R0, c[0];
MUL result.color.xyz, R0, R1.x;
MOV result.color.w, R0;
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_2_0
; 19 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c2, 0.50000000, 0.00000000, 1.00000000, 2.00000000
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3
texld r2, t0, s0
dp3 r1.x, t3, t3
mov r1.xy, r1.x
rcp r0.x, t3.w
mad r0.xy, t3, r0.x, c2.x
texld r3, r1, s2
texld r0, r0, s1
dp3_pp r1.x, t2, t2
cmp r0.x, -t3.z, c2.y, c2.z
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
dp3_pp r1.x, t1, r1
mul r0.x, r0, r0.w
max_pp r1.x, r1, c2.y
mul r0.x, r0, r3
mul_pp r0.x, r1, r0
mul r1, r2, c1
mul_pp r0.x, r0, c2.w
mul r1.xyz, r1, c0
mul r0.xyz, r1, r0.x
mov_pp r0.w, r1
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 16 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[3], texture[2], CUBE;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
TEX R0.w, R0.x, texture[1], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R0.x, fragment.texcoord[1], R0;
MUL R0.y, R0.w, R1.w;
MAX R0.x, R0, c[2];
MUL R1.x, R0, R0.y;
MUL R0, R2, c[1];
MUL R1.x, R1, c[2].y;
MUL R0.xyz, R0, c[0];
MUL result.color.xyz, R0, R1.x;
MOV result.color.w, R0;
END
# 16 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r1, t0, s0
dp3 r0.x, t3, t3
mov r2.xy, r0.x
mul r1, r1, c1
mul r1.xyz, r1, c0
texld r0, t3, s2
texld r2, r2, s1
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t2
mul r0.x, r2, r0.w
dp3_pp r2.x, t1, r3
max_pp r2.x, r2, c2
mul_pp r0.x, r2, r0
mul_pp r0.x, r0, c2.y
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 11 ALU, 2 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[3], texture[1], 2D;
MUL R0, R0, c[1];
MOV R1.xyz, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R1;
MAX R1.x, R1, c[2];
MUL R1.x, R1, R1.w;
MUL R1.x, R1, c[2].y;
MUL R0.xyz, R0, c[0];
MUL result.color.xyz, R0, R1.x;
MOV result.color.w, R0;
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 10 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
texld r0, t3, s1
texld r1, t0, s0
mov_pp r0.xyz, t2
dp3_pp r0.x, t1, r0
mul r1, r1, c1
max_pp r0.x, r0, c2
mul_pp r0.x, r0, r0.w
mul_pp r0.x, r0, c2.y
mul r1.xyz, r1, c0
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

#LINE 26

}

Fallback "Transparent/VertexLit"
}
