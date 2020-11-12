(
SynthDef(\theremin, { arg mod = 7, detune = 0, freq = 440, amp = 1, out = 0, pan = 0, gate = 1;
	var f, a, z, env;
	a = SinOsc.ar(freq + (freq * SinOsc.ar(mod,0,0.02)), mul: amp);
	z = Mix.ar(a);

	env = EnvGen.ar(Env.linen(\attackTime.kr(0.05), \sustainTime.kr(0.9), \releaseTime.kr(0.05)),gate,doneAction:2);

	Out.ar(out, Pan2.ar(z * env, pan))
}).store
)
//
// (
// Pdef(\a,
// 	Pbind(
// 		\instrument,\theremin,
// 		\degree,Pseq([0,3,8,7,5,8,7,3],inf),
// 		\dur, 2,
// 		\mod,Pn(Pseries(0.0,0.5,9),inf),
// 		\detune,Pn(Pseries(0,0.1,11),inf),
// 	)
// ).play
// )