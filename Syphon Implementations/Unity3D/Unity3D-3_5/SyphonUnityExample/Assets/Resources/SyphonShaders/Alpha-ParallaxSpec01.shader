Shader "Syphon/Transparent/Parallax Specular" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 0)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_Parallax ("Height", Range (0.005, 0.08)) = 0.02
	_MainTex ("Base (RGB) TransGloss (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_ParallaxMap ("Heightmap (A)", 2D) = "black" {}
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 600
	
	Alphatest Greater 0 ZWrite Off
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
Program "vp" {
// Vertex combos: 3
//   opengl - ALU: 20 to 75
//   d3d9 - ALU: 21 to 78
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
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
uniform sampler2D _ParallaxMap;
uniform float _Parallax;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
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
  vec2 tmpvar_64;
  tmpvar_64 = tmpvar_2.zw;
  vec2 _ret_val_i0;
  vec3 v;
  vec3 tmpvar_76;
  tmpvar_76 = normalize (tmpvar_4);
  v = tmpvar_76;
  v.z = (vec3((tmpvar_76.z + 0.42))).z;
  _ret_val_i0 = (((texture2D (_ParallaxMap, tmpvar_64).w * _Parallax) - (_Parallax / 2.0)) * (v.xy / v.z));
  vec4 tmpvar_82;
  tmpvar_82 = texture2D (_MainTex, (tmpvar_2.xy + _ret_val_i0));
  vec3 tmpvar_84;
  tmpvar_84 = (tmpvar_82.xyz * _Color.xyz);
  float tmpvar_86;
  tmpvar_86 = (tmpvar_82.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, (tmpvar_64 + _ret_val_i0)).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_94;
  tmpvar_94 = normal.xyz;
  vec4 c_i0;
  float tmpvar_109;
  tmpvar_109 = (pow (max (0.0, dot (tmpvar_94, normalize ((tmpvar_6 + normalize (tmpvar_4.xyz))))), (_Shininess * 128.0)) * tmpvar_82.w);
  c_i0.xyz = ((((tmpvar_84 * _LightColor0.xyz) * max (0.0, dot (tmpvar_94, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_109)) * 2.0).xyz;
  c_i0.w = (vec4((tmpvar_86 + ((_LightColor0.w * _SpecColor.w) * tmpvar_109)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_84 * gl_TexCoord[3].xyz)).xyz;
  c.w = (vec4(tmpvar_86)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
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
uniform sampler2D _ParallaxMap;
uniform float _Parallax;
uniform sampler2D _MainTex;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec4 c;
  vec2 tmpvar_50;
  tmpvar_50 = tmpvar_2.zw;
  vec2 _ret_val_i0;
  vec3 v;
  vec3 tmpvar_62;
  tmpvar_62 = normalize (gl_TexCoord[1].xyz);
  v = tmpvar_62;
  v.z = (vec3((tmpvar_62.z + 0.42))).z;
  _ret_val_i0 = (((texture2D (_ParallaxMap, tmpvar_50).w * _Parallax) - (_Parallax / 2.0)) * (v.xy / v.z));
  vec4 tmpvar_68;
  tmpvar_68 = texture2D (_MainTex, (tmpvar_2.xy + _ret_val_i0));
  float tmpvar_72;
  tmpvar_72 = (tmpvar_68.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, (tmpvar_50 + _ret_val_i0)).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  c.xyz = ((tmpvar_68.xyz * _Color.xyz) * (2.0 * texture2D (unity_Lightmap, gl_TexCoord[2].xy).xyz)).xyz;
  c.w = (vec4(tmpvar_72)).w;
  c.w = (vec4(tmpvar_72)).w;
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
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "VERTEXLIGHT_ON" }
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
uniform sampler2D _ParallaxMap;
uniform float _Parallax;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
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
  vec2 tmpvar_64;
  tmpvar_64 = tmpvar_2.zw;
  vec2 _ret_val_i0;
  vec3 v;
  vec3 tmpvar_76;
  tmpvar_76 = normalize (tmpvar_4);
  v = tmpvar_76;
  v.z = (vec3((tmpvar_76.z + 0.42))).z;
  _ret_val_i0 = (((texture2D (_ParallaxMap, tmpvar_64).w * _Parallax) - (_Parallax / 2.0)) * (v.xy / v.z));
  vec4 tmpvar_82;
  tmpvar_82 = texture2D (_MainTex, (tmpvar_2.xy + _ret_val_i0));
  vec3 tmpvar_84;
  tmpvar_84 = (tmpvar_82.xyz * _Color.xyz);
  float tmpvar_86;
  tmpvar_86 = (tmpvar_82.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, (tmpvar_64 + _ret_val_i0)).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_94;
  tmpvar_94 = normal.xyz;
  vec4 c_i0;
  float tmpvar_109;
  tmpvar_109 = (pow (max (0.0, dot (tmpvar_94, normalize ((tmpvar_6 + normalize (tmpvar_4.xyz))))), (_Shininess * 128.0)) * tmpvar_82.w);
  c_i0.xyz = ((((tmpvar_84 * _LightColor0.xyz) * max (0.0, dot (tmpvar_94, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_109)) * 2.0).xyz;
  c_i0.w = (vec4((tmpvar_86 + ((_LightColor0.w * _SpecColor.w) * tmpvar_109)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_84 * gl_TexCoord[3].xyz)).xyz;
  c.w = (vec4(tmpvar_86)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 2
//   opengl - ALU: 18 to 43, TEX: 3 to 3
//   d3d9 - ALU: 18 to 49, TEX: 3 to 3
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 43 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.5, 0.41999999, 2, 1 },
		{ 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.w, R0.x;
MUL R0.xyz, R1.w, fragment.texcoord[1];
ADD R1.x, R0.z, c[5].y;
RCP R1.x, R1.x;
MOV R0.z, c[4].x;
MUL R0.xy, R0, R1.x;
MUL R0.z, R0, c[5].x;
MAD R1.x, R0.w, c[4], -R0.z;
MAD R0.zw, R1.x, R0.xyxy, fragment.texcoord[0];
MAD R0.xy, R1.x, R0, fragment.texcoord[0];
TEX R2.yw, R0.zwzw, texture[2], 2D;
TEX R0, R0, texture[1], 2D;
MAD R1.xy, R2.wyzw, c[5].z, -c[5].w;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
MOV R2.xyz, fragment.texcoord[2];
MAD R2.xyz, R1.w, fragment.texcoord[1], R2;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
ADD R1.z, R1, c[5].w;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R2.x, R1, R2;
MOV R1.w, c[6].y;
MUL R2.y, R1.w, c[3].x;
MAX R1.w, R2.x, c[6].x;
POW R1.w, R1.w, R2.y;
MUL R1.w, R0, R1;
MUL R0, R0, c[2];
MOV R2.xyz, c[1];
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R1.w;
DP3 R1.x, R1, fragment.texcoord[2];
MAX R1.w, R1.x, c[6].x;
MUL R1.xyz, R0, c[0];
MAD R1.xyz, R1, R1.w, R2;
MUL R0.xyz, R0, fragment.texcoord[3];
MUL R1.xyz, R1, c[5].z;
ADD result.color.xyz, R1, R0;
MOV result.color.w, R0;
END
# 43 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
"ps_2_0
; 49 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
mov_pp r1.x, c5
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r1.x, c4, r1
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t1
add r2.x, r3.z, c5.y
rcp r2.x, r2.x
mul r2.xy, r3, r2.x
mad_pp r1.x, r0.w, c4, -r1
mov r3.y, t0.w
mov r3.x, t0.z
mad r3.xy, r1.x, r2, r3
mad r2.xy, r1.x, r2, t0
texld r1, r3, s2
texld r2, r2, s1
mov r1.x, r1.w
mad_pp r4.xy, r1, c5.z, c5.w
mul_pp r1.x, r4.y, r4.y
mov_pp r3.xyz, t2
mad_pp r3.xyz, r0.x, t1, r3
dp3_pp r0.x, r3, r3
mad_pp r1.x, -r4, r4, -r1
add_pp r1.x, r1, c6
rsq_pp r1.x, r1.x
rcp_pp r4.z, r1.x
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r3
dp3_pp r1.x, r4, r1
mov_pp r0.x, c3
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r3, r1.x, r0.x
mov r1.xyz, c0
mov r0.x, r3
mul r0.x, r2.w, r0
mul r2, r2, c2
mul r1.xyz, c1, r1
mul r1.xyz, r1, r0.x
dp3_pp r0.x, r4, t2
max_pp r0.x, r0, c6.y
mul r3.xyz, r2, c0
mad r0.xyz, r3, r0.x, r1
mul r1.xyz, r2, t3
mul r0.xyz, r0, c5.z
add_pp r0.xyz, r0, r1
mov_pp r0.w, r2
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
Float 1 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 0.5, 0.41999999, 8 } };
TEMP R0;
TEMP R1;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[1];
ADD R1.x, R0.z, c[2].y;
RCP R1.x, R1.x;
MUL R0.xy, R0, R1.x;
MOV R0.z, c[1].x;
MUL R0.z, R0, c[2].x;
MAD R0.z, R0.w, c[1].x, -R0;
MAD R0.xy, R0.z, R0, fragment.texcoord[0];
TEX R0, R0, texture[1], 2D;
TEX R1, fragment.texcoord[2], texture[3], 2D;
MUL R0, R0, c[0];
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R1, R0;
MUL result.color.xyz, R0, c[2].z;
MOV result.color.w, R0;
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
Vector 0 [_Color]
Float 1 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 3 [unity_Lightmap] 2D
"ps_2_0
; 18 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 0.50000000, 0.41999999, 8.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xy
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r2.xyz, r0.x, t1
add r0.x, r2.z, c2.y
rcp r1.x, r0.x
mov_pp r0.x, c2
mul_pp r0.x, c1, r0
mul r1.xy, r2, r1.x
mad_pp r0.x, r0.w, c1, -r0
mad r0.xy, r0.x, r1, t0
texld r1, r0, s1
texld r0, t2, s3
mul r1, r1, c0
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r1
mul_pp r0.xyz, r0, c2.z
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
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[19];
MOV R0.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[18];
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
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c21.x
dp3 oT2.y, r2, r0
dp3 oT2.z, v2, r0
dp3 oT2.x, v1, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 oT1.y, r1, r2
dp3 oT1.z, v2, r1
dp3 oT1.x, r1, v1
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
  tmpvar_19.xyz = (tmpvar_36 * (((_World2Object * tmpvar_53).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_36 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
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
uniform sampler2D _ParallaxMap;
uniform float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  vec4 tmpvar_2;
  tmpvar_2 = gl_TexCoord[0].xyzw;
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 c;
  vec2 tmpvar_63;
  tmpvar_63 = tmpvar_2.zw;
  vec2 _ret_val_i0;
  vec3 v;
  vec3 tmpvar_75;
  tmpvar_75 = normalize (tmpvar_4);
  v = tmpvar_75;
  v.z = (vec3((tmpvar_75.z + 0.42))).z;
  _ret_val_i0 = (((texture2D (_ParallaxMap, tmpvar_63).w * _Parallax) - (_Parallax / 2.0)) * (v.xy / v.z));
  vec4 tmpvar_81;
  tmpvar_81 = texture2D (_MainTex, (tmpvar_2.xy + _ret_val_i0));
  float tmpvar_85;
  tmpvar_85 = (tmpvar_81.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, (tmpvar_63 + _ret_val_i0)).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_93;
  tmpvar_93 = normal.xyz;
  vec3 tmpvar_96;
  tmpvar_96 = normalize (gl_TexCoord[2].xyz);
  float atten;
  atten = texture2D (_LightTexture0, vec2(dot (tmpvar_8, tmpvar_8))).w;
  vec4 c_i0;
  float tmpvar_115;
  tmpvar_115 = (pow (max (0.0, dot (tmpvar_93, normalize ((tmpvar_96 + normalize (tmpvar_4.xyz))))), (_Shininess * 128.0)) * tmpvar_81.w);
  c_i0.xyz = (((((tmpvar_81.xyz * _Color.xyz) * _LightColor0.xyz) * max (0.0, dot (tmpvar_93, tmpvar_96))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_115)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_85 + (((_LightColor0.w * _SpecColor.w) * tmpvar_115) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_85)).w;
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
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0.xyz, c[10];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[7];
DP4 R2.x, R0, c[5];
DP4 R2.y, R0, c[6];
MAD R0.xyz, R2, c[9].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[11];
DP4 R3.z, R1, c[7];
DP4 R3.x, R1, c[5];
DP4 R3.y, R1, c[6];
DP3 result.texcoord[1].y, R0, R2;
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
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
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c6
dp4 r4.z, c10, r0
mov r0, c5
mov r1.w, c13.x
mov r1.xyz, c9
dp4 r4.y, c10, r0
dp4 r2.z, r1, c6
dp4 r2.x, r1, c4
dp4 r2.y, r1, c5
mad r2.xyz, r2, c8.w, -v0
mov r1, c4
dp4 r4.x, c10, r1
dp3 oT1.y, r2, r3
dp3 oT2.y, r3, r4
dp3 oT1.z, v2, r2
dp3 oT1.x, r2, v1
dp3 oT2.z, v2, r4
dp3 oT2.x, v1, r4
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
  tmpvar_19.xyz = (tmpvar_34 * (((_World2Object * tmpvar_51).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_34 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _ParallaxMap;
uniform float _Parallax;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
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
  vec2 tmpvar_61;
  tmpvar_61 = tmpvar_2.zw;
  vec2 _ret_val_i0;
  vec3 v;
  vec3 tmpvar_73;
  tmpvar_73 = normalize (tmpvar_4);
  v = tmpvar_73;
  v.z = (vec3((tmpvar_73.z + 0.42))).z;
  _ret_val_i0 = (((texture2D (_ParallaxMap, tmpvar_61).w * _Parallax) - (_Parallax / 2.0)) * (v.xy / v.z));
  vec4 tmpvar_79;
  tmpvar_79 = texture2D (_MainTex, (tmpvar_2.xy + _ret_val_i0));
  float tmpvar_83;
  tmpvar_83 = (tmpvar_79.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, (tmpvar_61 + _ret_val_i0)).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_91;
  tmpvar_91 = normal.xyz;
  vec4 c_i0;
  float tmpvar_107;
  tmpvar_107 = (pow (max (0.0, dot (tmpvar_91, normalize ((tmpvar_6 + normalize (tmpvar_4.xyz))))), (_Shininess * 128.0)) * tmpvar_79.w);
  c_i0.xyz = (((((tmpvar_79.xyz * _Color.xyz) * _LightColor0.xyz) * max (0.0, dot (tmpvar_91, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_107)) * 2.0).xyz;
  c_i0.w = (vec4((tmpvar_83 + ((_LightColor0.w * _SpecColor.w) * tmpvar_107)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_83)).w;
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
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[19];
MOV R0.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[18];
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
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c21.x
dp4 r0.w, v0, c7
dp3 oT2.y, r2, r0
dp3 oT2.z, v2, r0
dp3 oT2.x, v1, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 oT1.y, r1, r2
dp3 oT1.z, v2, r1
dp3 oT1.x, r1, v1
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
  tmpvar_19.xyz = (tmpvar_36 * (((_World2Object * tmpvar_53).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_36 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  gl_TexCoord[3] = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyzw;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _ParallaxMap;
uniform float _Parallax;
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
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec4 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyzw;
  vec4 c;
  vec2 tmpvar_70;
  tmpvar_70 = tmpvar_2.zw;
  vec2 _ret_val_i0;
  vec3 v;
  vec3 tmpvar_82;
  tmpvar_82 = normalize (tmpvar_4);
  v = tmpvar_82;
  v.z = (vec3((tmpvar_82.z + 0.42))).z;
  _ret_val_i0 = (((texture2D (_ParallaxMap, tmpvar_70).w * _Parallax) - (_Parallax / 2.0)) * (v.xy / v.z));
  vec4 tmpvar_88;
  tmpvar_88 = texture2D (_MainTex, (tmpvar_2.xy + _ret_val_i0));
  float tmpvar_92;
  tmpvar_92 = (tmpvar_88.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, (tmpvar_70 + _ret_val_i0)).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_100;
  tmpvar_100 = normal.xyz;
  vec3 tmpvar_103;
  tmpvar_103 = normalize (gl_TexCoord[2].xyz);
  vec3 LightCoord_i0;
  LightCoord_i0 = tmpvar_8.xyz;
  float atten;
  atten = ((float((tmpvar_8.z > 0.0)) * texture2D (_LightTexture0, ((tmpvar_8.xy / tmpvar_8.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w);
  vec4 c_i0;
  float tmpvar_127;
  tmpvar_127 = (pow (max (0.0, dot (tmpvar_100, normalize ((tmpvar_103 + normalize (tmpvar_4.xyz))))), (_Shininess * 128.0)) * tmpvar_88.w);
  c_i0.xyz = (((((tmpvar_88.xyz * _Color.xyz) * _LightColor0.xyz) * max (0.0, dot (tmpvar_100, tmpvar_103))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_127)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_92 + (((_LightColor0.w * _SpecColor.w) * tmpvar_127) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_92)).w;
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
MOV R0.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R2;
MOV R1, c[19];
MOV R0.w, c[0].x;
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[17].w, -vertex.position;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[18];
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
mov r1.xyz, v1
mov r0, c10
dp4 r3.z, c18, r0
mov r0, c9
dp4 r3.y, c18, r0
mul r2.xyz, v2.zxyw, r1.yzxw
mov r1.xyz, v1
mad r2.xyz, v2.yzxw, r1.zxyw, -r2
mov r1, c8
dp4 r3.x, c18, r1
mad r0.xyz, r3, c16.w, -v0
mul r2.xyz, r2, v1.w
mov r1.xyz, c17
mov r1.w, c21.x
dp3 oT2.y, r2, r0
dp3 oT2.z, v2, r0
dp3 oT2.x, v1, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
dp3 oT1.y, r1, r2
dp3 oT1.z, v2, r1
dp3 oT1.x, r1, v1
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
  tmpvar_19.xyz = (tmpvar_36 * (((_World2Object * tmpvar_53).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_36 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
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
uniform sampler2D _ParallaxMap;
uniform float _Parallax;
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
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 c;
  vec2 tmpvar_63;
  tmpvar_63 = tmpvar_2.zw;
  vec2 _ret_val_i0;
  vec3 v;
  vec3 tmpvar_75;
  tmpvar_75 = normalize (tmpvar_4);
  v = tmpvar_75;
  v.z = (vec3((tmpvar_75.z + 0.42))).z;
  _ret_val_i0 = (((texture2D (_ParallaxMap, tmpvar_63).w * _Parallax) - (_Parallax / 2.0)) * (v.xy / v.z));
  vec4 tmpvar_81;
  tmpvar_81 = texture2D (_MainTex, (tmpvar_2.xy + _ret_val_i0));
  float tmpvar_85;
  tmpvar_85 = (tmpvar_81.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, (tmpvar_63 + _ret_val_i0)).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_93;
  tmpvar_93 = normal.xyz;
  vec3 tmpvar_96;
  tmpvar_96 = normalize (gl_TexCoord[2].xyz);
  float atten;
  atten = (texture2D (_LightTextureB0, vec2(dot (tmpvar_8, tmpvar_8))).w * textureCube (_LightTexture0, tmpvar_8).w);
  vec4 c_i0;
  float tmpvar_116;
  tmpvar_116 = (pow (max (0.0, dot (tmpvar_93, normalize ((tmpvar_96 + normalize (tmpvar_4.xyz))))), (_Shininess * 128.0)) * tmpvar_81.w);
  c_i0.xyz = (((((tmpvar_81.xyz * _Color.xyz) * _LightColor0.xyz) * max (0.0, dot (tmpvar_93, tmpvar_96))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_116)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_85 + (((_LightColor0.w * _SpecColor.w) * tmpvar_116) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_85)).w;
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
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0.w, c[0].x;
MOV R0.xyz, c[18];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[17].w, -vertex.position;
MUL R2.xyz, R1, vertex.attrib[14].w;
MOV R1, c[19];
DP3 result.texcoord[1].y, R0, R2;
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R2, R3;
DP3 result.texcoord[2].z, vertex.normal, R3;
DP3 result.texcoord[2].x, vertex.attrib[14], R3;
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
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
mov r1.w, c21.x
mov r1.xyz, c17
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c16.w, -v0
mov r1, c8
dp4 r4.x, c18, r1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 oT1.y, r2, r3
dp3 oT2.y, r3, r4
dp3 oT1.z, v2, r2
dp3 oT1.x, r2, v1
dp3 oT2.z, v2, r4
dp3 oT2.x, v1, r4
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
  tmpvar_19.xyz = (tmpvar_36 * (((_World2Object * tmpvar_53).xyz * unity_Scale.w) - tmpvar_1.xyz)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (tmpvar_36 * (_World2Object * _WorldSpaceLightPos0).xyz).xyz;
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
uniform sampler2D _ParallaxMap;
uniform float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
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
  vec2 tmpvar_63;
  tmpvar_63 = tmpvar_2.zw;
  vec2 _ret_val_i0;
  vec3 v;
  vec3 tmpvar_75;
  tmpvar_75 = normalize (tmpvar_4);
  v = tmpvar_75;
  v.z = (vec3((tmpvar_75.z + 0.42))).z;
  _ret_val_i0 = (((texture2D (_ParallaxMap, tmpvar_63).w * _Parallax) - (_Parallax / 2.0)) * (v.xy / v.z));
  vec4 tmpvar_81;
  tmpvar_81 = texture2D (_MainTex, (tmpvar_2.xy + _ret_val_i0));
  float tmpvar_85;
  tmpvar_85 = (tmpvar_81.w * _Color.w);
  vec4 normal;
  normal.xy = ((texture2D (_BumpMap, (tmpvar_63 + _ret_val_i0)).wy * 2.0) - 1.0);
  normal.z = (vec3(sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y))))).z;
  vec3 tmpvar_93;
  tmpvar_93 = normal.xyz;
  float atten;
  atten = texture2D (_LightTexture0, gl_TexCoord[3].xy).w;
  vec4 c_i0;
  float tmpvar_110;
  tmpvar_110 = (pow (max (0.0, dot (tmpvar_93, normalize ((tmpvar_6 + normalize (tmpvar_4.xyz))))), (_Shininess * 128.0)) * tmpvar_81.w);
  c_i0.xyz = (((((tmpvar_81.xyz * _Color.xyz) * _LightColor0.xyz) * max (0.0, dot (tmpvar_93, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_110)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_85 + (((_LightColor0.w * _SpecColor.w) * tmpvar_110) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_85)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 41 to 52, TEX: 3 to 5
//   d3d9 - ALU: 47 to 57, TEX: 3 to 5
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 46 ALU, 4 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.5, 0.41999999, 2, 1 },
		{ 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.z, R0.x;
MUL R1.xyz, R0.z, fragment.texcoord[1];
ADD R0.y, R1.z, c[5];
RCP R0.y, R0.y;
MOV R0.x, c[4];
MUL R0.x, R0, c[5];
DP3 R2.x, fragment.texcoord[2], fragment.texcoord[2];
MAD R0.w, R0, c[4].x, -R0.x;
MUL R1.xy, R1, R0.y;
MAD R0.xy, R0.w, R1, fragment.texcoord[0].zwzw;
MAD R1.xy, R0.w, R1, fragment.texcoord[0];
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R2.x, R2.x;
TEX R2.yw, R0, texture[2], 2D;
TEX R0.w, R0.w, texture[3], 2D;
TEX R1, R1, texture[1], 2D;
MAD R0.xy, R2.wyzw, c[5].z, -c[5].w;
MUL R2.xyz, R2.x, fragment.texcoord[2];
MUL R2.w, R0.y, R0.y;
MAD R3.xyz, R0.z, fragment.texcoord[1], R2;
MAD R2.w, -R0.x, R0.x, -R2;
ADD R0.z, R2.w, c[5].w;
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R3.x, R0, R3;
DP3 R0.x, R0, R2;
MOV R2.w, c[6].y;
MUL R3.y, R2.w, c[3].x;
MAX R2.w, R3.x, c[6].x;
POW R2.w, R2.w, R3.y;
MUL R2.w, R1, R2;
MUL R1, R1, c[2];
MAX R2.x, R0, c[6];
MOV R3.xyz, c[1];
MUL R3.xyz, R3, c[0];
MUL R3.xyz, R3, R2.w;
MUL R0.xyz, R1, c[0];
MUL R0.w, R0, c[5].z;
MAD R0.xyz, R0, R2.x, R3;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, R1;
END
# 46 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_2_0
; 53 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
mov_pp r1.x, c5
mov r2.y, t0.w
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r1.x, c4, r1
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t1
add r2.x, r3.z, c5.y
rcp r2.x, r2.x
mul r3.xy, r3, r2.x
mad_pp r1.x, r0.w, c4, -r1
mov r2.x, t0.z
mad r4.xy, r1.x, r3, r2
mad r1.xy, r1.x, r3, t0
dp3 r2.x, t3, t3
mov r3.xy, r2.x
texld r2, r1, s1
texld r1, r4, s2
texld r6, r3, s3
mov r3.x, r1.w
mov r3.y, r1
mad_pp r4.xy, r3, c5.z, c5.w
dp3_pp r1.x, t2, t2
rsq_pp r3.x, r1.x
mul_pp r3.xyz, r3.x, t2
mul_pp r1.x, r4.y, r4.y
mad_pp r5.xyz, r0.x, t1, r3
mad_pp r1.x, -r4, r4, -r1
add_pp r0.x, r1, c6
dp3_pp r1.x, r5, r5
rsq_pp r0.x, r0.x
rcp_pp r4.z, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, r5
dp3_pp r1.x, r4, r1
mov_pp r0.x, c3
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r5, r1.x, r0.x
mov r0.x, r5
dp3_pp r1.x, r4, r3
mov r5.xyz, c0
mul r0.x, r2.w, r0
mul r3.xyz, c1, r5
mul r3.xyz, r3, r0.x
max_pp r0.x, r1, c6.y
mul r1, r2, c2
mul r2.xyz, r1, c0
mul_pp r1.x, r6, c5.z
mad r0.xyz, r2, r0.x, r3
mul r0.xyz, r0, r1.x
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
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 41 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.5, 0.41999999, 2, 1 },
		{ 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.w, R0.x;
MUL R0.xyz, R1.w, fragment.texcoord[1];
ADD R1.x, R0.z, c[5].y;
RCP R1.x, R1.x;
MOV R0.z, c[4].x;
MUL R0.xy, R0, R1.x;
MUL R0.z, R0, c[5].x;
MAD R1.x, R0.w, c[4], -R0.z;
MAD R0.zw, R1.x, R0.xyxy, fragment.texcoord[0];
MAD R0.xy, R1.x, R0, fragment.texcoord[0];
TEX R2.yw, R0.zwzw, texture[2], 2D;
TEX R0, R0, texture[1], 2D;
MAD R1.xy, R2.wyzw, c[5].z, -c[5].w;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
MOV R2.xyz, fragment.texcoord[2];
MAD R2.xyz, R1.w, fragment.texcoord[1], R2;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
ADD R1.z, R1, c[5].w;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
DP3 R2.x, R1, R2;
MOV R1.w, c[6].y;
MUL R2.y, R1.w, c[3].x;
MAX R1.w, R2.x, c[6].x;
POW R1.w, R1.w, R2.y;
MUL R1.w, R0, R1;
MUL R0, R0, c[2];
MOV R2.xyz, c[1];
MUL R2.xyz, R2, c[0];
DP3 R1.x, R1, fragment.texcoord[2];
MUL R2.xyz, R2, R1.w;
MAX R1.x, R1, c[6];
MUL R0.xyz, R0, c[0];
MAD R0.xyz, R0, R1.x, R2;
MUL result.color.xyz, R0, c[5].z;
MOV result.color.w, R0;
END
# 41 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
"ps_2_0
; 47 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
mov_pp r1.x, c5
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r1.x, c4, r1
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t1
add r2.x, r3.z, c5.y
rcp r2.x, r2.x
mul r2.xy, r3, r2.x
mad_pp r1.x, r0.w, c4, -r1
mov r3.y, t0.w
mov r3.x, t0.z
mad r3.xy, r1.x, r2, r3
mad r2.xy, r1.x, r2, t0
texld r1, r3, s2
texld r2, r2, s1
mov r1.x, r1.w
mad_pp r4.xy, r1, c5.z, c5.w
mul_pp r1.x, r4.y, r4.y
mov_pp r3.xyz, t2
mad_pp r3.xyz, r0.x, t1, r3
dp3_pp r0.x, r3, r3
mad_pp r1.x, -r4, r4, -r1
add_pp r1.x, r1, c6
rsq_pp r1.x, r1.x
rcp_pp r4.z, r1.x
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r3
dp3_pp r1.x, r4, r1
mov_pp r0.x, c3
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r3, r1.x, r0.x
mov r1.xyz, c0
mov r0.x, r3
mul r0.x, r2.w, r0
mul r2, r2, c2
mul r1.xyz, c1, r1
mul r1.xyz, r1, r0.x
dp3_pp r0.x, r4, t2
max_pp r0.x, r0, c6.y
mul r2.xyz, r2, c0
mad r0.xyz, r2, r0.x, r1
mul r0.xyz, r0, c5.z
mov_pp r0.w, r2
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
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 52 ALU, 5 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.5, 0.41999999, 2, 1 },
		{ 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.z, R0.x;
MUL R1.xyz, R0.z, fragment.texcoord[1];
ADD R0.y, R1.z, c[5];
RCP R0.y, R0.y;
MUL R1.zw, R1.xyxy, R0.y;
MOV R0.x, c[4];
MUL R0.x, R0, c[5];
MAD R0.x, R0.w, c[4], -R0;
MAD R1.xy, R0.x, R1.zwzw, fragment.texcoord[0].zwzw;
MAD R1.zw, R0.x, R1, fragment.texcoord[0].xyxy;
RCP R0.y, fragment.texcoord[3].w;
MAD R0.xy, fragment.texcoord[3], R0.y, c[5].x;
DP3 R3.x, fragment.texcoord[3], fragment.texcoord[3];
TEX R3.yw, R1, texture[2], 2D;
TEX R2, R1.zwzw, texture[1], 2D;
TEX R0.w, R0, texture[3], 2D;
TEX R1.w, R3.x, texture[4], 2D;
MAD R0.xy, R3.wyzw, c[5].z, -c[5].w;
MUL R3.x, R0.y, R0.y;
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[2];
MAD R3.w, -R0.x, R0.x, -R3.x;
MAD R3.xyz, R0.z, fragment.texcoord[1], R1;
ADD R0.z, R3.w, c[5].w;
DP3 R3.w, R3, R3;
RSQ R3.w, R3.w;
MUL R3.xyz, R3.w, R3;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R1.x, R0, R1;
DP3 R3.x, R0, R3;
MOV R3.w, c[6].y;
SLT R1.y, c[6].x, fragment.texcoord[3].z;
MUL R0.w, R1.y, R0;
MUL R0.w, R0, R1;
MUL R3.y, R3.w, c[3].x;
MAX R3.x, R3, c[6];
POW R3.x, R3.x, R3.y;
MUL R3.w, R2, R3.x;
MUL R2, R2, c[2];
MOV R3.xyz, c[1];
MUL R0.xyz, R3, c[0];
MUL R0.xyz, R0, R3.w;
MAX R1.x, R1, c[6];
MUL R2.xyz, R2, c[0];
MUL R0.w, R0, c[5].z;
MAD R0.xyz, R2, R1.x, R0;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, R2;
END
# 52 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"ps_2_0
; 57 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3
mov_pp r1.x, c5
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r1.x, c4, r1
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t1
add r2.x, r3.z, c5.y
rcp r2.x, r2.x
mul r2.xy, r3, r2.x
mad_pp r1.x, r0.w, c4, -r1
mad r5.xy, r1.x, r2, t0
mov r3.y, t0.w
mov r3.x, t0.z
mad r3.xy, r1.x, r2, r3
dp3 r2.x, t3, t3
mov r4.xy, r2.x
rcp r1.x, t3.w
mad r1.xy, t3, r1.x, c5.x
texld r3, r3, s2
texld r1, r1, s3
texld r2, r5, s1
texld r6, r4, s4
mov r3.x, r3.w
mad_pp r4.xy, r3, c5.z, c5.w
dp3_pp r1.x, t2, t2
rsq_pp r3.x, r1.x
mul_pp r3.xyz, r3.x, t2
mul_pp r1.x, r4.y, r4.y
mad_pp r5.xyz, r0.x, t1, r3
mad_pp r1.x, -r4, r4, -r1
add_pp r0.x, r1, c6
dp3_pp r1.x, r5, r5
rsq_pp r0.x, r0.x
rcp_pp r4.z, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, r5
mov_pp r0.x, c3
dp3_pp r1.x, r4, r1
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r5, r1.x, r0.x
dp3_pp r1.x, r4, r3
mov r0.x, r5
mul r0.x, r2.w, r0
mul r2, r2, c2
mov r5.xyz, c0
mul r3.xyz, c1, r5
mul r3.xyz, r3, r0.x
max_pp r0.x, r1, c6.y
cmp r1.x, -t3.z, c6.y, c6
mul r2.xyz, r2, c0
mul r1.x, r1, r1.w
mul r1.x, r1, r6
mul_pp r1.x, r1, c5.z
mad r0.xyz, r2, r0.x, r3
mul r0.xyz, r0, r1.x
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
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 48 ALU, 5 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.5, 0.41999999, 2, 1 },
		{ 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
TEX R1.w, fragment.texcoord[3], texture[4], CUBE;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.z, R0.x;
MUL R1.xyz, R0.z, fragment.texcoord[1];
ADD R0.y, R1.z, c[5];
RCP R0.y, R0.y;
MOV R0.x, c[4];
MUL R0.x, R0, c[5];
MAD R0.w, R0, c[4].x, -R0.x;
MUL R1.xy, R1, R0.y;
MAD R0.xy, R0.w, R1, fragment.texcoord[0].zwzw;
MAD R1.xy, R0.w, R1, fragment.texcoord[0];
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
TEX R2, R1, texture[1], 2D;
TEX R3.yw, R0, texture[2], 2D;
TEX R0.w, R0.w, texture[3], 2D;
MAD R0.xy, R3.wyzw, c[5].z, -c[5].w;
MUL R3.x, R0.y, R0.y;
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R0.w, R0, R1;
MAD R3.w, -R0.x, R0.x, -R3.x;
MUL R1.xyz, R1.x, fragment.texcoord[2];
MAD R3.xyz, R0.z, fragment.texcoord[1], R1;
ADD R0.z, R3.w, c[5].w;
DP3 R3.w, R3, R3;
RSQ R3.w, R3.w;
MUL R3.xyz, R3.w, R3;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R3.x, R0, R3;
MOV R3.w, c[6].y;
DP3 R1.x, R0, R1;
MUL R3.y, R3.w, c[3].x;
MAX R3.x, R3, c[6];
POW R3.x, R3.x, R3.y;
MUL R3.w, R2, R3.x;
MUL R2, R2, c[2];
MOV R3.xyz, c[1];
MUL R0.xyz, R3, c[0];
MUL R0.xyz, R0, R3.w;
MAX R1.x, R1, c[6];
MUL R2.xyz, R2, c[0];
MUL R0.w, R0, c[5].z;
MAD R0.xyz, R2, R1.x, R0;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, R2;
END
# 48 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"ps_2_0
; 53 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
mov_pp r1.x, c5
mov r2.y, t0.w
mov r0.y, t0.w
mov r0.x, t0.z
mul_pp r1.x, c4, r1
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t1
add r2.x, r3.z, c5.y
rcp r2.x, r2.x
mul r4.xy, r3, r2.x
mad_pp r1.x, r0.w, c4, -r1
mov r2.x, t0.z
mad r3.xy, r1.x, r4, r2
mad r4.xy, r1.x, r4, t0
dp3 r2.x, t3, t3
mov r1.xy, r2.x
texld r6, r1, s3
texld r3, r3, s2
texld r1, t3, s4
texld r2, r4, s1
mov r3.x, r3.w
mad_pp r4.xy, r3, c5.z, c5.w
dp3_pp r1.x, t2, t2
rsq_pp r3.x, r1.x
mul_pp r3.xyz, r3.x, t2
mul_pp r1.x, r4.y, r4.y
mad_pp r5.xyz, r0.x, t1, r3
mad_pp r1.x, -r4, r4, -r1
add_pp r0.x, r1, c6
dp3_pp r1.x, r5, r5
rsq_pp r0.x, r0.x
rcp_pp r4.z, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, r5
mov_pp r0.x, c3
dp3_pp r1.x, r4, r1
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r5, r1.x, r0.x
dp3_pp r1.x, r4, r3
mov r0.x, r5
mul r0.x, r2.w, r0
mul r2, r2, c2
mov r5.xyz, c0
mul r3.xyz, c1, r5
mul r3.xyz, r3, r0.x
max_pp r0.x, r1, c6.y
mul r2.xyz, r2, c0
mul r1.x, r6, r1.w
mul_pp r1.x, r1, c5.z
mad r0.xyz, r2, r0.x, r3
mul r0.xyz, r0, r1.x
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
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 43 ALU, 4 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.5, 0.41999999, 2, 1 },
		{ 0, 128 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.w, fragment.texcoord[0].zwzw, texture[0], 2D;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.z, R0.x;
MUL R1.xyz, R0.z, fragment.texcoord[1];
ADD R0.y, R1.z, c[5];
MOV R0.x, c[4];
MUL R1.z, R0.x, c[5].x;
RCP R0.y, R0.y;
MAD R0.w, R0, c[4].x, -R1.z;
MUL R0.xy, R1, R0.y;
MAD R1.xy, R0.w, R0, fragment.texcoord[0];
MAD R0.xy, R0.w, R0, fragment.texcoord[0].zwzw;
TEX R2.yw, R0, texture[2], 2D;
TEX R0.w, fragment.texcoord[3], texture[3], 2D;
TEX R1, R1, texture[1], 2D;
MAD R0.xy, R2.wyzw, c[5].z, -c[5].w;
MUL R2.w, R0.y, R0.y;
MOV R2.xyz, fragment.texcoord[2];
MAD R2.w, -R0.x, R0.x, -R2;
MAD R2.xyz, R0.z, fragment.texcoord[1], R2;
ADD R0.z, R2.w, c[5].w;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R2.x, R0, R2;
MOV R2.w, c[6].y;
MUL R2.y, R2.w, c[3].x;
MAX R2.x, R2, c[6];
POW R2.w, R2.x, R2.y;
MUL R2.w, R1, R2;
MUL R1, R1, c[2];
MOV R2.xyz, c[1];
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R2.w;
DP3 R0.x, R0, fragment.texcoord[2];
MAX R2.w, R0.x, c[6].x;
MUL R0.xyz, R1, c[0];
MUL R0.w, R0, c[5].z;
MAD R0.xyz, R0, R2.w, R2;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, R1;
END
# 43 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Parallax]
SetTexture 0 [_ParallaxMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_BumpMap] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_2_0
; 49 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c5, 0.50000000, 0.41999999, 2.00000000, -1.00000000
def c6, 1.00000000, 0.00000000, 128.00000000, 0
dcl t0
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
mov r4.y, t0.w
mov r4.x, t0.z
mov r0.y, t0.w
mov r0.x, t0.z
texld r0, r0, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, t1
add r1.x, r3.z, c5.y
rcp r2.x, r1.x
mov_pp r1.x, c5
mul r2.xy, r3, r2.x
mul_pp r1.x, c4, r1
mad_pp r1.x, r0.w, c4, -r1
mad r3.xy, r1.x, r2, t0
mad r1.xy, r1.x, r2, r4
mov_pp r4.xyz, t2
mad_pp r4.xyz, r0.x, t1, r4
texld r2, r3, s1
texld r3, r1, s2
texld r1, t3, s3
mov r1.y, r3
mov r1.x, r3.w
mad_pp r3.xy, r1, c5.z, c5.w
mul_pp r1.x, r3.y, r3.y
mad_pp r1.x, -r3, r3, -r1
add_pp r0.x, r1, c6
dp3_pp r1.x, r4, r4
rsq_pp r0.x, r0.x
rcp_pp r3.z, r0.x
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, r4
dp3_pp r1.x, r3, r1
mov_pp r0.x, c3
mul_pp r0.x, c6.z, r0
max_pp r1.x, r1, c6.y
pow r4, r1.x, r0.x
mov r0.x, r4
mul r1.x, r2.w, r0
mul r2, r2, c2
dp3_pp r0.x, r3, t2
mov r4.xyz, c0
mul r3.xyz, c1, r4
mul r3.xyz, r3, r1.x
max_pp r0.x, r0, c6.y
mul r2.xyz, r2, c0
mul_pp r1.x, r1.w, c5.z
mad r0.xyz, r2, r0.x, r3
mul r0.xyz, r0, r1.x
mov_pp r0.w, r2
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

}
	}

#LINE 45

}

FallBack "Transparent/Bumped Specular"
}
