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

	
	if(syphonFBO){
		glDeleteFramebuffersEXT(1, &syphonFBO);
		syphonFBO = 0;
	}

    if(client)
    {
        [client stop];
        [client release];
        client = nil;
        
//		NSLog(@"destroyed Syphon Client");
    }
    [pool drain];
}


void syphonClientPublishTexture(SyphonCacheData* ptr){
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    if(ptr != NULL && ptr->syphonClient != nil && [ptr->syphonClient isValid] && ptr->textureID != 0){
//		NSLog(@"PUBLISHIN SOMETHIN AT %i/ %@", (int)ptr, ptr->syphonClient);
        
		if(!glIsTexture(ptr->textureID)){
			NSLog(@"GO FUCK YOURSELF! %i is not a texture! cannot publish client texture.", ptr->textureID);
			return;
		}
		
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
            glGenFramebuffers(1, &syphonFBO);
        }
        
        //bind FBO
        glBindFramebuffer(GL_FRAMEBUFFER, syphonFBO);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, ptr->textureID, 0);
        
        GLenum status;
        status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        
        if(status != GL_FRAMEBUFFER_COMPLETE)
        {
            NSLog(@"ERROR: UNITY PLUGIN CANNOT MAKE VALID FBO ATTACHMENT FROM UNITY TEXTURE ID. tex id is %i, error is %i", ptr->textureID, status);
            glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER, previousDrawFBO);        
            glBindFramebufferEXT(GL_READ_FRAMEBUFFER, previousReadFBO);
            glBindFramebufferEXT(GL_FRAMEBUFFER, previousFBO);
            glPopClientAttrib();
            glPopAttrib();
            [pool drain];
            return;
        }
//		else{
//			NSLog(@"drawing. tex id is %i, status is %i", ptr->textureID, status);
//		}
        
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
        
        if(!image){
//			NSLog(@"nil image.");
			//SAVE MATRIX STATE CODE
//			glActiveTexture(GL_TEXTURE0);

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
			glClearColor(0, 0, 0, 0);
			glClear(GL_COLOR_BUFFER_BIT);

			
			//POP MATRIX STATE CODE
			glMatrixMode(GL_MODELVIEW);
			glPopMatrix();
			glMatrixMode(GL_PROJECTION);
			glPopMatrix();
			glMatrixMode(GL_TEXTURE);
			glPopMatrix();
			
            glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER, previousDrawFBO);
            glBindFramebufferEXT(GL_READ_FRAMEBUFFER, previousReadFBO);
            glBindFramebufferEXT(GL_FRAMEBUFFER, previousFBO);
            glPopClientAttrib();
            glPopAttrib();
            // CGLUnlockContext(cachedContext);
            [pool drain];
            return;
		}
        

//		NSLog(@"drawing. tex id is %i, status is %i", ptr->textureID, status);


		
		
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
        
        if((int)ptr->textureWidth != (int)surfaceSize.width || (int)ptr->textureHeight != (int)surfaceSize.height){
            ptr->textureWidth = (int)surfaceSize.width;
            ptr->textureHeight = (int)surfaceSize.height;

			
			
			if(ptr->textureWidth == 0 || ptr->textureHeight == 0){			
				glBindTexture(GL_TEXTURE_RECTANGLE_EXT, 0);
				glDisable(GL_TEXTURE_RECTANGLE_EXT);
				
				//POP MATRIX STATE CODE
				glMatrixMode(GL_MODELVIEW);
				glPopMatrix();
				glMatrixMode(GL_PROJECTION);
				glPopMatrix();
				glMatrixMode(GL_TEXTURE);
				glPopMatrix();
				
				glBindFramebufferEXT(GL_FRAMEBUFFER, previousFBO);
				glBindFramebufferEXT(GL_READ_FRAMEBUFFER, previousReadFBO);
				glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER, previousDrawFBO);
				
				glPopClientAttrib();
				glPopAttrib();
				
				if(image)
				[image release];
				
				return;
			}

			//perform callback to unity here because the w/h changed
			handleTextureSizeChanged(ptr);
//            NSLog(@"w/h: %i, %i", ptr->textureWidth, ptr->textureHeight /*, texcount*/ );


        }
//		NSLog(@"DRAWING THE SHIT");
        
        //okay, draw the shit
        glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
        glTexParameterf( GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
        glTexParameterf( GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
        glTexParameterf( GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE );		

        
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
        
//		GLint texcount = 0;
//		glGetIntegerv(GL_TEXTURE_STACK_DEPTH, &texcount);
//		GLint modelcount = 0;
//		glGetIntegerv(GL_TEXTURE_STACK_DEPTH, &modelcount);
//		GLint projcount = 0;
//		glGetIntegerv(GL_TEXTURE_STACK_DEPTH, &projcount);
//
//		NSLog(@"w/h: %i, %i, counts: %i/%i/%i", ptr->textureWidth, ptr->textureHeight , texcount, modelcount, projcount);

		
        glBindFramebufferEXT(GL_FRAMEBUFFER, previousFBO);
        glBindFramebufferEXT(GL_READ_FRAMEBUFFER, previousReadFBO);
        glBindFramebufferEXT(GL_DRAW_FRAMEBUFFER, previousDrawFBO);

        glPopClientAttrib();
        glPopAttrib();
        
		if(syphonFBO){
//			NSLog(@"CACHING CONTEXT +  DELETING FBO at RESOURCE ID: %i", syphonFBO);
			glDeleteFramebuffersEXT(1, &syphonFBO);
			glGenFramebuffersEXT(1, &syphonFBO);
			syphonFBO = nil;
		}

		
        [image release];
		
		
//		glGetIntegerv(GL_TEXTURE_STACK_DEPTH, &texcount);
//		glGetIntegerv(GL_TEXTURE_STACK_DEPTH, &modelcount);
//		glGetIntegerv(GL_TEXTURE_STACK_DEPTH, &projcount);
//		
//		NSLog(@"again counts: %i/%i/%i",  texcount, modelcount, projcount);

        
        //  CGLUnlockContext(cachedContext);
    }
    [pool drain];
}


