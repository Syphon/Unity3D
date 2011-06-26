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


#import <Cocoa/Cocoa.h>
#import <Syphon/Syphon.h>
#import <OpenGL/OpenGL.h>
//#import <OpenGL/CGLMacro.h>


static SyphonServer* _unitySyphonServer = nil;

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