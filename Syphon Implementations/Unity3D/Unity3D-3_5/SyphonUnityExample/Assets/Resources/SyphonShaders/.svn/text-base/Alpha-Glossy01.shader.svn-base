Shader "Syphon/Transparent/Specular" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 0)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_MainTex ("Base (RGB) TransGloss (A)", 2D) = "white" {}
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
//   opengl - ALU: 10 to 60
//   d3d9 - ALU: 10 to 60
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Vector 10 [_WorldSpaceCameraPos]
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
# 31 ALU
PARAM c[19] = { { 1 },
		state.matrix.mvp,
		program.local[5..18] };
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
DP4 R2.z, R0, c[13];
DP4 R2.y, R0, c[12];
DP4 R2.x, R0, c[11];
MUL R0.y, R3.w, R3.w;
MAD R0.y, R0.x, R0.x, -R0;
MOV result.texcoord[1].x, R0;
DP4 R3.z, R1, c[16];
DP4 R3.y, R1, c[15];
DP4 R3.x, R1, c[14];
MUL R1.xyz, R0.y, c[17];
ADD R2.xyz, R2, R3;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[3].xyz, R2, R1;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
ADD result.texcoord[2].xyz, -R0, c[10];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 31 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [_MainTex_ST]
"vs_2_0
; 31 ALU
def c18, 1.00000000, 0, 0, 0
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
mov r0.w, c18.x
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r3.w, r3.w
mad r0.y, r0.x, r0.x, -r0
mov oT1.x, r0
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
mul r1.xyz, r0.y, c16
add r2.xyz, r2, r3
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT3.xyz, r2, r1
mov oT1.z, r2.w
mov oT1.y, r3.w
add oT2.xyz, -r0, c9
mad oT0.xy, v2, c17, c17.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_58;
  tmpvar_58[0] = _Object2World[0].xyz;
  tmpvar_58[1] = _Object2World[1].xyz;
  tmpvar_58[2] = _Object2World[2].xyz;
  vec3 tmpvar_62;
  tmpvar_62 = (tmpvar_58 * (gl_Normal.xyz * unity_Scale.w));
  vec4 tmpvar_67;
  tmpvar_67.xyz = tmpvar_62.xyz;
  tmpvar_67.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_67);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_67))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_67))).z;
  vec4 tmpvar_76;
  tmpvar_76 = (tmpvar_67.xyzz * tmpvar_67.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_76);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_76))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_76))).z;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = tmpvar_62.xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_WorldSpaceCameraPos.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_67.x * tmpvar_67.x) - (tmpvar_67.y * tmpvar_67.y)))).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
}


#endif
#ifdef FRAGMENT
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec4 c;
  vec4 tmpvar_42;
  tmpvar_42 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_44;
  tmpvar_44 = (tmpvar_42.xyz * _Color.xyz);
  float tmpvar_46;
  tmpvar_46 = (tmpvar_42.w * _Color.w);
  vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  vec4 c_i0;
  float tmpvar_61;
  tmpvar_61 = (pow (max (0.0, dot (tmpvar_4, normalize ((lightDir + normalize (gl_TexCoord[2].xyz))))), (_Shininess * 128.0)) * tmpvar_42.w);
  c_i0.xyz = ((((tmpvar_44 * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, lightDir))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_61)) * 2.0).xyz;
  c_i0.w = (vec4((tmpvar_46 + ((_LightColor0.w * _SpecColor.w) * tmpvar_61)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_44 * gl_TexCoord[3].xyz)).xyz;
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
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 10 ALU
PARAM c[12] = { program.local[0],
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, -R0, c[9];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[10], c[10].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 10 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 9 [unity_LightmapST]
Vector 10 [_MainTex_ST]
"vs_2_0
; 10 ALU
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT2.xyz, -r0, c8
mad oT0.xy, v2, c10, c10.zwzw
mad oT3.xy, v3, c9, c9.zwzw
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
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (_WorldSpaceCameraPos.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[2] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xy = ((gl_MultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw).xy;
  tmpvar_21.z = 0.0;
  tmpvar_21.w = 0.0;
  gl_TexCoord[3] = tmpvar_21;
}


#endif
#ifdef FRAGMENT
uniform sampler2D unity_Lightmap;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _Color;
void main ()
{
  vec4 c;
  vec4 tmpvar_27;
  tmpvar_27 = texture2D (_MainTex, gl_TexCoord[0].xy);
  float tmpvar_31;
  tmpvar_31 = (tmpvar_27.w * _Color.w);
  c.xyz = ((tmpvar_27.xyz * _Color.xyz) * (2.0 * texture2D (unity_Lightmap, gl_TexCoord[3].xy).xyz)).xyz;
  c.w = (vec4(tmpvar_31)).w;
  c.w = (vec4(tmpvar_31)).w;
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
Vector 10 [_WorldSpaceCameraPos]
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
# 60 ALU
PARAM c[27] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[9].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[12];
DP3 R4.z, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[11];
DP4 R4.xy, vertex.position, c[7];
MUL R2, R2, R2;
MOV R5.z, R3.x;
MOV R5.y, R4.z;
MOV R5.w, c[0].x;
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[13];
MAD R2, R1, R1, R2;
MAD R0, R3.x, R1, R0;
MUL R1, R2, c[14];
ADD R1, R1, c[0].x;
MOV result.texcoord[1].z, R3.x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[21];
DP4 R2.y, R5, c[20];
DP4 R2.x, R5, c[19];
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
MUL R0, R5.xyzz, R5.yzzx;
MUL R1.w, R4.z, R4.z;
DP4 R5.w, R0, c[24];
DP4 R5.z, R0, c[23];
DP4 R5.y, R0, c[22];
MAD R1.w, R5.x, R5.x, -R1;
MUL R0.xyz, R1.w, c[25];
ADD R2.xyz, R2, R5.yzww;
ADD R0.xyz, R2, R0;
MOV R3.x, R4.w;
MOV R3.y, R4;
ADD result.texcoord[3].xyz, R0, R1;
MOV result.texcoord[1].y, R4.z;
MOV result.texcoord[1].x, R5;
ADD result.texcoord[2].xyz, -R3.wxyw, c[10];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[26], c[26].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 60 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
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
"vs_2_0
; 60 ALU
def c26, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c8.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c11
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c10
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c26.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c12
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c13
add r1, r1, c26.x
mov oT1.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c20
dp4 r2.y, r5, c19
dp4 r2.x, r5, c18
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c26.y
mul r0, r0, r1
mul r1.xyz, r0.y, c15
mad r1.xyz, r0.x, c14, r1
mad r0.xyz, r0.z, c16, r1
mad r1.xyz, r0.w, c17, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c23
dp4 r5.z, r0, c22
dp4 r5.y, r0, c21
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c24
add r2.xyz, r2, r5.yzww
add r0.xyz, r2, r0
mov r3.x, r4.w
mov r3.y, r4
add oT3.xyz, r0, r1
mov oT1.y, r4.z
mov oT1.x, r5
add oT2.xyz, -r3.wxyw, c9
mad oT0.xy, v2, c25, c25.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_81;
  tmpvar_81[0] = _Object2World[0].xyz;
  tmpvar_81[1] = _Object2World[1].xyz;
  tmpvar_81[2] = _Object2World[2].xyz;
  vec3 tmpvar_85;
  tmpvar_85 = (tmpvar_81 * (gl_Normal.xyz * unity_Scale.w));
  vec4 tmpvar_90;
  tmpvar_90.xyz = tmpvar_85.xyz;
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
  vec3 tmpvar_110;
  tmpvar_110 = (_Object2World * tmpvar_1).xyz;
  vec4 tmpvar_113;
  tmpvar_113 = (unity_4LightPosX0 - tmpvar_110.x);
  vec4 tmpvar_114;
  tmpvar_114 = (unity_4LightPosY0 - tmpvar_110.y);
  vec4 tmpvar_115;
  tmpvar_115 = (unity_4LightPosZ0 - tmpvar_110.z);
  vec4 tmpvar_119;
  tmpvar_119 = (((tmpvar_113 * tmpvar_113) + (tmpvar_114 * tmpvar_114)) + (tmpvar_115 * tmpvar_115));
  vec4 tmpvar_129;
  tmpvar_129 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_113 * tmpvar_85.x) + (tmpvar_114 * tmpvar_85.y)) + (tmpvar_115 * tmpvar_85.z)) * inversesqrt (tmpvar_119))) * 1.0/((1.0 + (tmpvar_119 * unity_4LightAtten0))));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = tmpvar_85.xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_WorldSpaceCameraPos.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_90.x * tmpvar_90.x) - (tmpvar_90.y * tmpvar_90.y)))) + ((((unity_LightColor0 * tmpvar_129.x) + (unity_LightColor1 * tmpvar_129.y)) + (unity_LightColor2 * tmpvar_129.z)) + (unity_LightColor3 * tmpvar_129.w))).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
}


#endif
#ifdef FRAGMENT
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec4 c;
  vec4 tmpvar_42;
  tmpvar_42 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_44;
  tmpvar_44 = (tmpvar_42.xyz * _Color.xyz);
  float tmpvar_46;
  tmpvar_46 = (tmpvar_42.w * _Color.w);
  vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  vec4 c_i0;
  float tmpvar_61;
  tmpvar_61 = (pow (max (0.0, dot (tmpvar_4, normalize ((lightDir + normalize (gl_TexCoord[2].xyz))))), (_Shininess * 128.0)) * tmpvar_42.w);
  c_i0.xyz = ((((tmpvar_44 * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, lightDir))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_61)) * 2.0).xyz;
  c_i0.w = (vec4((tmpvar_46 + ((_LightColor0.w * _SpecColor.w) * tmpvar_61)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_44 * gl_TexCoord[3].xyz)).xyz;
  c.w = (vec4(tmpvar_46)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 2
//   opengl - ALU: 7 to 25, TEX: 1 to 2
//   d3d9 - ALU: 6 to 28, TEX: 1 to 2
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 25 ALU, 1 TEX
PARAM c[6] = { program.local[0..4],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MAD R1.xyz, R1.x, fragment.texcoord[2], c[0];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, fragment.texcoord[1], R1;
MOV R1.w, c[5].y;
MUL R1.y, R1.w, c[4].x;
MAX R1.x, R1, c[5];
POW R1.w, R1.x, R1.y;
MUL R1.w, R0, R1;
MUL R0, R0, c[3];
MOV R1.xyz, c[2];
MUL R1.xyz, R1, c[1];
MUL R2.xyz, R1, R1.w;
MUL R1.xyz, R0, c[1];
DP3 R1.w, fragment.texcoord[1], c[0];
MAX R1.w, R1, c[5].x;
MAD R1.xyz, R1, R1.w, R2;
MUL R0.xyz, R0, fragment.texcoord[3];
MUL R1.xyz, R1, c[5].z;
ADD result.color.xyz, R1, R0;
MOV result.color.w, R0;
END
# 25 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 28 ALU, 1 TEX
dcl_2d s0
def c5, 0.00000000, 128.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mad_pp r1.xyz, r0.x, t2, c0
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r1
dp3_pp r1.x, t1, r1
mov_pp r0.x, c4
mul_pp r0.x, c5.y, r0
max_pp r1.x, r1, c5
pow r3, r1.x, r0.x
mov r0.x, r3
mov r1.xyz, c1
mul r0.x, r2.w, r0
mul r1.xyz, c2, r1
mul r3.xyz, r1, r0.x
mul r1, r2, c3
mul r2.xyz, r1, c1
dp3_pp r0.x, t1, c0
max_pp r0.x, r0, c5
mad r0.xyz, r2, r0.x, r3
mul r1.xyz, r1, t3
mul r0.xyz, r0, c5.z
add_pp r0.xyz, r0, r1
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
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1, fragment.texcoord[3], texture[1], 2D;
MUL R0, R0, c[0];
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R1, R0;
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
dcl t3.xy
texld r1, t0, s0
texld r0, t3, s1
mul r1, r1, c0
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r1
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
//   opengl - ALU: 14 to 19
//   d3d9 - ALU: 14 to 19
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 18 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[15];
ADD result.texcoord[3].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
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
dp4 oT4.z, r0, c10
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c14
add oT3.xyz, -r0, c13
mad oT0.xy, v2, c15, c15.zwzw
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
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_46;
  tmpvar_46[0] = _Object2World[0].xyz;
  tmpvar_46[1] = _Object2World[1].xyz;
  tmpvar_46[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_46 * (gl_Normal.xyz * unity_Scale.w)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_WorldSpaceLightPos0.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (_WorldSpaceCameraPos.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
  vec4 tmpvar_25;
  tmpvar_25.xyz = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyz;
  tmpvar_25.w = 0.0;
  gl_TexCoord[4] = tmpvar_25;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_10;
  tmpvar_10 = gl_TexCoord[4].xyz;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = texture2D (_MainTex, gl_TexCoord[0].xy);
  float tmpvar_47;
  tmpvar_47 = (tmpvar_43.w * _Color.w);
  vec3 tmpvar_50;
  tmpvar_50 = normalize (gl_TexCoord[2].xyz);
  float atten;
  atten = texture2D (_LightTexture0, vec2(dot (tmpvar_10, tmpvar_10))).w;
  vec4 c_i0;
  float tmpvar_69;
  tmpvar_69 = (pow (max (0.0, dot (tmpvar_4, normalize ((tmpvar_50 + normalize (gl_TexCoord[3].xyz))))), (_Shininess * 128.0)) * tmpvar_43.w);
  c_i0.xyz = (((((tmpvar_43.xyz * _Color.xyz) * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, tmpvar_50))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_69)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_47 + (((_LightColor0.w * _SpecColor.w) * tmpvar_69) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_47)).w;
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
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 12 [_MainTex_ST]
"!!ARBvp1.0
# 14 ALU
PARAM c[13] = { program.local[0],
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[2].xyz, c[11];
ADD result.texcoord[3].xyz, -R0, c[10];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 14 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 11 [_MainTex_ST]
"vs_2_0
; 14 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c8.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov oT2.xyz, c10
add oT3.xyz, -r0, c9
mad oT0.xy, v2, c11, c11.zwzw
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
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_44;
  tmpvar_44[0] = _Object2World[0].xyz;
  tmpvar_44[1] = _Object2World[1].xyz;
  tmpvar_44[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_44 * (gl_Normal.xyz * unity_Scale.w)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = _WorldSpaceLightPos0.xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (_WorldSpaceCameraPos.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform vec4 _LightColor0;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 c;
  vec4 tmpvar_41;
  tmpvar_41 = texture2D (_MainTex, gl_TexCoord[0].xy);
  float tmpvar_45;
  tmpvar_45 = (tmpvar_41.w * _Color.w);
  vec4 c_i0;
  float tmpvar_61;
  tmpvar_61 = (pow (max (0.0, dot (tmpvar_4, normalize ((tmpvar_6 + normalize (gl_TexCoord[3].xyz))))), (_Shininess * 128.0)) * tmpvar_41.w);
  c_i0.xyz = (((((tmpvar_41.xyz * _Color.xyz) * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_61)) * 2.0).xyz;
  c_i0.w = (vec4((tmpvar_45 + ((_LightColor0.w * _SpecColor.w) * tmpvar_61)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_45)).w;
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
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 19 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].w, R0, c[12];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[15];
ADD result.texcoord[3].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_2_0
; 19 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT4.w, r0, c11
dp4 oT4.z, r0, c10
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c14
add oT3.xyz, -r0, c13
mad oT0.xy, v2, c15, c15.zwzw
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
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_46;
  tmpvar_46[0] = _Object2World[0].xyz;
  tmpvar_46[1] = _Object2World[1].xyz;
  tmpvar_46[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_46 * (gl_Normal.xyz * unity_Scale.w)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_WorldSpaceLightPos0.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (_WorldSpaceCameraPos.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
  gl_TexCoord[4] = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyzw;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec4 tmpvar_10;
  tmpvar_10 = gl_TexCoord[4].xyzw;
  vec4 c;
  vec4 tmpvar_50;
  tmpvar_50 = texture2D (_MainTex, gl_TexCoord[0].xy);
  float tmpvar_54;
  tmpvar_54 = (tmpvar_50.w * _Color.w);
  vec3 tmpvar_57;
  tmpvar_57 = normalize (gl_TexCoord[2].xyz);
  vec3 LightCoord_i0;
  LightCoord_i0 = tmpvar_10.xyz;
  float atten;
  atten = ((float((tmpvar_10.z > 0.0)) * texture2D (_LightTexture0, ((tmpvar_10.xy / tmpvar_10.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w);
  vec4 c_i0;
  float tmpvar_81;
  tmpvar_81 = (pow (max (0.0, dot (tmpvar_4, normalize ((tmpvar_57 + normalize (gl_TexCoord[3].xyz))))), (_Shininess * 128.0)) * tmpvar_50.w);
  c_i0.xyz = (((((tmpvar_50.xyz * _Color.xyz) * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, tmpvar_57))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_81)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_54 + (((_LightColor0.w * _SpecColor.w) * tmpvar_81) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_54)).w;
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
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 18 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[15];
ADD result.texcoord[3].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
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
dp4 oT4.z, r0, c10
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c14
add oT3.xyz, -r0, c13
mad oT0.xy, v2, c15, c15.zwzw
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
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_46;
  tmpvar_46[0] = _Object2World[0].xyz;
  tmpvar_46[1] = _Object2World[1].xyz;
  tmpvar_46[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_46 * (gl_Normal.xyz * unity_Scale.w)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_WorldSpaceLightPos0.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (_WorldSpaceCameraPos.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
  vec4 tmpvar_25;
  tmpvar_25.xyz = (_LightMatrix0 * (_Object2World * tmpvar_1)).xyz;
  tmpvar_25.w = 0.0;
  gl_TexCoord[4] = tmpvar_25;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_10;
  tmpvar_10 = gl_TexCoord[4].xyz;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = texture2D (_MainTex, gl_TexCoord[0].xy);
  float tmpvar_47;
  tmpvar_47 = (tmpvar_43.w * _Color.w);
  vec3 tmpvar_50;
  tmpvar_50 = normalize (gl_TexCoord[2].xyz);
  float atten;
  atten = (texture2D (_LightTextureB0, vec2(dot (tmpvar_10, tmpvar_10))).w * textureCube (_LightTexture0, tmpvar_10).w);
  vec4 c_i0;
  float tmpvar_70;
  tmpvar_70 = (pow (max (0.0, dot (tmpvar_4, normalize ((tmpvar_50 + normalize (gl_TexCoord[3].xyz))))), (_Shininess * 128.0)) * tmpvar_43.w);
  c_i0.xyz = (((((tmpvar_43.xyz * _Color.xyz) * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, tmpvar_50))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_70)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_47 + (((_LightColor0.w * _SpecColor.w) * tmpvar_70) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_47)).w;
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
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 17 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
MOV result.texcoord[2].xyz, c[15];
ADD result.texcoord[3].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
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
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
mov oT2.xyz, c14
add oT3.xyz, -r0, c13
mad oT0.xy, v2, c15, c15.zwzw
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
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
uniform mat4 _LightMatrix0;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  mat3 tmpvar_46;
  tmpvar_46[0] = _Object2World[0].xyz;
  tmpvar_46[1] = _Object2World[1].xyz;
  tmpvar_46[2] = _Object2World[2].xyz;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_1).xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = (tmpvar_46 * (gl_Normal.xyz * unity_Scale.w)).xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = _WorldSpaceLightPos0.xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (_WorldSpaceCameraPos.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
  vec4 tmpvar_25;
  tmpvar_25.xy = (_LightMatrix0 * (_Object2World * tmpvar_1)).xy;
  tmpvar_25.z = 0.0;
  tmpvar_25.w = 0.0;
  gl_TexCoord[4] = tmpvar_25;
}


#endif
#ifdef FRAGMENT
uniform vec4 _SpecColor;
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform vec4 _LightColor0;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = texture2D (_MainTex, gl_TexCoord[0].xy);
  float tmpvar_47;
  tmpvar_47 = (tmpvar_43.w * _Color.w);
  float atten;
  atten = texture2D (_LightTexture0, gl_TexCoord[4].xy).w;
  vec4 c_i0;
  float tmpvar_64;
  tmpvar_64 = (pow (max (0.0, dot (tmpvar_4, normalize ((tmpvar_6 + normalize (gl_TexCoord[3].xyz))))), (_Shininess * 128.0)) * tmpvar_43.w);
  c_i0.xyz = (((((tmpvar_43.xyz * _Color.xyz) * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_64)) * (atten * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_47 + (((_LightColor0.w * _SpecColor.w) * tmpvar_64) * atten)))).w;
  c = c_i0;
  c.w = (vec4(tmpvar_47)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 24 to 35, TEX: 1 to 3
//   d3d9 - ALU: 28 to 37, TEX: 1 to 3
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 29 ALU, 2 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
DP3 R1.x, fragment.texcoord[4], fragment.texcoord[4];
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R2.x, R2.x;
TEX R1.w, R1.x, texture[1], 2D;
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[2];
MAD R2.xyz, R2.x, fragment.texcoord[3], R1;
DP3 R1.x, fragment.texcoord[1], R1;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
DP3 R2.x, fragment.texcoord[1], R2;
MOV R2.w, c[4].y;
MUL R2.y, R2.w, c[3].x;
MAX R2.x, R2, c[4];
POW R2.w, R2.x, R2.y;
MUL R2.w, R0, R2;
MUL R0, R0, c[2];
MOV R2.xyz, c[1];
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R2.w;
MUL R0.xyz, R0, c[0];
MAX R1.x, R1, c[4];
MUL R1.y, R1.w, c[4].z;
MAD R0.xyz, R0, R1.x, R2;
MUL result.color.xyz, R0, R1.y;
MOV result.color.w, R0;
END
# 29 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 32 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00000000, 128.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r2, t0, s0
dp3 r0.x, t4, t4
mov r0.xy, r0.x
texld r5, r0, s1
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r0.x
dp3_pp r0.x, t3, t3
mul_pp r3.xyz, r1.x, t2
rsq_pp r0.x, r0.x
mad_pp r1.xyz, r0.x, t3, r3
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r1
dp3_pp r1.x, t1, r1
mov_pp r0.x, c3
mul_pp r0.x, c4.y, r0
max_pp r1.x, r1, c4
pow r4, r1.x, r0.x
mov r0.x, r4
mul r0.x, r2.w, r0
mul r2, r2, c2
mov r1.xyz, c0
mul r1.xyz, c1, r1
mul r4.xyz, r1, r0.x
dp3_pp r1.x, t1, r3
mul_pp r0.x, r5, c4.z
mul r2.xyz, r2, c0
max_pp r1.x, r1, c4
mad r1.xyz, r2, r1.x, r4
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
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 24 ALU, 1 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
DP3 R1.w, fragment.texcoord[3], fragment.texcoord[3];
MOV R1.xyz, fragment.texcoord[2];
RSQ R1.w, R1.w;
MAD R2.xyz, R1.w, fragment.texcoord[3], R1;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
DP3 R1.x, fragment.texcoord[1], R1;
DP3 R2.x, fragment.texcoord[1], R2;
MOV R1.w, c[4].y;
MUL R2.y, R1.w, c[3].x;
MAX R1.w, R2.x, c[4].x;
POW R1.w, R1.w, R2.y;
MUL R1.w, R0, R1;
MUL R0, R0, c[2];
MOV R2.xyz, c[1];
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R1.w;
MUL R0.xyz, R0, c[0];
MAX R1.x, R1, c[4];
MAD R0.xyz, R0, R1.x, R2;
MUL result.color.xyz, R0, c[4].z;
MOV result.color.w, R0;
END
# 24 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 28 ALU, 1 TEX
dcl_2d s0
def c4, 0.00000000, 128.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r1, t0, s0
dp3_pp r0.x, t3, t3
rsq_pp r0.x, r0.x
mov_pp r2.xyz, t2
mad_pp r2.xyz, r0.x, t3, r2
dp3_pp r0.x, r2, r2
rsq_pp r0.x, r0.x
mul_pp r2.xyz, r0.x, r2
dp3_pp r2.x, t1, r2
mov_pp r0.x, c3
mul_pp r0.x, c4.y, r0
max_pp r2.x, r2, c4
pow r3, r2.x, r0.x
mov r2.xyz, c0
mov r0.x, r3
mul r0.x, r1.w, r0
mul r1, r1, c2
mul r2.xyz, c1, r2
mul r2.xyz, r2, r0.x
mov_pp r0.xyz, t2
dp3_pp r0.x, t1, r0
mul r1.xyz, r1, c0
max_pp r0.x, r0, c4
mad r0.xyz, r1, r0.x, r2
mul r0.xyz, r0, c4.z
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
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 35 ALU, 3 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 128, 0.5, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[0], texture[0], 2D;
DP3 R0.z, fragment.texcoord[4], fragment.texcoord[4];
RCP R0.x, fragment.texcoord[4].w;
MAD R0.xy, fragment.texcoord[4], R0.x, c[4].z;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
TEX R0.w, R0, texture[1], 2D;
TEX R1.w, R0.z, texture[2], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
MAD R1.xyz, R1.x, fragment.texcoord[3], R0;
DP3 R0.x, fragment.texcoord[1], R0;
DP3 R3.x, R1, R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R1;
DP3 R1.x, fragment.texcoord[1], R1;
MOV R3.x, c[4].y;
SLT R0.y, c[4].x, fragment.texcoord[4].z;
MUL R0.y, R0, R0.w;
MUL R0.y, R0, R1.w;
MUL R1.y, R3.x, c[3].x;
MAX R1.x, R1, c[4];
POW R1.x, R1.x, R1.y;
MUL R3.x, R2.w, R1;
MUL R2, R2, c[2];
MOV R1.xyz, c[1];
MUL R1.xyz, R1, c[0];
MUL R0.w, R0.y, c[4];
MUL R1.xyz, R1, R3.x;
MUL R2.xyz, R2, c[0];
MAX R0.x, R0, c[4];
MAD R0.xyz, R2, R0.x, R1;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, R2;
END
# 35 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_2_0
; 37 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c4, 0.00000000, 128.00000000, 1.00000000, 0.50000000
def c5, 2.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4
texld r2, t0, s0
dp3 r1.x, t4, t4
mov r1.xy, r1.x
rcp r0.x, t4.w
mad r0.xy, t4, r0.x, c4.w
texld r0, r0, s1
texld r5, r1, s2
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r0.x
dp3_pp r0.x, t3, t3
mul_pp r3.xyz, r1.x, t2
rsq_pp r0.x, r0.x
mad_pp r1.xyz, r0.x, t3, r3
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r1
dp3_pp r1.x, t1, r1
mov_pp r0.x, c3
mul_pp r0.x, c4.y, r0
max_pp r1.x, r1, c4
pow r4, r1.x, r0.x
mov r1.x, r4
mul r1.x, r2.w, r1
mul r2, r2, c2
cmp r0.x, -t4.z, c4, c4.z
mul r0.x, r0, r0.w
mul r0.x, r0, r5
mov r4.xyz, c0
mul r4.xyz, c1, r4
mul r4.xyz, r4, r1.x
dp3_pp r1.x, t1, r3
mul_pp r0.x, r0, c5
mul r2.xyz, r2, c0
max_pp r1.x, r1, c4
mad r1.xyz, r2, r1.x, r4
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
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 31 ALU, 3 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[4], texture[2], CUBE;
DP3 R0.x, fragment.texcoord[4], fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
TEX R0.w, R0.x, texture[1], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
MAD R1.xyz, R1.x, fragment.texcoord[3], R0;
DP3 R0.x, fragment.texcoord[1], R0;
MUL R0.y, R0.w, R1.w;
DP3 R3.x, R1, R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R1;
DP3 R1.x, fragment.texcoord[1], R1;
MOV R3.x, c[4].y;
MUL R1.y, R3.x, c[3].x;
MAX R1.x, R1, c[4];
POW R1.x, R1.x, R1.y;
MUL R3.x, R2.w, R1;
MUL R2, R2, c[2];
MOV R1.xyz, c[1];
MUL R1.xyz, R1, c[0];
MUL R0.w, R0.y, c[4].z;
MUL R1.xyz, R1, R3.x;
MUL R2.xyz, R2, c[0];
MAX R0.x, R0, c[4];
MAD R0.xyz, R2, R0.x, R1;
MUL result.color.xyz, R0, R0.w;
MOV result.color.w, R2;
END
# 31 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_2_0
; 33 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c4, 0.00000000, 128.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r2, t0, s0
dp3 r0.x, t4, t4
mov r0.xy, r0.x
texld r5, r0, s1
texld r0, t4, s2
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r0.x
dp3_pp r0.x, t3, t3
mul_pp r3.xyz, r1.x, t2
rsq_pp r0.x, r0.x
mad_pp r1.xyz, r0.x, t3, r3
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r1
dp3_pp r1.x, t1, r1
mov_pp r0.x, c3
mul_pp r0.x, c4.y, r0
max_pp r1.x, r1, c4
pow r4, r1.x, r0.x
mov r1.x, r4
mul r1.x, r2.w, r1
mul r2, r2, c2
mov r4.xyz, c0
mul r4.xyz, c1, r4
mul r4.xyz, r4, r1.x
dp3_pp r1.x, t1, r3
mul r0.x, r5, r0.w
mul_pp r0.x, r0, c4.z
mul r2.xyz, r2, c0
max_pp r1.x, r1, c4
mad r1.xyz, r2, r1.x, r4
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
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 26 ALU, 2 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[4], texture[1], 2D;
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
MOV R1.xyz, fragment.texcoord[2];
RSQ R2.x, R2.x;
MAD R2.xyz, R2.x, fragment.texcoord[3], R1;
DP3 R1.x, fragment.texcoord[1], R1;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
DP3 R2.x, fragment.texcoord[1], R2;
MOV R2.w, c[4].y;
MUL R2.y, R2.w, c[3].x;
MAX R2.x, R2, c[4];
POW R2.w, R2.x, R2.y;
MUL R2.w, R0, R2;
MUL R0, R0, c[2];
MOV R2.xyz, c[1];
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R2.w;
MUL R0.xyz, R0, c[0];
MAX R1.x, R1, c[4];
MUL R1.y, R1.w, c[4].z;
MAD R0.xyz, R0, R1.x, R2;
MUL result.color.xyz, R0, R1.y;
MOV result.color.w, R0;
END
# 26 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 29 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00000000, 128.00000000, 2.00000000, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xy
texld r0, t4, s1
texld r1, t0, s0
dp3_pp r0.x, t3, t3
mov_pp r2.xyz, t2
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, t3, r2
dp3_pp r2.x, r0, r0
rsq_pp r2.x, r2.x
mul_pp r0.xyz, r2.x, r0
dp3_pp r0.x, t1, r0
mov_pp r2.x, c3
mul_pp r2.x, c4.y, r2
max_pp r0.x, r0, c4
pow r3, r0.x, r2.x
mov r0.x, r3
mul r0.x, r1.w, r0
mul r1, r1, c2
mov r2.xyz, c0
mov_pp r3.xyz, t2
dp3_pp r3.x, t1, r3
mul r2.xyz, c1, r2
mul r0.xyz, r2, r0.x
mul_pp r2.x, r0.w, c4.z
mul r1.xyz, r1, c0
max_pp r3.x, r3, c4
mad r0.xyz, r1, r3.x, r0
mul r0.xyz, r0, r2.x
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

#LINE 31

}

Fallback "Transparent/VertexLit"
}
