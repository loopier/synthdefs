// from "/Applications/SuperCollider/examples/demonstrations/stealthissound.scd"

(
SynthDef(\bass,{|out= 0 freq = 440 amp = 0.1 gate=1 cutoff= 1000 rq=0.2 pan=0.0 drive = 2.0, filtertime=1 |

	var osc, filter, env, filterenv;
	var oschiend, filterhiend;
	var ab;
	var sig, sighiend;

	osc = Saw.ar(freq);
	oschiend = Mix(Saw.ar(freq*[0.25,1,1.5],[0.5,0.4,0.1]));

	filterenv = EnvGen.ar(Env.adsr(0.0,0.5,0.2,0.2),gate, timeScale: filtertime,doneAction:2);
	filter =  RLPF.ar(osc,cutoff*filterenv+100,rq);

	filterhiend =  RLPF.ar(oschiend,cutoff*filterenv+100,rq);
	ab = abs(filterhiend);
	filterhiend = (filterhiend*(ab + drive)/(filterhiend ** 2 + (drive - 1) * ab + 1));
	//remove low end
	filterhiend = BLowShelf.ar(filterhiend,300,1.0,-12);
	//dip at 1600Hz
	filterhiend = BPeakEQ.ar(filterhiend,1600,1.0,-6);

	env = EnvGen.ar(Env.adsr(0.01,0.0,0.9,0.05),gate,doneAction:2);

	sig = filter*env*amp*2;
	sighiend = filterhiend*env*amp*2;

	Out.ar(out,Pan2.ar(filter*env*amp*2,pan));

}).store;
)

// (
// Pdef(\a,
// 	Pfxb(
// 		Pbind(\instrument, \bass,
// 			// \midinote,Pstutter(4,Pseq([36,43,39,31],inf)),
// 			\octave, Pseq([3,4],inf),
// 			\scale, Scale.minor,
// 			\degree, Pstutter(2, Pseq([0,2,-2,-3],inf)),
// 			\dur, 1,
// 			\rq,Pstutter(4,Pn(Pseries(1.0,-0.1,8),inf)),
// 			\cutoff,Pstutter(4,Pn(Pseries(8000,-1000,7),inf))
// 		),
// 	\chorus),
// ).play;
// )
