//SyphonClientUnity.m
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
//#import <OpenGL/CGLMacro.h>

// texture attachment is going to come from unity via GetNativeID();
static GLuint syphonFBO = 0; 
//
//
void syphonClientDestroyResources(SyphonClient* client)
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    //    
    //    glDeleteFramebuffersEXT(1, &syphonFBO);
    //    syphonFBO = 0;
    //    
    //    // lets create our client if we dont have it. 
    if(client)
    {
        [client stop];
        [client release];
        client = nil;
        
        //NSLog(@"destroyed Syphon Client");
    }
    [pool drain];
}


void syphonClientPublishTexture(SyphonCacheData* ptr){
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if(ptr->syphonClient && [ptr->syphonClient isValid]){
        //        //should probably check if CGLGetCurrentContext() is == cachedContext
        
        //lock
        //CGLLockContext(cachedContext);
        
        //cache previous bits
        GLint previousFBO, previousReadFBO, previousDrawFBO, previousMatrixMode;
        glGetIntegerv(GL_FRAMEBUFFER_BINDING, &previousFBO);
        glGetIntegerv(GL_READ_FRAMEBUFFER_BINDING, &previousReadFBO);
        glGetIntegerv(GL_DRAW_FRAMEBUFFER_BINDING, &previousDrawFBO);
        glGetIntegerv(GL_MATRIX_MODE, &previousMatrixMode);
        glPushAttrib(GL_ALL_ATTRIB_BITS);
        glPushClientAttrib(GL_CLIENT_ALL_ATTRIB_BITS);
        
        
        //make sure FBO is valid
        if(!syphonFBO)
        {	
            glGenFramebuffersEXT(1, &syphonFBO);
        }
        
        //bind FBO
        glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, syphonFBO);
        glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, ptr->textureID, 0);
        
        GLenum status;
        status = glCheckFramebufferStatus(GL_FRAMEBUFFER_EXT);
        
        if(status != GL_FRAMEBUFFER_COMPLETE_EXT)
        {
            NSLog(@"ERROR: UNITY PLUGIN CANNOT MAKE VALID FBO ATTACHMENT FROM UNITY TEXTURE ID");
            glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER, previousDrawFBO);        
            glBindFramebufferEXT(GL_READ_FRAMEBUFFER, previousReadFBO);
            glBindFramebufferEXT(GL_FRAMEBUFFER, previousFBO);
            glPopClientAttrib();
            glPopAttrib();
            // CGLUnlockContext(cachedContext);
            [pool drain];
            return;
        }   
        
        
        //setup state to how it 'should' be?
        glDisable (GL_CULL_FACE);
        glDisable (GL_LIGHTING);
        glDisable (GL_BLEND);
        glDisable (GL_ALPHA_TEST);
        glDepthFunc (GL_LEQUAL);
        glEnable (GL_DEPTH_TEST);
        glDepthMask (GL_FALSE);
        
        //get image!
        SyphonImage* image = [ptr->syphonClient newFrameImageForContext:cachedContext];
        
        
        
        //SAVE MATRIX STATE CODE
        glActiveTexture(GL_TEXTURE0);
        glMatrixMode(GL_TEXTURE);
        glPushMatrix();
        glLoadIdentity();				
        // Setup OpenGL coordinate system
        glViewport(0, 0, ptr->textureWidth,  ptr->textureHeight);
        glMatrixMode(GL_PROJECTION);
        glPushMatrix();
        glLoadIdentity();				
        glOrtho(0, ptr->textureWidth, 0, ptr->textureHeight, -1, 1);	
        glMatrixMode(GL_MODELVIEW);
        glPushMatrix();
        glLoadIdentity();				
        glColor4f(0, 0, 0, 0);
        //END SAVE MATRIX STATE CODE
        
        glEnable(GL_TEXTURE_RECTANGLE_EXT);
        glBindTexture(GL_TEXTURE_RECTANGLE_EXT, [image textureName]);
        NSSize surfaceSize = [image textureSize];
        
        if(ptr->textureWidth != surfaceSize.width || ptr->textureHeight != surfaceSize.height){
            //perform callback to unity here because the w/h changed
            ptr->textureWidth = (int)surfaceSize.width;
            ptr->textureHeight = (int)surfaceSize.height;
            NSLog(@"w/h: %i, %i", ptr->textureWidth, ptr->textureHeight);
            ptr->updateTextureSizeFlag = true;
        }
        
        //okay, draw the shit
        glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
        glTexParameterf( GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
        glTexParameterf( GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
        glTexParameterf( GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE );		
        //        glBegin(GL_QUADS);					
        //        glTexCoord2f(0, surfaceSize.height);
        //        glVertex2f(0, 0);
        //        
        //        glTexCoord2f(0, 0);
        //        glVertex2f(0, surfaceSize.height);					
        //        
        //        glTexCoord2f(surfaceSize.width, 0);
        //        glVertex2f(surfaceSize.width, surfaceSize.height);					
        //        
        //        glTexCoord2f(surfaceSize.width,surfaceSize.height);
        //        glVertex2f(surfaceSize.width, 0);					
        //        glEnd();
        
        glBegin(GL_QUADS);					
        glTexCoord2f(0, 0);
        glVertex2f(0, 0);        
        glTexCoord2f(0, surfaceSize.height);
        glVertex2f(0, surfaceSize.height);					        
        glTexCoord2f(surfaceSize.width, surfaceSize.height);
        glVertex2f(surfaceSize.width, surfaceSize.height);					        
        glTexCoord2f(surfaceSize.width,0);
        glVertex2f(surfaceSize.width, 0);					
        glEnd();
        
        glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
		glDisable(GL_TEXTURE_RECTANGLE_EXT);
        
        //POP MATRIX STATE CODE
        glMatrixMode(GL_MODELVIEW);
        glPopMatrix();			
        glMatrixMode(GL_PROJECTION);
        glPopMatrix();		
        glMatrixMode(GL_TEXTURE);
        glPopMatrix();	
        
        glPopClientAttrib();
        glPopAttrib();	
        
        glBindFramebufferEXT(GL_FRAMEBUFFER, previousFBO);	
        glBindFramebufferEXT(GL_READ_FRAMEBUFFER, previousReadFBO);
        glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER, previousDrawFBO);        
        
        [image release];
        
        //  CGLUnlockContext(cachedContext);
    }
    [pool drain];
}


