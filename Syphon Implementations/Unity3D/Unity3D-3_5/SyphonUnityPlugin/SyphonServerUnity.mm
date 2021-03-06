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
    static void cacheGraphicsContext();
    
//#import <OpenGL/CGLMacro.h>
static int serversCount = 0;
    static CGLContextObj cachedContext;

//get the count of servers
int SyServerCount(){
    @autoreleasepool{
    serversCount = [[[SyphonServerDirectory sharedDirectory] servers] count];
	return serversCount;
    }
}


//get the clients! each object returned
void* SyServerAtIndex(int myIndex, char* myAppName, char* myName, char* myUuId){
    @autoreleasepool{

        void* syPtr = (__bridge void*)[[[SyphonServerDirectory sharedDirectory] servers] objectAtIndex:myIndex];

        if(serversCount > 0){
            NSDictionary* serverDict = [[[SyphonServerDirectory sharedDirectory] servers] objectAtIndex:myIndex];
            NSString* appName = [serverDict objectForKey:SyphonServerDescriptionAppNameKey];
            NSString* name = [serverDict objectForKey:SyphonServerDescriptionNameKey];
            NSString *uuid = [serverDict objectForKey:SyphonServerDescriptionUUIDKey];	
            strncpy(myAppName, [appName UTF8String],256);
            strncpy(myName, [name UTF8String], 256);
            strncpy(myUuId, [uuid UTF8String], 256);
        }
   
    return syPtr;
    }
}

    
void syphonServerDestroyResources(SyphonServer* server)
{
    @autoreleasepool {
        if(server != nil)
        {
    //        NSLog(@"destroying Syphon Server : %@ with thread ID %@", server,  [NSThread currentThread]);
            [server stop];
            server = nil;
        }
    }
}

//    
    void syphonServerCreate(SyphonCacheData* ptr)
    {
        @autoreleasepool {
            if(cachedContext != nil && CGLGetContextRetainCount(cachedContext) != 0){
                ptr->syphonServer = [[SyphonServer alloc] initWithName:ptr->serverName context:cachedContext options:nil];
        //     NSLog(@"creating Syphon Server : %@ with thread ID %@", ptr->serverName,  [NSThread currentThread]);
            }
            else
            { //force a context refresh.
                cacheGraphicsContext();
    //            NSLog(@"context is nil?! HOW! %i", CGLGetContextRetainCount(cachedContext));
            }
        }
    }


    

void syphonServerPublishTexture(SyphonCacheData* ptr){    
    @autoreleasepool{
        if(!ptr->syphonServer){
            syphonServerCreate(ptr);
        }
        
        if(ptr->syphonServer)
        {
            
            if(!glIsTexture(ptr->textureID)){
                NSLog(@" %i is not a texture! cannot publish server texture.", ptr->textureID);
                return;
            }
            
    //		NSLog(@"texture id: %li, x: %i, y: %i, syphon server pointer value: %li", (unsigned long)ptr->textureID, ptr->textureWidth, ptr->textureHeight, (unsigned long)ptr->syphonServer);
            //NSLog(@"publishing Syphon Server : %@ with thread ID %@", ptr->serverName,  [NSThread currentThread]);
            NSRect rect = NSMakeRect(0, 0, ptr->textureWidth, ptr->textureHeight);
            if(cachedContext != nil && CGLGetContextRetainCount(cachedContext) != 0){
            [ptr->syphonServer publishFrameTexture:ptr->textureID textureTarget:GL_TEXTURE_2D imageRegion:rect textureDimensions:rect.size flipped:NO];
            }
            else
            { //force a context refresh.
                cacheGraphicsContext();
                //            NSLog(@"context is 2 nil?! HOW! %i", CGLGetContextRetainCount(cachedContext));
            }

        }
    }
}
    
    
    
#ifdef __cplusplus
    }
#endif