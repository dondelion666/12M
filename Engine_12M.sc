// CroneEngine_12M
Engine_12M : CroneEngine {

    //////// 1 ////////
    // we will initialize variables here
    // the only variable we need is one
    // to store the synth we create
    var buffer;
    var synth;

    // don't change this
    *new { arg context, doneCallback;
        ^super.new(context, doneCallback);
    }

    // alloc is where we will define things
    alloc {

        //////// 2 ////////
        // define here!
        SynthDef("bufplayer", {
        arg out;
        
        out=Playbuf.ar(
        numChannels:2,
        bufnum: buffer,
        );
        
	      Out.ar(0,out);
	      }).add;

       context.server.sync;


        //////// 3 ////////
		// create the the sound "synth"s
        synth=Synth("bufplayer",target:context.server);
        

        //////// 4 ////////
        // define commands for the lua

        // a load function to load samples
        this.addCommand("load","s", { arg msg;
        
            Buffer.read(context.server,msg[1]);
            });
        

        
    }


    free {
        //////// 5 ////////
        // free any variable we create
        // otherwise it won't ever stop!
        synth.free;
    }
}
