//SyphonCacheData.h
//  SyphonUnityPlugin
/*
 
 Copyright 2010-2011 Brian Chasalow, bangnoise (Tom Butterworth) & vade (Anton Marini).
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

//this class is used to sync the GL thread in unity, and the ofxQTKitVideoPlayer
#import "SyphonServerObject.h"
#import <Syphon/Syphon.h>

class SyphonCacheData
{
	public:
		SyphonCacheData();
        //init a client with a syphon server pointer
        SyphonCacheData(NSDictionary* ptr);
		virtual ~SyphonCacheData();
		void cacheTextureValues(int mytextureID, int width, int height, bool imaServer);
        int textureID;
		int textureWidth;
		int textureHeight; 

        NSString* serverName;
        CGLContextObj cachedContext;
        SyphonServer* syphonServer;
        //initialized once data is cached
        bool initialized;
        //if(!isAServer), then is a client
        bool isAServer;
        //client related
        SyphonClient* syphonClient;
        bool updateTextureSizeFlag;
};