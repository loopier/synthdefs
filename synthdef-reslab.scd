(
SynthDef(\reslab, {
	var freq = \freq.kr(440);
	var amp = \amp.kr(1);
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var attackTime = \attackTime.kr(0.01);
	var decayTime = \decayTime.kr(0.01);
	var sustainLevel = \sustainLevel.kr(0.5);
	var releaseTime = \releaseTime.kr(0.5);
	var gate = \gate.kr(1);
	var cutoff = \cutoff.kr(1000);
	var rq = \rq.kr(0.1);

	var sig, env, filter;
	env = Env.adsr(attackTime, decayTime, sustainLevel, releaseTime).kr(2, gate);
	// env = EnvGen.kr(Env.perc(attackTime, decayTime), gate, doneAction: 2);
	sig = Mix([Saw.ar(freq), Pulse.ar(freq / 2, 0.5)]);
	// sig = RLPF.ar(sig, LFNoise1.kr(0.3, 1000, 1500), rq, env);
	sig = RLPF.ar(sig, cutoff, rq, env);

	Out.ar(out, Pan2.ar(sig * env * amp * (-12.dbamp), pan));
}).store
)

(
Pdef(\res,
	// Pfxb(
	Pbind(\instrument, \reslab, \scale, Scale.spanish, \degree, Pseq({(0..7).choose}.dup(8),inf), \dur, 1/8, \releaseTime, 0.01, \octave, Pstutter(100,Pseq([3,4,5],inf)), \pan, Pn(Pseries(-1.0, 0.02, 100)), \cutoff, Pn(Pseries(300, 100, 100)), \amp, 1)
		// , \gverb, \room, 50, \damp, 0.97)
).play
)
