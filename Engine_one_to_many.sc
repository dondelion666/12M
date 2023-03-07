// CroneEngine_one_to_many
Engine_one_to_many : CroneEngine {

    var b;
    var synth;

    *new { arg context, doneCallback;
        ^super.new(context, doneCallback);
    }

    alloc {
    
    b=Buffer.new(context.server);
    
    SynthDef("bufplayer", {
    
      var snd;
  	  snd=PlayBuf.ar(
    		numChannels:2,
  	  	bufnum:b,
  	  	loop:0;
  	  );
  	    Out.ar(0,snd); 
      }).add;
    
    context.server.sync;
    
    synth=Synth("bufplayer",target:context.server);
    
    this.addCommand("file", "s", { arg msg;
         
         b.free;
         
         b=Buffer.read(context.server,msg[1]);
         
         });
    
    }

    free {
        synth.free;
    }
}
