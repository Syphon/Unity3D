Syphon for Unity Pro 3.5+
Copyright (c)  2010-2012 Brian Chasalow, bangnoise (Tom Butterworth) & vade (Anton Marini).
/*
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

Syphon for Unity 3.5, version 1.0

Please report any and all crashes/freezes, preferably including crash logs

http://code.google.com/p/syphon-implementations/issues

If Unity freezes, see http://www.thexlab.com/faqs/activitymonitor.html the section entitled 'sampling a process' and send us that log.
if Unity crashes, see http://echoone.com/bugreports/console.html and send the relevant log.

More features to be added soon. If there's something missing that you want, let us know.

Instructions-
Add a Syphon.cs to your main camera. this will act as your Syphon manager.

Syphon Server:
Add a SyphonServerTexture to any camera in your scene. 

Syphon Client:
Add a SyphonClientTexture to any object in your scene.

On the Syphon.cs script inspector:
Click on a Syphon server in the dropdown menu, then click 'add' to add it to the clients list.
On your SyphonClientTexture, in the public inspector fields, add the name and appName of the client you just added.
Take a look at the code in SyphonClientTexture.cs's ApplyTexture() method to see how to add additional functionality- adding the texture to projectors, bump maps, etc.
