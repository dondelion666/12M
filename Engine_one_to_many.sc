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
      arg out=0, rate=1, start=0, end=1, trig=0;
      var env, snd, pos, frames;
      
      // rate is modified by BufRateScale to convert between sampling rates
	    rate = rate*BufRateScale.kr(b);
	    // frames is the number of frames
	    frames = BufFrames.kr(b);
	    
	    // Phasor is a ramp
	    pos=Phasor.ar(
	      trig:trig,
		    rate:rate,
		    start:start*frames,
		    end:end*frames,
		    resetPos:start*frames,
	    );
	    
	    env=EnvGen.ar(Env.asr(0.01,1,0.01,0),gate:trig);
      
  	  snd=BufRd.ar(
		    numChannels:2,
		    bufnum:b,
		    phase:pos,
		    loop:0,
		    interpolation:4,
	    );
	    
	    snd=snd*env;
	    
  	  Out.ar(out,snd); 
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
        synths[msg[1]-1].set(\trig,1);
        });
    
    }

    free {
        synths.free;
    }
}
