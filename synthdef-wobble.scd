// from "/Applications/SuperCollider/examples/demonstrations/stealthissound.scd"
(
SynthDef(\wobble,{|out= 0 freq = 440 amp = 1.0 gate=1 lforate = 10 lfowidth= 0.5 cutoff= 12000 rq=0.5 pan=0.0|

	var lfo, pulse, filter, env;

	lfo = LFTri.kr(lforate,Rand(0,2.0)!2);

	pulse = Pulse.ar(freq*(1.0+(lfowidth*lfo)),0.5);

	filter = RLPF.ar(pulse,cutoff,rq);

	env = EnvGen.ar(Env.adsr(\attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5), \releaseTime.kr(1)),gate,doneAction:2);

	Out.ar(out,Pan2.ar(filter*env*amp*0.5,pan));

}).store;
)
//
// (
// Pdef(\a,
// 	// Pfxb(
// 	Pbind(
// 		\instrument,\wobble,
// 		\octave, 3,
// 		\degree,Pseq([0,3,8,7,5,8,7,3],inf),
// 		\dur,Pseq((0.5!8) ++ (0.25!8) ++ (2.0!8),inf),
// 		\lfowidth,Pn(Pseries(0.0,0.025,7),inf),
// 		\lforate,Pn(Pseries(2,1,11),inf),
// 		\rq,Pn(Pseries(0.9,-0.1,5),inf),
// 		// \attackTime, 0.3,
// 	),
// 	// \chorus),
// ).play
// )