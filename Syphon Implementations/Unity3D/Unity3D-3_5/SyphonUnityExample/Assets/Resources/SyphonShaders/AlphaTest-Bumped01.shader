Shader "Syphon/Transparent/Cutout/Bumped Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
}

SubShader {
	Tags {"IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	LOD 300
	
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		AlphaToMask True 
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 7 to 71
//   d3d9 - ALU: 7 to 74
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
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
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
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
  vec3 tmpvar_53;
  tmpvar_53 = normal.xyz;
  float x;
  x = (tmpvar_46 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_45 * _LightColor0.xyz) * (max (0.0, dot (tmpvar_53, tmpvar_4)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_46)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_45 * tmpvar_6)).xyz;
  c.w = (vec4(tmpvar_46)).w;
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
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
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
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec2 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xy;
  vec4 c;
  vec4 tmpvar_37;
  tmpvar_37 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  vec3 tmpvar_38;
  tmpvar_38 = tmpvar_37.xyz;
  float tmpvar_39;
  tmpvar_39 = tmpvar_37.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  float x;
  x = (tmpvar_39 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  c.xyz = (tmpvar_38 * (2.0 * texture2D (unity_Lightmap, tmpvar_4).xyz)).xyz;
  c.w = (vec4(tmpvar_39)).w;
  c.w = (vec4(tmpvar_39)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_ProjectionParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Vector 23 [_MainTex_ST]
Vector 24 [_BumpMap_ST]
"!!ARBvp1.0
# 40 ALU
PARAM c[25] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..24] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[14].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[18];
DP4 R2.y, R0, c[17];
DP4 R2.x, R0, c[16];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[21];
DP4 R3.y, R1, c[20];
DP4 R3.x, R1, c[19];
MOV R1.xyz, vertex.attrib[14];
DP4 R0.w, vertex.position, c[4];
ADD R3.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R2.xyz, R0.x, c[22];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
MUL R0.xyz, R0, vertex.attrib[14].w;
MOV R1, c[15];
ADD result.texcoord[2].xyz, R3, R2;
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
DP3 result.texcoord[1].y, R2, R0;
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
DP3 result.texcoord[1].z, vertex.normal, R2;
DP3 result.texcoord[1].x, R2, vertex.attrib[14];
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[24].xyxy, c[24];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[23], c[23].zwzw;
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Vector 23 [_MainTex_ST]
Vector 24 [_BumpMap_ST]
"vs_2_0
; 43 ALU
def c25, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c14.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c25.x
dp4 r2.z, r0, c18
dp4 r2.y, r0, c17
dp4 r2.x, r0, c16
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c21
dp4 r3.y, r1, c20
dp4 r3.x, r1, c19
mad r0.x, r0, r0, -r0.y
mul r1.xyz, r0.x, c22
add r2.xyz, r2, r3
mov r0.xyz, v1
add oT2.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
dp4 r3.z, c15, r0
mov r0, c9
dp4 r3.y, c15, r0
mul r2.xyz, r1, v1.w
mov r1, c8
dp4 r3.x, c15, r1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c25.y
mul r1.y, r1, c12.x
dp3 oT1.y, r3, r2
dp3 oT1.z, v2, r3
dp3 oT1.x, r3, v1
mad oT3.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mad oT0.zw, v3.xyxy, c24.xyxy, c24
mad oT0.xy, v3, c23, c23.zwzw
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
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
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
  vec4 tmpvar_147;
  vec4 tmpvar_57;
  tmpvar_57 = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw);
  tmpvar_147.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_147.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  mat3 tmpvar_65;
  tmpvar_65[0] = _Object2World[0].xyz;
  tmpvar_65[1] = _Object2World[1].xyz;
  tmpvar_65[2] = _Object2World[2].xyz;
  vec3 tmpvar_71;
  tmpvar_71 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_72;
  tmpvar_72[0].x = tmpvar_3.x;
  tmpvar_72[0].y = tmpvar_71.x;
  tmpvar_72[0].z = tmpvar_5.x;
  tmpvar_72[1].x = tmpvar_3.y;
  tmpvar_72[1].y = tmpvar_71.y;
  tmpvar_72[1].z = tmpvar_5.y;
  tmpvar_72[2].x = tmpvar_3.z;
  tmpvar_72[2].y = tmpvar_71.z;
  tmpvar_72[2].z = tmpvar_5.z;
  vec4 tmpvar_87;
  tmpvar_87.xyz = (tmpvar_65 * (tmpvar_5 * unity_Scale.w)).xyz;
  tmpvar_87.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_87);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_87))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_87))).z;
  vec4 tmpvar_96;
  tmpvar_96 = (tmpvar_87.xyzz * tmpvar_87.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_96);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_96))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_96))).z;
  vec4 o_i0;
  vec4 tmpvar_109;
  tmpvar_109 = (tmpvar_57 * 0.5);
  o_i0 = tmpvar_109;
  vec2 tmpvar_110;
  tmpvar_110.x = tmpvar_109.x;
  tmpvar_110.y = (vec2((tmpvar_109.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_110 + tmpvar_109.w);
  o_i0.zw = tmpvar_57.zw;
  gl_Position = tmpvar_57.xyzw;
  gl_TexCoord[0] = tmpvar_147.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_72 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_87.x * tmpvar_87.x) - (tmpvar_87.y * tmpvar_87.y)))).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  gl_TexCoord[3] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyzw;
  vec4 c;
  vec4 tmpvar_48;
  tmpvar_48 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  vec3 tmpvar_49;
  tmpvar_49 = tmpvar_48.xyz;
  float tmpvar_50;
  tmpvar_50 = tmpvar_48.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_57;
  tmpvar_57 = normal.xyz;
  float x;
  x = (tmpvar_50 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_49 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_57, tmpvar_4)) * texture2DProj (_ShadowMapTexture, tmpvar_8).x) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_50)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_49 * tmpvar_6)).xyz;
  c.w = (vec4(tmpvar_50)).w;
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
Vector 12 [_BumpMap_ST]
"!!ARBvp1.0
# 12 ALU
PARAM c[13] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..12] };
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
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 12 instructions, 2 R-regs
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
Vector 12 [_BumpMap_ST]
"vs_2_0
; 12 ALU
def c13, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v3
dcl_texcoord1 v4
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c13.x
mul r1.y, r1, c8.x
mad oT3.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mad oT0.zw, v3.xyxy, c12.xyxy, c12
mad oT0.xy, v3, c11, c11.zwzw
mad oT1.xy, v4, c10, c10.zwzw
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
uniform vec4 _BumpMap_ST;
void main ()
{
  vec4 tmpvar_7;
  tmpvar_7 = gl_MultiTexCoord0.xyzw;
  vec4 tmpvar_100;
  vec4 tmpvar_37;
  tmpvar_37 = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw);
  tmpvar_100.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_100.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec4 o_i0;
  vec4 tmpvar_66;
  tmpvar_66 = (tmpvar_37 * 0.5);
  o_i0 = tmpvar_66;
  vec2 tmpvar_67;
  tmpvar_67.x = tmpvar_66.x;
  tmpvar_67.y = (vec2((tmpvar_66.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_67 + tmpvar_66.w);
  o_i0.zw = tmpvar_37.zw;
  gl_Position = tmpvar_37.xyzw;
  gl_TexCoord[0] = tmpvar_100.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xy = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw).xy;
  tmpvar_19.z = 0.0;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  gl_TexCoord[3] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec2 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xy;
  vec4 tmpvar_6;
  tmpvar_6 = gl_TexCoord[3].xyzw;
  vec4 c;
  vec4 tmpvar_41;
  tmpvar_41 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  vec3 tmpvar_42;
  tmpvar_42 = tmpvar_41.xyz;
  float tmpvar_43;
  tmpvar_43 = tmpvar_41.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  float x;
  x = (tmpvar_43 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  c.xyz = (tmpvar_42 * min ((2.0 * texture2D (unity_Lightmap, tmpvar_4).xyz), vec3((texture2DProj (_ShadowMapTexture, tmpvar_6).x * 2.0)))).xyz;
  c.w = (vec4(tmpvar_43)).w;
  c.w = (vec4(tmpvar_43)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
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
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
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
  vec3 tmpvar_53;
  tmpvar_53 = normal.xyz;
  float x;
  x = (tmpvar_46 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_45 * _LightColor0.xyz) * (max (0.0, dot (tmpvar_53, tmpvar_4)) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_46)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_45 * tmpvar_6)).xyz;
  c.w = (vec4(tmpvar_46)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_ProjectionParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Vector 31 [_MainTex_ST]
Vector 32 [_BumpMap_ST]
"!!ARBvp1.0
# 71 ALU
PARAM c[33] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..32] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[14].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[17];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[16];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[18];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[19];
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
MUL R1.xyz, R0.y, c[21];
MAD R1.xyz, R0.x, c[20], R1;
MAD R0.xyz, R0.z, c[22], R1;
MAD R1.xyz, R0.w, c[23], R0;
MUL R0, R4.xyzz, R4.yzzx;
DP4 R3.z, R0, c[29];
DP4 R3.y, R0, c[28];
DP4 R3.x, R0, c[27];
MUL R1.w, R3, R3;
MAD R0.x, R4, R4, -R1.w;
DP4 R2.z, R4, c[26];
DP4 R2.y, R4, c[25];
DP4 R2.x, R4, c[24];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[30];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
ADD result.texcoord[2].xyz, R3, R1;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R0, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
DP3 result.texcoord[1].y, R2, R1;
MUL R1.xyz, R0.xyww, c[0].z;
MUL R1.y, R1, c[13].x;
DP3 result.texcoord[1].z, vertex.normal, R2;
DP3 result.texcoord[1].x, R2, vertex.attrib[14];
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[32].xyxy, c[32];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[31], c[31].zwzw;
END
# 71 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Vector 31 [_MainTex_ST]
Vector 32 [_BumpMap_ST]
"vs_2_0
; 74 ALU
def c33, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c14.w
dp4 r0.x, v0, c5
add r1, -r0.x, c17
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c16
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c33.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c18
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c19
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c33.x
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c33.y
mul r0, r0, r1
mul r1.xyz, r0.y, c21
mad r1.xyz, r0.x, c20, r1
mad r0.xyz, r0.z, c22, r1
mad r1.xyz, r0.w, c23, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c29
dp4 r3.y, r0, c28
dp4 r3.x, r0, c27
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c30
dp4 r2.z, r4, c26
dp4 r2.y, r4, c25
dp4 r2.x, r4, c24
add r2.xyz, r2, r3
add r2.xyz, r2, r0
mov r0.xyz, v1
add oT2.xyz, r2, r1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mov r0, c10
dp4 r3.z, c15, r0
mov r0, c8
dp4 r3.x, c15, r0
mul r2.xyz, r1, v1.w
mov r1, c9
dp4 r3.y, c15, r1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c33.z
mul r1.y, r1, c12.x
dp3 oT1.y, r3, r2
dp3 oT1.z, v2, r3
dp3 oT1.x, r3, v1
mad oT3.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mad oT0.zw, v3.xyxy, c32.xyxy, c32
mad oT0.xy, v3, c31, c31.zwzw
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
uniform vec4 _WorldSpaceLightPos0;
uniform mat4 _World2Object;
uniform vec4 _ProjectionParams;
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
  vec4 tmpvar_196;
  vec4 tmpvar_80;
  tmpvar_80 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  tmpvar_196.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_196.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  mat3 tmpvar_88;
  tmpvar_88[0] = _Object2World[0].xyz;
  tmpvar_88[1] = _Object2World[1].xyz;
  tmpvar_88[2] = _Object2World[2].xyz;
  vec3 tmpvar_92;
  tmpvar_92 = (tmpvar_88 * (tmpvar_5 * unity_Scale.w));
  vec3 tmpvar_94;
  tmpvar_94 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_95;
  tmpvar_95[0].x = tmpvar_3.x;
  tmpvar_95[0].y = tmpvar_94.x;
  tmpvar_95[0].z = tmpvar_5.x;
  tmpvar_95[1].x = tmpvar_3.y;
  tmpvar_95[1].y = tmpvar_94.y;
  tmpvar_95[1].z = tmpvar_5.y;
  tmpvar_95[2].x = tmpvar_3.z;
  tmpvar_95[2].y = tmpvar_94.z;
  tmpvar_95[2].z = tmpvar_5.z;
  vec4 tmpvar_110;
  tmpvar_110.xyz = tmpvar_92.xyz;
  tmpvar_110.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_110);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_110))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_110))).z;
  vec4 tmpvar_119;
  tmpvar_119 = (tmpvar_110.xyzz * tmpvar_110.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_119);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_119))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_119))).z;
  vec3 tmpvar_130;
  tmpvar_130 = (_Object2World * tmpvar_1).xyz;
  vec4 tmpvar_133;
  tmpvar_133 = (unity_4LightPosX0 - tmpvar_130.x);
  vec4 tmpvar_134;
  tmpvar_134 = (unity_4LightPosY0 - tmpvar_130.y);
  vec4 tmpvar_135;
  tmpvar_135 = (unity_4LightPosZ0 - tmpvar_130.z);
  vec4 tmpvar_139;
  tmpvar_139 = (((tmpvar_133 * tmpvar_133) + (tmpvar_134 * tmpvar_134)) + (tmpvar_135 * tmpvar_135));
  vec4 tmpvar_149;
  tmpvar_149 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_133 * tmpvar_92.x) + (tmpvar_134 * tmpvar_92.y)) + (tmpvar_135 * tmpvar_92.z)) * inversesqrt (tmpvar_139))) * 1.0/((1.0 + (tmpvar_139 * unity_4LightAtten0))));
  vec4 o_i0;
  vec4 tmpvar_158;
  tmpvar_158 = (tmpvar_80 * 0.5);
  o_i0 = tmpvar_158;
  vec2 tmpvar_159;
  tmpvar_159.x = tmpvar_158.x;
  tmpvar_159.y = (vec2((tmpvar_158.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_159 + tmpvar_158.w);
  o_i0.zw = tmpvar_80.zw;
  gl_Position = tmpvar_80.xyzw;
  gl_TexCoord[0] = tmpvar_196.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_95 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_110.x * tmpvar_110.x) - (tmpvar_110.y * tmpvar_110.y)))) + ((((unity_LightColor0 * tmpvar_149.x) + (unity_LightColor1 * tmpvar_149.y)) + (unity_LightColor2 * tmpvar_149.z)) + (unity_LightColor3 * tmpvar_149.w))).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  gl_TexCoord[3] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyzw;
  vec4 c;
  vec4 tmpvar_48;
  tmpvar_48 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  vec3 tmpvar_49;
  tmpvar_49 = tmpvar_48.xyz;
  float tmpvar_50;
  tmpvar_50 = tmpvar_48.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_57;
  tmpvar_57 = normal.xyz;
  float x;
  x = (tmpvar_50 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_49 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_57, tmpvar_4)) * texture2DProj (_ShadowMapTexture, tmpvar_8).x) * 2.0)).xyz;
  c_i0_i1.w = (vec4(tmpvar_50)).w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_49 * tmpvar_6)).xyz;
  c.w = (vec4(tmpvar_50)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 4
//   opengl - ALU: 9 to 21, TEX: 2 to 3
//   d3d9 - ALU: 9 to 23, TEX: 3 to 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 19 ALU, 2 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1, R0, c[1];
SLT R0.x, R1.w, c[2];
MOV result.color.w, R1;
TEX R0.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
KIL -R0.x;
MAD R0.xy, R0.wyzw, c[3].x, -c[3].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[3].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R0.x, R0, fragment.texcoord[1];
MAX R0.w, R0.x, c[3].z;
MUL R0.xyz, R1, fragment.texcoord[2];
MUL R0.w, R0, c[3].x;
MUL R1.xyz, R1, c[0];
MUL R1.xyz, R1, R0.w;
ADD result.color.xyz, R1, R0;
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"ps_2_0
; 22 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
texld r0, t0, s0
mul r0, r0, c1
add r1.x, r0.w, -c2
cmp r1.x, r1, c3, c3.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
texld r2, r2, s1
texkill r1.xyzw
mov r1.x, r2.w
mov r1.y, r2
mad_pp r2.xy, r1, c3.z, c3.w
mul_pp r1.x, r2.y, r2.y
mad_pp r1.x, -r2, r2, -r1
add_pp r1.x, r1, c3.y
rsq_pp r1.x, r1.x
rcp_pp r2.z, r1.x
dp3_pp r1.x, r2, t1
mul r2.xyz, r0, t2
max_pp r1.x, r1, c3
mul_pp r1.x, r1, c3.z
mul r0.xyz, r0, c0
mul r0.xyz, r0, r1.x
add_pp r0.xyz, r0, r2
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
SetTexture 2 [unity_Lightmap] 2D
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
TEX R0, fragment.texcoord[1], texture[2], 2D;
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
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 9 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c2, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t1.xy
texld r0, t0, s0
mul r1, r0, c0
add r0.x, r1.w, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r2, -r0.x
texld r0, t1, s2
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
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_ShadowMapTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 21 ALU, 3 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1, R0, c[1];
SLT R0.x, R1.w, c[2];
MOV result.color.w, R1;
TEX R0.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
KIL -R0.x;
TXP R0.x, fragment.texcoord[3], texture[2], 2D;
MAD R0.yz, R0.xwyw, c[3].x, -c[3].y;
MUL R0.w, R0.z, R0.z;
MAD R0.w, -R0.y, R0.y, -R0;
ADD R0.w, R0, c[3].y;
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
DP3 R0.y, R0.yzww, fragment.texcoord[1];
MAX R0.y, R0, c[3].z;
MUL R0.w, R0.y, R0.x;
MUL R0.xyz, R1, fragment.texcoord[2];
MUL R0.w, R0, c[3].x;
MUL R1.xyz, R1, c[0];
MUL R1.xyz, R1, R0.w;
ADD result.color.xyz, R1, R0;
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_ShadowMapTexture] 2D
"ps_2_0
; 23 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3
texld r0, t0, s0
mul r1, r0, c1
add r0.x, r1.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r0, -r0.x
mov r2.y, t0.w
mov r2.x, t0.z
texld r2, r2, s1
texkill r0.xyzw
texldp r0, t3, s2
mov r2.x, r2.w
mad_pp r3.xy, r2, c3.z, c3.w
mul_pp r2.x, r3.y, r3.y
mad_pp r2.x, -r3, r3, -r2
add_pp r2.x, r2, c3.y
rsq_pp r2.x, r2.x
rcp_pp r3.z, r2.x
dp3_pp r2.x, r3, t1
max_pp r2.x, r2, c3
mul_pp r0.x, r2, r0
mul r2.xyz, r1, t2
mul_pp r0.x, r0, c3.z
mul r1.xyz, r1, c0
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
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 12 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R2.x, fragment.texcoord[3], texture[2], 2D;
MUL R1, R0, c[0];
SLT R0.x, R1.w, c[1];
MOV result.color.w, R1;
KIL -R0.x;
TEX R0, fragment.texcoord[1], texture[3], 2D;
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
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [unity_Lightmap] 2D
"ps_2_0
; 10 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 0.00000000, 1.00000000, 8.00000000, 2.00000000
dcl t0.xy
dcl t1.xy
dcl t3
texld r0, t0, s0
texld r2, t1, s3
mul r0, r0, c0
add r1.x, r0.w, -c1
cmp r1.x, r1, c2, c2.y
mov_pp r1, -r1.x
mul_pp r2.xyz, r2.w, r2
mul_pp r2.xyz, r2, c2.z
texkill r1.xyzw
texldp r1, t3, s2
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
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  vec3 tmpvar_44;
  tmpvar_44 = tmpvar_43.xyz;
  float tmpvar_45;
  tmpvar_45 = tmpvar_43.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_52;
  tmpvar_52 = normal.xyz;
  float x;
  x = (tmpvar_45 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_44 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_52, normalize (tmpvar_4))) * texture2D (_LightTexture0, vec2(dot (tmpvar_6, tmpvar_6))).w) * 2.0)).xyz;
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
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec4 c;
  vec4 tmpvar_41;
  tmpvar_41 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  vec3 tmpvar_42;
  tmpvar_42 = tmpvar_41.xyz;
  float tmpvar_43;
  tmpvar_43 = tmpvar_41.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_50;
  tmpvar_50 = normal.xyz;
  float x;
  x = (tmpvar_43 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_42 * _LightColor0.xyz) * (max (0.0, dot (tmpvar_50, tmpvar_4)) * 2.0)).xyz;
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
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec4 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyzw;
  vec4 c;
  vec4 tmpvar_50;
  tmpvar_50 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  vec3 tmpvar_51;
  tmpvar_51 = tmpvar_50.xyz;
  float tmpvar_52;
  tmpvar_52 = tmpvar_50.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_59;
  tmpvar_59 = normal.xyz;
  float x;
  x = (tmpvar_52 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec3 LightCoord_i0;
  LightCoord_i0 = tmpvar_6.xyz;
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_51 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_59, normalize (tmpvar_4))) * ((float((tmpvar_6.z > 0.0)) * texture2D (_LightTexture0, ((tmpvar_6.xy / tmpvar_6.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w)) * 2.0)).xyz;
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
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  vec3 tmpvar_44;
  tmpvar_44 = tmpvar_43.xyz;
  float tmpvar_45;
  tmpvar_45 = tmpvar_43.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_52;
  tmpvar_52 = normal.xyz;
  float x;
  x = (tmpvar_45 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_44 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_52, normalize (tmpvar_4))) * (texture2D (_LightTextureB0, vec2(dot (tmpvar_6, tmpvar_6))).w * textureCube (_LightTexture0, tmpvar_6).w)) * 2.0)).xyz;
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
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec2 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xy;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = (texture2D (_MainTex, tmpvar_2.xy) * _Color);
  vec3 tmpvar_44;
  tmpvar_44 = tmpvar_43.xyz;
  float tmpvar_45;
  tmpvar_45 = tmpvar_43.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_52;
  tmpvar_52 = normal.xyz;
  float x;
  x = (tmpvar_45 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_44 * _LightColor0.xyz) * ((max (0.0, dot (tmpvar_52, tmpvar_4)) * texture2D (_LightTexture0, tmpvar_6).w) * 2.0)).xyz;
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
//   opengl - ALU: 17 to 29, TEX: 2 to 4
//   d3d9 - ALU: 20 to 32, TEX: 3 to 5
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 23 ALU, 3 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R1, R0, c[1];
SLT R0.y, R1.w, c[2].x;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
DP3 R2.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R2.x, R2.x;
MOV result.color.w, R1;
TEX R0.w, R0.x, texture[2], 2D;
KIL -R0.y;
MAD R0.xy, R2.wyzw, c[3].x, -c[3].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[3].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
MUL R2.xyz, R2.x, fragment.texcoord[1];
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[3].z;
MUL R0.x, R0, R0.w;
MUL R0.w, R0.x, c[3].x;
MUL R0.xyz, R1, c[0];
MUL result.color.xyz, R0, R0.w;
END
# 23 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"ps_2_0
; 26 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
texld r0, t0, s0
mul r2, r0, c1
add r0.x, r2.w, -c2
cmp r1.x, r0, c3, c3.y
mov_pp r1, -r1.x
dp3 r0.x, t2, t2
mov r3.xy, r0.x
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s1
texkill r1.xyzw
texld r3, r3, s2
mov r0.x, r0.w
mad_pp r4.xy, r0, c3.z, c3.w
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
dp3_pp r1.x, t1, t1
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t1
rcp_pp r4.z, r0.x
dp3_pp r0.x, r4, r1
max_pp r0.x, r0, c3
mul_pp r0.x, r0, r3
mul_pp r0.x, r0, c3.z
mul r1.xyz, r2, c0
mul r0.xyz, r1, r0.x
mov_pp r0.w, r2
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
SetTexture 1 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 17 ALU, 2 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1, R0, c[1];
SLT R0.x, R1.w, c[2];
MOV result.color.w, R1;
TEX R0.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
KIL -R0.x;
MAD R0.xy, R0.wyzw, c[3].x, -c[3].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[3].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R0.x, R0, fragment.texcoord[1];
MAX R0.x, R0, c[3].z;
MUL R0.w, R0.x, c[3].x;
MUL R0.xyz, R1, c[0];
MUL result.color.xyz, R0, R0.w;
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"ps_2_0
; 20 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
dcl t0
dcl t1.xyz
texld r0, t0, s0
mul r0, r0, c1
add r1.x, r0.w, -c2
cmp r1.x, r1, c3, c3.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul r0.xyz, r0, c0
texld r2, r2, s1
texkill r1.xyzw
mov r1.x, r2.w
mov r1.y, r2
mad_pp r2.xy, r1, c3.z, c3.w
mul_pp r1.x, r2.y, r2.y
mad_pp r1.x, -r2, r2, -r1
add_pp r1.x, r1, c3.y
rsq_pp r1.x, r1.x
rcp_pp r2.z, r1.x
dp3_pp r1.x, r2, t1
max_pp r1.x, r1, c3
mul_pp r1.x, r1, c3.z
mul r0.xyz, r0, r1.x
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
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 29 ALU, 4 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0, 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R3.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2, R0, c[1];
SLT R0.w, R2, c[2].x;
DP3 R0.z, fragment.texcoord[2], fragment.texcoord[2];
RCP R0.x, fragment.texcoord[2].w;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.x, R1.x;
MAD R0.xy, fragment.texcoord[2], R0.x, c[3].w;
MUL R1.xyz, R1.x, fragment.texcoord[1];
MOV result.color.w, R2;
KIL -R0.w;
TEX R0.w, R0, texture[2], 2D;
TEX R1.w, R0.z, texture[3], 2D;
MAD R0.xy, R3.wyzw, c[3].x, -c[3].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[3].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R0.x, R0, R1;
SLT R0.y, c[3].z, fragment.texcoord[2].z;
MUL R0.y, R0, R0.w;
MUL R0.y, R0, R1.w;
MAX R0.x, R0, c[3].z;
MUL R0.x, R0, R0.y;
MUL R0.w, R0.x, c[3].x;
MUL R0.xyz, R2, c[0];
MUL result.color.xyz, R0, R0.w;
END
# 29 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"ps_2_0
; 32 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c4, 0.50000000, 0, 0, 0
dcl t0
dcl t1.xyz
dcl t2
texld r0, t0, s0
mul r2, r0, c1
add r0.x, r2.w, -c2
cmp r1.x, r0, c3, c3.y
dp3 r0.x, t2, t2
mov r3.xy, r0.x
mov_pp r1, -r1.x
rcp r0.x, t2.w
mad r0.xy, t2, r0.x, c4.x
mov r4.y, t0.w
mov r4.x, t0.z
texkill r1.xyzw
texld r1, r4, s1
texld r3, r3, s3
texld r0, r0, s2
dp3_pp r1.x, t1, t1
mov r0.y, r1
mov r0.x, r1.w
mad_pp r4.xy, r0, c3.z, c3.w
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t1
rcp_pp r4.z, r0.x
dp3_pp r0.x, r4, r1
cmp r1.x, -t2.z, c3, c3.y
mul r1.x, r1, r0.w
mul r1.x, r1, r3
max_pp r0.x, r0, c3
mul_pp r0.x, r0, r1
mul_pp r0.x, r0, c3.z
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
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 25 ALU, 4 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R3.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R1.w, fragment.texcoord[2], texture[3], CUBE;
MUL R2, R0, c[1];
SLT R0.y, R2.w, c[2].x;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
MOV result.color.w, R2;
TEX R0.w, R0.x, texture[2], 2D;
KIL -R0.y;
MAD R0.xy, R3.wyzw, c[3].x, -c[3].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[3].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R0.x, R0, R1;
MUL R0.y, R0.w, R1.w;
MAX R0.x, R0, c[3].z;
MUL R0.x, R0, R0.y;
MUL R0.w, R0.x, c[3].x;
MUL R0.xyz, R2, c[0];
MUL result.color.xyz, R0, R0.w;
END
# 25 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"ps_2_0
; 29 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
dcl t0
dcl t1.xyz
dcl t2.xyz
texld r0, t0, s0
mul r2, r0, c1
add r0.x, r2.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r1, -r0.x
dp3 r0.x, t2, t2
mov r3.y, t0.w
mov r3.x, t0.z
mov r4.xy, r3
mov r0.xy, r0.x
texld r3, r0, s2
texkill r1.xyzw
texld r1, r4, s1
texld r0, t2, s3
dp3_pp r1.x, t1, t1
mov r0.y, r1
mov r0.x, r1.w
mad_pp r4.xy, r0, c3.z, c3.w
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t1
rcp_pp r4.z, r0.x
dp3_pp r0.x, r4, r1
mul r1.x, r3, r0.w
max_pp r0.x, r0, c3
mul_pp r0.x, r0, r1
mul_pp r0.x, r0, c3.z
mul r1.xyz, r2, c0
mul r0.xyz, r1, r0.x
mov_pp r0.w, r2
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
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 19 ALU, 3 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.w, fragment.texcoord[2], texture[2], 2D;
MUL R1, R0, c[1];
SLT R0.x, R1.w, c[2];
MOV result.color.w, R1;
TEX R0.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
KIL -R0.x;
MAD R0.xy, R0.wyzw, c[3].x, -c[3].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[3].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R0.x, R0, fragment.texcoord[1];
MAX R0.x, R0, c[3].z;
MUL R0.x, R0, R2.w;
MUL R0.w, R0.x, c[3].x;
MUL R0.xyz, R1, c[0];
MUL result.color.xyz, R0, R0.w;
END
# 19 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"ps_2_0
; 22 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
dcl t0
dcl t1.xyz
dcl t2.xy
texld r0, t0, s0
mul r1, r0, c1
add r0.x, r1.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r0, -r0.x
mov r2.y, t0.w
mov r2.x, t0.z
mul r1.xyz, r1, c0
texld r2, r2, s1
texkill r0.xyzw
texld r0, t2, s2
mov r0.y, r2
mov r0.x, r2.w
mad_pp r2.xy, r0, c3.z, c3.w
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c3.y
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r0.x, r2, t1
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
//   opengl - ALU: 22 to 22
//   d3d9 - ALU: 23 to 23
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
Vector 10 [_MainTex_ST]
Vector 11 [_BumpMap_ST]
"!!ARBvp1.0
# 22 ALU
PARAM c[12] = { program.local[0],
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
TEMP R1;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R1.xyz, R0, vertex.attrib[14].w;
DP3 R0.y, R1, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[1].xyz, R0, c[9].w;
DP3 R0.y, R1, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[2].xyz, R0, c[9].w;
DP3 R0.y, R1, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
MUL result.texcoord[3].xyz, R0, c[9].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[11].xyxy, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 22 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [_MainTex_ST]
Vector 10 [_BumpMap_ST]
"vs_2_0
; 23 ALU
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
dp3 r0.y, r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul oT1.xyz, r0, c8.w
dp3 r0.y, r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul oT2.xyz, r0, c8.w
dp3 r0.y, r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul oT3.xyz, r0, c8.w
mad oT0.zw, v3.xyxy, c10.xyxy, c10
mad oT0.xy, v3, c9, c9.zwzw
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
  vec3 tmpvar_54;
  tmpvar_54 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_55;
  tmpvar_55[0].x = tmpvar_3.x;
  tmpvar_55[0].y = tmpvar_54.x;
  tmpvar_55[0].z = tmpvar_5.x;
  tmpvar_55[1].x = tmpvar_3.y;
  tmpvar_55[1].y = tmpvar_54.y;
  tmpvar_55[1].z = tmpvar_5.y;
  tmpvar_55[2].x = tmpvar_3.z;
  tmpvar_55[2].y = tmpvar_54.z;
  tmpvar_55[2].z = tmpvar_5.z;
  mat3 tmpvar_71;
  tmpvar_71[0] = _Object2World[0].xyz;
  tmpvar_71[1] = _Object2World[1].xyz;
  tmpvar_71[2] = _Object2World[2].xyz;
  mat3 tmpvar_81;
  tmpvar_81[0] = _Object2World[0].xyz;
  tmpvar_81[1] = _Object2World[1].xyz;
  tmpvar_81[2] = _Object2World[2].xyz;
  mat3 tmpvar_91;
  tmpvar_91[0] = _Object2World[0].xyz;
  tmpvar_91[1] = _Object2World[1].xyz;
  tmpvar_91[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex.xyzw).xyzw;
  gl_TexCoord[0] = tmpvar_129.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = ((tmpvar_55 * tmpvar_71[0].xyz) * unity_Scale.w).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = ((tmpvar_55 * tmpvar_81[1].xyz) * unity_Scale.w).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = ((tmpvar_55 * tmpvar_91[2].xyz) * unity_Scale.w).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 res;
  vec3 worldN;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_48;
  tmpvar_48 = normal.xyz;
  float x;
  x = ((texture2D (_MainTex, tmpvar_2.xy) * _Color).w - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  worldN.x = dot (tmpvar_4, tmpvar_48);
  worldN.y = (vec2(dot (tmpvar_6, tmpvar_48))).y;
  worldN.z = (vec3(dot (tmpvar_8, tmpvar_48))).z;
  res.xyz = ((worldN * 0.5) + 0.5).xyz;
  res.w = 0.0;
  gl_FragData[0] = res.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 16 to 16, TEX: 2 to 2
//   d3d9 - ALU: 20 to 20, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 16 ALU, 2 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2, 1, 0.5 } };
TEMP R0;
TEMP R1;
TEX R0.w, fragment.texcoord[0], texture[0], 2D;
MUL R0.x, R0.w, c[0].w;
SLT R0.x, R0, c[1];
MOV result.color.w, c[2].x;
TEX R0.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
KIL -R0.x;
MAD R0.xy, R0.wyzw, c[2].y, -c[2].z;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[2];
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R1.z, fragment.texcoord[3], R0;
DP3 R1.x, R0, fragment.texcoord[1];
DP3 R1.y, R0, fragment.texcoord[2];
MAD result.color.xyz, R1, c[2].w, c[2].w;
END
# 16 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"ps_2_0
; 20 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c2, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c3, 0.50000000, 0, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r0, t0, s0
mul r0.x, r0.w, c0.w
add r0.x, r0, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
texld r1, r1, s1
texkill r0.xyzw
mov r0.y, r1
mov r0.x, r1.w
mad_pp r0.xy, r0, c2.z, c2.w
mul_pp r1.x, r0.y, r0.y
mad_pp r1.x, -r0, r0, -r1
add_pp r1.x, r1, c2.y
rsq_pp r1.x, r1.x
rcp_pp r0.z, r1.x
dp3 r1.z, t3, r0
dp3 r1.x, r0, t1
dp3 r1.y, r0, t2
mad_pp r0.xyz, r1, c3.x, c3.x
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
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyzw;
  vec4 light;
  vec2 tmpvar_71;
  vec4 tmpvar_37;
  tmpvar_37 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_38;
  tmpvar_38 = tmpvar_37.xyz;
  float tmpvar_39;
  tmpvar_39 = tmpvar_37.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_71).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  float x;
  x = (tmpvar_39 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 tmpvar_51;
  tmpvar_51 = -(log2 (texture2DProj (_LightBuffer, tmpvar_4)));
  light = tmpvar_51;
  light.xyz = (tmpvar_51.xyz + unity_Ambient.xyz).xyz;
  vec4 c_i0;
  c_i0.xyz = (tmpvar_38 * light.xyz).xyz;
  c_i0.w = (vec4(tmpvar_39)).w;
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
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyzw;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 light;
  vec2 tmpvar_93;
  vec4 tmpvar_43;
  tmpvar_43 = (texture2D (_MainTex, gl_TexCoord[0].xy) * _Color);
  vec3 tmpvar_44;
  tmpvar_44 = tmpvar_43.xyz;
  float tmpvar_45;
  tmpvar_45 = tmpvar_43.w;
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_93).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  float x;
  x = (tmpvar_45 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 tmpvar_57;
  tmpvar_57 = -(log2 (texture2DProj (_LightBuffer, tmpvar_4)));
  light = tmpvar_57;
  light.xyz = (tmpvar_57.xyz + mix ((2.0 * texture2D (unity_LightmapInd, tmpvar_6.xy).xyz), (2.0 * texture2D (unity_Lightmap, tmpvar_6.xy).xyz), vec3(clamp (tmpvar_6.z, 0.0, 1.0)))).xyz;
  vec4 c_i0;
  c_i0.xyz = (tmpvar_44 * light.xyz).xyz;
  c_i0.w = (vec4(tmpvar_45)).w;
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
SetTexture 2 [_LightBuffer] 2D
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
TXP R0.xyz, fragment.texcoord[1], texture[2], 2D;
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
SetTexture 2 [_LightBuffer] 2D
"ps_2_0
; 11 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c3, 0.00000000, 1.00000000, 0, 0
dcl t0.xy
dcl t1
texld r0, t0, s0
mul r1, r0, c0
add r0.x, r1.w, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r2, -r0.x
texldp r0, t1, s2
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
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
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
TEX R1, fragment.texcoord[2], texture[3], 2D;
TXP R3.xyz, fragment.texcoord[1], texture[2], 2D;
MUL R2, R0, c[0];
SLT R0.x, R2.w, c[1];
MUL R1.xyz, R1.w, R1;
MOV result.color.w, R2;
KIL -R0.x;
TEX R0, fragment.texcoord[2], texture[4], 2D;
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
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"ps_2_0
; 17 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c2, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t1
dcl t2.xyz
texld r0, t0, s0
texldp r3, t1, s2
texld r1, t2, s3
mul r2, r0, c0
add r0.x, r2.w, -c1
cmp r0.x, r0, c2, c2.y
mov_pp r0, -r0.x
texkill r0.xyzw
texld r0, t2, s4
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

#LINE 31

}

FallBack "Transparent/Cutout/Diffuse"
}
