// from "/Applications/SuperCollider/examples/demonstrations/stealthissound.scd"

(

//no use of gate, fixed length
SynthDef(\moogbass,{|out= 0 freq = 440 amp = 0.1 gate=1 attackTime= 0.2 fenvamount=0.5 cutoff= 1000 gain=2.0 pan=0.0|

	var osc, filter, env, filterenv;

	//alternative: richer source
	osc = Mix(Pulse.ar(freq.lag(0.05)*[1.0,1.001,2.0],Rand(0.45,0.5)!3,0.33));

	filterenv = EnvGen.ar(Env.adsr(attackTime,0.0,1.0,0.2),gate,doneAction:2);
	filter =  MoogFF.ar(osc,cutoff*(1.0+(fenvamount*filterenv)),gain);

	// env = EnvGen.ar(Env.adsr(0.001,0.3,0.9,0.2),gate,doneAction:2);
	env = EnvGen.ar(Env.adsr(attackTime, \decayTime.kr(0.3), \sustainLevel.kr(0.9), \releaseTime.kr(0.2)),gate,doneAction:2);

	Out.ar(out,Pan2.ar((0.7*filter+(0.3*filter.distort))*env*amp,pan));

}).store;

)

(
Pdef(\a,
	// Pfxb(
		Pfxb(
			// Pmono( \moogbass,
			Pbind( \instrument, \moogbass,
				\amp, 0.8,
				\octave, Pseq([3,4],inf),
				\scale, Scale.minor,
				\degree, Pstutter(2, Pseq([0,2,-2,-3],inf)),
				// \degree, Pseq([ 0, 0, 7, 0, 7, 0, 0, 0, 0, 0, 3, 0, 7, 7, 7, 7, 7, 10, 7, 10 ],inf),
				// \midinote,Pseq([24,36,43,48, 43,48,36,36, 36,36,39,36, 31,31,31,31, 31,34,31,34]-24,inf),
				\dur, 1,
				// \legato, 0.01,
				// \releaseTime, 0,
				\gain,Pn(Pseries(2,0.1,19),inf),
				\cutoff,Pstutter(3,Pn(Pseries(50,250,40),inf)),
				\attackTime,Pn(Pseries(0.0,0.01,30),inf),
				\fenvamount,Pstutter(4,Pn(Pseries(0.0,0.05,20),inf))
			),
			\chorus),
		// \distort),
).play
)