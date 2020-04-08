// from "/Applications/SuperCollider/examples/demonstrations/stealthissound.scd"

// velocity-controlled bass
(

SynthDef(\velobass,{|out= 0 freq = 440 amp = 0.1 gate=1 cutoff= 12000 rq=0.25 lagTime=0.01 pan = 0.0|

	var lfo, osc, filter, env, sig;

	var basefreq =  ((freq.lag(lagTime).cpsmidi)+[0,11.95,31.03]).midicps;

	osc = Saw.ar(basefreq,[0.5,0.4,0.1]); //+PinkNoise.ar(Line.kr(1.0,0,0.03));

	env = EnvGen.ar(Env.adsr(0.01,1.0,1.0,0.25),gate,doneAction:2);

	filter = BLowPass4.ar(osc,100+((amp.squared)*(freq+cutoff)),rq);

	sig = Mix(filter)*env*amp*0.8 * (-10.dbamp);

	Out.ar(out,Pan2.ar(sig,pan));

}).store
)


(
Pdef(\a,
	PmonoArtic(
		\velobass,
		\octave, 3,
		// \midinote,Pseq([13,18,3,1,3,1,3,1,4,1,3]+36,inf),
		\dur,Pseq([0.5,0.5,0.5,0.5,1.0,0.5,1.5,0.5,1.0,0.5,1.0],inf),
		\amp,Pseq([0.7,1.0,0.5,0.6,0.4,0.7,0.8,0.3,0.6,0.4,0.7],inf),
		\cutoff, Pkey(\amp) * 2000 + 1000,
		\rq,0.1,
	),
).play
)

(
Pdef(\a,
	// Pfxb(
		Pbind(\instrument, \velobass,
			// \midinote,Pstutter(4,Pseq([36,43,39,31],inf)),
			\octave, Pseq([3,4],inf),
			\scale, Scale.minor,
			\degree, Pstutter(2, Pseq([0,2,-2,-3],inf)),
			\dur, 1/2,
		\amp, Pn(Pstutter(4,Pseries(0.3, 0.05, 30))),
			\rq,Pstutter(4,Pn(Pseries(1.0,-0.1,8),inf)),
			// \cutoff,Pstutter(4,Pn(Pseries(8000,-1000,7),inf)),
			\cutoff, Pkey(\amp) * 2000 + 1000,
		),
		// \chorus),
).play;
)