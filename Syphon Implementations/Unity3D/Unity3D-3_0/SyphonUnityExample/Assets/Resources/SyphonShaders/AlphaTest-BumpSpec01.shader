Shader "Syphon/Transparent/Cutout/Bumped Specular" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 0)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_MainTex ("Base (RGB) TransGloss (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
}

SubShader {
	Tags {"IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	LOD 400
	
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		AlphaToMask True
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 20 to 80
//   d3d9 - ALU: 21 to 83
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
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
# 44 ALU
PARAM c[25] = { { 1 },
		state.matrix.mvp,
		program.local[5..24] };
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
DP4 R2.z, R0, c[18];
DP4 R2.y, R0, c[17];
DP4 R2.x, R0, c[16];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[21];
DP4 R3.y, R1, c[20];
DP4 R3.x, R1, c[19];
ADD R2.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R3.xyz, R0.x, c[22];
MOV R1.xyz, vertex.attrib[14];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
ADD result.texcoord[3].xyz, R2, R3;
MOV R0.xyz, c[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[13].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[15];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[1].y, R0, R2;
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[24].xyxy, c[24];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[23], c[23].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 44 instructions, 4 R-regs
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
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [_MainTex_ST]
Vector 23 [_BumpMap_ST]
"vs_2_0
; 47 ALU
def c24, 1.00000000, 0, 0, 0
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
mov r0.w, c24.x
dp4 r2.z, r0, c17
dp4 r2.y, r0, c16
dp4 r2.x, r0, c15
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c20
dp4 r3.y, r1, c19
dp4 r3.x, r1, c18
add r1.xyz, r2, r3
mad r0.x, r0, r0, -r0.y
mul r2.xyz, r0.x, c21
add oT3.xyz, r1, r2
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
mov r1.w, c24.x
mov r1.xyz, c13
dp4 r4.y, c14, r0
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c12.w, -v0
mov r1, c8
dp4 r4.x, c14, r1
dp3 oT1.y, r2, r3
dp3 oT2.y, r3, r4
dp3 oT1.z, v2, r2
dp3 oT1.x, r2, v1
dp3 oT2.z, v2, r4
dp3 oT2.x, v1, r4
mad oT0.zw, v3.xyxy, c23.xyxy, c23
mad oT0.xy, v3, c22, c22.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
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
  vec4 tmpvar_143;
  tmpvar_143.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_143.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  mat3 tmpvar_63;
  tmpvar_63[0] = _Object2World[0].xyz;
  tmpvar_63[1] = _Object2World[1].xyz;
  tmpvar_63[2] = _Object2World[2].xyz;
  vec3 tmpvar_69;
  tmpvar_69 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_70;
  tmpvar_70[0].x = tmpvar_3.x;
  tmpvar_70[0].y = tmpvar_69.x;
  tmpvar_70[0].z = tmpvar_5.x;
  tmpvar_70[1].x = tmpvar_3.y;
  tmpvar_70[1].y = tmpvar_69.y;
  tmpvar_70[1].z = tmpvar_5.y;
  tmpvar_70[2].x = tmpvar_3.z;
  tmpvar_70[2].y = tmpvar_69.z;
  tmpvar_70[2].z = tmpvar_5.z;
  vec4 tmpvar_87;
  tmpvar_87.xyz = _WorldSpaceCameraPos.xyz;
  tmpvar_87.w = 1.0;
  vec4 tmpvar_90;
  tmpvar_90.xyz = (tmpvar_63 * (tmpvar_5 * unity_Scale.w)).xyz;
  tmpvar_90.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_90);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_90))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_90))).z;
  vec4 tmpvar_99;
  tmpvar_99 = (tmpvar_90.xyzz * tmpvar_90.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_99);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_99))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_99))).z;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_143.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_70 * (((_World2Object * tmpvar_87).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_70 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_90.x * tmpvar_90.x) - (tmpvar_90.y * tmpvar_90.y)))).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 c;
  vec4 tmpvar_54;
  tmpvar_54 = texture2D (_MainTex, tmpvar_2.xy);
  vec3 tmpvar_56;
  tmpvar_56 = (tmpvar_54.xyz * _Color.xyz);
  float tmpvar_57;
  tmpvar_57 = tmpvar_54.w;
  float tmpvar_58;
  tmpvar_58 = (tmpvar_54.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_66;
  tmpvar_66 = normal.xyz;
  float x;
  x = (tmpvar_58 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0;
  float tmpvar_81;
  tmpvar_81 = (pow (max (0.0, dot (tmpvar_66, normalize ((tmpvar_6 + normalize (tmpvar_4.xyz))))), (_Shininess * 128.0)) * tmpvar_57);
  c_i0.xyz = ((((tmpvar_56 * _LightColor0.xyz) * max (0.0, dot (tmpvar_66, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_81)) * 2.0).xyz;
  c_i0.w = (vec4((tmpvar_58 + ((_LightColor0.w * _SpecColor.w) * tmpvar_81)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_56 * tmpvar_8)).xyz;
  c.w = (vec4(tmpvar_58)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
Vector 17 [_BumpMap_ST]
"!!ARBvp1.0
# 20 ALU
PARAM c[18] = { { 1 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[13].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[17].xyxy, c[17];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
Vector 16 [_BumpMap_ST]
"vs_2_0
; 21 ALU
def c17, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
mov r0.xyz, c13
mov r0.w, c17.x
dp4 r2.z, r0, c10
dp4 r2.x, r0, c8
dp4 r2.y, r0, c9
mad r0.xyz, r2, c12.w, -v0
dp3 oT1.y, r0, r1
dp3 oT1.z, v2, r0
dp3 oT1.x, r0, v1
mad oT0.zw, v3.xyxy, c16.xyxy, c16
mad oT0.xy, v3, c15, c15.zwzw
mad oT2.xy, v4, c14, c14.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
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
  vec4 tmpvar_96;
  tmpvar_96.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_96.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_50;
  tmpvar_50 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_51;
  tmpvar_51[0].x = tmpvar_3.x;
  tmpvar_51[0].y = tmpvar_50.x;
  tmpvar_51[0].z = tmpvar_5.x;
  tmpvar_51[1].x = tmpvar_3.y;
  tmpvar_51[1].y = tmpvar_50.y;
  tmpvar_51[1].z = tmpvar_5.y;
  tmpvar_51[2].x = tmpvar_3.z;
  tmpvar_51[2].y = tmpvar_50.z;
  tmpvar_51[2].z = tmpvar_5.z;
  vec4 tmpvar_64;
  tmpvar_64.xyz = _WorldSpaceCameraPos.xyz;
  tmpvar_64.w = 1.0;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_96.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_51 * (((_World2Object * tmpvar_64).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xy = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw).xy;
  tmpvar_21.z = 0.0;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec2 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xy;
  vec4 c;
  vec4 tmpvar_40;
  tmpvar_40 = texture2D (_MainTex, tmpvar_2.xy);
  vec3 tmpvar_42;
  tmpvar_42 = (tmpvar_40.xyz * _Color.xyz);
  float tmpvar_44;
  tmpvar_44 = (tmpvar_40.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  float x;
  x = (tmpvar_44 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  c.xyz = (tmpvar_42 * (2.0 * texture2D (unity_Lightmap, tmpvar_6).xyz)).xyz;
  c.w = (vec4(tmpvar_44)).w;
  c.w = (vec4(tmpvar_44)).w;
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
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [_MainTex_ST]
Vector 25 [_BumpMap_ST]
"!!ARBvp1.0
# 49 ALU
PARAM c[26] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..25] };
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
DP4 R2.z, R0, c[19];
DP4 R2.y, R0, c[18];
DP4 R2.x, R0, c[17];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[22];
DP4 R3.y, R1, c[21];
DP4 R3.x, R1, c[20];
ADD R2.xyz, R2, R3;
MAD R0.x, R0, R0, -R0.y;
MUL R3.xyz, R0.x, c[23];
MOV R1.xyz, vertex.attrib[14];
MUL R0.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R1.zxyw, -R0;
ADD result.texcoord[3].xyz, R2, R3;
MOV R0.w, c[0].x;
MOV R0.xyz, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[14].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[16];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[1].y, R0, R2;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[25].xyxy, c[25];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[24], c[24].zwzw;
END
# 49 instructions, 4 R-regs
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
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [_MainTex_ST]
Vector 25 [_BumpMap_ST]
"vs_2_0
; 52 ALU
def c26, 1.00000000, 0.50000000, 0, 0
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
mov r0.w, c26.x
dp4 r2.z, r0, c19
dp4 r2.y, r0, c18
dp4 r2.x, r0, c17
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c22
dp4 r3.y, r1, c21
dp4 r3.x, r1, c20
add r1.xyz, r2, r3
mad r0.x, r0, r0, -r0.y
mul r2.xyz, r0.x, c23
add oT3.xyz, r1, r2
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1.w, c26.x
mov r1.xyz, c15
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
mov r1, c8
dp4 r4.x, c16, r1
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c26.y
mul r1.y, r1, c12.x
dp3 oT1.y, r2, r3
dp3 oT2.y, r3, r4
dp3 oT1.z, v2, r2
dp3 oT1.x, r2, v1
dp3 oT2.z, v2, r4
dp3 oT2.x, v1, r4
mad oT4.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov oT4.zw, r0
mad oT0.zw, v3.xyxy, c25.xyxy, c25
mad oT0.xy, v3, c24, c24.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
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
  vec4 tmpvar_161;
  vec4 tmpvar_62;
  tmpvar_62 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  tmpvar_161.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_161.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  mat3 tmpvar_70;
  tmpvar_70[0] = _Object2World[0].xyz;
  tmpvar_70[1] = _Object2World[1].xyz;
  tmpvar_70[2] = _Object2World[2].xyz;
  vec3 tmpvar_76;
  tmpvar_76 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_77;
  tmpvar_77[0].x = tmpvar_3.x;
  tmpvar_77[0].y = tmpvar_76.x;
  tmpvar_77[0].z = tmpvar_5.x;
  tmpvar_77[1].x = tmpvar_3.y;
  tmpvar_77[1].y = tmpvar_76.y;
  tmpvar_77[1].z = tmpvar_5.y;
  tmpvar_77[2].x = tmpvar_3.z;
  tmpvar_77[2].y = tmpvar_76.z;
  tmpvar_77[2].z = tmpvar_5.z;
  vec4 tmpvar_94;
  tmpvar_94.xyz = _WorldSpaceCameraPos.xyz;
  tmpvar_94.w = 1.0;
  vec4 tmpvar_97;
  tmpvar_97.xyz = (tmpvar_70 * (tmpvar_5 * unity_Scale.w)).xyz;
  tmpvar_97.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_97);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_97))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_97))).z;
  vec4 tmpvar_106;
  tmpvar_106 = (tmpvar_97.xyzz * tmpvar_97.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_106);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_106))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_106))).z;
  vec4 o_i0;
  vec4 tmpvar_119;
  tmpvar_119 = (tmpvar_62 * 0.5);
  o_i0 = tmpvar_119;
  vec2 tmpvar_120;
  tmpvar_120.x = tmpvar_119.x;
  tmpvar_120.y = (vec2((tmpvar_119.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_120 + tmpvar_119.w);
  o_i0.zw = tmpvar_62.zw;
  gl_Position = tmpvar_62.xyzw;
  gl_TexCoord[0] = tmpvar_161.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_77 * (((_World2Object * tmpvar_94).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_77 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_97.x * tmpvar_97.x) - (tmpvar_97.y * tmpvar_97.y)))).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
  gl_TexCoord[4] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 tmpvar_10;
  tmpvar_10 = gl_TexCoord[4].xyzw;
  vec4 c;
  vec4 tmpvar_58;
  tmpvar_58 = texture2D (_MainTex, tmpvar_2.xy);
  vec3 tmpvar_60;
  tmpvar_60 = (tmpvar_58.xyz * _Color.xyz);
  float tmpvar_61;
  tmpvar_61 = tmpvar_58.w;
  float tmpvar_62;
  tmpvar_62 = (tmpvar_58.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_70;
  tmpvar_70 = normal.xyz;
  float x;
  x = (tmpvar_62 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  float tmpvar_75;
  tmpvar_75 = texture2DProj (_ShadowMapTexture, tmpvar_10).x;
  vec4 c_i0;
  float tmpvar_90;
  tmpvar_90 = (pow (max (0.0, dot (tmpvar_70, normalize ((tmpvar_6 + normalize (tmpvar_4.xyz))))), (_Shininess * 128.0)) * tmpvar_61);
  c_i0.xyz = ((((tmpvar_60 * _LightColor0.xyz) * max (0.0, dot (tmpvar_70, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_90)) * (tmpvar_75 * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_62 + (((_LightColor0.w * _SpecColor.w) * tmpvar_90) * tmpvar_75)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_60 * tmpvar_8)).xyz;
  c.w = (vec4(tmpvar_62)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_BumpMap_ST]
"!!ARBvp1.0
# 25 ALU
PARAM c[19] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R0.xyz, R0, vertex.attrib[14].w;
MOV R1.xyz, c[15];
MOV R1.w, c[0].x;
DP4 R0.w, vertex.position, c[4];
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[14].w, -vertex.position;
DP3 result.texcoord[1].y, R2, R0;
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
DP3 result.texcoord[1].z, vertex.normal, R2;
DP3 result.texcoord[1].x, R2, vertex.attrib[14];
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[16], c[16].zwzw;
END
# 25 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
Vector 18 [_BumpMap_ST]
"vs_2_0
; 26 ALU
def c19, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r0.xyz, r0, v1.w
mov r1.xyz, c15
mov r1.w, c19.x
dp4 r0.w, v0, c3
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
dp3 oT1.y, r2, r0
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c19.y
mul r1.y, r1, c12.x
dp3 oT1.z, v2, r2
dp3 oT1.x, r2, v1
mad oT4.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov oT4.zw, r0
mad oT0.zw, v3.xyxy, c18.xyxy, c18
mad oT0.xy, v3, c17, c17.zwzw
mad oT2.xy, v4, c16, c16.zwzw
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES

#ifdef VERTEX
attribute vec4 TANGENT;
uniform vec4 unity_Scale;
uniform vec4 unity_LightmapST;
uniform vec3 _WorldSpaceCameraPos;
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
  vec4 tmpvar_114;
  vec4 tmpvar_42;
  tmpvar_42 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  tmpvar_114.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_114.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_57;
  tmpvar_57 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_58;
  tmpvar_58[0].x = tmpvar_3.x;
  tmpvar_58[0].y = tmpvar_57.x;
  tmpvar_58[0].z = tmpvar_5.x;
  tmpvar_58[1].x = tmpvar_3.y;
  tmpvar_58[1].y = tmpvar_57.y;
  tmpvar_58[1].z = tmpvar_5.y;
  tmpvar_58[2].x = tmpvar_3.z;
  tmpvar_58[2].y = tmpvar_57.z;
  tmpvar_58[2].z = tmpvar_5.z;
  vec4 tmpvar_71;
  tmpvar_71.xyz = _WorldSpaceCameraPos.xyz;
  tmpvar_71.w = 1.0;
  vec4 o_i0;
  vec4 tmpvar_76;
  tmpvar_76 = (tmpvar_42 * 0.5);
  o_i0 = tmpvar_76;
  vec2 tmpvar_77;
  tmpvar_77.x = tmpvar_76.x;
  tmpvar_77.y = (vec2((tmpvar_76.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_77 + tmpvar_76.w);
  o_i0.zw = tmpvar_42.zw;
  gl_Position = tmpvar_42.xyzw;
  gl_TexCoord[0] = tmpvar_114.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_58 * (((_World2Object * tmpvar_71).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xy = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw).xy;
  tmpvar_21.z = 0.0;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  gl_TexCoord[4] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform float _Cutoff;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec2 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xy;
  vec4 tmpvar_8;
  tmpvar_8 = gl_TexCoord[4].xyzw;
  vec4 c;
  vec4 tmpvar_44;
  tmpvar_44 = texture2D (_MainTex, tmpvar_2.xy);
  vec3 tmpvar_46;
  tmpvar_46 = (tmpvar_44.xyz * _Color.xyz);
  float tmpvar_48;
  tmpvar_48 = (tmpvar_44.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  float x;
  x = (tmpvar_48 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  c.xyz = (tmpvar_46 * min ((2.0 * texture2D (unity_Lightmap, tmpvar_6).xyz), vec3((texture2DProj (_ShadowMapTexture, tmpvar_8).x * 2.0)))).xyz;
  c.w = (vec4(tmpvar_48)).w;
  c.w = (vec4(tmpvar_48)).w;
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
Vector 14 [_WorldSpaceCameraPos]
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
# 75 ALU
PARAM c[33] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..32] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[13].w;
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
MOV R0.w, c[0].x;
DP4 R2.z, R4, c[26];
DP4 R2.y, R4, c[25];
DP4 R2.x, R4, c[24];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[30];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
ADD result.texcoord[3].xyz, R3, R1;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R0.xyz, c[14];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[13].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[15];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[1].y, R0, R2;
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[32].xyxy, c[32];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[31], c[31].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 75 instructions, 5 R-regs
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
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
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
"vs_2_0
; 78 ALU
def c32, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c12.w
dp4 r0.x, v0, c5
add r1, -r0.x, c16
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c15
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c32.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c17
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c18
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c32.x
dp4 r2.z, r4, c25
dp4 r2.y, r4, c24
dp4 r2.x, r4, c23
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c32.y
mul r0, r0, r1
mul r1.xyz, r0.y, c20
mad r1.xyz, r0.x, c19, r1
mad r0.xyz, r0.z, c21, r1
mad r1.xyz, r0.w, c22, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c28
dp4 r3.y, r0, c27
dp4 r3.x, r0, c26
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c29
add r2.xyz, r2, r3
add r2.xyz, r2, r0
add oT3.xyz, r2, r1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
mov r1.w, c32.x
mov r1.xyz, c13
dp4 r4.y, c14, r0
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c12.w, -v0
mov r1, c8
dp4 r4.x, c14, r1
dp3 oT1.y, r2, r3
dp3 oT2.y, r3, r4
dp3 oT1.z, v2, r2
dp3 oT1.x, r2, v1
dp3 oT2.z, v2, r4
dp3 oT2.x, v1, r4
mad oT0.zw, v3.xyxy, c31.xyxy, c31
mad oT0.xy, v3, c30, c30.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
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
  vec4 tmpvar_192;
  tmpvar_192.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_192.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  mat3 tmpvar_86;
  tmpvar_86[0] = _Object2World[0].xyz;
  tmpvar_86[1] = _Object2World[1].xyz;
  tmpvar_86[2] = _Object2World[2].xyz;
  vec3 tmpvar_90;
  tmpvar_90 = (tmpvar_86 * (tmpvar_5 * unity_Scale.w));
  vec3 tmpvar_92;
  tmpvar_92 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_93;
  tmpvar_93[0].x = tmpvar_3.x;
  tmpvar_93[0].y = tmpvar_92.x;
  tmpvar_93[0].z = tmpvar_5.x;
  tmpvar_93[1].x = tmpvar_3.y;
  tmpvar_93[1].y = tmpvar_92.y;
  tmpvar_93[1].z = tmpvar_5.y;
  tmpvar_93[2].x = tmpvar_3.z;
  tmpvar_93[2].y = tmpvar_92.z;
  tmpvar_93[2].z = tmpvar_5.z;
  vec4 tmpvar_110;
  tmpvar_110.xyz = _WorldSpaceCameraPos.xyz;
  tmpvar_110.w = 1.0;
  vec4 tmpvar_113;
  tmpvar_113.xyz = tmpvar_90.xyz;
  tmpvar_113.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_113);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_113))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_113))).z;
  vec4 tmpvar_122;
  tmpvar_122 = (tmpvar_113.xyzz * tmpvar_113.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_122);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_122))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_122))).z;
  vec3 tmpvar_133;
  tmpvar_133 = (_Object2World * tmpvar_1).xyz;
  vec4 tmpvar_136;
  tmpvar_136 = (unity_4LightPosX0 - tmpvar_133.x);
  vec4 tmpvar_137;
  tmpvar_137 = (unity_4LightPosY0 - tmpvar_133.y);
  vec4 tmpvar_138;
  tmpvar_138 = (unity_4LightPosZ0 - tmpvar_133.z);
  vec4 tmpvar_142;
  tmpvar_142 = (((tmpvar_136 * tmpvar_136) + (tmpvar_137 * tmpvar_137)) + (tmpvar_138 * tmpvar_138));
  vec4 tmpvar_152;
  tmpvar_152 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_136 * tmpvar_90.x) + (tmpvar_137 * tmpvar_90.y)) + (tmpvar_138 * tmpvar_90.z)) * inversesqrt (tmpvar_142))) * 1.0/((1.0 + (tmpvar_142 * unity_4LightAtten0))));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_192.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_93 * (((_World2Object * tmpvar_110).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_93 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_113.x * tmpvar_113.x) - (tmpvar_113.y * tmpvar_113.y)))) + ((((unity_LightColor0 * tmpvar_152.x) + (unity_LightColor1 * tmpvar_152.y)) + (unity_LightColor2 * tmpvar_152.z)) + (unity_LightColor3 * tmpvar_152.w))).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 c;
  vec4 tmpvar_54;
  tmpvar_54 = texture2D (_MainTex, tmpvar_2.xy);
  vec3 tmpvar_56;
  tmpvar_56 = (tmpvar_54.xyz * _Color.xyz);
  float tmpvar_57;
  tmpvar_57 = tmpvar_54.w;
  float tmpvar_58;
  tmpvar_58 = (tmpvar_54.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_66;
  tmpvar_66 = normal.xyz;
  float x;
  x = (tmpvar_58 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0;
  float tmpvar_81;
  tmpvar_81 = (pow (max (0.0, dot (tmpvar_66, normalize ((tmpvar_6 + normalize (tmpvar_4.xyz))))), (_Shininess * 128.0)) * tmpvar_57);
  c_i0.xyz = ((((tmpvar_56 * _LightColor0.xyz) * max (0.0, dot (tmpvar_66, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_81)) * 2.0).xyz;
  c_i0.w = (vec4((tmpvar_58 + ((_LightColor0.w * _SpecColor.w) * tmpvar_81)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_56 * tmpvar_8)).xyz;
  c.w = (vec4(tmpvar_58)).w;
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
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 17 [unity_4LightPosX0]
Vector 18 [unity_4LightPosY0]
Vector 19 [unity_4LightPosZ0]
Vector 20 [unity_4LightAtten0]
Vector 21 [unity_LightColor0]
Vector 22 [unity_LightColor1]
Vector 23 [unity_LightColor2]
Vector 24 [unity_LightColor3]
Vector 25 [unity_SHAr]
Vector 26 [unity_SHAg]
Vector 27 [unity_SHAb]
Vector 28 [unity_SHBr]
Vector 29 [unity_SHBg]
Vector 30 [unity_SHBb]
Vector 31 [unity_SHC]
Vector 32 [_MainTex_ST]
Vector 33 [_BumpMap_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[34] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..33] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[14].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[18];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[17];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[19];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[20];
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
MUL R1.xyz, R0.y, c[22];
MAD R1.xyz, R0.x, c[21], R1;
MAD R0.xyz, R0.z, c[23], R1;
MAD R1.xyz, R0.w, c[24], R0;
MUL R0, R4.xyzz, R4.yzzx;
DP4 R3.z, R0, c[30];
DP4 R3.y, R0, c[29];
DP4 R3.x, R0, c[28];
MUL R1.w, R3, R3;
MOV R0.w, c[0].x;
MAD R0.x, R4, R4, -R1.w;
DP4 R2.z, R4, c[27];
DP4 R2.y, R4, c[26];
DP4 R2.x, R4, c[25];
ADD R2.xyz, R2, R3;
MUL R3.xyz, R0.x, c[31];
ADD R3.xyz, R2, R3;
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
ADD result.texcoord[3].xyz, R3, R1;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R0.xyz, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[14].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[16];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[1].y, R0, R2;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].z;
MUL R1.y, R1, c[13].x;
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[33].xyxy, c[33];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[32], c[32].zwzw;
END
# 80 instructions, 5 R-regs
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
Vector 15 [_WorldSpaceCameraPos]
Vector 16 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 17 [unity_4LightPosX0]
Vector 18 [unity_4LightPosY0]
Vector 19 [unity_4LightPosZ0]
Vector 20 [unity_4LightAtten0]
Vector 21 [unity_LightColor0]
Vector 22 [unity_LightColor1]
Vector 23 [unity_LightColor2]
Vector 24 [unity_LightColor3]
Vector 25 [unity_SHAr]
Vector 26 [unity_SHAg]
Vector 27 [unity_SHAb]
Vector 28 [unity_SHBr]
Vector 29 [unity_SHBg]
Vector 30 [unity_SHBb]
Vector 31 [unity_SHC]
Vector 32 [_MainTex_ST]
Vector 33 [_BumpMap_ST]
"vs_2_0
; 83 ALU
def c34, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c14.w
dp4 r0.x, v0, c5
add r1, -r0.x, c18
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c17
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c34.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c19
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c20
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c34.x
dp4 r2.z, r4, c27
dp4 r2.y, r4, c26
dp4 r2.x, r4, c25
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c34.y
mul r0, r0, r1
mul r1.xyz, r0.y, c22
mad r1.xyz, r0.x, c21, r1
mad r0.xyz, r0.z, c23, r1
mad r1.xyz, r0.w, c24, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c30
dp4 r3.y, r0, c29
dp4 r3.x, r0, c28
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c31
add r2.xyz, r2, r3
add r2.xyz, r2, r0
add oT3.xyz, r2, r1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c16, r0
mov r0, c9
dp4 r4.y, c16, r0
mov r1.w, c34.x
mov r1.xyz, c15
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
mov r1, c8
dp4 r4.x, c16, r1
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c34.z
mul r1.y, r1, c12.x
dp3 oT1.y, r2, r3
dp3 oT2.y, r3, r4
dp3 oT1.z, v2, r2
dp3 oT1.x, r2, v1
dp3 oT2.z, v2, r4
dp3 oT2.x, v1, r4
mad oT4.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov oT4.zw, r0
mad oT0.zw, v3.xyxy, c33.xyxy, c33
mad oT0.xy, v3, c32, c32.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
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
  vec4 tmpvar_210;
  vec4 tmpvar_85;
  tmpvar_85 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  tmpvar_210.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_210.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  mat3 tmpvar_93;
  tmpvar_93[0] = _Object2World[0].xyz;
  tmpvar_93[1] = _Object2World[1].xyz;
  tmpvar_93[2] = _Object2World[2].xyz;
  vec3 tmpvar_97;
  tmpvar_97 = (tmpvar_93 * (tmpvar_5 * unity_Scale.w));
  vec3 tmpvar_99;
  tmpvar_99 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_100;
  tmpvar_100[0].x = tmpvar_3.x;
  tmpvar_100[0].y = tmpvar_99.x;
  tmpvar_100[0].z = tmpvar_5.x;
  tmpvar_100[1].x = tmpvar_3.y;
  tmpvar_100[1].y = tmpvar_99.y;
  tmpvar_100[1].z = tmpvar_5.y;
  tmpvar_100[2].x = tmpvar_3.z;
  tmpvar_100[2].y = tmpvar_99.z;
  tmpvar_100[2].z = tmpvar_5.z;
  vec4 tmpvar_117;
  tmpvar_117.xyz = _WorldSpaceCameraPos.xyz;
  tmpvar_117.w = 1.0;
  vec4 tmpvar_120;
  tmpvar_120.xyz = tmpvar_97.xyz;
  tmpvar_120.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_120);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_120))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_120))).z;
  vec4 tmpvar_129;
  tmpvar_129 = (tmpvar_120.xyzz * tmpvar_120.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_129);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_129))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_129))).z;
  vec3 tmpvar_140;
  tmpvar_140 = (_Object2World * tmpvar_1).xyz;
  vec4 tmpvar_143;
  tmpvar_143 = (unity_4LightPosX0 - tmpvar_140.x);
  vec4 tmpvar_144;
  tmpvar_144 = (unity_4LightPosY0 - tmpvar_140.y);
  vec4 tmpvar_145;
  tmpvar_145 = (unity_4LightPosZ0 - tmpvar_140.z);
  vec4 tmpvar_149;
  tmpvar_149 = (((tmpvar_143 * tmpvar_143) + (tmpvar_144 * tmpvar_144)) + (tmpvar_145 * tmpvar_145));
  vec4 tmpvar_159;
  tmpvar_159 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_143 * tmpvar_97.x) + (tmpvar_144 * tmpvar_97.y)) + (tmpvar_145 * tmpvar_97.z)) * inversesqrt (tmpvar_149))) * 1.0/((1.0 + (tmpvar_149 * unity_4LightAtten0))));
  vec4 o_i0;
  vec4 tmpvar_168;
  tmpvar_168 = (tmpvar_85 * 0.5);
  o_i0 = tmpvar_168;
  vec2 tmpvar_169;
  tmpvar_169.x = tmpvar_168.x;
  tmpvar_169.y = (vec2((tmpvar_168.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_169 + tmpvar_168.w);
  o_i0.zw = tmpvar_85.zw;
  gl_Position = tmpvar_85.xyzw;
  gl_TexCoord[0] = tmpvar_210.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_100 * (((_World2Object * tmpvar_117).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_100 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_120.x * tmpvar_120.x) - (tmpvar_120.y * tmpvar_120.y)))) + ((((unity_LightColor0 * tmpvar_159.x) + (unity_LightColor1 * tmpvar_159.y)) + (unity_LightColor2 * tmpvar_159.z)) + (unity_LightColor3 * tmpvar_159.w))).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
  gl_TexCoord[4] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 tmpvar_10;
  tmpvar_10 = gl_TexCoord[4].xyzw;
  vec4 c;
  vec4 tmpvar_58;
  tmpvar_58 = texture2D (_MainTex, tmpvar_2.xy);
  vec3 tmpvar_60;
  tmpvar_60 = (tmpvar_58.xyz * _Color.xyz);
  float tmpvar_61;
  tmpvar_61 = tmpvar_58.w;
  float tmpvar_62;
  tmpvar_62 = (tmpvar_58.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_70;
  tmpvar_70 = normal.xyz;
  float x;
  x = (tmpvar_62 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  float tmpvar_75;
  tmpvar_75 = texture2DProj (_ShadowMapTexture, tmpvar_10).x;
  vec4 c_i0;
  float tmpvar_90;
  tmpvar_90 = (pow (max (0.0, dot (tmpvar_70, normalize ((tmpvar_6 + normalize (tmpvar_4.xyz))))), (_Shininess * 128.0)) * tmpvar_61);
  c_i0.xyz = ((((tmpvar_60 * _LightColor0.xyz) * max (0.0, dot (tmpvar_70, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_90)) * (tmpvar_75 * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_62 + (((_LightColor0.w * _SpecColor.w) * tmpvar_90) * tmpvar_75)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_60 * tmpvar_8)).xyz;
  c.w = (vec4(tmpvar_62)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 4
//   opengl - ALU: 10 to 38, TEX: 2 to 3
//   d3d9 - ALU: 10 to 43, TEX: 3 to 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 36 ALU, 2 TEX
PARAM c[6] = { program.local[0..4],
		{ 2, 1, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.w, R0, c[2];
SLT R1.x, R2.w, c[4];
MUL R0.xyz, R0, c[2];
MOV R2.xyz, fragment.texcoord[2];
MOV result.color.w, R2;
KIL -R1.x;
MAD R1.xy, R1.wyzw, c[5].x, -c[5].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
DP3 R1.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.w, R1.w;
MAD R2.xyz, R1.w, fragment.texcoord[1], R2;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
ADD R1.z, R1, c[5].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R2.x, R1, R2;
MOV R1.w, c[5];
MUL R2.y, R1.w, c[3].x;
MAX R1.w, R2.x, c[5].z;
POW R1.w, R1.w, R2.y;
MOV R2.xyz, c[1];
MUL R0.w, R0, R1;
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R0.w;
DP3 R0.w, R1, fragment.texcoord[2];
MUL R1.xyz, R0, c[0];
MAX R0.w, R0, c[5].z;
MAD R1.xyz, R1, R0.w, R2;
MUL R0.xyz, R0, fragment.texcoord[3];
MUL R1.xyz, R1, c[5].x;
ADD result.color.xyz, R1, R0;
END
# 36 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"ps_2_0
; 43 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c5, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c6, 128.00000000, 0, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r3, t0, s0
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
cmp r1.x, r1, c5, c5.y
mov r2.y, t0.w
mov r2.x, t0.z
mov r4.xy, r2
mov_pp r2, -r1.x
mul r3.xyz, r3, c2
texld r1, r4, s1
texkill r2.xyzw
mov r1.x, r1.w
mad_pp r5.xy, r1, c5.z, c5.w
mul_pp r1.x, r5.y, r5.y
dp3_pp r2.x, t1, t1
mad_pp r1.x, -r5, r5, -r1
rsq_pp r2.x, r2.x
mov_pp r4.xyz, t2
mad_pp r4.xyz, r2.x, t1, r4
add_pp r2.x, r1, c5.y
dp3_pp r1.x, r4, r4
rsq_pp r2.x, r2.x
rcp_pp r5.z, r2.x
rsq_pp r1.x, r1.x
mul_pp r2.xyz, r1.x, r4
dp3_pp r2.x, r5, r2
mov_pp r1.x, c3
mul_pp r1.x, c6, r1
max_pp r2.x, r2, c5
pow r4, r2.x, r1.x
mov r1.x, r4
mov r2.xyz, c0
mul r1.x, r3.w, r1
mul r2.xyz, c1, r2
mul r2.xyz, r2, r1.x
dp3_pp r1.x, r5, t2
max_pp r1.x, r1, c5
mul r4.xyz, r3, c0
mad r1.xyz, r4, r1.x, r2
mul r2.xyz, r3, t3
mul r1.xyz, r1, c5.z
add_pp r1.xyz, r1, r2
mov_pp r1.w, r0.x
mov_pp oC0, r1
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
# 10 ALU, 2 TEX
PARAM c[3] = { program.local[0..1],
		{ 8 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0.w, R0, c[0];
SLT R1.x, R0.w, c[1];
MUL R0.xyz, R0, c[0];
MOV result.color.w, R0;
KIL -R1.x;
TEX R1, fragment.texcoord[2], texture[2], 2D;
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R1, R0;
MUL result.color.xyz, R0, c[2].x;
END
# 10 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
Float 1 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 10 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c2, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t2.xy
texld r3, t0, s0
mul r0.x, r3.w, c0.w
add r1.x, r0, -c1
cmp r1.x, r1, c2, c2.y
mov_pp r2, -r1.x
texld r1, t2, s2
texkill r2.xyzw
mul_pp r1.xyz, r1.w, r1
mul r2.xyz, r3, c0
mul_pp r1.xyz, r1, r2
mul_pp r1.xyz, r1, c2.z
mov_pp r1.w, r0.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_ShadowMapTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 38 ALU, 3 TEX
PARAM c[6] = { program.local[0..4],
		{ 2, 1, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R3.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TXP R3.x, fragment.texcoord[4], texture[2], 2D;
MUL R1.w, R0, c[2];
SLT R1.x, R1.w, c[4];
DP3 R2.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R2.w, R2.w;
MOV R2.xyz, fragment.texcoord[2];
MAD R2.xyz, R2.w, fragment.texcoord[1], R2;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
MOV R2.w, c[5];
MUL R0.xyz, R0, c[2];
MOV result.color.w, R1;
KIL -R1.x;
MAD R1.xy, R3.wyzw, c[5].x, -c[5].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[5].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R2.x, R1, R2;
MUL R2.y, R2.w, c[3].x;
MAX R2.x, R2, c[5].z;
POW R2.w, R2.x, R2.y;
MOV R2.xyz, c[1];
MUL R0.w, R0, R2;
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R0.w;
DP3 R0.w, R1, fragment.texcoord[2];
MUL R1.xyz, R0, c[0];
MAX R0.w, R0, c[5].z;
MAD R1.xyz, R1, R0.w, R2;
MUL R0.w, R3.x, c[5].x;
MUL R0.xyz, R0, fragment.texcoord[3];
MUL R1.xyz, R1, R0.w;
ADD result.color.xyz, R1, R0;
END
# 38 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_ShadowMapTexture] 2D
"ps_2_0
; 43 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c5, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c6, 128.00000000, 0, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4
texld r3, t0, s0
texldp r6, t4, s2
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul r3.xyz, r3, c2
mov_pp r5.xyz, t2
texkill r1.xyzw
texld r1, r2, s1
mov r1.x, r1.w
mad_pp r4.xy, r1, c5.z, c5.w
mul_pp r1.x, r4.y, r4.y
mad_pp r1.x, -r4, r4, -r1
dp3_pp r2.x, t1, t1
rsq_pp r2.x, r2.x
mad_pp r5.xyz, r2.x, t1, r5
dp3_pp r2.x, r5, r5
add_pp r1.x, r1, c5.y
rsq_pp r1.x, r1.x
rcp_pp r4.z, r1.x
rsq_pp r2.x, r2.x
mul_pp r2.xyz, r2.x, r5
dp3_pp r2.x, r4, r2
mov_pp r1.x, c3
mul_pp r1.x, c6, r1
max_pp r2.x, r2, c5
pow r5, r2.x, r1.x
mov r1.x, r5
mul r2.x, r3.w, r1
dp3_pp r1.x, r4, t2
mov r5.xyz, c0
mul r4.xyz, c1, r5
mul r2.xyz, r4, r2.x
mul r4.xyz, r3, c0
max_pp r1.x, r1, c5
mad r2.xyz, r4, r1.x, r2
mul_pp r1.x, r6, c5.z
mul r3.xyz, r3, t3
mul r1.xyz, r2, r1.x
add_pp r1.xyz, r1, r3
mov_pp r1.w, r0.x
mov_pp oC0, r1
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
# 13 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R2.x, fragment.texcoord[4], texture[2], 2D;
MUL R0.w, R0, c[0];
SLT R1.x, R0.w, c[1];
MUL R0.xyz, R0, c[0];
MOV result.color.w, R0;
KIL -R1.x;
TEX R1, fragment.texcoord[2], texture[3], 2D;
MUL R1.xyz, R1.w, R1;
MUL R1.w, R2.x, c[2].y;
MUL R1.xyz, R1, c[2].x;
MIN R1.xyz, R1, R1.w;
MUL result.color.xyz, R0, R1;
END
# 13 instructions, 3 R-regs
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
; 12 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 0.00000000, 1.00000000, 8.00000000, 2.00000000
dcl t0.xy
dcl t2.xy
dcl t4
texld r1, t0, s0
texld r3, t2, s3
mul r0.x, r1.w, c0.w
add r2.x, r0, -c1
cmp r2.x, r2, c2, c2.y
mov_pp r2, -r2.x
mul_pp r3.xyz, r3.w, r3
mul_pp r3.xyz, r3, c2.z
mul r1.xyz, r1, c0
mov_pp r1.w, r0.x
texkill r2.xyzw
texldp r2, t4, s2
mul_pp r2.x, r2, c2.w
min_pp r2.xyz, r3, r2.x
mul_pp r1.xyz, r1, r2
mov_pp oC0, r1
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
//   opengl - ALU: 26 to 35
//   d3d9 - ALU: 29 to 38
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 34 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[19];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[17].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 4 R-regs
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
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_2_0
; 37 ALU
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.w, c21.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp3 oT1.y, r0, r2
dp3 oT1.z, v2, r0
dp3 oT1.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 oT2.y, r2, r3
dp3 oT2.z, v2, r3
dp3 oT2.x, v1, r3
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad oT0.zw, v3.xyxy, c20.xyxy, c20
mad oT0.xy, v3, c19, c19.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
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
  vec4 tmpvar_90;
  tmpvar_90.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_90.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_35;
  tmpvar_35 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_36;
  tmpvar_36[0].x = tmpvar_3.x;
  tmpvar_36[0].y = tmpvar_35.x;
  tmpvar_36[0].z = tmpvar_5.x;
  tmpvar_36[1].x = tmpvar_3.y;
  tmpvar_36[1].y = tmpvar_35.y;
  tmpvar_36[1].z = tmpvar_5.y;
  tmpvar_36[2].x = tmpvar_3.z;
  tmpvar_36[2].y = tmpvar_35.z;
  tmpvar_36[2].z = tmpvar_5.z;
  vec4 tmpvar_53;
  tmpvar_53.xyz = _WorldSpaceCameraPos.xyz;
  tmpvar_53.w = 1.0;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_90.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_36 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_36 * (((_World2Object * tmpvar_53).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 c;
  vec4 tmpvar_53;
  tmpvar_53 = texture2D (_MainTex, tmpvar_2.xy);
  vec3 tmpvar_55;
  tmpvar_55 = (tmpvar_53.xyz * _Color.xyz);
  float tmpvar_56;
  tmpvar_56 = tmpvar_53.w;
  float tmpvar_57;
  tmpvar_57 = (tmpvar_53.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_65;
  tmpvar_65 = normal.xyz;
  float x;
  x = (tmpvar_57 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec3 tmpvar_68;
  tmpvar_68 = normalize (tmpvar_4);
  float atten;
  atten = texture2D (_LightTexture0, vec2(dot (tmpvar_8, tmpvar_8))).w;
  vec4 c_i0;
  float tmpvar_87;
  tmpvar_87 = (pow (max (0.0, dot (tmpvar_65, normalize ((tmpvar_68 + normalize (tmpvar_6.xyz))))), (_Shininess * 128.0)) * tmpvar_56);
  c_i0.xyz = ((((tmpvar_55 * _LightColor0.xyz) * max (0.0, dot (tmpvar_65, tmpvar_68))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_87)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_57 + (((_LightColor0.w * _SpecColor.w) * tmpvar_87) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_57)).w;
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
Vector 9 [unity_Scale]
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 5 [_World2Object]
Vector 12 [_MainTex_ST]
Vector 13 [_BumpMap_ST]
"!!ARBvp1.0
# 26 ALU
PARAM c[14] = { { 1 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[10];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[7];
DP4 R2.y, R1, c[6];
DP4 R2.x, R1, c[5];
MAD R2.xyz, R2, c[9].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[11];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[7];
DP4 R3.y, R0, c[6];
DP4 R3.x, R0, c[5];
DP3 result.texcoord[1].y, R3, R1;
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[1].z, vertex.normal, R3;
DP3 result.texcoord[1].x, R3, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[13].xyxy, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 26 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_World2Object]
Vector 11 [_MainTex_ST]
Vector 12 [_BumpMap_ST]
"vs_2_0
; 29 ALU
def c13, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.w, c13.x
mov r0.xyz, c9
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
mad r3.xyz, r1, c8.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c6
dp4 r4.z, c10, r0
mov r0, c5
mov r1, c4
dp4 r4.y, c10, r0
dp4 r4.x, c10, r1
dp3 oT1.y, r4, r2
dp3 oT2.y, r2, r3
dp3 oT1.z, v2, r4
dp3 oT1.x, r4, v1
dp3 oT2.z, v2, r3
dp3 oT2.x, v1, r3
mad oT0.zw, v3.xyxy, c12.xyxy, c12
mad oT0.xy, v3, c11, c11.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _World2Object;
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
  vec4 tmpvar_83;
  tmpvar_83.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_83.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_33;
  tmpvar_33 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_34;
  tmpvar_34[0].x = tmpvar_3.x;
  tmpvar_34[0].y = tmpvar_33.x;
  tmpvar_34[0].z = tmpvar_5.x;
  tmpvar_34[1].x = tmpvar_3.y;
  tmpvar_34[1].y = tmpvar_33.y;
  tmpvar_34[1].z = tmpvar_5.y;
  tmpvar_34[2].x = tmpvar_3.z;
  tmpvar_34[2].y = tmpvar_33.z;
  tmpvar_34[2].z = tmpvar_5.z;
  vec4 tmpvar_51;
  tmpvar_51.xyz = _WorldSpaceCameraPos.xyz;
  tmpvar_51.w = 1.0;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_83.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_34 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_34 * (((_World2Object * tmpvar_51).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec4 tmpvar_51;
  tmpvar_51 = texture2D (_MainTex, tmpvar_2.xy);
  vec3 tmpvar_53;
  tmpvar_53 = (tmpvar_51.xyz * _Color.xyz);
  float tmpvar_54;
  tmpvar_54 = tmpvar_51.w;
  float tmpvar_55;
  tmpvar_55 = (tmpvar_51.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_63;
  tmpvar_63 = normal.xyz;
  float x;
  x = (tmpvar_55 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0;
  float tmpvar_79;
  tmpvar_79 = (pow (max (0.0, dot (tmpvar_63, normalize ((tmpvar_4 + normalize (tmpvar_6.xyz))))), (_Shininess * 128.0)) * tmpvar_54);
  c_i0.xyz = ((((tmpvar_53 * _LightColor0.xyz) * max (0.0, dot (tmpvar_63, tmpvar_4))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_79)) * 2.0).xyz;
  c_i0.w = (vec4((tmpvar_55 + ((_LightColor0.w * _SpecColor.w) * tmpvar_79)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_55)).w;
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
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 35 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[19];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[17].w, -vertex.position;
DP4 R0.w, vertex.position, c[8];
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].w, R0, c[16];
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 4 R-regs
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
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_2_0
; 38 ALU
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.w, c21.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp4 r0.w, v0, c7
dp3 oT1.y, r0, r2
dp3 oT1.z, v2, r0
dp3 oT1.x, r0, v1
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 oT2.y, r2, r3
dp3 oT2.z, v2, r3
dp3 oT2.x, v1, r3
dp4 oT3.w, r0, c15
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad oT0.zw, v3.xyxy, c20.xyxy, c20
mad oT0.xy, v3, c19, c19.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
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
  vec4 tmpvar_90;
  tmpvar_90.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_90.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_35;
  tmpvar_35 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_36;
  tmpvar_36[0].x = tmpvar_3.x;
  tmpvar_36[0].y = tmpvar_35.x;
  tmpvar_36[0].z = tmpvar_5.x;
  tmpvar_36[1].x = tmpvar_3.y;
  tmpvar_36[1].y = tmpvar_35.y;
  tmpvar_36[1].z = tmpvar_5.y;
  tmpvar_36[2].x = tmpvar_3.z;
  tmpvar_36[2].y = tmpvar_35.z;
  tmpvar_36[2].z = tmpvar_5.z;
  vec4 tmpvar_53;
  tmpvar_53.xyz = _WorldSpaceCameraPos.xyz;
  tmpvar_53.w = 1.0;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_90.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_36 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_36 * (((_World2Object * tmpvar_53).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  gl_TexCoord[3] = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyzw;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyzw;
  vec4 c;
  vec4 tmpvar_60;
  tmpvar_60 = texture2D (_MainTex, tmpvar_2.xy);
  vec3 tmpvar_62;
  tmpvar_62 = (tmpvar_60.xyz * _Color.xyz);
  float tmpvar_63;
  tmpvar_63 = tmpvar_60.w;
  float tmpvar_64;
  tmpvar_64 = (tmpvar_60.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_72;
  tmpvar_72 = normal.xyz;
  float x;
  x = (tmpvar_64 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec3 tmpvar_75;
  tmpvar_75 = normalize (tmpvar_4);
  vec3 LightCoord_i0;
  LightCoord_i0 = tmpvar_8.xyz;
  float atten;
  atten = ((float((tmpvar_8.z > 0.0)) * texture2D (_LightTexture0, ((tmpvar_8.xy / tmpvar_8.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w);
  vec4 c_i0;
  float tmpvar_99;
  tmpvar_99 = (pow (max (0.0, dot (tmpvar_72, normalize ((tmpvar_75 + normalize (tmpvar_6.xyz))))), (_Shininess * 128.0)) * tmpvar_63);
  c_i0.xyz = ((((tmpvar_62 * _LightColor0.xyz) * max (0.0, dot (tmpvar_72, tmpvar_75))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_99)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_64 + (((_LightColor0.w * _SpecColor.w) * tmpvar_99) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_64)).w;
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
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 34 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[19];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[17].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 4 R-regs
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
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_2_0
; 37 ALU
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.w, c21.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp3 oT1.y, r0, r2
dp3 oT1.z, v2, r0
dp3 oT1.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 oT2.y, r2, r3
dp3 oT2.z, v2, r3
dp3 oT2.x, v1, r3
dp4 oT3.z, r0, c14
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad oT0.zw, v3.xyxy, c20.xyxy, c20
mad oT0.xy, v3, c19, c19.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
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
  vec4 tmpvar_90;
  tmpvar_90.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_90.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_35;
  tmpvar_35 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_36;
  tmpvar_36[0].x = tmpvar_3.x;
  tmpvar_36[0].y = tmpvar_35.x;
  tmpvar_36[0].z = tmpvar_5.x;
  tmpvar_36[1].x = tmpvar_3.y;
  tmpvar_36[1].y = tmpvar_35.y;
  tmpvar_36[1].z = tmpvar_5.y;
  tmpvar_36[2].x = tmpvar_3.z;
  tmpvar_36[2].y = tmpvar_35.z;
  tmpvar_36[2].z = tmpvar_5.z;
  vec4 tmpvar_53;
  tmpvar_53.xyz = _WorldSpaceCameraPos.xyz;
  tmpvar_53.w = 1.0;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_90.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_36 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_36 * (((_World2Object * tmpvar_53).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 c;
  vec4 tmpvar_53;
  tmpvar_53 = texture2D (_MainTex, tmpvar_2.xy);
  vec3 tmpvar_55;
  tmpvar_55 = (tmpvar_53.xyz * _Color.xyz);
  float tmpvar_56;
  tmpvar_56 = tmpvar_53.w;
  float tmpvar_57;
  tmpvar_57 = (tmpvar_53.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_65;
  tmpvar_65 = normal.xyz;
  float x;
  x = (tmpvar_57 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec3 tmpvar_68;
  tmpvar_68 = normalize (tmpvar_4);
  float atten;
  atten = (texture2D (_LightTextureB0, vec2(dot (tmpvar_8, tmpvar_8))).w * textureCube (_LightTexture0, tmpvar_8).w);
  vec4 c_i0;
  float tmpvar_88;
  tmpvar_88 = (pow (max (0.0, dot (tmpvar_65, normalize ((tmpvar_68 + normalize (tmpvar_6.xyz))))), (_Shininess * 128.0)) * tmpvar_56);
  c_i0.xyz = ((((tmpvar_55 * _LightColor0.xyz) * max (0.0, dot (tmpvar_65, tmpvar_68))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_88)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_57 + (((_LightColor0.w * _SpecColor.w) * tmpvar_88) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_57)).w;
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
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
Vector 21 [_BumpMap_ST]
"!!ARBvp1.0
# 32 ALU
PARAM c[22] = { { 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[19];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.y, R0, c[10];
DP4 R3.x, R0, c[9];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[1].y, R3, R1;
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[1].z, vertex.normal, R3;
DP3 result.texcoord[1].x, R3, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 32 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
Vector 20 [_BumpMap_ST]
"vs_2_0
; 35 ALU
def c21, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.w, c21.x
mov r0.xyz, c17
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1, c8
dp4 r4.x, c18, r1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 oT1.y, r4, r2
dp3 oT2.y, r2, r3
dp3 oT1.z, v2, r4
dp3 oT1.x, r4, v1
dp3 oT2.z, v2, r3
dp3 oT2.x, v1, r3
dp4 oT3.y, r0, c13
dp4 oT3.x, r0, c12
mad oT0.zw, v3.xyxy, c20.xyxy, c20
mad oT0.xy, v3, c19, c19.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
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
  vec4 tmpvar_90;
  tmpvar_90.xy = ((tmpvar_7.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_90.zw = ((tmpvar_7.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw).xy;
  vec3 tmpvar_35;
  tmpvar_35 = (cross (tmpvar_5, tmpvar_3.xyz) * tmpvar_3.w);
  mat3 tmpvar_36;
  tmpvar_36[0].x = tmpvar_3.x;
  tmpvar_36[0].y = tmpvar_35.x;
  tmpvar_36[0].z = tmpvar_5.x;
  tmpvar_36[1].x = tmpvar_3.y;
  tmpvar_36[1].y = tmpvar_35.y;
  tmpvar_36[1].z = tmpvar_5.y;
  tmpvar_36[2].x = tmpvar_3.z;
  tmpvar_36[2].y = tmpvar_35.z;
  tmpvar_36[2].z = tmpvar_5.z;
  vec4 tmpvar_53;
  tmpvar_53.xyz = _WorldSpaceCameraPos.xyz;
  tmpvar_53.w = 1.0;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  gl_TexCoord[0] = tmpvar_90.xyzw;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_36 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_36 * (((_World2Object * tmpvar_53).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
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
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec2 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xy;
  vec4 c;
  vec4 tmpvar_53;
  tmpvar_53 = texture2D (_MainTex, tmpvar_2.xy);
  vec3 tmpvar_55;
  tmpvar_55 = (tmpvar_53.xyz * _Color.xyz);
  float tmpvar_56;
  tmpvar_56 = tmpvar_53.w;
  float tmpvar_57;
  tmpvar_57 = (tmpvar_53.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_2.zw).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_65;
  tmpvar_65 = normal.xyz;
  float x;
  x = (tmpvar_57 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  float atten;
  atten = texture2D (_LightTexture0, tmpvar_8).w;
  vec4 c_i0;
  float tmpvar_82;
  tmpvar_82 = (pow (max (0.0, dot (tmpvar_65, normalize ((tmpvar_4 + normalize (tmpvar_6.xyz))))), (_Shininess * 128.0)) * tmpvar_56);
  c_i0.xyz = ((((tmpvar_55 * _LightColor0.xyz) * max (0.0, dot (tmpvar_65, tmpvar_4))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_82)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_57 + (((_LightColor0.w * _SpecColor.w) * tmpvar_82) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_57)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 34 to 45, TEX: 2 to 4
//   d3d9 - ALU: 41 to 51, TEX: 3 to 5
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 39 ALU, 3 TEX
PARAM c[6] = { program.local[0..4],
		{ 2, 1, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R3.w, R0, c[2];
SLT R1.y, R3.w, c[4].x;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[2];
MUL R0.xyz, R0, c[0];
MOV result.color.w, R3;
KIL -R1.y;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R2.w, R1.x, texture[2], 2D;
MAD R3.xy, R1.wyzw, c[5].x, -c[5].y;
MUL R1.x, R3.y, R3.y;
MAD R1.x, -R3, R3, -R1;
ADD R1.w, R1.x, c[5].y;
DP3 R1.y, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.x, R1.y;
RSQ R3.z, R1.w;
MUL R2.xyz, R1.x, fragment.texcoord[1];
DP3 R1.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.y;
MAD R1.xyz, R1.x, fragment.texcoord[2], R2;
DP3 R1.w, R1, R1;
RCP R3.z, R3.z;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, R3, R1;
MOV R1.w, c[5];
MUL R1.y, R1.w, c[3].x;
DP3 R2.x, R3, R2;
MAX R1.x, R1, c[5].z;
POW R1.x, R1.x, R1.y;
MUL R0.w, R0, R1.x;
MOV R1.xyz, c[1];
MUL R1.xyz, R1, c[0];
MUL R1.xyz, R1, R0.w;
MAX R1.w, R2.x, c[5].z;
MUL R0.w, R2, c[5].x;
MAD R0.xyz, R0, R1.w, R1;
MUL result.color.xyz, R0, R0.w;
END
# 39 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"ps_2_0
; 45 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c5, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c6, 128.00000000, 0, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r3, t0, s0
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
cmp r2.x, r1, c5, c5.y
mov_pp r2, -r2.x
dp3 r1.x, t3, t3
mov r4.xy, r1.x
mul r3.xyz, r3, c2
mov r1.y, t0.w
mov r1.x, t0.z
mul r3.xyz, r3, c0
texld r1, r1, s1
texld r7, r4, s2
texkill r2.xyzw
mov r1.x, r1.w
mad_pp r5.xy, r1, c5.z, c5.w
dp3_pp r2.x, t1, t1
rsq_pp r4.x, r2.x
mul_pp r1.x, r5.y, r5.y
mad_pp r1.x, -r5, r5, -r1
dp3_pp r2.x, t2, t2
add_pp r1.x, r1, c5.y
rsq_pp r1.x, r1.x
rcp_pp r5.z, r1.x
mov_pp r1.x, c3
mul_pp r4.xyz, r4.x, t1
rsq_pp r2.x, r2.x
mad_pp r6.xyz, r2.x, t2, r4
dp3_pp r2.x, r6, r6
rsq_pp r2.x, r2.x
mul_pp r2.xyz, r2.x, r6
dp3_pp r2.x, r5, r2
mul_pp r1.x, c6, r1
max_pp r2.x, r2, c5
pow r6, r2.x, r1.x
mov r1.x, r6
dp3_pp r2.x, r5, r4
mov r6.xyz, c0
mul r1.x, r3.w, r1
mul r4.xyz, c1, r6
mul r4.xyz, r4, r1.x
max_pp r1.x, r2, c5
mul_pp r2.x, r7, c5.z
mad r1.xyz, r3, r1.x, r4
mul r1.xyz, r1, r2.x
mov_pp r1.w, r0.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 34 ALU, 2 TEX
PARAM c[6] = { program.local[0..4],
		{ 2, 1, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R2.w, R0, c[2];
SLT R1.x, R2.w, c[4];
MUL R0.xyz, R0, c[2];
MOV R2.xyz, fragment.texcoord[1];
MUL R0.xyz, R0, c[0];
MOV result.color.w, R2;
KIL -R1.x;
MAD R1.xy, R1.wyzw, c[5].x, -c[5].y;
DP3 R1.w, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.w, R1.w;
MAD R2.xyz, R1.w, fragment.texcoord[2], R2;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[5].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R2.x, R1, R2;
MOV R1.w, c[5];
MUL R2.y, R1.w, c[3].x;
MAX R1.w, R2.x, c[5].z;
POW R1.w, R1.w, R2.y;
MOV R2.xyz, c[1];
MUL R0.w, R0, R1;
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R0.w;
DP3 R0.w, R1, fragment.texcoord[1];
MAX R0.w, R0, c[5].z;
MAD R0.xyz, R0, R0.w, R2;
MUL result.color.xyz, R0, c[5].x;
END
# 34 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"ps_2_0
; 41 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c5, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c6, 128.00000000, 0, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
texld r3, t0, s0
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
mul r3.xyz, r3, c2
cmp r1.x, r1, c5, c5.y
mov r2.y, t0.w
mov r2.x, t0.z
mov r4.xy, r2
mov_pp r2, -r1.x
mul r3.xyz, r3, c0
texld r1, r4, s1
texkill r2.xyzw
mov r1.x, r1.w
mad_pp r5.xy, r1, c5.z, c5.w
mul_pp r1.x, r5.y, r5.y
dp3_pp r2.x, t2, t2
mad_pp r1.x, -r5, r5, -r1
rsq_pp r2.x, r2.x
mov_pp r4.xyz, t1
mad_pp r4.xyz, r2.x, t2, r4
add_pp r2.x, r1, c5.y
dp3_pp r1.x, r4, r4
rsq_pp r2.x, r2.x
rcp_pp r5.z, r2.x
rsq_pp r1.x, r1.x
mul_pp r2.xyz, r1.x, r4
dp3_pp r2.x, r5, r2
mov_pp r1.x, c3
mul_pp r1.x, c6, r1
max_pp r2.x, r2, c5
pow r4, r2.x, r1.x
mov r1.x, r4
mov r2.xyz, c0
mul r1.x, r3.w, r1
mul r2.xyz, c1, r2
mul r2.xyz, r2, r1.x
dp3_pp r1.x, r5, t1
max_pp r1.x, r1, c5
mad r1.xyz, r3, r1.x, r2
mul r1.xyz, r1, c5.z
mov_pp r1.w, r0.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 45 ALU, 4 TEX
PARAM c[7] = { program.local[0..4],
		{ 2, 1, 0, 128 },
		{ 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TEX R4.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
MUL R3.w, R2, c[2];
SLT R0.w, R3, c[4].x;
DP3 R0.z, fragment.texcoord[3], fragment.texcoord[3];
RCP R0.x, fragment.texcoord[3].w;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.x, R1.x;
DP3 R3.x, fragment.texcoord[2], fragment.texcoord[2];
MUL R1.xyz, R1.x, fragment.texcoord[1];
RSQ R3.x, R3.x;
MAD R3.xyz, R3.x, fragment.texcoord[2], R1;
DP3 R4.x, R3, R3;
MAD R0.xy, fragment.texcoord[3], R0.x, c[6].x;
MOV result.color.w, R3;
KIL -R0.w;
TEX R0.w, R0, texture[2], 2D;
TEX R1.w, R0.z, texture[3], 2D;
MAD R0.xy, R4.wyzw, c[5].x, -c[5].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[5].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R1.x, R0, R1;
RSQ R1.y, R4.x;
MAX R4.x, R1, c[5].z;
MUL R1.xyz, R1.y, R3;
DP3 R0.x, R0, R1;
MOV R3.x, c[5].w;
MUL R0.y, R3.x, c[3].x;
MAX R0.x, R0, c[5].z;
POW R1.x, R0.x, R0.y;
MOV R0.xyz, c[1];
MUL R1.x, R2.w, R1;
MUL R0.xyz, R0, c[0];
MUL R0.xyz, R0, R1.x;
MUL R1.xyz, R2, c[2];
SLT R2.x, c[5].z, fragment.texcoord[3].z;
MUL R0.w, R2.x, R0;
MUL R0.w, R0, R1;
MUL R1.xyz, R1, c[0];
MUL R0.w, R0, c[5].x;
MAD R0.xyz, R1, R4.x, R0;
MUL result.color.xyz, R0, R0.w;
END
# 45 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"ps_2_0
; 51 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c5, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c6, 128.00000000, 0.50000000, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3
texld r3, t0, s0
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
cmp r2.x, r1, c5, c5.y
dp3 r1.x, t3, t3
mov r4.xy, r1.x
mov_pp r2, -r2.x
rcp r1.x, t3.w
mad r1.xy, t3, r1.x, c6.y
mul r3.xyz, r3, c2
mov r5.y, t0.w
mov r5.x, t0.z
mul r3.xyz, r3, c0
texld r7, r4, s3
texkill r2.xyzw
texld r2, r5, s1
texld r1, r1, s2
dp3_pp r2.x, t1, t1
rsq_pp r4.x, r2.x
dp3_pp r2.x, t2, t2
mov r1.y, r2
mov r1.x, r2.w
mad_pp r5.xy, r1, c5.z, c5.w
mul_pp r1.x, r5.y, r5.y
mad_pp r1.x, -r5, r5, -r1
add_pp r1.x, r1, c5.y
rsq_pp r1.x, r1.x
rcp_pp r5.z, r1.x
mov_pp r1.x, c3
mul_pp r4.xyz, r4.x, t1
rsq_pp r2.x, r2.x
mad_pp r6.xyz, r2.x, t2, r4
dp3_pp r2.x, r6, r6
rsq_pp r2.x, r2.x
mul_pp r2.xyz, r2.x, r6
dp3_pp r2.x, r5, r2
mul_pp r1.x, c6, r1
max_pp r2.x, r2, c5
pow r6, r2.x, r1.x
mov r1.x, r6
dp3_pp r2.x, r5, r4
mov r6.xyz, c0
mul r1.x, r3.w, r1
mul r4.xyz, c1, r6
mul r4.xyz, r4, r1.x
max_pp r1.x, r2, c5
cmp r2.x, -t3.z, c5, c5.y
mul r2.x, r2, r1.w
mul r2.x, r2, r7
mul_pp r2.x, r2, c5.z
mad r1.xyz, r3, r1.x, r4
mul r1.xyz, r1, r2.x
mov_pp r1.w, r0.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 41 ALU, 4 TEX
PARAM c[6] = { program.local[0..4],
		{ 2, 1, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TEX R4.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R1.w, fragment.texcoord[3], texture[3], CUBE;
MUL R3.w, R2, c[2];
SLT R0.y, R3.w, c[4].x;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.x, R1.x;
DP3 R3.x, fragment.texcoord[2], fragment.texcoord[2];
MUL R1.xyz, R1.x, fragment.texcoord[1];
RSQ R3.x, R3.x;
MAD R3.xyz, R3.x, fragment.texcoord[2], R1;
DP3 R4.x, R3, R3;
MOV result.color.w, R3;
TEX R0.w, R0.x, texture[2], 2D;
KIL -R0.y;
MAD R0.xy, R4.wyzw, c[5].x, -c[5].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[5].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R1.x, R0, R1;
RSQ R1.y, R4.x;
MAX R4.x, R1, c[5].z;
MUL R1.xyz, R1.y, R3;
DP3 R0.x, R0, R1;
MOV R3.x, c[5].w;
MUL R0.w, R0, R1;
MUL R0.y, R3.x, c[3].x;
MAX R0.x, R0, c[5].z;
POW R1.x, R0.x, R0.y;
MOV R0.xyz, c[1];
MUL R1.x, R2.w, R1;
MUL R0.xyz, R0, c[0];
MUL R0.xyz, R0, R1.x;
MUL R1.xyz, R2, c[2];
MUL R1.xyz, R1, c[0];
MUL R0.w, R0, c[5].x;
MAD R0.xyz, R1, R4.x, R0;
MUL result.color.xyz, R0, R0.w;
END
# 41 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"ps_2_0
; 47 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c5, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c6, 128.00000000, 0, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r3, t0, s0
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
cmp r1.x, r1, c5, c5.y
mov_pp r2, -r1.x
dp3 r1.x, t3, t3
mov r1.xy, r1.x
mul r3.xyz, r3, c2
mov r4.y, t0.w
mov r4.x, t0.z
mul r3.xyz, r3, c0
texld r7, r1, s2
texkill r2.xyzw
texld r2, r4, s1
texld r1, t3, s3
dp3_pp r2.x, t1, t1
rsq_pp r4.x, r2.x
dp3_pp r2.x, t2, t2
mov r1.y, r2
mov r1.x, r2.w
mad_pp r5.xy, r1, c5.z, c5.w
mul_pp r1.x, r5.y, r5.y
mad_pp r1.x, -r5, r5, -r1
add_pp r1.x, r1, c5.y
rsq_pp r1.x, r1.x
rcp_pp r5.z, r1.x
mov_pp r1.x, c3
mul_pp r4.xyz, r4.x, t1
rsq_pp r2.x, r2.x
mad_pp r6.xyz, r2.x, t2, r4
dp3_pp r2.x, r6, r6
rsq_pp r2.x, r2.x
mul_pp r2.xyz, r2.x, r6
dp3_pp r2.x, r5, r2
mul_pp r1.x, c6, r1
max_pp r2.x, r2, c5
pow r6, r2.x, r1.x
mov r1.x, r6
dp3_pp r2.x, r5, r4
mov r6.xyz, c0
mul r1.x, r3.w, r1
mul r4.xyz, c1, r6
mul r4.xyz, r4, r1.x
max_pp r1.x, r2, c5
mul r2.x, r7, r1.w
mul_pp r2.x, r2, c5.z
mad r1.xyz, r3, r1.x, r4
mul r1.xyz, r1, r2.x
mov_pp r1.w, r0.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 36 ALU, 3 TEX
PARAM c[6] = { program.local[0..4],
		{ 2, 1, 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R3.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
TEX R1.w, fragment.texcoord[3], texture[2], 2D;
MUL R2.w, R0, c[2];
SLT R1.x, R2.w, c[4];
DP3 R3.x, fragment.texcoord[2], fragment.texcoord[2];
MUL R0.xyz, R0, c[2];
RSQ R3.x, R3.x;
MOV R2.xyz, fragment.texcoord[1];
MAD R2.xyz, R3.x, fragment.texcoord[2], R2;
DP3 R3.x, R2, R2;
RSQ R3.x, R3.x;
MUL R2.xyz, R3.x, R2;
MOV R3.x, c[5].w;
MUL R0.xyz, R0, c[0];
MOV result.color.w, R2;
KIL -R1.x;
MAD R1.xy, R3.wyzw, c[5].x, -c[5].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[5].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R2.x, R1, R2;
MUL R2.y, R3.x, c[3].x;
MAX R2.x, R2, c[5].z;
POW R3.x, R2.x, R2.y;
MOV R2.xyz, c[1];
MUL R0.w, R0, R3.x;
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R0.w;
DP3 R0.w, R1, fragment.texcoord[1];
MAX R0.w, R0, c[5].z;
MUL R1.x, R1.w, c[5];
MAD R0.xyz, R0, R0.w, R2;
MUL result.color.xyz, R0, R1.x;
END
# 36 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
SetTexture 2 [_LightTexture0] 2D
"ps_2_0
; 42 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c5, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c6, 128.00000000, 0, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
texld r3, t0, s0
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mul r3.xyz, r3, c2
mov r2.y, t0.w
mov r2.x, t0.z
mov_pp r5.xyz, t1
mul r3.xyz, r3, c0
texld r2, r2, s1
texkill r1.xyzw
texld r1, t3, s2
dp3_pp r2.x, t2, t2
rsq_pp r2.x, r2.x
mad_pp r5.xyz, r2.x, t2, r5
dp3_pp r2.x, r5, r5
mov r1.y, r2
mov r1.x, r2.w
mad_pp r4.xy, r1, c5.z, c5.w
mul_pp r1.x, r4.y, r4.y
mad_pp r1.x, -r4, r4, -r1
add_pp r1.x, r1, c5.y
rsq_pp r1.x, r1.x
rcp_pp r4.z, r1.x
rsq_pp r2.x, r2.x
mul_pp r2.xyz, r2.x, r5
dp3_pp r2.x, r4, r2
mov_pp r1.x, c3
mul_pp r1.x, c6, r1
max_pp r2.x, r2, c5
pow r5, r2.x, r1.x
mov r1.x, r5
mul r2.x, r3.w, r1
dp3_pp r1.x, r4, t1
max_pp r1.x, r1, c5
mov r5.xyz, c0
mul r4.xyz, c1, r5
mul r4.xyz, r4, r2.x
mul_pp r2.x, r1.w, c5.z
mad r1.xyz, r3, r1.x, r4
mul r1.xyz, r1, r2.x
mov_pp r1.w, r0.x
mov_pp oC0, r1
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
uniform float _Shininess;
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
  vec3 tmpvar_52;
  tmpvar_52 = normal.xyz;
  float x;
  x = ((texture2D (_MainTex, tmpvar_2.xy).w * _Color.w) - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  worldN.x = dot (tmpvar_4, tmpvar_52);
  worldN.y = (vec2(dot (tmpvar_6, tmpvar_52))).y;
  worldN.z = (vec3(dot (tmpvar_8, tmpvar_52))).z;
  res.xyz = ((worldN * 0.5) + 0.5).xyz;
  res.w = (vec4(_Shininess)).w;
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
Float 1 [_Shininess]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 16 ALU, 2 TEX
PARAM c[4] = { program.local[0..2],
		{ 2, 1, 0.5 } };
TEMP R0;
TEMP R1;
TEX R0.w, fragment.texcoord[0], texture[0], 2D;
MUL R0.x, R0.w, c[0].w;
SLT R0.x, R0, c[2];
MOV result.color.w, c[1].x;
TEX R0.yw, fragment.texcoord[0].zwzw, texture[1], 2D;
KIL -R0.x;
MAD R0.xy, R0.wyzw, c[3].x, -c[3].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[3].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R1.z, fragment.texcoord[3], R0;
DP3 R1.x, R0, fragment.texcoord[1];
DP3 R1.y, R0, fragment.texcoord[2];
MAD result.color.xyz, R1, c[3].z, c[3].z;
END
# 16 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_Color]
Float 1 [_Shininess]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpMap] 2D
"ps_2_0
; 20 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c3, 0.00000000, 1.00000000, 2.00000000, -1.00000000
def c4, 0.50000000, 0, 0, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r0, t0, s0
mul r0.x, r0.w, c0.w
add r0.x, r0, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
texld r1, r1, s1
texkill r0.xyzw
mov r0.y, r1
mov r0.x, r1.w
mad_pp r0.xy, r0, c3.z, c3.w
mul_pp r1.x, r0.y, r0.y
mad_pp r1.x, -r0, r0, -r1
add_pp r1.x, r1, c3.y
rsq_pp r1.x, r1.x
rcp_pp r0.z, r1.x
dp3 r1.z, t3, r0
dp3 r1.x, r0, t1
dp3 r1.y, r0, t2
mad_pp r0.xyz, r1, c4.x, c4.x
mov_pp r0.w, c1.x
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
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec2 tmpvar_77;
  vec4 tmpvar_39;
  tmpvar_39 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_41;
  tmpvar_41 = (tmpvar_39.xyz * _Color.xyz);
  float tmpvar_42;
  tmpvar_42 = tmpvar_39.w;
  float tmpvar_43;
  tmpvar_43 = (tmpvar_39.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_77).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  float x;
  x = (tmpvar_43 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 tmpvar_56;
  tmpvar_56 = -(log2 (texture2DProj (_LightBuffer, tmpvar_4)));
  light = tmpvar_56;
  light.xyz = (tmpvar_56.xyz + unity_Ambient.xyz).xyz;
  vec4 c;
  float tmpvar_60;
  tmpvar_60 = (light.w * tmpvar_42);
  c.xyz = ((tmpvar_41 * light.xyz) + ((light.xyz * _SpecColor.xyz) * tmpvar_60)).xyz;
  c.w = (vec4((tmpvar_43 + (tmpvar_60 * _SpecColor.w)))).w;
  gl_FragData[0] = c.xyzw;
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
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec2 tmpvar_99;
  vec4 tmpvar_45;
  tmpvar_45 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_47;
  tmpvar_47 = (tmpvar_45.xyz * _Color.xyz);
  float tmpvar_48;
  tmpvar_48 = tmpvar_45.w;
  float tmpvar_49;
  tmpvar_49 = (tmpvar_45.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, tmpvar_99).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  float x;
  x = (tmpvar_49 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 tmpvar_62;
  tmpvar_62 = -(log2 (texture2DProj (_LightBuffer, tmpvar_4)));
  light = tmpvar_62;
  light.xyz = (tmpvar_62.xyz + mix ((2.0 * texture2D (unity_LightmapInd, tmpvar_6.xy).xyz), (2.0 * texture2D (unity_Lightmap, tmpvar_6.xy).xyz), vec3(clamp (tmpvar_6.z, 0.0, 1.0)))).xyz;
  vec4 c;
  float tmpvar_80;
  tmpvar_80 = (light.w * tmpvar_48);
  c.xyz = ((tmpvar_47 * light.xyz) + ((light.xyz * _SpecColor.xyz) * tmpvar_80)).xyz;
  c.w = (vec4((tmpvar_49 + (tmpvar_80 * _SpecColor.w)))).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 2
//   opengl - ALU: 16 to 24, TEX: 2 to 4
//   d3d9 - ALU: 16 to 22, TEX: 3 to 5
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Vector 2 [unity_Ambient]
Float 3 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 2 [_LightBuffer] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 16 ALU, 2 TEX
PARAM c[4] = { program.local[0..3] };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R2.x, R0.w, c[1].w;
SLT R1.x, R2, c[3];
MUL R0.xyz, R0, c[1];
KIL -R1.x;
TXP R1, fragment.texcoord[1], texture[2], 2D;
LG2 R1.w, R1.w;
MUL R0.w, -R1, R0;
LG2 R1.x, R1.x;
LG2 R1.z, R1.z;
LG2 R1.y, R1.y;
ADD R1.xyz, -R1, c[2];
MUL R0.xyz, R1, R0;
MUL R1.xyz, R1, c[0];
MAD result.color.xyz, R0.w, R1, R0;
MAD result.color.w, R0, c[0], R2.x;
END
# 16 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Vector 2 [unity_Ambient]
Float 3 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 2 [_LightBuffer] 2D
"ps_2_0
; 16 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c4, 0.00000000, 1.00000000, 0, 0
dcl t0.xy
dcl t1
texld r2, t0, s0
mul r0.x, r2.w, c1.w
add r1.x, r0, -c3
cmp r1.x, r1, c4, c4.y
mov_pp r3, -r1.x
mul r2.xyz, r2, c1
texldp r1, t1, s2
texkill r3.xyzw
log_pp r1.x, r1.x
log_pp r1.z, r1.z
log_pp r1.y, r1.y
add_pp r3.xyz, -r1, c2
mul_pp r2.xyz, r3, r2
log_pp r1.x, r1.w
mul_pp r1.x, r2.w, -r1
mul r3.xyz, r3, c0
mad r2.xyz, r1.x, r3, r2
mad r2.w, r1.x, c0, r0.x
mov_pp oC0, r2
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 24 ALU, 4 TEX
PARAM c[4] = { program.local[0..2],
		{ 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2, fragment.texcoord[2], texture[4], 2D;
TEX R3, fragment.texcoord[2], texture[3], 2D;
MUL R2.xyz, R2.w, R2;
MUL R4.x, R0.w, c[1].w;
SLT R1.x, R4, c[2];
MUL R2.xyz, R2, c[3].x;
MUL R3.xyz, R3.w, R3;
MAD R3.xyz, R3, c[3].x, -R2;
MOV_SAT R2.w, fragment.texcoord[2].z;
MAD R2.xyz, R2.w, R3, R2;
MUL R0.xyz, R0, c[1];
KIL -R1.x;
TXP R1, fragment.texcoord[1], texture[2], 2D;
LG2 R1.w, R1.w;
MUL R0.w, -R1, R0;
LG2 R1.x, R1.x;
LG2 R1.y, R1.y;
LG2 R1.z, R1.z;
ADD R1.xyz, -R1, R2;
MUL R2.xyz, R1, c[0];
MUL R0.xyz, R1, R0;
MAD result.color.xyz, R0.w, R2, R0;
MAD result.color.w, R0, c[0], R4.x;
END
# 24 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 2 [_LightBuffer] 2D
SetTexture 3 [unity_Lightmap] 2D
SetTexture 4 [unity_LightmapInd] 2D
"ps_2_0
; 22 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c3, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t1
dcl t2.xyz
texld r4, t0, s0
texldp r3, t1, s2
texld r2, t2, s3
mul r0.x, r4.w, c1.w
add r1.x, r0, -c2
cmp r1.x, r1, c3, c3.y
mov_pp r1, -r1.x
mul r4.xyz, r4, c1
texkill r1.xyzw
texld r1, t2, s4
mul_pp r1.xyz, r1.w, r1
mul_pp r5.xyz, r1, c3.z
mul_pp r1.xyz, r2.w, r2
mad_pp r2.xyz, r1, c3.z, -r5
mov_sat r1.x, t2.z
mad_pp r1.xyz, r1.x, r2, r5
log_pp r2.x, r3.x
log_pp r2.y, r3.y
log_pp r2.z, r3.z
add_pp r3.xyz, -r2, r1
mul r2.xyz, r3, c0
log_pp r1.x, r3.w
mul_pp r1.x, r4.w, -r1
mul_pp r3.xyz, r3, r4
mad r2.xyz, r1.x, r2, r3
mad r2.w, r1.x, c0, r0.x
mov_pp oC0, r2
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" }
"!!GLES"
}

}
	}

#LINE 36

}

FallBack "Transparent/Cutout/VertexLit"
}
