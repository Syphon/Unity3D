Shader "Syphon/Transparent/Cutout/Specular" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 0)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_MainTex ("Base (RGB) TransGloss (A)", 2D) = "white" {}
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
//   opengl - ALU: 10 to 66
//   d3d9 - ALU: 10 to 66
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
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
  vec4 tmpvar_42;
  tmpvar_42 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_44;
  tmpvar_44 = (tmpvar_42.xyz * _Color.xyz);
  float tmpvar_45;
  tmpvar_45 = tmpvar_42.w;
  float tmpvar_46;
  tmpvar_46 = (tmpvar_42.w * _Color.w);
  float x;
  x = (tmpvar_46 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  vec4 c_i0;
  float tmpvar_61;
  tmpvar_61 = (pow (max (0.0, dot (tmpvar_4, normalize ((lightDir + normalize (tmpvar_6.xyz))))), (_Shininess * 128.0)) * tmpvar_45);
  c_i0.xyz = ((((tmpvar_44 * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, lightDir))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_61)) * 2.0).xyz;
  c_i0.w = (vec4((tmpvar_46 + ((_LightColor0.w * _SpecColor.w) * tmpvar_61)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_44 * tmpvar_8)).xyz;
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
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
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
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_OFF" }
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
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec2 tmpvar_6;
  tmpvar_6 = gl_TexCoord[3].xy;
  vec4 c;
  vec4 tmpvar_27;
  tmpvar_27 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_27.xyz * _Color.xyz);
  float tmpvar_31;
  tmpvar_31 = (tmpvar_27.w * _Color.w);
  float x;
  x = (tmpvar_31 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  c.xyz = (tmpvar_29 * (2.0 * texture2D (unity_Lightmap, tmpvar_6).xyz)).xyz;
  c.w = (vec4(tmpvar_31)).w;
  c.w = (vec4(tmpvar_31)).w;
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
Vector 11 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Vector 12 [unity_SHAr]
Vector 13 [unity_SHAg]
Vector 14 [unity_SHAb]
Vector 15 [unity_SHBr]
Vector 16 [unity_SHBg]
Vector 17 [unity_SHBb]
Vector 18 [unity_SHC]
Vector 19 [_MainTex_ST]
"!!ARBvp1.0
# 36 ALU
PARAM c[20] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..19] };
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
DP4 R2.z, R1.wxyz, c[14];
DP4 R2.y, R1.wxyz, c[13];
DP4 R2.x, R1.wxyz, c[12];
DP4 R1.z, R0, c[17];
DP4 R1.y, R0, c[16];
DP4 R1.x, R0, c[15];
MUL R3.x, R3.w, R3.w;
MAD R0.x, R1.w, R1.w, -R3;
ADD R3.xyz, R2, R1;
MUL R2.xyz, R0.x, c[18];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MOV result.position, R0;
MUL R1.y, R1, c[9].x;
MOV result.texcoord[4].zw, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[3].xyz, R3, R2;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R1.w;
ADD result.texcoord[2].xyz, -R0, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[19], c[19].zwzw;
END
# 36 instructions, 4 R-regs
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
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [unity_SHAr]
Vector 13 [unity_SHAg]
Vector 14 [unity_SHAb]
Vector 15 [unity_SHBr]
Vector 16 [unity_SHBg]
Vector 17 [unity_SHBb]
Vector 18 [unity_SHC]
Vector 19 [_MainTex_ST]
"vs_2_0
; 36 ALU
def c20, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c10.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c20.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c14
dp4 r2.y, r1.wxyz, c13
dp4 r2.x, r1.wxyz, c12
dp4 r1.z, r0, c17
dp4 r1.y, r0, c16
dp4 r1.x, r0, c15
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c18
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c20.y
mov oPos, r0
mul r1.y, r1, c8.x
mov oT4.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT3.xyz, r3, r2
mad oT4.xy, r1.z, c9.zwzw, r1
mov oT1.z, r2.w
mov oT1.y, r3.w
mov oT1.x, r1.w
add oT2.xyz, -r0, c11
mad oT0.xy, v2, c19, c19.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  vec4 tmpvar_58;
  tmpvar_58 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  mat3 tmpvar_65;
  tmpvar_65[0] = _Object2World[0].xyz;
  tmpvar_65[1] = _Object2World[1].xyz;
  tmpvar_65[2] = _Object2World[2].xyz;
  vec3 tmpvar_69;
  tmpvar_69 = (tmpvar_65 * (gl_Normal.xyz * unity_Scale.w));
  vec4 tmpvar_74;
  tmpvar_74.xyz = tmpvar_69.xyz;
  tmpvar_74.w = 1.0;
  vec3 x2;
  vec3 x1;
  x1.x = dot (unity_SHAr, tmpvar_74);
  x1.y = (vec2(dot (unity_SHAg, tmpvar_74))).y;
  x1.z = (vec3(dot (unity_SHAb, tmpvar_74))).z;
  vec4 tmpvar_83;
  tmpvar_83 = (tmpvar_74.xyzz * tmpvar_74.yzzx);
  x2.x = dot (unity_SHBr, tmpvar_83);
  x2.y = (vec2(dot (unity_SHBg, tmpvar_83))).y;
  x2.z = (vec3(dot (unity_SHBb, tmpvar_83))).z;
  vec4 o_i0;
  vec4 tmpvar_96;
  tmpvar_96 = (tmpvar_58 * 0.5);
  o_i0 = tmpvar_96;
  vec2 tmpvar_97;
  tmpvar_97.x = tmpvar_96.x;
  tmpvar_97.y = (vec2((tmpvar_96.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_97 + tmpvar_96.w);
  o_i0.zw = tmpvar_58.zw;
  gl_Position = tmpvar_58.xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = tmpvar_69.xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_WorldSpaceCameraPos.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = ((x1 + x2) + (unity_SHC.xyz * ((tmpvar_74.x * tmpvar_74.x) - (tmpvar_74.y * tmpvar_74.y)))).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
  gl_TexCoord[4] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 tmpvar_10;
  tmpvar_10 = gl_TexCoord[4].xyzw;
  vec4 c;
  vec4 tmpvar_46;
  tmpvar_46 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_48;
  tmpvar_48 = (tmpvar_46.xyz * _Color.xyz);
  float tmpvar_49;
  tmpvar_49 = tmpvar_46.w;
  float tmpvar_50;
  tmpvar_50 = (tmpvar_46.w * _Color.w);
  float x;
  x = (tmpvar_50 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  float tmpvar_55;
  tmpvar_55 = texture2DProj (_ShadowMapTexture, tmpvar_10).x;
  vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  vec4 c_i0;
  float tmpvar_70;
  tmpvar_70 = (pow (max (0.0, dot (tmpvar_4, normalize ((lightDir + normalize (tmpvar_6.xyz))))), (_Shininess * 128.0)) * tmpvar_49);
  c_i0.xyz = ((((tmpvar_48 * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, lightDir))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_70)) * (tmpvar_55 * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_50 + (((_LightColor0.w * _SpecColor.w) * tmpvar_70) * tmpvar_55)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_48 * tmpvar_8)).xyz;
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
Vector 10 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Vector 11 [unity_LightmapST]
Vector 12 [_MainTex_ST]
"!!ARBvp1.0
# 15 ALU
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
MOV result.position, R0;
MUL R1.y, R1, c[9].x;
MOV result.texcoord[4].zw, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[4].xy, R1, R1.z;
ADD result.texcoord[2].xyz, -R0, c[10];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[11], c[11].zwzw;
END
# 15 instructions, 2 R-regs
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
Vector 10 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 11 [unity_LightmapST]
Vector 12 [_MainTex_ST]
"vs_2_0
; 15 ALU
def c13, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c13.x
mov oPos, r0
mul r1.y, r1, c8.x
mov oT4.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mad oT4.xy, r1.z, c9.zwzw, r1
add oT2.xyz, -r0, c10
mad oT0.xy, v2, c12, c12.zwzw
mad oT3.xy, v3, c11, c11.zwzw
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
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  vec4 tmpvar_40;
  tmpvar_40 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  vec4 o_i0;
  vec4 tmpvar_58;
  tmpvar_58 = (tmpvar_40 * 0.5);
  o_i0 = tmpvar_58;
  vec2 tmpvar_59;
  tmpvar_59.x = tmpvar_58.x;
  tmpvar_59.y = (vec2((tmpvar_58.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_59 + tmpvar_58.w);
  o_i0.zw = tmpvar_40.zw;
  gl_Position = tmpvar_40.xyzw;
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
void main ()
{
  vec2 tmpvar_6;
  tmpvar_6 = gl_TexCoord[3].xy;
  vec4 tmpvar_8;
  tmpvar_8 = gl_TexCoord[4].xyzw;
  vec4 c;
  vec4 tmpvar_31;
  tmpvar_31 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_31.xyz * _Color.xyz);
  float tmpvar_35;
  tmpvar_35 = (tmpvar_31.w * _Color.w);
  float x;
  x = (tmpvar_35 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  c.xyz = (tmpvar_33 * min ((2.0 * texture2D (unity_Lightmap, tmpvar_6).xyz), vec3((texture2DProj (_ShadowMapTexture, tmpvar_8).x * 2.0)))).xyz;
  c.w = (vec4(tmpvar_35)).w;
  c.w = (vec4(tmpvar_35)).w;
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
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
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
  vec4 tmpvar_42;
  tmpvar_42 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_44;
  tmpvar_44 = (tmpvar_42.xyz * _Color.xyz);
  float tmpvar_45;
  tmpvar_45 = tmpvar_42.w;
  float tmpvar_46;
  tmpvar_46 = (tmpvar_42.w * _Color.w);
  float x;
  x = (tmpvar_46 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  vec4 c_i0;
  float tmpvar_61;
  tmpvar_61 = (pow (max (0.0, dot (tmpvar_4, normalize ((lightDir + normalize (tmpvar_6.xyz))))), (_Shininess * 128.0)) * tmpvar_45);
  c_i0.xyz = ((((tmpvar_44 * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, lightDir))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_61)) * 2.0).xyz;
  c_i0.w = (vec4((tmpvar_46 + ((_LightColor0.w * _SpecColor.w) * tmpvar_61)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_44 * tmpvar_8)).xyz;
  c.w = (vec4(tmpvar_46)).w;
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
Vector 11 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Vector 12 [unity_4LightPosX0]
Vector 13 [unity_4LightPosY0]
Vector 14 [unity_4LightPosZ0]
Vector 15 [unity_4LightAtten0]
Vector 16 [unity_LightColor0]
Vector 17 [unity_LightColor1]
Vector 18 [unity_LightColor2]
Vector 19 [unity_LightColor3]
Vector 20 [unity_SHAr]
Vector 21 [unity_SHAg]
Vector 22 [unity_SHAb]
Vector 23 [unity_SHBr]
Vector 24 [unity_SHBg]
Vector 25 [unity_SHBb]
Vector 26 [unity_SHC]
Vector 27 [_MainTex_ST]
"!!ARBvp1.0
# 66 ALU
PARAM c[28] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..27] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[10].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[13];
DP3 R4.z, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[12];
DP4 R4.xy, vertex.position, c[7];
MUL R2, R2, R2;
MOV R5.z, R3.x;
MOV R5.y, R4.z;
MOV R5.w, c[0].x;
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[14];
MAD R2, R1, R1, R2;
MAD R0, R3.x, R1, R0;
MUL R1, R2, c[15];
ADD R1, R1, c[0].x;
MOV result.texcoord[1].z, R3.x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[22];
DP4 R2.y, R5, c[21];
DP4 R2.x, R5, c[20];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[17];
MAD R1.xyz, R0.x, c[16], R1;
MAD R0.xyz, R0.z, c[18], R1;
MAD R1.xyz, R0.w, c[19], R0;
MUL R0, R5.xyzz, R5.yzzx;
MUL R1.w, R4.z, R4.z;
DP4 R5.w, R0, c[25];
DP4 R5.z, R0, c[24];
DP4 R5.y, R0, c[23];
MAD R1.w, R5.x, R5.x, -R1;
MUL R0.xyz, R1.w, c[26];
ADD R2.xyz, R2, R5.yzww;
ADD R5.yzw, R2.xxyz, R0.xxyz;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].z;
ADD result.texcoord[3].xyz, R5.yzww, R1;
MOV R1.x, R2;
MUL R1.y, R2, c[9].x;
MOV R3.x, R4.w;
MOV R3.y, R4;
ADD result.texcoord[4].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MOV result.texcoord[1].y, R4.z;
MOV result.texcoord[1].x, R5;
ADD result.texcoord[2].xyz, -R3.wxyw, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[27], c[27].zwzw;
END
# 66 instructions, 6 R-regs
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
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [unity_4LightPosX0]
Vector 13 [unity_4LightPosY0]
Vector 14 [unity_4LightPosZ0]
Vector 15 [unity_4LightAtten0]
Vector 16 [unity_LightColor0]
Vector 17 [unity_LightColor1]
Vector 18 [unity_LightColor2]
Vector 19 [unity_LightColor3]
Vector 20 [unity_SHAr]
Vector 21 [unity_SHAg]
Vector 22 [unity_SHAb]
Vector 23 [unity_SHBr]
Vector 24 [unity_SHBg]
Vector 25 [unity_SHBb]
Vector 26 [unity_SHC]
Vector 27 [_MainTex_ST]
"vs_2_0
; 66 ALU
def c28, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c10.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c13
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c12
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c28.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c14
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c15
add r1, r1, c28.x
mov oT1.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c22
dp4 r2.y, r5, c21
dp4 r2.x, r5, c20
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c28.y
mul r0, r0, r1
mul r1.xyz, r0.y, c17
mad r1.xyz, r0.x, c16, r1
mad r0.xyz, r0.z, c18, r1
mad r1.xyz, r0.w, c19, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c25
dp4 r5.z, r0, c24
dp4 r5.y, r0, c23
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c26
add r2.xyz, r2, r5.yzww
add r5.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c28.z
add oT3.xyz, r5.yzww, r1
mov r1.x, r2
mul r1.y, r2, c8.x
mov r3.x, r4.w
mov r3.y, r4
mad oT4.xy, r2.z, c9.zwzw, r1
mov oPos, r0
mov oT4.zw, r0
mov oT1.y, r4.z
mov oT1.x, r5
add oT2.xyz, -r3.wxyw, c11
mad oT0.xy, v2, c27, c27.zwzw
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
uniform vec3 _WorldSpaceCameraPos;
uniform vec4 _ProjectionParams;
uniform mat4 _Object2World;
uniform vec4 _MainTex_ST;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = gl_Vertex.xyzw;
  vec4 tmpvar_81;
  tmpvar_81 = (gl_ModelViewProjectionMatrix * tmpvar_1);
  mat3 tmpvar_88;
  tmpvar_88[0] = _Object2World[0].xyz;
  tmpvar_88[1] = _Object2World[1].xyz;
  tmpvar_88[2] = _Object2World[2].xyz;
  vec3 tmpvar_92;
  tmpvar_92 = (tmpvar_88 * (gl_Normal.xyz * unity_Scale.w));
  vec4 tmpvar_97;
  tmpvar_97.xyz = tmpvar_92.xyz;
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
  vec3 tmpvar_117;
  tmpvar_117 = (_Object2World * tmpvar_1).xyz;
  vec4 tmpvar_120;
  tmpvar_120 = (unity_4LightPosX0 - tmpvar_117.x);
  vec4 tmpvar_121;
  tmpvar_121 = (unity_4LightPosY0 - tmpvar_117.y);
  vec4 tmpvar_122;
  tmpvar_122 = (unity_4LightPosZ0 - tmpvar_117.z);
  vec4 tmpvar_126;
  tmpvar_126 = (((tmpvar_120 * tmpvar_120) + (tmpvar_121 * tmpvar_121)) + (tmpvar_122 * tmpvar_122));
  vec4 tmpvar_136;
  tmpvar_136 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_120 * tmpvar_92.x) + (tmpvar_121 * tmpvar_92.y)) + (tmpvar_122 * tmpvar_92.z)) * inversesqrt (tmpvar_126))) * 1.0/((1.0 + (tmpvar_126 * unity_4LightAtten0))));
  vec4 o_i0;
  vec4 tmpvar_145;
  tmpvar_145 = (tmpvar_81 * 0.5);
  o_i0 = tmpvar_145;
  vec2 tmpvar_146;
  tmpvar_146.x = tmpvar_145.x;
  tmpvar_146.y = (vec2((tmpvar_145.y * _ProjectionParams.x))).y;
  o_i0.xy = (tmpvar_146 + tmpvar_145.w);
  o_i0.zw = tmpvar_81.zw;
  gl_Position = tmpvar_81.xyzw;
  vec4 tmpvar_17;
  tmpvar_17.xy = ((gl_MultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw).xy;
  tmpvar_17.z = 0.0;
  tmpvar_17.w = 0.0;
  gl_TexCoord[0] = tmpvar_17;
  vec4 tmpvar_19;
  tmpvar_19.xyz = tmpvar_92.xyz;
  tmpvar_19.w = 0.0;
  gl_TexCoord[1] = tmpvar_19;
  vec4 tmpvar_21;
  tmpvar_21.xyz = (_WorldSpaceCameraPos.xyz - (_Object2World * tmpvar_1).xyz).xyz;
  tmpvar_21.w = 0.0;
  gl_TexCoord[2] = tmpvar_21;
  vec4 tmpvar_23;
  tmpvar_23.xyz = (((x1 + x2) + (unity_SHC.xyz * ((tmpvar_97.x * tmpvar_97.x) - (tmpvar_97.y * tmpvar_97.y)))) + ((((unity_LightColor0 * tmpvar_136.x) + (unity_LightColor1 * tmpvar_136.y)) + (unity_LightColor2 * tmpvar_136.z)) + (unity_LightColor3 * tmpvar_136.w))).xyz;
  tmpvar_23.w = 0.0;
  gl_TexCoord[3] = tmpvar_23;
  gl_TexCoord[4] = o_i0.xyzw;
}


#endif
#ifdef FRAGMENT
uniform vec4 _WorldSpaceLightPos0;
uniform vec4 _SpecColor;
uniform float _Shininess;
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
  vec3 tmpvar_8;
  tmpvar_8 = gl_TexCoord[3].xyz;
  vec4 tmpvar_10;
  tmpvar_10 = gl_TexCoord[4].xyzw;
  vec4 c;
  vec4 tmpvar_46;
  tmpvar_46 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_48;
  tmpvar_48 = (tmpvar_46.xyz * _Color.xyz);
  float tmpvar_49;
  tmpvar_49 = tmpvar_46.w;
  float tmpvar_50;
  tmpvar_50 = (tmpvar_46.w * _Color.w);
  float x;
  x = (tmpvar_50 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  float tmpvar_55;
  tmpvar_55 = texture2DProj (_ShadowMapTexture, tmpvar_10).x;
  vec3 lightDir;
  lightDir = _WorldSpaceLightPos0.xyz;
  vec4 c_i0;
  float tmpvar_70;
  tmpvar_70 = (pow (max (0.0, dot (tmpvar_4, normalize ((lightDir + normalize (tmpvar_6.xyz))))), (_Shininess * 128.0)) * tmpvar_49);
  c_i0.xyz = ((((tmpvar_48 * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, lightDir))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_70)) * (tmpvar_55 * 2.0)).xyz;
  c_i0.w = (vec4((tmpvar_50 + (((_LightColor0.w * _SpecColor.w) * tmpvar_70) * tmpvar_55)))).w;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_48 * tmpvar_8)).xyz;
  c.w = (vec4(tmpvar_50)).w;
  gl_FragData[0] = c.xyzw;
}


#endif
"
}

}
Program "fp" {
// Fragment combos: 4
//   opengl - ALU: 10 to 30, TEX: 1 to 3
//   d3d9 - ALU: 10 to 33, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
Float 5 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 28 ALU, 1 TEX
PARAM c[7] = { program.local[0..5],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1.w, R0, c[3];
SLT R1.x, R1.w, c[5];
MOV result.color.w, R1;
KIL -R1.x;
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MAD R1.xyz, R1.x, fragment.texcoord[2], c[0];
DP3 R2.x, R1, R1;
RSQ R2.x, R2.x;
MUL R1.xyz, R2.x, R1;
DP3 R1.x, fragment.texcoord[1], R1;
MOV R2.x, c[6].y;
MUL R1.y, R2.x, c[4].x;
MAX R1.x, R1, c[6];
POW R2.x, R1.x, R1.y;
MOV R1.xyz, c[2];
MUL R0.w, R0, R2.x;
MUL R1.xyz, R1, c[1];
MUL R2.xyz, R1, R0.w;
MUL R1.xyz, R0, c[3];
MUL R0.xyz, R1, c[1];
DP3 R0.w, fragment.texcoord[1], c[0];
MAX R0.w, R0, c[6].x;
MAD R0.xyz, R0, R0.w, R2;
MUL R1.xyz, R1, fragment.texcoord[3];
MUL R0.xyz, R0, c[6].z;
ADD result.color.xyz, R0, R1;
END
# 28 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
Float 5 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 32 ALU, 2 TEX
dcl_2d s0
def c6, 0.00000000, 1.00000000, 128.00000000, 2.00000000
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r3, t0, s0
mul r0.x, r3.w, c3.w
add r1.x, r0, -c5
cmp r1.x, r1, c6, c6.y
mov_pp r1, -r1.x
mul r3.xyz, r3, c3
texkill r1.xyzw
dp3_pp r1.x, t2, t2
rsq_pp r1.x, r1.x
mad_pp r2.xyz, r1.x, t2, c0
dp3_pp r1.x, r2, r2
rsq_pp r1.x, r1.x
mul_pp r2.xyz, r1.x, r2
dp3_pp r2.x, t1, r2
mov_pp r1.x, c4
mul_pp r1.x, c6.z, r1
max_pp r2.x, r2, c6
pow r4, r2.x, r1.x
mov r1.x, r4
mov r2.xyz, c1
mul r1.x, r3.w, r1
mul r2.xyz, c2, r2
mul r2.xyz, r2, r1.x
dp3_pp r1.x, t1, c0
mul r4.xyz, r3, c1
max_pp r1.x, r1, c6
mad r1.xyz, r4, r1.x, r2
mul r2.xyz, r3, t3
mul r1.xyz, r1, c6.w
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
SetTexture 1 [unity_Lightmap] 2D
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
TEX R1, fragment.texcoord[3], texture[1], 2D;
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
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 10 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c2, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t3.xy
texld r3, t0, s0
mul r0.x, r3.w, c0.w
add r1.x, r0, -c1
cmp r1.x, r1, c2, c2.y
mov_pp r2, -r1.x
texld r1, t3, s1
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
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
Float 5 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 30 ALU, 2 TEX
PARAM c[7] = { program.local[0..5],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R2.w, R0, c[3];
SLT R1.x, R2.w, c[5];
DP3 R1.y, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.y, R1.y;
MAD R2.xyz, R1.y, fragment.texcoord[2], c[0];
DP3 R1.y, R2, R2;
RSQ R1.y, R1.y;
MUL R2.xyz, R1.y, R2;
DP3 R1.z, fragment.texcoord[1], R2;
MOV R1.y, c[6];
MUL R1.w, R1.y, c[4].x;
MAX R1.y, R1.z, c[6].x;
POW R1.y, R1.y, R1.w;
MUL R0.w, R0, R1.y;
MUL R1.yzw, R0.xxyz, c[3].xxyz;
MOV R2.xyz, c[2];
MUL R2.xyz, R2, c[1];
MUL R2.xyz, R2, R0.w;
DP3 R0.w, fragment.texcoord[1], c[0];
MUL R0.xyz, R1.yzww, c[1];
MAX R0.w, R0, c[6].x;
MAD R0.xyz, R0, R0.w, R2;
MOV result.color.w, R2;
KIL -R1.x;
TXP R1.x, fragment.texcoord[4], texture[1], 2D;
MUL R0.w, R1.x, c[6].z;
MUL R1.xyz, R1.yzww, fragment.texcoord[3];
MUL R0.xyz, R0, R0.w;
ADD result.color.xyz, R0, R1;
END
# 30 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
Float 5 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"ps_2_0
; 33 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c6, 0.00000000, 1.00000000, 128.00000000, 2.00000000
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4
texld r3, t0, s0
texldp r5, t4, s1
mul r0.x, r3.w, c3.w
add r1.x, r0, -c5
cmp r1.x, r1, c6, c6.y
mov_pp r1, -r1.x
mul r3.xyz, r3, c3
texkill r1.xyzw
dp3_pp r1.x, t2, t2
rsq_pp r1.x, r1.x
mad_pp r2.xyz, r1.x, t2, c0
dp3_pp r1.x, r2, r2
rsq_pp r1.x, r1.x
mul_pp r2.xyz, r1.x, r2
dp3_pp r2.x, t1, r2
mov_pp r1.x, c4
mul_pp r1.x, c6.z, r1
max_pp r2.x, r2, c6
pow r4, r2.x, r1.x
mov r1.x, r4
mul r4.xyz, r3, c1
mov r2.xyz, c1
mul r1.x, r3.w, r1
mul r2.xyz, c2, r2
mul r2.xyz, r2, r1.x
dp3_pp r1.x, t1, c0
max_pp r1.x, r1, c6
mad r2.xyz, r4, r1.x, r2
mul_pp r1.x, r5, c6.w
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
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R2.x, fragment.texcoord[4], texture[1], 2D;
MUL R0.w, R0, c[0];
SLT R1.x, R0.w, c[1];
MUL R0.xyz, R0, c[0];
MOV result.color.w, R0;
KIL -R1.x;
TEX R1, fragment.texcoord[3], texture[2], 2D;
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
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 12 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c2, 0.00000000, 1.00000000, 8.00000000, 2.00000000
dcl t0.xy
dcl t3.xy
dcl t4
texld r1, t0, s0
texld r3, t3, s2
mul r0.x, r1.w, c0.w
add r2.x, r0, -c1
cmp r2.x, r2, c2, c2.y
mov_pp r2, -r2.x
mul_pp r3.xyz, r3.w, r3
mul_pp r3.xyz, r3, c2.z
mul r1.xyz, r1, c0
mov_pp r1.w, r0.x
texkill r2.xyzw
texldp r2, t4, s1
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
  vec3 tmpvar_10;
  tmpvar_10 = gl_TexCoord[4].xyz;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_45;
  tmpvar_45 = (tmpvar_43.xyz * _Color.xyz);
  float tmpvar_46;
  tmpvar_46 = tmpvar_43.w;
  float tmpvar_47;
  tmpvar_47 = (tmpvar_43.w * _Color.w);
  float x;
  x = (tmpvar_47 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec3 tmpvar_50;
  tmpvar_50 = normalize (tmpvar_6);
  float atten;
  atten = texture2D (_LightTexture0, vec2(dot (tmpvar_10, tmpvar_10))).w;
  vec4 c_i0;
  float tmpvar_69;
  tmpvar_69 = (pow (max (0.0, dot (tmpvar_4, normalize ((tmpvar_50 + normalize (tmpvar_8.xyz))))), (_Shininess * 128.0)) * tmpvar_46);
  c_i0.xyz = ((((tmpvar_45 * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, tmpvar_50))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_69)) * (atten * 2.0)).xyz;
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
  vec4 tmpvar_41;
  tmpvar_41 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_43;
  tmpvar_43 = (tmpvar_41.xyz * _Color.xyz);
  float tmpvar_44;
  tmpvar_44 = tmpvar_41.w;
  float tmpvar_45;
  tmpvar_45 = (tmpvar_41.w * _Color.w);
  float x;
  x = (tmpvar_45 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 c_i0;
  float tmpvar_61;
  tmpvar_61 = (pow (max (0.0, dot (tmpvar_4, normalize ((tmpvar_6 + normalize (tmpvar_8.xyz))))), (_Shininess * 128.0)) * tmpvar_44);
  c_i0.xyz = ((((tmpvar_43 * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_61)) * 2.0).xyz;
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
  vec4 tmpvar_10;
  tmpvar_10 = gl_TexCoord[4].xyzw;
  vec4 c;
  vec4 tmpvar_50;
  tmpvar_50 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_52;
  tmpvar_52 = (tmpvar_50.xyz * _Color.xyz);
  float tmpvar_53;
  tmpvar_53 = tmpvar_50.w;
  float tmpvar_54;
  tmpvar_54 = (tmpvar_50.w * _Color.w);
  float x;
  x = (tmpvar_54 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec3 tmpvar_57;
  tmpvar_57 = normalize (tmpvar_6);
  vec3 LightCoord_i0;
  LightCoord_i0 = tmpvar_10.xyz;
  float atten;
  atten = ((float((tmpvar_10.z > 0.0)) * texture2D (_LightTexture0, ((tmpvar_10.xy / tmpvar_10.w) + 0.5)).w) * texture2D (_LightTextureB0, vec2(dot (LightCoord_i0, LightCoord_i0))).w);
  vec4 c_i0;
  float tmpvar_81;
  tmpvar_81 = (pow (max (0.0, dot (tmpvar_4, normalize ((tmpvar_57 + normalize (tmpvar_8.xyz))))), (_Shininess * 128.0)) * tmpvar_53);
  c_i0.xyz = ((((tmpvar_52 * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, tmpvar_57))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_81)) * (atten * 2.0)).xyz;
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
  vec3 tmpvar_10;
  tmpvar_10 = gl_TexCoord[4].xyz;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_45;
  tmpvar_45 = (tmpvar_43.xyz * _Color.xyz);
  float tmpvar_46;
  tmpvar_46 = tmpvar_43.w;
  float tmpvar_47;
  tmpvar_47 = (tmpvar_43.w * _Color.w);
  float x;
  x = (tmpvar_47 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec3 tmpvar_50;
  tmpvar_50 = normalize (tmpvar_6);
  float atten;
  atten = (texture2D (_LightTextureB0, vec2(dot (tmpvar_10, tmpvar_10))).w * textureCube (_LightTexture0, tmpvar_10).w);
  vec4 c_i0;
  float tmpvar_70;
  tmpvar_70 = (pow (max (0.0, dot (tmpvar_4, normalize ((tmpvar_50 + normalize (tmpvar_8.xyz))))), (_Shininess * 128.0)) * tmpvar_46);
  c_i0.xyz = ((((tmpvar_45 * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, tmpvar_50))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_70)) * (atten * 2.0)).xyz;
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
  vec2 tmpvar_10;
  tmpvar_10 = gl_TexCoord[4].xy;
  vec4 c;
  vec4 tmpvar_43;
  tmpvar_43 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_45;
  tmpvar_45 = (tmpvar_43.xyz * _Color.xyz);
  float tmpvar_46;
  tmpvar_46 = tmpvar_43.w;
  float tmpvar_47;
  tmpvar_47 = (tmpvar_43.w * _Color.w);
  float x;
  x = (tmpvar_47 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  float atten;
  atten = texture2D (_LightTexture0, tmpvar_10).w;
  vec4 c_i0;
  float tmpvar_64;
  tmpvar_64 = (pow (max (0.0, dot (tmpvar_4, normalize ((tmpvar_6 + normalize (tmpvar_8.xyz))))), (_Shininess * 128.0)) * tmpvar_46);
  c_i0.xyz = ((((tmpvar_45 * _LightColor0.xyz) * max (0.0, dot (tmpvar_4, tmpvar_6))) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_64)) * (atten * 2.0)).xyz;
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
//   opengl - ALU: 27 to 38, TEX: 1 to 3
//   d3d9 - ALU: 32 to 41, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
Float 4 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 32 ALU, 2 TEX
PARAM c[6] = { program.local[0..4],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R2.w, R0, c[2];
SLT R1.y, R2.w, c[4].x;
DP3 R1.x, fragment.texcoord[4], fragment.texcoord[4];
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[2];
RSQ R2.x, R2.x;
MUL R0.xyz, R0, c[0];
MOV result.color.w, R2;
TEX R1.w, R1.x, texture[1], 2D;
KIL -R1.y;
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[2];
MAD R2.xyz, R2.x, fragment.texcoord[3], R1;
DP3 R3.x, R2, R2;
RSQ R3.x, R3.x;
MUL R2.xyz, R3.x, R2;
DP3 R2.x, fragment.texcoord[1], R2;
MOV R3.x, c[5].y;
MUL R2.y, R3.x, c[3].x;
MAX R2.x, R2, c[5];
POW R3.x, R2.x, R2.y;
MOV R2.xyz, c[1];
MUL R0.w, R0, R3.x;
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R0.w;
DP3 R0.w, fragment.texcoord[1], R1;
MAX R0.w, R0, c[5].x;
MUL R1.x, R1.w, c[5].z;
MAD R0.xyz, R0, R0.w, R2;
MUL result.color.xyz, R0, R1.x;
END
# 32 instructions, 4 R-regs
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
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 36 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c5, 0.00000000, 1.00000000, 128.00000000, 2.00000000
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r3, t0, s0
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
cmp r2.x, r1, c5, c5.y
mov_pp r2, -r2.x
dp3 r1.x, t4, t4
mov r1.xy, r1.x
mul r3.xyz, r3, c2
mul r3.xyz, r3, c0
mov_pp r1.w, r0.x
texld r6, r1, s1
texkill r2.xyzw
dp3_pp r1.x, t2, t2
rsq_pp r2.x, r1.x
dp3_pp r1.x, t3, t3
mul_pp r4.xyz, r2.x, t2
rsq_pp r1.x, r1.x
mad_pp r2.xyz, r1.x, t3, r4
dp3_pp r1.x, r2, r2
rsq_pp r1.x, r1.x
mul_pp r2.xyz, r1.x, r2
dp3_pp r2.x, t1, r2
mov_pp r1.x, c3
mul_pp r1.x, c5.z, r1
max_pp r2.x, r2, c5
pow r5, r2.x, r1.x
mov r1.x, r5
mov r2.xyz, c0
mul r2.xyz, c1, r2
mul r1.x, r3.w, r1
mul r5.xyz, r2, r1.x
dp3_pp r2.x, t1, r4
max_pp r2.x, r2, c5
mul_pp r1.x, r6, c5.w
mad r2.xyz, r3, r2.x, r5
mul r1.xyz, r2, r1.x
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
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 27 ALU, 1 TEX
PARAM c[6] = { program.local[0..4],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1.w, R0, c[2];
SLT R1.x, R1.w, c[4];
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[2];
RSQ R2.x, R2.x;
MUL R0.xyz, R0, c[0];
MOV result.color.w, R1;
KIL -R1.x;
MOV R1.xyz, fragment.texcoord[2];
MAD R2.xyz, R2.x, fragment.texcoord[3], R1;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
DP3 R2.x, fragment.texcoord[1], R2;
MOV R2.w, c[5].y;
MUL R2.y, R2.w, c[3].x;
MAX R2.x, R2, c[5];
POW R2.w, R2.x, R2.y;
MOV R2.xyz, c[1];
MUL R0.w, R0, R2;
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R0.w;
DP3 R0.w, fragment.texcoord[1], R1;
MAX R0.w, R0, c[5].x;
MAD R0.xyz, R0, R0.w, R2;
MUL result.color.xyz, R0, c[5].z;
END
# 27 instructions, 3 R-regs
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
"ps_2_0
; 32 ALU, 2 TEX
dcl_2d s0
def c5, 0.00000000, 1.00000000, 128.00000000, 2.00000000
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r3, t0, s0
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mul r3.xyz, r3, c2
mov_pp r2.xyz, t2
mul r3.xyz, r3, c0
texkill r1.xyzw
dp3_pp r1.x, t3, t3
rsq_pp r1.x, r1.x
mad_pp r2.xyz, r1.x, t3, r2
dp3_pp r1.x, r2, r2
rsq_pp r1.x, r1.x
mul_pp r2.xyz, r1.x, r2
dp3_pp r2.x, t1, r2
mov_pp r1.x, c3
mul_pp r1.x, c5.z, r1
max_pp r2.x, r2, c5
pow r4, r2.x, r1.x
mov r1.x, r4
mov r2.xyz, c0
mul r1.x, r3.w, r1
mul r2.xyz, c1, r2
mul r2.xyz, r2, r1.x
mov_pp r1.xyz, t2
dp3_pp r1.x, t1, r1
max_pp r1.x, r1, c5
mad r1.xyz, r3, r1.x, r2
mul r1.xyz, r1, c5.w
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
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 38 ALU, 3 TEX
PARAM c[6] = { program.local[0..4],
		{ 0, 128, 0.5, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[0], texture[0], 2D;
MUL R3.x, R2.w, c[2].w;
SLT R0.w, R3.x, c[4].x;
DP3 R0.z, fragment.texcoord[4], fragment.texcoord[4];
RCP R0.x, fragment.texcoord[4].w;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R2.xyz, R2, c[2];
MAD R0.xy, fragment.texcoord[4], R0.x, c[5].z;
RSQ R1.x, R1.x;
MUL R2.xyz, R2, c[0];
MOV result.color.w, R3.x;
KIL -R0.w;
TEX R0.w, R0, texture[1], 2D;
TEX R1.w, R0.z, texture[2], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
MAD R1.xyz, R1.x, fragment.texcoord[3], R0;
DP3 R0.x, fragment.texcoord[1], R0;
DP3 R3.y, R1, R1;
RSQ R3.y, R3.y;
MUL R1.xyz, R3.y, R1;
DP3 R1.x, fragment.texcoord[1], R1;
MOV R3.y, c[5];
SLT R0.y, c[5].x, fragment.texcoord[4].z;
MUL R0.y, R0, R0.w;
MUL R0.y, R0, R1.w;
MUL R1.y, R3, c[3].x;
MAX R1.x, R1, c[5];
POW R1.x, R1.x, R1.y;
MUL R2.w, R2, R1.x;
MOV R1.xyz, c[1];
MUL R1.xyz, R1, c[0];
MUL R0.w, R0.y, c[5];
MUL R1.xyz, R1, R2.w;
MAX R0.x, R0, c[5];
MAD R0.xyz, R2, R0.x, R1;
MUL result.color.xyz, R0, R0.w;
END
# 38 instructions, 4 R-regs
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
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_2_0
; 41 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c5, 0.00000000, 1.00000000, 128.00000000, 0.50000000
def c6, 2.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4
texld r3, t0, s0
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
cmp r1.x, r1, c5, c5.y
mov_pp r4, -r1.x
dp3 r2.x, t4, t4
mov r2.xy, r2.x
rcp r1.x, t4.w
mad r1.xy, t4, r1.x, c5.w
mul r3.xyz, r3, c2
mul r3.xyz, r3, c0
texld r1, r1, s1
texld r6, r2, s2
texkill r4.xyzw
dp3_pp r1.x, t2, t2
rsq_pp r2.x, r1.x
dp3_pp r1.x, t3, t3
mul_pp r4.xyz, r2.x, t2
rsq_pp r1.x, r1.x
mad_pp r2.xyz, r1.x, t3, r4
dp3_pp r1.x, r2, r2
rsq_pp r1.x, r1.x
mul_pp r2.xyz, r1.x, r2
dp3_pp r2.x, t1, r2
mov_pp r1.x, c3
mul_pp r1.x, c5.z, r1
max_pp r2.x, r2, c5
pow r5, r2.x, r1.x
mov r2.x, r5
cmp r1.x, -t4.z, c5, c5.y
mul r1.x, r1, r1.w
mul r1.x, r1, r6
mov r5.xyz, c0
mul r2.x, r3.w, r2
mul r5.xyz, c1, r5
mul r5.xyz, r5, r2.x
dp3_pp r2.x, t1, r4
max_pp r2.x, r2, c5
mul_pp r1.x, r1, c6
mad r2.xyz, r3, r2.x, r5
mul r1.xyz, r2, r1.x
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
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 34 ALU, 3 TEX
PARAM c[6] = { program.local[0..4],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[4], texture[2], CUBE;
MUL R3.x, R2.w, c[2].w;
SLT R0.y, R3.x, c[4].x;
DP3 R0.x, fragment.texcoord[4], fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R2.xyz, R2, c[2];
RSQ R1.x, R1.x;
MUL R2.xyz, R2, c[0];
MOV result.color.w, R3.x;
TEX R0.w, R0.x, texture[1], 2D;
KIL -R0.y;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
MAD R1.xyz, R1.x, fragment.texcoord[3], R0;
DP3 R0.x, fragment.texcoord[1], R0;
MUL R0.y, R0.w, R1.w;
DP3 R3.y, R1, R1;
RSQ R3.y, R3.y;
MUL R1.xyz, R3.y, R1;
DP3 R1.x, fragment.texcoord[1], R1;
MOV R3.y, c[5];
MUL R1.y, R3, c[3].x;
MAX R1.x, R1, c[5];
POW R1.x, R1.x, R1.y;
MUL R2.w, R2, R1.x;
MOV R1.xyz, c[1];
MUL R1.xyz, R1, c[0];
MUL R0.w, R0.y, c[5].z;
MUL R1.xyz, R1, R2.w;
MAX R0.x, R0, c[5];
MAD R0.xyz, R2, R0.x, R1;
MUL result.color.xyz, R0, R0.w;
END
# 34 instructions, 4 R-regs
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
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_2_0
; 37 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.00000000, 1.00000000, 128.00000000, 2.00000000
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r3, t0, s0
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
cmp r2.x, r1, c5, c5.y
mov_pp r2, -r2.x
dp3 r1.x, t4, t4
mov r1.xy, r1.x
mul r3.xyz, r3, c2
mul r3.xyz, r3, c0
texld r6, r1, s1
texld r1, t4, s2
texkill r2.xyzw
dp3_pp r1.x, t2, t2
rsq_pp r2.x, r1.x
dp3_pp r1.x, t3, t3
mul_pp r4.xyz, r2.x, t2
rsq_pp r1.x, r1.x
mad_pp r2.xyz, r1.x, t3, r4
dp3_pp r1.x, r2, r2
rsq_pp r1.x, r1.x
mul_pp r2.xyz, r1.x, r2
dp3_pp r2.x, t1, r2
mov_pp r1.x, c3
mul_pp r1.x, c5.z, r1
max_pp r2.x, r2, c5
pow r5, r2.x, r1.x
mov r2.x, r5
mov r5.xyz, c0
mul r1.x, r6, r1.w
mul r2.x, r3.w, r2
mul r5.xyz, c1, r5
mul r5.xyz, r5, r2.x
dp3_pp r2.x, t1, r4
max_pp r2.x, r2, c5
mul_pp r1.x, r1, c5.w
mad r2.xyz, r3, r2.x, r5
mul r1.xyz, r2, r1.x
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
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 29 ALU, 2 TEX
PARAM c[6] = { program.local[0..4],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[4], texture[1], 2D;
MUL R2.w, R0, c[2];
SLT R1.x, R2.w, c[4];
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[2];
RSQ R2.x, R2.x;
MUL R0.xyz, R0, c[0];
MOV result.color.w, R2;
KIL -R1.x;
MOV R1.xyz, fragment.texcoord[2];
MAD R2.xyz, R2.x, fragment.texcoord[3], R1;
DP3 R3.x, R2, R2;
RSQ R3.x, R3.x;
MUL R2.xyz, R3.x, R2;
DP3 R2.x, fragment.texcoord[1], R2;
MOV R3.x, c[5].y;
MUL R2.y, R3.x, c[3].x;
MAX R2.x, R2, c[5];
POW R3.x, R2.x, R2.y;
MOV R2.xyz, c[1];
MUL R0.w, R0, R3.x;
MUL R2.xyz, R2, c[0];
MUL R2.xyz, R2, R0.w;
DP3 R0.w, fragment.texcoord[1], R1;
MAX R0.w, R0, c[5].x;
MUL R1.x, R1.w, c[5].z;
MAD R0.xyz, R0, R0.w, R2;
MUL result.color.xyz, R0, R1.x;
END
# 29 instructions, 4 R-regs
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
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 33 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c5, 0.00000000, 1.00000000, 128.00000000, 2.00000000
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xy
texld r3, t0, s0
mul r0.x, r3.w, c2.w
add r1.x, r0, -c4
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mul r3.xyz, r3, c2
mov_pp r2.xyz, t2
mul r3.xyz, r3, c0
texkill r1.xyzw
texld r1, t4, s1
dp3_pp r1.x, t3, t3
rsq_pp r1.x, r1.x
mad_pp r2.xyz, r1.x, t3, r2
dp3_pp r1.x, r2, r2
rsq_pp r1.x, r1.x
mul_pp r2.xyz, r1.x, r2
dp3_pp r2.x, t1, r2
mov_pp r1.x, c3
mul_pp r1.x, c5.z, r1
max_pp r2.x, r2, c5
pow r4, r2.x, r1.x
mov r1.x, r4
mul r1.x, r3.w, r1
mov r2.xyz, c0
mul r2.xyz, c1, r2
mul r4.xyz, r2, r1.x
mul_pp r1.x, r1.w, c5.w
mov_pp r2.xyz, t2
dp3_pp r2.x, t1, r2
max_pp r2.x, r2, c5
mad r2.xyz, r3, r2.x, r4
mul r1.xyz, r2, r1.x
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
uniform float _Shininess;
uniform sampler2D _MainTex;
uniform float _Cutoff;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyz;
  vec4 res;
  float x;
  x = ((texture2D (_MainTex, gl_TexCoord[0].xy).w * _Color.w) - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  res.xyz = ((tmpvar_4 * 0.5) + 0.5).xyz;
  res.w = (vec4(_Shininess)).w;
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
Float 1 [_Shininess]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 6 ALU, 1 TEX
PARAM c[4] = { program.local[0..2],
		{ 0.5 } };
TEMP R0;
TEX R0.w, fragment.texcoord[0], texture[0], 2D;
MUL R0.x, R0.w, c[0].w;
SLT R0.x, R0, c[2];
MAD result.color.xyz, fragment.texcoord[1], c[3].x, c[3].x;
MOV result.color.w, c[1].x;
KIL -R0.x;
END
# 6 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_Color]
Float 1 [_Shininess]
Float 2 [_Cutoff]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 7 ALU, 2 TEX
dcl_2d s0
def c3, 0.00000000, 1.00000000, 0.50000000, 0
dcl t0.xy
dcl t1.xyz
texld r0, t0, s0
mul r0.x, r0.w, c0.w
add r0.x, r0, -c2
cmp r0.x, r0, c3, c3.y
mov_pp r0, -r0.x
texkill r0.xyzw
mad_pp r0.xyz, t1, c3.z, c3.z
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
void main ()
{
  vec4 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyzw;
  vec4 light;
  vec4 tmpvar_27;
  tmpvar_27 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_27.xyz * _Color.xyz);
  float tmpvar_30;
  tmpvar_30 = tmpvar_27.w;
  float tmpvar_31;
  tmpvar_31 = (tmpvar_27.w * _Color.w);
  float x;
  x = (tmpvar_31 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 tmpvar_36;
  tmpvar_36 = -(log2 (texture2DProj (_LightBuffer, tmpvar_4)));
  light = tmpvar_36;
  light.xyz = (tmpvar_36.xyz + unity_Ambient.xyz).xyz;
  vec4 c;
  float tmpvar_40;
  tmpvar_40 = (light.w * tmpvar_30);
  c.xyz = ((tmpvar_29 * light.xyz) + ((light.xyz * _SpecColor.xyz) * tmpvar_40)).xyz;
  c.w = (vec4((tmpvar_31 + (tmpvar_40 * _SpecColor.w)))).w;
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
void main ()
{
  vec4 tmpvar_4;
  tmpvar_4 = gl_TexCoord[1].xyzw;
  vec3 tmpvar_6;
  tmpvar_6 = gl_TexCoord[2].xyz;
  vec4 light;
  vec4 tmpvar_33;
  tmpvar_33 = texture2D (_MainTex, gl_TexCoord[0].xy);
  vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_33.xyz * _Color.xyz);
  float tmpvar_36;
  tmpvar_36 = tmpvar_33.w;
  float tmpvar_37;
  tmpvar_37 = (tmpvar_33.w * _Color.w);
  float x;
  x = (tmpvar_37 - _Cutoff);
  if ((x < 0.0)) {
    discard;
  };
  vec4 tmpvar_42;
  tmpvar_42 = -(log2 (texture2DProj (_LightBuffer, tmpvar_4)));
  light = tmpvar_42;
  light.xyz = (tmpvar_42.xyz + mix ((2.0 * texture2D (unity_LightmapInd, tmpvar_6.xy).xyz), (2.0 * texture2D (unity_Lightmap, tmpvar_6.xy).xyz), vec3(clamp (tmpvar_6.z, 0.0, 1.0)))).xyz;
  vec4 c;
  float tmpvar_60;
  tmpvar_60 = (light.w * tmpvar_36);
  c.xyz = ((tmpvar_35 * light.xyz) + ((light.xyz * _SpecColor.xyz) * tmpvar_60)).xyz;
  c.w = (vec4((tmpvar_37 + (tmpvar_60 * _SpecColor.w)))).w;
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
SetTexture 1 [_LightBuffer] 2D
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
TXP R1, fragment.texcoord[1], texture[1], 2D;
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
SetTexture 1 [_LightBuffer] 2D
"ps_2_0
; 16 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00000000, 1.00000000, 0, 0
dcl t0.xy
dcl t1
texld r2, t0, s0
mul r0.x, r2.w, c1.w
add r1.x, r0, -c3
cmp r1.x, r1, c4, c4.y
mov_pp r3, -r1.x
mul r2.xyz, r2, c1
texldp r1, t1, s1
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
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
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
TEX R2, fragment.texcoord[2], texture[3], 2D;
TEX R3, fragment.texcoord[2], texture[2], 2D;
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
TXP R1, fragment.texcoord[1], texture[1], 2D;
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
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 22 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c3, 0.00000000, 1.00000000, 8.00000000, 0
dcl t0.xy
dcl t1
dcl t2.xyz
texld r4, t0, s0
texldp r3, t1, s1
texld r2, t2, s2
mul r0.x, r4.w, c1.w
add r1.x, r0, -c2
cmp r1.x, r1, c3, c3.y
mov_pp r1, -r1.x
mul r4.xyz, r4, c1
texkill r1.xyzw
texld r1, t2, s3
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

#LINE 32

}

Fallback "Transparent/Cutout/VertexLit"
}
