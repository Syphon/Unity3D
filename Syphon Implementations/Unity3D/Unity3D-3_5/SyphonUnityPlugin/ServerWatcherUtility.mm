//
//  ServerWatcherUtility.mm
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

#import <Cocoa/Cocoa.h>
#import <Syphon/Syphon.h>
#import <OpenGL/OpenGL.h>
#import <string.h>
#import "SyphonCacheData.h"
#ifdef __cplusplus

extern "C" {
		typedef void* MonoDomain;
		typedef void* MonoAssembly;
		typedef void* MonoImage;
		typedef void* MonoClass;
		typedef void* MonoObject;
		typedef void* MonoMethodDesc;
		typedef void* MonoMethod;
		typedef void* MonoString;
		typedef int gboolean;
		typedef void* gpointer;
		
		MonoDomain *mono_domain_get();
		MonoAssembly *mono_domain_assembly_open(MonoDomain *domain, const char *assemblyName);
		MonoImage *mono_assembly_get_image(MonoAssembly *assembly);
        void  mono_assembly_close (MonoAssembly *assembly);
		MonoMethodDesc *mono_method_desc_new(const char *methodString, gboolean useNamespace);
		MonoMethodDesc *mono_method_desc_free(MonoMethodDesc *desc);
		MonoMethod *mono_method_desc_search_in_image(MonoMethodDesc *methodDesc, MonoImage *image);
		MonoObject *mono_runtime_invoke(MonoMethod *method, void *obj, void **params, MonoObject **exc);
		MonoClass *mono_class_from_name(MonoImage *image, const char *namespaceString, const char *classnameString);
		MonoMethod *mono_class_get_methods(MonoClass*, gpointer* iter);
		MonoString *mono_string_new(MonoDomain *domain, const char *text);

		char* mono_method_get_name (MonoMethod *method);
}
MonoDomain *domain;
NSString *assemblyPath;
MonoAssembly *monoAssembly;
MonoImage *monoImage;

MonoMethodDesc *updateServerDesc;
MonoMethod *updateServer; 
MonoMethodDesc *announceServerDesc;
MonoMethod *announceServer;
MonoMethodDesc *retireServerDesc;
MonoMethod *retireServer;

MonoMethodDesc *textureSizeChangedDesc;
MonoMethod *textureSizeChanged;

#endif

@interface ServerWatcherUtility : NSObject 
{

	
	
}

@end
static NSString* pathToBundle = nil;

static ServerWatcherUtility* watcherUtility;

@implementation ServerWatcherUtility

- (void)handleServerRetire:(NSNotification *)notification
{

	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	const char* param2 = [[[notification object] objectForKey:SyphonServerDescriptionNameKey] UTF8String];
	const char* param1 = [[[notification object] objectForKey:SyphonServerDescriptionAppNameKey] UTF8String];
	const char* param3 = [[[notification object] objectForKey:SyphonServerDescriptionUUIDKey] UTF8String];
  //NSLog(@"announceing server! %s %s %s", param2, param1, param3);
    
    
	MonoString* myString = mono_string_new(domain, param1);
	MonoString* myString2 = mono_string_new(domain, param2);
	MonoString* myString3 = mono_string_new(domain, param3);
	void *args[] = { myString, myString2, myString3 };
	mono_runtime_invoke(retireServer, NULL, args, NULL);
	[pool drain];

}

- (void)handleServerUpdate:(NSNotification *)notification
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	const char* param2 = [[[notification object] objectForKey:SyphonServerDescriptionNameKey] UTF8String];
	const char* param1 = [[[notification object] objectForKey:SyphonServerDescriptionAppNameKey] UTF8String];
	const char* param3 = [[[notification object] objectForKey:SyphonServerDescriptionUUIDKey] UTF8String];

    
    int serverPtr = 0;
    NSArray* serversArray = [[SyphonServerDirectory sharedDirectory] servers];
    for(NSDictionary* dict in serversArray){
        if([[notification object] objectForKey:SyphonServerDescriptionUUIDKey] == [dict objectForKey:SyphonServerDescriptionUUIDKey]){
            serverPtr = (int)dict;            
        }
    }
    
	MonoString* myString = mono_string_new(domain, param1);
	MonoString* myString2 = mono_string_new(domain, param2);
	MonoString* myString3 = mono_string_new(domain, param3);
	void *args[] = { myString, myString2, myString3, &serverPtr };
	mono_runtime_invoke(updateServer, NULL, args, NULL);
	
	[pool drain];

}


- (void)handleServerAnnounce:(NSNotification *)notification
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	const char* param2 = [[[notification object] objectForKey:SyphonServerDescriptionNameKey] UTF8String];
	const char* param1 = [[[notification object] objectForKey:SyphonServerDescriptionAppNameKey] UTF8String];
	const char* param3 = [[[notification object] objectForKey:SyphonServerDescriptionUUIDKey] UTF8String];
    //  NSLog(@"announceing server! %s %s %s", param2, param1, param3);
  
   int serverPtr = 0;
    NSArray* serversArray = [[SyphonServerDirectory sharedDirectory] servers];
    for(NSDictionary* dict in serversArray){
        if([[notification object] objectForKey:SyphonServerDescriptionUUIDKey] == [dict objectForKey:SyphonServerDescriptionUUIDKey]){
            serverPtr = (int)dict;            
        }
    }
    
	MonoString* myString = mono_string_new(domain, param1);
	MonoString* myString2 = mono_string_new(domain, param2);
	MonoString* myString3 = mono_string_new(domain, param3);
	void *args[] = { myString, myString2, myString3, &serverPtr };
	mono_runtime_invoke(announceServer, NULL, args, NULL);
	[pool drain];
}






@end

#ifdef __cplusplus
extern "C" {
	
	
    void handleTextureSizeChanged(SyphonCacheData* ptr){
        void *args[] = { &ptr, &(ptr->textureWidth), &(ptr->textureHeight) };
        mono_runtime_invoke(textureSizeChanged, NULL, args, NULL);
        
    }
	
	void monoMethods(){
        announceServerDesc = mono_method_desc_new("Syphon:OnAnnounceServer", FALSE);
		announceServer =  mono_method_desc_search_in_image(announceServerDesc, monoImage);
		
		retireServerDesc = mono_method_desc_new("Syphon:OnRetireServer", FALSE);
		retireServer =  mono_method_desc_search_in_image(retireServerDesc, monoImage);
	
		updateServerDesc = mono_method_desc_new("Syphon:OnUpdateServer", FALSE);
		updateServer =  mono_method_desc_search_in_image(updateServerDesc, monoImage);

        textureSizeChangedDesc = mono_method_desc_new("Syphon:OnTextureSizeChanged", FALSE);
		textureSizeChanged =  mono_method_desc_search_in_image(textureSizeChangedDesc, monoImage);

        
		mono_method_desc_free(announceServerDesc);
    	mono_method_desc_free(retireServerDesc);
		mono_method_desc_free(updateServerDesc);	
		mono_method_desc_free(textureSizeChangedDesc);	

	}
    
    //[[SyphonServerDirectory sharedDirectory] addObserver:watcherUtility forKeyPath:@"servers" options:0 context:nil];
    
	void registerCallbacks()
	{	
        //NSLog(@"registering callbacks");
		if(watcherUtility == nil){
			watcherUtility = [[ServerWatcherUtility alloc] init];
			[[NSNotificationCenter defaultCenter] addObserver:watcherUtility selector:@selector(handleServerRetire:) name:SyphonServerRetireNotification object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:watcherUtility selector:@selector(handleServerAnnounce:) name:SyphonServerAnnounceNotification object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:watcherUtility selector:@selector(handleServerUpdate:) name:SyphonServerUpdateNotification object:nil];
            
		}
	}
	
    
//void ServerPluginInitEditor(const char* myString){
//	assemblyPath = [NSString stringWithUTF8String: myString];
//    //[assemblyPath retain];
//	domain = mono_domain_get();
//	monoAssembly = mono_domain_assembly_open(domain, assemblyPath.UTF8String);
//    if(!monoAssembly){        
//        NSLog(@"ERROR OPENING THE MONO ASSEMBLY. FIX.");
//    }
//	monoImage = mono_assembly_get_image(monoAssembly);
//	NSLog(@"SYPHON PLUGIN INIT EDITOR: %@", assemblyPath); //check if this is the right path
//	monoMethods();
//}
//
//
//	
// void ServerPluginInit(){
//	assemblyPath = [[[NSBundle mainBundle] bundlePath]
//					stringByAppendingPathComponent:@"Contents/Data/Managed/Assembly-CSharp-firstpass.dll"];
//	NSLog(@"SYPHON PLUGIN INIT -BUILT: %@", assemblyPath); //check if this is the right path
//  //  [assemblyPath retain];
//	 domain = mono_domain_get();
//	 monoAssembly = mono_domain_assembly_open(domain, assemblyPath.UTF8String);
//     if(!monoAssembly){        
//         NSLog(@"ERROR OPENING THE MONO ASSEMBLY. FIX.");
//     }
//	 monoImage = mono_assembly_get_image(monoAssembly);
//	 monoMethods();
//}
	
	
void InitServerPlugin(){
    assemblyPath = pathToBundle;
  //  NSLog(@"SYPHON PLUGIN INIT -BUILT: %@", assemblyPath); //check if this is the right path
    //  [assemblyPath retain];
    domain = mono_domain_get();
    monoAssembly = mono_domain_assembly_open(domain, assemblyPath.UTF8String);
    if(!monoAssembly){
     NSLog(@"ERROR OPENING THE MONO ASSEMBLY. this means that there was a problem in the path to your Assembly. Probably means your Syphon plugin .bundle or Syphon.cs script is not in the .Plugins folder");
    }
    monoImage = mono_assembly_get_image(monoAssembly);
    monoMethods();
}



    
	
void unregisterCallbacks()
{	
    //   NSLog(@"unregistering callbacks");
    if(watcherUtility != nil){
        //[[SyphonServerDirectory sharedDirectory] removeObserver:watcherUtility forKeyPath:@"servers"];
        [[NSNotificationCenter defaultCenter] removeObserver:watcherUtility name:SyphonServerAnnounceNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:watcherUtility name:SyphonServerRetireNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:watcherUtility name:SyphonServerUpdateNotification object:nil];
        
        [watcherUtility release];
        watcherUtility = nil;
        

    }
    if(pathToBundle != nil){
        [pathToBundle release];
        pathToBundle = nil;
    }
}
    
    

}
	
#endif
