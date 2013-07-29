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
    
    
    void UnitySetGraphicsDevice (void* device, int deviceType, int eventType){
        // If we've got an OpenGL device, remember device type. There's no OpenGL
        // "device pointer" to remember since OpenGL always operates on a currently set
        // global context.
        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
        if (deviceType == kGfxRendererOpenGL)
        {
            //      NSLog(@"Set OpenGL graphics device: %i", deviceType);
        }
        
        switch (eventType) {
            case kGfxDeviceEventInitialize:
            {
                //                NSLog(@"init graphics device");
                cachedContext = CGLGetCurrentContext();
				NSLog(@"CACHING CONTEXT very first time!");

//                NSString* bundlePath = [[[NSBundle mainBundle] bundlePath]
//                                        stringByAppendingPathComponent:@"Contents/Data/Managed/Assembly-CSharp-firstpass.dll"];
//                if( [ [NSFileManager defaultManager] fileExistsAtPath:bundlePath isDirectory:NO]){
//                    //            NSLog(@"in the app!");
//                    pathToBundle = bundlePath;
//                }
//                else{
//                    //              NSLog(@"in the editor");
//                    char *path=NULL;
//                    size_t size;
//                    path=getcwd(path,size);
//                    NSString* myString = [NSString stringWithUTF8String: path];
//                    NSString* finalString = [myString stringByAppendingPathComponent:@"/Library/ScriptAssemblies/Assembly-CSharp-firstpass.dll"];
//                    pathToBundle = finalString;
//                }
//                [pathToBundle retain];

                registerCallbacks();
                break;
            }
            case kGfxDeviceEventShutdown:
            {
                // NSLog(@"shutdown graphics device");
                //if you are quitting the app, kill all callbacks. 
                unregisterCallbacks();				
                break;
            }
            default:
                break;
                //NSLog(@"graphics device changed. - this doesnt ever get called i dont think");
                
        }
        
        [pool drain];
        
    }
    
    
    void* CreateClientTexture(NSDictionary* serverPtr){
		SyphonCacheData* clientPtr = new SyphonCacheData(serverPtr);
        //add it to a list
        syphonClients.push_back(clientPtr);
//        NSLog(@"CREATED CLIENT TEXTURE AT %li, and added it to the list. count is now %i", (unsigned long)clientPtr, (int)syphonClients.size());
//		int idx = 0;
//		
//		for(std::list<SyphonCacheData*>::iterator list_iter =syphonClients.begin();
//            list_iter != syphonClients.end(); list_iter++){
//			NSLog(@"%i, list iter: %@", idx, [(*list_iter)->syphonClient serverDescription]);
//			idx++;
//		}
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
			NSLog(@"DESTROYED A CLIENT TEXTURE AT %li, count is now %i", (unsigned long)killMe, (int)syphonClients.size());

            delete killMe;
			killMe->destroyMe = NO;
			killMe = NULL;
        }
		
//		int idx = 0;
		
//		for(std::list<SyphonCacheData*>::iterator list_iter =syphonClients.begin();
//            list_iter != syphonClients.end(); list_iter++){
//			NSLog(@"remaining: %i, list iter: %@", idx, [(*list_iter)->syphonClient serverDescription]);
//			idx++;
//		}
    }
    
    
    void* CreateServerTexture(const char* serverName){
		SyphonCacheData* ptr = new SyphonCacheData();
        ptr->serverName = [[NSString alloc] initWithUTF8String:serverName];
        
		NSLog(@"CREATIN SERVER TEXTURE AT: %li", (unsigned long)ptr);
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
    
    //    void FlagServerToBeKilled(SyphonCacheData* ptr){
    //        if(ptr){
    //            ptr->destroyMe = true;
    //        }
    //    }
    
    
    void UpdateTextureSizes(){
        for(std::list<SyphonCacheData*>::iterator list_iter =syphonClients.begin(); 
            list_iter != syphonClients.end(); list_iter++){
            
            if((*list_iter)->updateTextureSizeFlag){
                NSLog(@"SOMETHING CHANGED");
                handleTextureSizeChanged(*list_iter);
                (*list_iter)->updateTextureSizeFlag = false; 
            }
        }   
    }

//	void resetContext(){
//		NSLog(@"YO WTF! RESETTING");
//        if(cachedContext != CGLGetCurrentContext()){
//		NSLog(@"for real YO WTF! RESETTING");
//			cachedContext = CGLGetCurrentContext();
//            if(syphonFBO){
//				NSLog(@"CACHING CONTEXT +  DELETING FBO at RESOURCE ID: %i", syphonFBO);
//				glDeleteFramebuffersEXT(1, &syphonFBO);
//                glGenFramebuffersEXT(1, &syphonFBO);
//				syphonFBO = nil;
//			}
//		}
//	}

//	void forceCacheGraphicsContext(){
//			cachedContext = CGLGetCurrentContext();
//            if(syphonFBO){
//				NSLog(@"EYYYO WTF: %i", syphonFBO);
//				glDeleteFramebuffersEXT(1, &syphonFBO);
//                glGenFramebuffersEXT(1, &syphonFBO);
//				syphonFBO = nil;
//			}
//
//            for(std::list<SyphonCacheData*>::iterator list_iter =syphonServers.begin();
//                list_iter != syphonServers.end(); list_iter++){
//                //         NSLog(@"Syphon.Unity.cacheGraphicsContext:: Context changed. destroying/recreating: %@",(*list_iter)->serverName);
//                
//                //don't destroy/create if it's not initialized yet!
//                if((*list_iter)->initialized){
//                    syphonServerDestroyResources( (*list_iter)->syphonServer);
//					// NSLog(@"destroying resources.");
//                    (*list_iter)->syphonServer = nil;
//                    syphonServerCreate((*list_iter));
//                }
//            }
//	}
	
    void cacheGraphicsContext(){
        if(cachedContext != CGLGetCurrentContext()){
			cachedContext = CGLGetCurrentContext();
            if(syphonFBO){
				NSLog(@"CACHING CONTEXT +  DELETING FBO at RESOURCE ID: %i", syphonFBO);
				glDeleteFramebuffersEXT(1, &syphonFBO);
                glGenFramebuffersEXT(1, &syphonFBO);
				syphonFBO = nil;
			}
            
            for(std::list<SyphonCacheData*>::iterator list_iter =syphonServers.begin(); 
                list_iter != syphonServers.end(); list_iter++){
                //         NSLog(@"Syphon.Unity.cacheGraphicsContext:: Context changed. destroying/recreating: %@",(*list_iter)->serverName);
                
                //don't destroy/create if it's not initialized yet!
                if((*list_iter)->initialized){
                    syphonServerDestroyResources( (*list_iter)->syphonServer);
					// NSLog(@"destroying resources.");
                    (*list_iter)->syphonServer = nil;
                    syphonServerCreate((*list_iter));
                }
            }
		}    
    }
    
    
    void UnityRenderEvent(int instanceID)
	{
		SyphonCacheData* ptr = (SyphonCacheData*)instanceID;
        if((NSUInteger)ptr == 1){
//			NSLog(@"WE GOOD?!");
            cacheGraphicsContext();
		
        }
		else if((NSUInteger)ptr != 0){

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
				if(!foundOne)
					return;
			}
			
			
//			NSLog(@"this shouldnt even be happening.");
            if(ptr->pluginType != PLUGIN_SYPHON)
                return;
			
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