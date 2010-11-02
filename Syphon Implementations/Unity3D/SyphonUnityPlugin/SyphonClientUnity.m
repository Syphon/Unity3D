/*
    SyphonClientUnity.m
	Unity3D
	
    Copyright 2010 bangnoise (Tom Butterworth) & vade (Anton Marini).
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

// single shared, static SyphonClient
static SyphonClient* _unitySyphonClient = nil;

// texture attachment is going to come from unity via GetNativeID();
static GLuint syphonFBO = 0; 


void syphonClientDestroyResources()
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    glDeleteFramebuffersEXT(1, &syphonFBO);
    syphonFBO = 0;
    
    // lets create our client if we dont have it. 
    if(_unitySyphonClient)
    {
        [_unitySyphonClient stop];
        [_unitySyphonClient release];
        _unitySyphonClient = nil;
        
        NSLog(@"destroying Syphon Client");
    }
    [pool drain];
}


void syphonClientUpdateTexture(int nativeTexture, int width, int height)
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    // lets create our client if we dont have it. 
    if(!_unitySyphonClient)
    {
        NSLog(@"creating Syphon Client");
        NSArray* serversArray = [[SyphonServerDirectory sharedDirectory] servers];
        
        if([serversArray count])
        {
            NSDictionary* serverDict = [serversArray objectAtIndex:0];
            
            NSLog(@"%@", serverDict);
            
            _unitySyphonClient = [[SyphonClient alloc] initWithServerDescription:serverDict options:nil newFrameHandler:nil];
        }
    }
    
    // NSLog(@"syphonClientUpdateTexture: Current Unity Context: %p FBO is: %u", CGLGetCurrentContext(), syphonFBO);
    
    if(_unitySyphonClient && [_unitySyphonClient isValid])
    {          
        NSSize nativeTextureSize = NSMakeSize(width, height);
        
        // NSLog(@"syphonClientUpdateTexture has Valid Syphon Client Connection");

        // CGLContextObj cgl_ctx = CGLGetCurrentContext();
        
        glPushAttrib(GL_ALL_ATTRIB_BITS);
		glPushClientAttrib(GL_CLIENT_ALL_ATTRIB_BITS);

        // Disable depth, we dont need it, saves us a buffer write.
        glDisable(GL_DEPTH_TEST);
        
        // Bind our FBO, which renders to our Unity Texture.
        GLint previousFBO, previousReadFBO, previousDrawFBO;
        glGetIntegerv(GL_FRAMEBUFFER_BINDING, &previousFBO);
        glGetIntegerv(GL_READ_FRAMEBUFFER_BINDING, &previousReadFBO);
        glGetIntegerv(GL_DRAW_FRAMEBUFFER_BINDING, &previousDrawFBO);
        
        // Create our FBO if we dont have it already
        if(!syphonFBO)
        {
            glGenFramebuffersEXT(1, &syphonFBO);
        }
        
        glBindFramebuffer(GL_FRAMEBUFFER_EXT, syphonFBO);
        glFramebufferTexture2D(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, nativeTexture, 0);

        GLenum status;
        status = glCheckFramebufferStatus(GL_FRAMEBUFFER_EXT);
        
        if(status != GL_FRAMEBUFFER_COMPLETE)
        {
            NSLog(@"ERROR: SYPHON UNITY PLUGIN CANNOT MAKE VALID FBO ATTACHMENT FROM UNITY TEXTURE ID");
        }        
        
        glClearColor(0.0, 0.0, 0.0, 0.0);
        glClear(GL_COLOR_BUFFER_BIT);
      
        // Bind our Syphon texture to be active when we draw
        //[_unitySyphonClient bindFrameTexture:CGLGetCurrentContext()];
        SyphonImage* image = [_unitySyphonClient newFrameImageForContext:CGLGetCurrentContext()];
        
        // Need to bind first otherwise this is NSZeroSize...
        NSSize surfaceSize = [image textureSize];
        
                
		// Setup OpenGL coordinate system
		glViewport(0, 0, nativeTextureSize.width,  nativeTextureSize.height);
		
		glMatrixMode(GL_TEXTURE);
		glPushMatrix();
		glLoadIdentity();
		
		glMatrixMode(GL_PROJECTION);
		glPushMatrix();
		glLoadIdentity();
		glOrtho(0, nativeTextureSize.width, 0, nativeTextureSize.height, -1, 1);
		
		glMatrixMode(GL_MODELVIEW);
		glPushMatrix();
		glLoadIdentity();
		
        glColor4f(1.0, 1.0, 1.0, 1.0);
    
        // Disable anything that needs disabling
        glDisable(GL_LIGHTING);
        
        // blending off, we replace, saves us some blending and buffer function calculations
        glDisable(GL_BLEND);

        // bind the texture from our lates Syphon Image. Calling glBindTexture updates our texture for us.
        glEnable(GL_TEXTURE_RECTANGLE_EXT);
        glBindTexture(GL_TEXTURE_RECTANGLE_EXT, [image textureName]);

        glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
        glTexParameterf( GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
        glTexParameterf( GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
        glTexParameterf( GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE );
        
        // TODO: Add fit/fill/letterbox options for fitting surfaces into textures        
        glBegin(GL_QUADS);
        glTexCoord2f(surfaceSize.width, surfaceSize.height);
        glVertex2f(0.0f, 0.0f);
        
        glTexCoord2f(surfaceSize.width, 0.0);
        glVertex2f(0.0f, nativeTextureSize.height);

        glTexCoord2f(0.0, 0.0);
        glVertex2f(nativeTextureSize.width, nativeTextureSize.height);

        glTexCoord2f(0.0, surfaceSize.height);
        glVertex2f(nativeTextureSize.width, 0.0f);
        
        glEnd();

  
        // for some reason this was not working for me form within Unity.. :(
/*        GLfloat coords[] = 
        {
            0.0f, 0.0f,
            0.0f, surfaceSize.height,
            surfaceSize.width, surfaceSize.height,
            surfaceSize.width, 0.0f,
        };
  
  
        GLfloat verts[] = 
		{
			0.0f, 0.0f,
			0.0f, nativeTextureSize.height,
			nativeTextureSize.width, nativeTextureSize.height,
			nativeTextureSize.width, 0.0f,
		};
		
		glEnableClientState( GL_TEXTURE_COORD_ARRAY );
		glTexCoordPointer(2, GL_FLOAT, 0, coords );
		glEnableClientState(GL_VERTEX_ARRAY);
		glVertexPointer(2, GL_FLOAT, 0, verts );
		glDrawArrays( GL_TRIANGLE_FAN, 0, 4 );
*/
        
        glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
        glDisable(GL_TEXTURE_RECTANGLE_EXT);
        
        
		//glEnable(GL_TEXTURE_2D);
        
		// Restore OpenGL states
		glMatrixMode(GL_MODELVIEW);
		glPopMatrix();
		
		glMatrixMode(GL_PROJECTION);
		glPopMatrix();
                
		glMatrixMode(GL_TEXTURE);
		glPopMatrix();
		
		glPopClientAttrib();
		glPopAttrib();
        
        //glFlushRenderAPPLE();
        
        glBindFramebufferEXT(GL_FRAMEBUFFER, previousFBO);	
        glBindFramebufferEXT(GL_READ_FRAMEBUFFER, previousReadFBO);
        glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER, previousDrawFBO);        

    }
    [pool drain];
}