/*
    SyphonServerUnity.m
	Unity3D
	
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


#ifdef __cplusplus
extern "C"{
#endif

#import <Cocoa/Cocoa.h>
#import <Syphon/Syphon.h>
#import <OpenGL/OpenGL.h>
//#import <OpenGL/CGLMacro.h>
static NSArray* serversArray = nil;
static SyphonServer* _unitySyphonServer = nil;
static int serversCount = 0;

//get the count of servers
int SyServerCount(){
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	serversArray = [[SyphonServerDirectory sharedDirectory] servers];
    serversCount = [serversArray count];
	[pool drain];
    NSLog(@"servers Count: %i", serversCount);
	return serversCount;
}


//get the clients! each object returned
void SyServerAtIndex(int myIndex, char* myAppName, char* myName, char* myUuId, int myCapacity){
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if(serversCount > 0){
//	NSDictionary* serverDict = [serversArray objectAtIndex:myIndex];
///	NSString* appName = [serverDict objectForKey:SyphonServerDescriptionAppNameKey];
//	NSString* name = [serverDict objectForKey:SyphonServerDescriptionNameKey];
//	NSString *uuid = [serverDict objectForKey:SyphonServerDescriptionUUIDKey];	
//	    NSLog(@"capacity Count: %i", myCapacity);

//	strncpy(myAppName, [appName UTF8String], myCapacity);
//	strncpy(myName, [name UTF8String], myCapacity);
//	strncpy(myUuId, [uuid UTF8String], myCapacity);
    }
	[pool drain];
}

void syphonServerDestroyResources()
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    // lets create our client if we dont have it. 
    if(_unitySyphonServer )
    {
        [_unitySyphonServer stop];
        [_unitySyphonServer release];
        _unitySyphonServer = nil;
        NSLog(@"destroying Syphon Server");
    }
    [pool drain];
}


void syphonServerPublishTexture(int nativeTexture, int width, int height)
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    // lets create our client if we dont have it. 
    if(_unitySyphonServer == nil)
    {
        _unitySyphonServer = [[SyphonServer alloc] initWithName:@"Demo" context:CGLGetCurrentContext() options:nil];
        NSLog(@"creating Syphon Server");
    }
    
    if(_unitySyphonServer)
    {
    
        NSRect rect = NSMakeRect(0, 0, width, height);
        [_unitySyphonServer publishFrameTexture:nativeTexture textureTarget:GL_TEXTURE_2D imageRegion:rect textureDimensions:rect.size flipped:NO];
    }
    
    [pool drain];
}


    
#ifdef __cplusplus
    }
#endif