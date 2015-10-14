//SyphonUnity.mm
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
#import "SyphonUnity.h"
#include <list>
#include <string>
#ifdef __cplusplus
extern "C" {
    
    static std::list<SyphonCacheData*> syphonServers;
    static std::list<SyphonCacheData*> syphonClients;

    static void UNITY_INTERFACE_API OnGraphicsDeviceEvent(UnityGfxDeviceEventType eventType);
    
    static IUnityInterfaces* s_UnityInterfaces = NULL;
    static IUnityGraphics* s_Graphics = NULL;
    static UnityGfxRenderer s_DeviceType = kUnityGfxRendererNull;
    
    extern "C" void	UNITY_INTERFACE_EXPORT UNITY_INTERFACE_API UnityPluginLoad(IUnityInterfaces* unityInterfaces)
    {
        s_UnityInterfaces = unityInterfaces;
        s_Graphics = s_UnityInterfaces->Get<IUnityGraphics>();
        s_Graphics->RegisterDeviceEventCallback(OnGraphicsDeviceEvent);
        
        // Run OnGraphicsDeviceEvent(initialize) manually on plugin load
        OnGraphicsDeviceEvent(kUnityGfxDeviceEventInitialize);
        registerCallbacks();
    }
    
    extern "C" void UNITY_INTERFACE_EXPORT UNITY_INTERFACE_API UnityPluginUnload()
    {
        s_Graphics->UnregisterDeviceEventCallback(OnGraphicsDeviceEvent);
        unregisterCallbacks();
    }
    
    
     static void UNITY_INTERFACE_API OnGraphicsDeviceEvent(UnityGfxDeviceEventType eventType)
    {
        UnityGfxRenderer currentDeviceType = s_DeviceType;
        
        
        switch (eventType)
        {
            case kUnityGfxDeviceEventInitialize:
            {
                NSLog(@"Syphon Unity OnGraphicsDeviceEvent(Initialize).\n");
                s_DeviceType = s_Graphics->GetRenderer();
                currentDeviceType = s_DeviceType;
                cacheGraphicsContext();
                break;
            }
                
            case kUnityGfxDeviceEventShutdown:
            {
                NSLog(@"Syphon Unity OnGraphicsDeviceEvent(Shutdown).\n");
                s_DeviceType = kUnityGfxRendererNull;
                //                g_TexturePointer = NULL;
                break;
            }
                
            case kUnityGfxDeviceEventBeforeReset:
            {
                NSLog(@"Syphon Unity OnGraphicsDeviceEvent(BeforeReset).\n");
                break;
            }
                
            case kUnityGfxDeviceEventAfterReset:
            {
                NSLog(@"Syphon Unity OnGraphicsDeviceEvent(AfterReset).\n");
                break;
            }
        };
}

    
    
//    void UnitySetGraphicsDevice (void* device, int deviceType, int eventType){
//        // If we've got an OpenGL device, remember device type. There's no OpenGL
//        // "device pointer" to remember since OpenGL always operates on a currently set
//        // global context.
//        
//        @autoreleasepool {
//            
//
//            
//            if (deviceType == kGfxRendererOpenGL)
//            {
//                //      NSLog(@"Set OpenGL graphics device: %i", deviceType);
//            }
//            
//            switch (eventType) {
//                case kGfxDeviceEventInitialize:
//                {
//                    //                NSLog(@"init graphics device");
//                    cachedContext = CGLGetCurrentContext();
//                    NSLog(@"CACHING CONTEXT very first time!");
//
//                    registerCallbacks();
//                    break;
//                }
//                case kGfxDeviceEventShutdown:
//                {
//                    // NSLog(@"shutdown graphics device");
//                    //if you are quitting the app, kill all callbacks. 
//                    unregisterCallbacks();				
//                    break;
//                }
//                default:
//                    break;
//                    //NSLog(@"graphics device changed. - this doesnt ever get called i dont think");
//                    
//            }
//        
//        }
//        
//    }
    
    
    void* CreateClientTexture(NSDictionary* serverPtr){
//        NSLog(@"CREATED CLIENT TEXTURE AT %li, and added it to the list. count is now xx", ( long)serverPtr );
		SyphonCacheData* clientPtr = new SyphonCacheData(serverPtr);
        //add it to a list
        syphonClients.push_back(clientPtr);

		return clientPtr;
	}
	
	void QueueToKillTexture(long killed){
		SyphonCacheData* killMe = (SyphonCacheData*)killed;		
        if(killMe != NULL && killed != 0){
			killMe->destroyMe = YES;
		}
	}
	
    void KillClientTexture(SyphonCacheData* killMe){
		
        if(killMe != NULL && (NSUInteger)killMe != 0){
            //            //if the cache data says it's not a server, then it's a client.
            if(!killMe->isAServer && killMe->syphonClient != nil){
                syphonClientDestroyResources(killMe->syphonClient);
				killMe->syphonClient = nil;
//                NSLog(@"destroyed one");
            }
            //            
            //remove the selected syphonServer from the list
            if (std::find(syphonClients.begin(), syphonClients.end(), killMe) !=
                syphonClients.end())
            {
                syphonClients.remove(killMe);
//                NSLog(@"removed one, count is now %i", (int)syphonClients.size());
            }
            //delete the cache data associated with it
//			NSLog(@"DESTROYED A CLIENT TEXTURE AT %li, count is now %i", (unsigned long)killMe, (int)syphonClients.size());

            delete killMe;
			killMe->destroyMe = NO;
			killMe = NULL;
        }		

    }
    
    
    void* CreateServerTexture(const char* serverName){
		SyphonCacheData* ptr = new SyphonCacheData();
        ptr->serverName = [[NSString alloc] initWithUTF8String:serverName];
        
//		NSLog(@"CREATIN SERVER TEXTURE AT: %li", (unsigned long)ptr);
        //add it to a list
        syphonServers.push_back(ptr);
		return ptr;
	}
    
    void KillServerTexture(SyphonCacheData* killMe){
        if(killMe != NULL){
            if(killMe->isAServer && killMe->syphonServer != nil){
                //destroy the syphon server itself,
                syphonServerDestroyResources(killMe->syphonServer);
				killMe->syphonServer = nil;
            }
            
            //remove the selected syphonServer from the list
            if (std::find(syphonServers.begin(), syphonServers.end(), killMe) !=
                syphonServers.end())
                syphonServers.remove(killMe);
            
            //delete the cache data associated with it
            delete killMe;
			killMe->destroyMe = false;
			killMe = NULL;
        }
    }

    
    void UpdateTextureSizes(){
        for(std::list<SyphonCacheData*>::iterator list_iter =syphonClients.begin(); 
            list_iter != syphonClients.end(); list_iter++){
            
            if((*list_iter)->updateTextureSizeFlag){
//                NSLog(@"SOMETHING CHANGED");
                handleTextureSizeChanged(*list_iter);
                (*list_iter)->updateTextureSizeFlag = false; 
            }
        }   
    }


   static void cacheGraphicsContext(){
           CGLContextObj kCGLContext = CGLGetCurrentContext();
           CGLCreateContext(CGLGetPixelFormat(kCGLContext), kCGLContext, &cachedContext);

            if(syphonFBO){
//				NSLog(@"CACHING CONTEXT +  DELETING FBO at RESOURCE ID: %i", syphonFBO);
				glDeleteFramebuffersEXT(1, &syphonFBO);
                glGenFramebuffersEXT(1, &syphonFBO);
			}
            
            for(std::list<SyphonCacheData*>::iterator list_iter =syphonServers.begin(); 
                list_iter != syphonServers.end(); list_iter++){
                //         NSLog(@"Syphon.Unity.cacheGraphicsContext:: Context changed. destroying/recreating: %@",(*list_iter)->serverName);
                
                //don't destroy/create if it's not initialized yet!
                if((*list_iter)->initialized){
                    syphonServerDestroyResources( (*list_iter)->syphonServer);
//                     NSLog(@"destroying/recreating syphon resources.");
                    (*list_iter)->syphonServer = nil;
                    syphonServerCreate((*list_iter));
                }
            }
			
			
			for(std::list<SyphonCacheData*>::iterator list_iter =syphonClients.begin();
                list_iter != syphonClients.end(); list_iter++){
                //don't destroy/create if it's not initialized yet!
                if((*list_iter)->initialized){
					
					NSDictionary* ptr = [(SyphonClient*)((*list_iter)->syphonClient) serverDescription];
                    syphonClientDestroyResources( (*list_iter)->syphonClient);
//					 NSLog(@"destroying client resources...");
                    (*list_iter)->syphonClient = nil;
					(*list_iter)->syphonClient = [[SyphonClient alloc] initWithServerDescription:ptr options:nil newFrameHandler:nil];
                }
            }
    }
    

	
    // --------------------------------------------------------------------------
    // GetRenderEventFunc, an example function we export which is used to get a rendering event callback function.
    extern "C" UnityRenderingEvent UNITY_INTERFACE_EXPORT UNITY_INTERFACE_API SyphonGetRenderEventFunc()
    {
        return SyphonUnityRenderEvent;
    }
    
    
	void SyphonUnityRenderEvent(int instanceID)
	{
		
        @autoreleasepool {
            
        

		SyphonCacheData* ptr = (SyphonCacheData*)instanceID;
//		if((NSUInteger)ptr == 200){
//			//			NSLog(@"WE GOOD?!");
//			cacheGraphicsContext();
//
//			return;
//		}
		
		if(ptr == nil){
//			NSLog(@"early out DATA!: %i " , instanceID);
			return;
		}


            if((NSUInteger)ptr != 0){

                //if we're 64 bit, get the pointer a little differently.
                if(sizeof(int*) == 8){
                    bool foundOne = false;
                    for(std::list<SyphonCacheData*>::iterator list_iter =syphonServers.begin();
                        list_iter != syphonServers.end(); list_iter++){
                        NSUInteger smaller = (NSUInteger)(*list_iter);
                        if((int)(smaller) == instanceID){
                            ptr = *list_iter;
                            foundOne = true;
                        }
                    }
                    
                    for(std::list<SyphonCacheData*>::iterator list_iter = syphonClients.begin();
                    list_iter != syphonClients.end(); list_iter++){
                        NSUInteger smaller = (NSUInteger)(*list_iter);
                        if((int)(smaller) == instanceID){
                            ptr = *list_iter;
                            foundOne = true;
                        }
                    }
                    //if you didnt find a match, you're probably trying to access this from the wrong plugin, so just get out.
                    if(!foundOne){

                        return;
                    }
                }
                

                //if it's a server
                if(ptr != nil && ptr->isAServer && ptr->initialized && ptr->serverName != nil){
                    //serialize destruction to same thread as drawing
                    if(ptr->destroyMe)
                        KillServerTexture((SyphonCacheData*)ptr);
                    else
                    syphonServerPublishTexture((SyphonCacheData*)ptr);
                }
                //if it's a client
                if(ptr != nil && !ptr->isAServer && ptr->initialized){
                    //serialize destruction to same thread as drawing
                    if(ptr->destroyMe)
                        KillClientTexture((SyphonCacheData*)ptr);
                    else
                    syphonClientPublishTexture((SyphonCacheData*)ptr);
                }
                
            }

        }
    }
    

    void CacheServerTextureValues(int mytextureID, int width, int height, long data){
		SyphonCacheData* ptr = (SyphonCacheData*)data;
        if(ptr){
            ptr->cacheTextureValues(mytextureID, width, height, YES);
        }
        
    }
    
    void CacheClientTextureValues(int mytextureID, int width, int height, long data){
		SyphonCacheData* ptr = (SyphonCacheData*)data;
        if(ptr){
//			NSLog(@"TEX ID CACHED: %i, %i/%i", mytextureID, width, height);
            ptr->cacheTextureValues(mytextureID, width, height, NO);
        }        
    }
    
}
#endif