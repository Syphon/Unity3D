Shader "Syphon/Transparent/Bumped Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 300
	
	Alphatest Greater 0 ZWrite Off 	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
Program "vp" {
// Vertex combos: 3
//   opengl - ALU: 7 to 66
//   d3d9 - ALU: 7 to 69
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"!!ARBvp1.0
# 35 ALU
PARAM c[24] = { { 1 },
		state.matrix.mvp,
		program.local[5..23] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[17];
DP4 R2.y, R0, c[16];
DP4 R2.x, R0, c[15];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[20];
DP4 R3.y, R1, c[19];
DP4 R3.x, R1, c[18];
MOV R1.xyz, vertex.attrib[14];
ADD R3.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R2.xyz, R0.x, c[21];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
ADD result.texcoord[2].xyz, R3, R2;
MOV R1, c[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP3 result.texcoord[1].y, R2, R0;
DP3 result.texcoord[1].z, vertex.normal, R2;
DP3 result.texcoord[1].x, R2, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[23].xyxy, c[23];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[22], c[22].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Vector 21 [_MainTex_ST]
Vector 22 [_BumpMap_ST]
"vs_2_0
; 38 ALU
def c23, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c12.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c23.x
dp4 r2.z, r0, c16
dp4 r2.y, r0, c15
dp4 r2.x, r0, c14
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c19
dp4 r3.y, r1, c18
dp4 r3.x, r1, c17
mad r0.x, r0, r0, -r0.y
mul r1.xyz, r0.x, c20
add r2.xyz, r2, r3
mov r0.xyz, v1
add oT2.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
dp4 r3.z, c13, r0
mul r2.xyz, r1, v1.w
mov r0, c9
mov r1, c8
dp4 r3.y, c13, r0
dp4 r3.x, c13, r1
dp3 oT1.y, r3, r2
dp3 oT1.z, v2, r3
dp3 oT1.x, r3, v1
mad oT0.zw, v3.xyxy, c22.xyxy, c22
mad oT0.xy, v3, c21, c21.zwzw
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
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform vec4 _BumpMap_ST;
void main ()
{
  vec4 tmpvar_3;
  tmpvar_3 = TANGENT.xyzw;
  vec3 tmpvar_5;
  tmpvar_5 = gl_Normal.xyz;
  vec4 tmpvar_7;
  tmpvar_7 = gl_MultiTexCoord0.xyzw;
  vec4 tmpvar_129;
  tmpvar_129.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_129.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  mat3 tmpvar_58;
  tmpvar_58[0] = _Object2World[0].xyz;
  tmpvar_58[1] = _Object2World[1].xyz;
  tmpvar_58[2] = _Object2World[2].xyz;
  vec3 tmpvar_64;
  tmpvar_64 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_65;
  tmpvar_65[0].x = tmpvar_3.x;
  tmpvar_65[0].y = tmpvar_64.x;
  tmpvar_65[0].z = tmpvar_5.x;
  tmpvar_65[1].x = tmpvar_3.y;
  tmpvar_65[1].y = tmpvar_64.y;
  tmpvar_65[1].z = tmpvar_5.y;
  tmpvar_65[2].x = tmpvar_3.z;
  tmpvar_65[2].y = tmpvar_64.z;
  tmpvar_65[2].z = tmpvar_5.z;
  vec4 tmpvar_80;
  tmpvar_80.xyz = (tmpvar_58 * (tmpvar_5 * unity_Scale.w)).xyz;
  tmpvar_80.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_80);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_80))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_80))).z;
  vec4 tmpvar_89;
  tmpvar_89 = (tmpvar_80.xyzz * tmpvar_80.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_89);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_89))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_89))).z;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw).xyzw;
  gl_TexCoord[0] = tmpvar_129.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_65 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_80.x * tmpvar_80.x) - (tmpvar_80.y * tmpvar_80.y)))).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec4 c;
  vec4 tmpvar_44;
  tmpvar_44 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  vec3 tmpvar_45;
  tmpvar_45 = tmpvar_44.xyz;
  float tmpvar_46;
  tmpvar_46 = tmpvar_44.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_45 * _LightColor0.xyz) * (max (0.0, dot (normal.xyz, gl_TexCoord[1].xyz)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_46)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_45 * gl_TexCoord[2].xyz)).xyz;
  c.w = (vec4(tmpvar_46)).w;
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
Vector 11 [_BumpMap_ST]
"!!ARBvp1.0
# 7 ALU
PARAM c[12] = { program.local[0],
		state.matrix.mvp,
		program.local[5..11] };
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[11].xyxy, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 7 instructions, 0 R-regs
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
Vector 10 [_BumpMap_ST]
"vs_2_0
; 7 ALU
dcl_position0 v0
dcl_texcoord0 v3
dcl_texcoord1 v4
mad oT0.zw, v3.xyxy, c10.xyxy, c10
mad oT0.xy, v3, c9, c9.zwzw
mad oT1.xy, v4, c8, c8.zwzw
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
uniform vec4 _BumpMap_ST;
void main ()
{
  vec4 tmpvar_7;
  tmpvar_7 = gl_MultiTexCoord0.xyzw;
  vec4 tmpvar_82;
  tmpvar_82.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_82.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw).xyzw;
  gl_TexCoord[0] = tmpvar_82.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xy = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw).xy;
  tmpvar_19.z = 0.0;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec4 c;
  vec4 tmpvar_37;
  tmpvar_37 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  float tmpvar_39;
  tmpvar_39 = tmpvar_37.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  c.xyz = (tmpvar_37.xyz * (2.0 * texture2D (unity_Lightmap, gl_TexCoord[1].xy).xyz)).xyz;
  c.w = (vec4(tmpvar_39)).w;
  c.w = (vec4(tmpvar_39)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
Vector 30 [_MainTex_ST]
Vector 31 [_BumpMap_ST]
"!!ARBvp1.0
# 66 ALU
PARAM c[32] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..31] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[13].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[16];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[15];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[17];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[18];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[20];
MAD R1.xyz, R0.x, c[19], R1;
MAD R0.xyz, R0.z, c[21], R1;
MAD R1.xyz, R0.w, c[22], R0;
MUL R0, R4.xyzz, R4.yzzx;
DP4 R3.z, R0, c[28];
DP4 R3.y, R0, c[27];
DP4 R3.x, R0, c[26];
MUL R1.w, R3, R3;
MAD R0.x, R4, R4, -R1.w;
DP4 R2.z, R4, c[25];
DP4 R2.y, R4, c[24];
DP4 R2.x, R4, c[23];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[29];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
ADD result.texcoord[2].xyz, R3, R1;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R0, c[14];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP3 result.texcoord[1].y, R2, R1;
DP3 result.texcoord[1].z, vertex.normal, R2;
DP3 result.texcoord[1].x, R2, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[31].xyxy, c[31];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[30], c[30].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 66 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_SHAr]
Vector 23 [unity_SHAg]
Vector 24 [unity_SHAb]
Vector 25 [unity_SHBr]
Vector 26 [unity_SHBg]
Vector 27 [unity_SHBb]
Vector 28 [unity_SHC]
Vector 29 [_MainTex_ST]
Vector 30 [_BumpMap_ST]
"vs_2_0
; 69 ALU
def c31, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c12.w
dp4 r0.x, v0, c5
add r1, -r0.x, c15
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c14
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c31.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c16
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c17
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c31.x
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c31.y
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mad r1.xyz, r0.w, c21, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c27
dp4 r3.y, r0, c26
dp4 r3.x, r0, c25
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c28
dp4 r2.z, r4, c24
dp4 r2.y, r4, c23
dp4 r2.x, r4, c22
add r2.xyz, r2, r3
add r2.xyz, r2, r0
mov r0.xyz, v1
add oT2.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
dp4 r3.z, c13, r0
mul r2.xyz, r1, v1.w
mov r1, c9
mov r0, c8
dp4 r3.y, c13, r1
dp4 r3.x, c13, r0
dp3 oT1.y, r3, r2
dp3 oT1.z, v2, r3
dp3 oT1.x, r3, v1
mad oT0.zw, v3.xyxy, c30.xyxy, c30
mad oT0.xy, v3, c29, c29.zwzw
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
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform vec4 _BumpMap_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  vec4 tmpvar_3;
  tmpvar_3 = TANGENT.xyzw;
  vec3 tmpvar_5;
  tmpvar_5 = gl_Normal.xyz;
  vec4 tmpvar_7;
  tmpvar_7 = gl_MultiTexCoord0.xyzw;
  vec4 tmpvar_178;
  tmpvar_178.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_178.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  mat3 tmpvar_81;
  tmpvar_81[0] = _Object2World[0].xyz;
  tmpvar_81[1] = _Object2World[1].xyz;
  tmpvar_81[2] = _Object2World[2].xyz;
  vec3 tmpvar_85;
  tmpvar_85 = (tmpvar_81 * (tmpvar_5 * unity_Scale.w));
  vec3 tmpvar_87;
  tmpvar_87 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_88;
  tmpvar_88[0].x = tmpvar_3.x;
  tmpvar_88[0].y = tmpvar_87.x;
  tmpvar_88[0].z = tmpvar_5.x;
  tmpvar_88[1].x = tmpvar_3.y;
  tmpvar_88[1].y = tmpvar_87.y;
  tmpvar_88[1].z = tmpvar_5.y;
  tmpvar_88[2].x = tmpvar_3.z;
  tmpvar_88[2].y = tmpvar_87.z;
  tmpvar_88[2].z = tmpvar_5.z;
  vec4 tmpvar_103;
  tmpvar_103.xyz = tmpvar_85.xyz;
  tmpvar_103.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_103);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_103))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_103))).z;
  vec4 tmpvar_112;
  tmpvar_112 = (tmpvar_103.xyzz * tmpvar_103.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_112);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_112))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_112))).z;
  vec3 tmpvar_123;
  tmpvar_123 = (_Object2World * tmpvar_1).xyz;
  vec4 tmpvar_126;
  tmpvar_126 = (unity_4LightPosX0 - tmpvar_123.x);
  vec4 tmpvar_127;
  tmpvar_127 = (unity_4LightPosY0 - tmpvar_123.y);
  vec4 tmpvar_128;
  tmpvar_128 = (unity_4LightPosZ0 - tmpvar_123.z);
  vec4 tmpvar_132;
  tmpvar_132 = (((tmpvar_126 * tmpvar_126) + (tmpvar_127 * tmpvar_127)) + (tmpvar_128 * tmpvar_128));
  vec4 tmpvar_142;
  tmpvar_142 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_126 * tmpvar_85.x) + (tmpvar_127 * tmpvar_85.y)) + (tmpvar_128 * tmpvar_85.z)) * inversesqrt (tmpvar_132))) * 1.0/((1.0 + (tmpvar_132 * unity_4LightAtten0))));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_178.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_88 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_103.x * tmpvar_103.x) - (tmpvar_103.y * tmpvar_103.y)))) + ((((unity_LightColor0 * tmpvar_142.x) + (unity_LightColor1 * tmpvar_142.y)) + (unity_LightColor2 * tmpvar_142.z)) + (unity_LightColor3 * tmpvar_142.w))).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec4 c;
  vec4 tmpvar_44;
  tmpvar_44 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  vec3 tmpvar_45;
  tmpvar_45 = tmpvar_44.xyz;
  float tmpvar_46;
  tmpvar_46 = tmpvar_44.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_45 * _LightColor0.xyz) * (max (0.0, dot (normal.xyz, gl_TexCoord[1].xyz)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_46)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_45 * gl_TexCoord[2].xyz)).xyz;
  c.w = (vec4(tmpvar_46)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 2
//   opengl - ALU: 7 to 17, TEX: 2 to 2
//   d3d9 - ALU: 6 to 19, TEX: 2 to 2
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 17 ALU, 2 TEX
PARAM c[3] = { program.local[0..1],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAD R1.xy, R1.wyzw, c[2].x, -c[2].y;
MUL R0, R0, c[1];
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[2].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R1.x, R1, fragment.texcoord[1];
MAX R1.w, R1.x, c[2].z;
MUL R1.xyz, R0, fragment.texcoord[2];
MUL R1.w, R1, c[2].x;
MUL R0.xyz, R0, c[0];
MUL R0.xyz, R0, R1.w;
ADD result.color.xyz, R0, R1;
MOV result.color.w, R0;
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"ps_2_0
; 19 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
texld r1, t0, s0
mul r1, r1, c1
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s1
mov r0.x, r0.w
mad_pp r2.xy, r0, c2.x, c2.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.x, r2, t1
mul r2.xyz, r1, t2
max_pp r0.x, r0, c2.w
mul_pp r0.x, r0, c2
mul r1.xyz, r1, c0
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
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 7 ALU, 2 TEX
PARAM c[2] = { program.local[0],
		{ 8 } };
TEMP R0;
TEMP R1;
TEX R1, fragment.texcoord[1], texture[2], 2D;
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
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 6 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c1, 8.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
texld r0, t1, s2
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
//   opengl - ALU: 17 to 26
//   d3d9 - ALU: 20 to 29
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"!!ARBvp1.0
# 25 ALU
PARAM c[21] = { program.local[0],
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R1, vertex.attrib[14].w;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[2].z, R0, c[15];
DP4 result.texcoord[2].y, R0, c[14];
DP4 result.texcoord[2].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[20].xyxy, c[20];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 25 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 18 [_MainTex_ST]
Vector 19 [_BumpMap_ST]
"vs_2_0
; 28 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
mul r2.xyz, r1, v1.w
dp4 r3.z, c17, r0
mov r0, c9
dp4 r3.y, c17, r0
mov r1, c8
dp4 r3.x, c17, r1
mad r0.xyz, r3, c16.w, -v0
dp3 oT1.y, r0, r2
dp3 oT1.z, v2, r0
dp3 oT1.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 oT2.z, r0, c14
dp4 oT2.y, r0, c13
dp4 oT2.x, r0, c12
mad oT0.zw, v3.xyxy, c19.xyxy, c19
mad oT0.xy, v3, c18, c18.zwzw
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
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 _BumpMap_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  vec4 tmpvar_3;
  tmpvar_3 = TANGENT.xyzw;
  vec3 tmpvar_5;
  tmpvar_5 = gl_Normal.xyz;
  vec4 tmpvar_7;
  tmpvar_7 = gl_MultiTexCoord0.xyzw;
  vec4 tmpvar_76;
  tmpvar_76.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_76.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_30;
  tmpvar_30 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_31;
  tmpvar_31[0].x = tmpvar_3.x;
  tmpvar_31[0].y = tmpvar_30.x;
  tmpvar_31[0].z = tmpvar_5.x;
  tmpvar_31[1].x = tmpvar_3.y;
  tmpvar_31[1].y = tmpvar_30.y;
  tmpvar_31[1].z = tmpvar_5.y;
  tmpvar_31[2].x = tmpvar_3.z;
  tmpvar_31[2].y = tmpvar_30.z;
  tmpvar_31[2].z = tmpvar_5.z;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_76.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_31 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  float tmpvar_45;
  tmpvar_45 = tmpvar_43.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_43.xyz * _LightColor0.xyz) * ((max (0.0, dot (normal.xyz, normalize (gl_TexCoord[1].xyz))) * texture2D (_LightTexture0, vec2(dot (tmpvar_6, tmpvar_6))).w) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_45)).w;
  c = c_i0_i1;
  c.w = (vec4(tmpvar_45)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceLightPos0]
Matrix 5 [_World2Object]
Vector 10 [_MainTex_ST]
Vector 11 [_BumpMap_ST]
"!!ARBvp1.0
# 17 ALU
PARAM c[12] = { program.local[0],
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R1, c[9];
DP4 R2.z, R1, c[7];
DP4 R2.y, R1, c[6];
DP4 R2.x, R1, c[5];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP3 result.texcoord[1].y, R2, R0;
DP3 result.texcoord[1].z, vertex.normal, R2;
DP3 result.texcoord[1].x, R2, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[11].xyxy, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceLightPos0]
Matrix 4 [_World2Object]
Vector 9 [_MainTex_ST]
Vector 10 [_BumpMap_ST]
"vs_2_0
; 20 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c6
dp4 r3.z, c8, r0
mul r2.xyz, r1, v1.w
mov r0, c5
mov r1, c4
dp4 r3.y, c8, r0
dp4 r3.x, c8, r1
dp3 oT1.y, r3, r2
dp3 oT1.z, v2, r3
dp3 oT1.x, r3, v1
mad oT0.zw, v3.xyxy, c10.xyxy, c10
mad oT0.xy, v3, c9, c9.zwzw
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
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _World2Object;
uniform vec4 _MainTex_ST;
uniform vec4 _BumpMap_ST;
void main ()
{
  vec4 tmpvar_3;
  tmpvar_3 = TANGENT.xyzw;
  vec3 tmpvar_5;
  tmpvar_5 = gl_Normal.xyz;
  vec4 tmpvar_7;
  tmpvar_7 = gl_MultiTexCoord0.xyzw;
  vec4 tmpvar_69;
  tmpvar_69.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_69.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_28;
  tmpvar_28 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_29;
  tmpvar_29[0].x = tmpvar_3.x;
  tmpvar_29[0].y = tmpvar_28.x;
  tmpvar_29[0].z = tmpvar_5.x;
  tmpvar_29[1].x = tmpvar_3.y;
  tmpvar_29[1].y = tmpvar_28.y;
  tmpvar_29[1].z = tmpvar_5.y;
  tmpvar_29[2].x = tmpvar_3.z;
  tmpvar_29[2].y = tmpvar_28.z;
  tmpvar_29[2].z = tmpvar_5.z;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw).xyzw;
  gl_TexCoord[0] = tmpvar_69.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_29 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec4 c;
  vec4 tmpvar_41;
  tmpvar_41 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  float tmpvar_43;
  tmpvar_43 = tmpvar_41.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_41.xyz * _LightColor0.xyz) * (max (0.0, dot (normal.xyz, gl_TexCoord[1].xyz)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_43)).w;
  c = c_i0_i1;
  c.w = (vec4(tmpvar_43)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"!!ARBvp1.0
# 26 ALU
PARAM c[21] = { program.local[0],
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R0.w, vertex.position, c[8];
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[2].w, R0, c[16];
DP4 result.texcoord[2].z, R0, c[15];
DP4 result.texcoord[2].y, R0, c[14];
DP4 result.texcoord[2].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[20].xyxy, c[20];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 26 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 18 [_MainTex_ST]
Vector 19 [_BumpMap_ST]
"vs_2_0
; 29 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
mul r2.xyz, r1, v1.w
dp4 r3.z, c17, r0
mov r0, c9
dp4 r3.y, c17, r0
mov r1, c8
dp4 r3.x, c17, r1
mad r0.xyz, r3, c16.w, -v0
dp4 r0.w, v0, c7
dp3 oT1.y, r0, r2
dp3 oT1.z, v2, r0
dp3 oT1.x, r0, v1
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 oT2.w, r0, c15
dp4 oT2.z, r0, c14
dp4 oT2.y, r0, c13
dp4 oT2.x, r0, c12
mad oT0.zw, v3.xyxy, c19.xyxy, c19
mad oT0.xy, v3, c18, c18.zwzw
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
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 _BumpMap_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  vec4 tmpvar_3;
  tmpvar_3 = TANGENT.xyzw;
  vec3 tmpvar_5;
  tmpvar_5 = gl_Normal.xyz;
  vec4 tmpvar_7;
  tmpvar_7 = gl_MultiTexCoord0.xyzw;
  vec4 tmpvar_76;
  tmpvar_76.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_76.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_30;
  tmpvar_30 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_31;
  tmpvar_31[0].x = tmpvar_3.x;
  tmpvar_31[0].y = tmpvar_30.x;
  tmpvar_31[0].z = tmpvar_5.x;
  tmpvar_31[1].x = tmpvar_3.y;
  tmpvar_31[1].y = tmpvar_30.y;
  tmpvar_31[1].z = tmpvar_5.y;
  tmpvar_31[2].x = tmpvar_3.z;
  tmpvar_31[2].y = tmpvar_30.z;
  tmpvar_31[2].z = tmpvar_5.z;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_76.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_31 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  gl_TexCoord[2] = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyzw;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec4 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyzw;
  vec4 c;
  vec4 tmpvar_50;
  tmpvar_50 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  float tmpvar_52;
  tmpvar_52 = tmpvar_50.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 LightCoord_i0;
  LightCoord_i0 = tmpvar_6.xyz;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_50.xyz * _LightColor0.xyz) * ((max (0.0, dot (normal.xyz, normalize (gl_TexCoord[1].xyz))) * ((float((tmpvar_6.z > 0.0)) * texture2D (_LightTexture0, ((tmpvar_6.xy / tmpvar_6.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_52)).w;
  c = c_i0_i1;
  c.w = (vec4(tmpvar_52)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"!!ARBvp1.0
# 25 ALU
PARAM c[21] = { program.local[0],
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R1, vertex.attrib[14].w;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[2].z, R0, c[15];
DP4 result.texcoord[2].y, R0, c[14];
DP4 result.texcoord[2].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[20].xyxy, c[20];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 25 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 18 [_MainTex_ST]
Vector 19 [_BumpMap_ST]
"vs_2_0
; 28 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
mul r2.xyz, r1, v1.w
dp4 r3.z, c17, r0
mov r0, c9
dp4 r3.y, c17, r0
mov r1, c8
dp4 r3.x, c17, r1
mad r0.xyz, r3, c16.w, -v0
dp3 oT1.y, r0, r2
dp3 oT1.z, v2, r0
dp3 oT1.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 oT2.z, r0, c14
dp4 oT2.y, r0, c13
dp4 oT2.x, r0, c12
mad oT0.zw, v3.xyxy, c19.xyxy, c19
mad oT0.xy, v3, c18, c18.zwzw
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
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 _BumpMap_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  vec4 tmpvar_3;
  tmpvar_3 = TANGENT.xyzw;
  vec3 tmpvar_5;
  tmpvar_5 = gl_Normal.xyz;
  vec4 tmpvar_7;
  tmpvar_7 = gl_MultiTexCoord0.xyzw;
  vec4 tmpvar_76;
  tmpvar_76.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_76.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_30;
  tmpvar_30 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_31;
  tmpvar_31[0].x = tmpvar_3.x;
  tmpvar_31[0].y = tmpvar_30.x;
  tmpvar_31[0].z = tmpvar_5.x;
  tmpvar_31[1].x = tmpvar_3.y;
  tmpvar_31[1].y = tmpvar_30.y;
  tmpvar_31[1].z = tmpvar_5.y;
  tmpvar_31[2].x = tmpvar_3.z;
  tmpvar_31[2].y = tmpvar_30.z;
  tmpvar_31[2].z = tmpvar_5.z;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_76.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_31 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  float tmpvar_45;
  tmpvar_45 = tmpvar_43.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_43.xyz * _LightColor0.xyz) * ((max (0.0, dot (normal.xyz, normalize (gl_TexCoord[1].xyz))) * (texture2D (_LightTextureB0, vec2(dot (tmpvar_6, tmpvar_6))).w * textureCube (_LightTexture0, tmpvar_6).w)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_45)).w;
  c = c_i0_i1;
  c.w = (vec4(tmpvar_45)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 18 [_MainTex_ST]
Vector 19 [_BumpMap_ST]
"!!ARBvp1.0
# 23 ALU
PARAM c[20] = { program.local[0],
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R1, c[17];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
DP3 result.texcoord[1].y, R2, R0;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[1].z, vertex.normal, R2;
DP3 result.texcoord[1].x, R2, vertex.attrib[14];
DP4 result.texcoord[2].y, R0, c[14];
DP4 result.texcoord[2].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 23 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 17 [_MainTex_ST]
Vector 18 [_BumpMap_ST]
"vs_2_0
; 26 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
dp4 r3.z, c16, r0
mov r0, c9
dp4 r3.y, c16, r0
mul r2.xyz, r1, v1.w
mov r1, c8
dp4 r3.x, c16, r1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 oT1.y, r3, r2
dp3 oT1.z, v2, r3
dp3 oT1.x, r3, v1
dp4 oT2.y, r0, c13
dp4 oT2.x, r0, c12
mad oT0.zw, v3.xyxy, c18.xyxy, c18
mad oT0.xy, v3, c17, c17.zwzw
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
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _World2Object;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
uniform vec4 _BumpMap_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  vec4 tmpvar_3;
  tmpvar_3 = TANGENT.xyzw;
  vec3 tmpvar_5;
  tmpvar_5 = gl_Normal.xyz;
  vec4 tmpvar_7;
  tmpvar_7 = gl_MultiTexCoord0.xyzw;
  vec4 tmpvar_76;
  tmpvar_76.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_76.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_30;
  tmpvar_30 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_31;
  tmpvar_31[0].x = tmpvar_3.x;
  tmpvar_31[0].y = tmpvar_30.x;
  tmpvar_31[0].z = tmpvar_5.x;
  tmpvar_31[1].x = tmpvar_3.y;
  tmpvar_31[1].y = tmpvar_30.y;
  tmpvar_31[1].z = tmpvar_5.y;
  tmpvar_31[2].x = tmpvar_3.z;
  tmpvar_31[2].y = tmpvar_30.z;
  tmpvar_31[2].z = tmpvar_5.z;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_76.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_31 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xy = (_LightMatrix0 * (_Object2World * tmpvar_1)).xy;
  tmpvar_21.z = 0.0;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  float tmpvar_45;
  tmpvar_45 = tmpvar_43.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_43.xyz * _LightColor0.xyz) * ((max (0.0, dot (normal.xyz, gl_TexCoord[1].xyz)) * texture2D (_LightTexture0, gl_TexCoord[2].xy).w) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_45)).w;
  c = c_i0_i1;
  c.w = (vec4(tmpvar_45)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 15 to 27, TEX: 2 to 4
//   d3d9 - ALU: 17 to 29, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 21 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R0, R0, c[1];
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R2.x, R2.x;
MUL R0.xyz, R0, c[0];
MOV result.color.w, R0;
TEX R1.w, R1.x, texture[2], 2D;
MAD R1.xy, R2.wyzw, c[2].x, -c[2].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[2].y;
RSQ R1.z, R1.z;
MUL R2.xyz, R2.x, fragment.texcoord[1];
RCP R1.z, R1.z;
DP3 R1.x, R1, R2;
MAX R1.x, R1, c[2].z;
MUL R1.x, R1, R1.w;
MUL R1.x, R1, c[2];
MUL result.color.xyz, R0, R1.x;
END
# 21 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"ps_2_0
; 23 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
texld r2, t0, s0
dp3 r0.x, t2, t2
mov r1.xy, r0.x
mov r0.y, t0.w
mov r0.x, t0.z
texld r3, r1, s2
texld r0, r0, s1
mov r0.x, r0.w
mad_pp r4.xy, r0, c2.x, c2.y
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
dp3_pp r1.x, t1, t1
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t1
rcp_pp r4.z, r0.x
dp3_pp r0.x, r4, r1
mul r1, r2, c1
max_pp r0.x, r0, c2.w
mul_pp r0.x, r0, r3
mul_pp r0.x, r0, c2
mul r1.xyz, r1, c0
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
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 15 ALU, 2 TEX
PARAM c[3] = { program.local[0..1],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[1];
MAD R1.xy, R1.wyzw, c[2].x, -c[2].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[2].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R1.x, R1, fragment.texcoord[1];
MAX R1.x, R1, c[2].z;
MUL R1.x, R1, c[2];
MUL R0.xyz, R0, c[0];
MUL result.color.xyz, R0, R1.x;
MOV result.color.w, R0;
END
# 15 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"ps_2_0
; 17 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl t0
dcl t1.xyz
texld r1, t0, s0
mul r1, r1, c1
mov r0.y, t0.w
mov r0.x, t0.z
mul r1.xyz, r1, c0
texld r0, r0, s1
mov r0.x, r0.w
mad_pp r2.xy, r0, c2.x, c2.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.x, r2, t1
max_pp r0.x, r0, c2.w
mul_pp r0.x, r0, c2
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
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 27 ALU, 4 TEX
PARAM c[3] = { program.local[0..1],
		{ 2, 1, 0, 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TEX R3.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
DP3 R0.z, fragment.texcoord[2], fragment.texcoord[2];
RCP R0.x, fragment.texcoord[2].w;
MAD R0.xy, fragment.texcoord[2], R0.x, c[2].w;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
TEX R0.w, R0, texture[2], 2D;
TEX R1.w, R0.z, texture[3], 2D;
MAD R0.xy, R3.wyzw, c[2].x, -c[2].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[2].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R0.x, R0, R1;
SLT R0.y, c[2].z, fragment.texcoord[2].z;
MUL R0.y, R0, R0.w;
MUL R0.y, R0, R1.w;
MAX R0.x, R0, c[2].z;
MUL R1.x, R0, R0.y;
MUL R0, R2, c[1];
MUL R1.x, R1, c[2];
MUL R0.xyz, R0, c[0];
MUL result.color.xyz, R0, R1.x;
MOV result.color.w, R0;
END
# 27 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"ps_2_0
; 29 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
def c3, 0.50000000, 0, 0, 0
dcl t0
dcl t1.xyz
dcl t2
texld r2, t0, s0
dp3 r0.x, t2, t2
mov r3.xy, r0.x
rcp r0.x, t2.w
mad r0.xy, t2, r0.x, c3.x
mov r1.y, t0.w
mov r1.x, t0.z
texld r1, r1, s1
texld r3, r3, s3
texld r0, r0, s2
dp3_pp r1.x, t1, t1
mov r0.y, r1
mov r0.x, r1.w
mad_pp r4.xy, r0, c2.x, c2.y
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t1
rcp_pp r4.z, r0.x
dp3_pp r0.x, r4, r1
max_pp r0.x, r0, c2.w
cmp r1.x, -t2.z, c2.w, c2.z
mul r1.x, r1, r0.w
mul r1.x, r1, r3
mul_pp r0.x, r0, r1
mul r1, r2, c1
mul_pp r0.x, r0, c2
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
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 23 ALU, 4 TEX
PARAM c[3] = { program.local[0..1],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TEX R3.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R1.w, fragment.texcoord[2], texture[3], CUBE;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
TEX R0.w, R0.x, texture[2], 2D;
MAD R0.xy, R3.wyzw, c[2].x, -c[2].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[2].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R0.x, R0, R1;
MUL R0.y, R0.w, R1.w;
MAX R0.x, R0, c[2].z;
MUL R1.x, R0, R0.y;
MUL R0, R2, c[1];
MUL R1.x, R1, c[2];
MUL R0.xyz, R0, c[0];
MUL result.color.xyz, R0, R1.x;
MOV result.color.w, R0;
END
# 23 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"ps_2_0
; 25 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
texld r2, t0, s0
dp3 r1.x, t2, t2
mov r1.xy, r1.x
mov r0.y, t0.w
mov r0.x, t0.z
texld r3, r1, s2
texld r1, r0, s1
texld r0, t2, s3
dp3_pp r1.x, t1, t1
mov r0.y, r1
mov r0.x, r1.w
mad_pp r4.xy, r0, c2.x, c2.y
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t1
rcp_pp r4.z, r0.x
dp3_pp r0.x, r4, r1
max_pp r0.x, r0, c2.w
mul r1.x, r3, r0.w
mul_pp r0.x, r0, r1
mul r1, r2, c1
mul_pp r0.x, r0, c2
mul r1.xyz, r1, c0
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
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 17 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R2.w, fragment.texcoord[2], texture[2], 2D;
MUL R0, R0, c[1];
MAD R1.xy, R1.wyzw, c[2].x, -c[2].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[2].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R1.x, R1, fragment.texcoord[1];
MAX R1.x, R1, c[2].z;
MUL R1.x, R1, R2.w;
MUL R1.x, R1, c[2];
MUL R0.xyz, R0, c[0];
MUL result.color.xyz, R0, R1.x;
MOV result.color.w, R0;
END
# 17 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"ps_2_0
; 19 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c2, 2.00000000, -1.00000000, 1.00000000, 0.00000000
dcl t0
dcl t1.xyz
dcl t2.xy
texld r1, t0, s0
mul r1, r1, c1
mov r0.y, t0.w
mov r0.x, t0.z
mul r1.xyz, r1, c0
texld r2, r0, s1
texld r0, t2, s2
mov r0.y, r2
mov r0.x, r2.w
mad_pp r2.xy, r0, c2.x, c2.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c2.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.x, r2, t1
max_pp r0.x, r0, c2.w
mul_pp r0.x, r0, r0.w
mul_pp r0.x, r0, c2
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

#LINE 30

}

FallBack "Transparent/Diffuse"
}