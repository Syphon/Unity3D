/*
    SyphonServerUnity.mm
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
#import <OpenGL/OpenGL.h>

//#import <OpenGL/CGLMacro.h>
static int serversCount = 0;
    static CGLContextObj cachedContext;

//get the count of servers
int SyServerCount(){
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    serversCount = [[[SyphonServerDirectory sharedDirectory] servers] count];
	[pool drain];
	return serversCount;
}


//get the clients! each object returned
void* SyServerAtIndex(int myIndex, char* myAppName, char* myName, char* myUuId){
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    void* syPtr = [[[SyphonServerDirectory sharedDirectory] servers] objectAtIndex:myIndex];

    if(serversCount > 0){
	NSDictionary* serverDict = [[[SyphonServerDirectory sharedDirectory] servers] objectAtIndex:myIndex];
	NSString* appName = [serverDict objectForKey:SyphonServerDescriptionAppNameKey];
	NSString* name = [serverDict objectForKey:SyphonServerDescriptionNameKey];
	NSString *uuid = [serverDict objectForKey:SyphonServerDescriptionUUIDKey];	
	strncpy(myAppName, [appName UTF8String],256);
	strncpy(myName, [name UTF8String], 256);
	strncpy(myUuId, [uuid UTF8String], 256);
    }
	[pool drain];
    return syPtr;

}

    
void syphonServerDestroyResources(SyphonServer* server)
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    // lets create our client if we dont have it. 
    if(server != nil)
    {
        [server stop];
        [server release];
        server = nil;
         //   NSLog(@"destroying Syphon Server : %@ with thread ID %@", server,  [NSThread currentThread]); 
    }

    
    [pool drain];
}

//    
    void syphonServerCreate(SyphonCacheData* ptr)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        ptr->syphonServer = [[SyphonServer alloc] initWithName:ptr->serverName context:cachedContext options:nil];
       //     NSLog(@"creating Syphon Server : %@ with thread ID %@", ptr->serverName,  [NSThread currentThread]); 
        [pool drain];
    }


    

void syphonServerPublishTexture(SyphonCacheData* ptr){    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if(!ptr->syphonServer){
        syphonServerCreate(ptr);
    }
    
    if(ptr->syphonServer)
    {        
    //    NSLog(@"texture id: %i, x: %i, y: %i, syphon server pointer value: %i", ptr->textureID, ptr->textureWidth, ptr->textureHeight, (int)ptr->syphonServer);
        //NSLog(@"publishing Syphon Server : %@ with thread ID %@", ptr->serverName,  [NSThread currentThread]); 
        NSRect rect = NSMakeRect(0, 0, ptr->textureWidth, ptr->textureHeight);
        [ptr->syphonServer publishFrameTexture:ptr->textureID textureTarget:GL_TEXTURE_2D imageRegion:rect textureDimensions:rect.size flipped:NO];
    }

    [pool drain];
}
    
    
    
#ifdef __cplusplus
    }
#endif