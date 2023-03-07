// CroneEngine_one_to_many
Engine_one_to_many : CroneEngine {

    var b;
    var synths;

    *new { arg context, doneCallback;
        ^super.new(context, doneCallback);
    }

    alloc {
    
    b=Buffer.new(context.server);
    
    SynthDef("bufplayer", {
      arg t_trig=0;
      var snd;
  	  snd=PlayBuf.ar(
  	    trigger: t_trig,
    		numChannels:2,
  	  	bufnum:b,
  	  	loop:0;
  	  );
  	    Out.ar(0,snd); 
      }).add;
    
    context.server.sync;
    
   
    synths=Array.fill(32,{arg i;
        Synth("bufplayer",target:context.server);
        });
    
    this.addCommand("file", "s", { arg msg;
         b.free;
         b=Buffer.read(context.server,msg[1]);
         });
         
    this.addCommand("play", "ii", { arg msg;
        synths[msg[1]-1].set(\t_trig,1);
        });
    
    }

    free {
        synths.free;
    }
}
