(
// low pass gate
SynthDef(\lpg, {
	var lfofreq = \lfofreq.kr(1);
	var lfodepth = \lfodepth.kr(0);
	var freq = \freq.kr(440) * (1 + (LFTri.kr(lfofreq) * lfodepth));
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var gate = \gate.kr(1);
	var attack = \attack.kr(0.01);
	var decay = \decay.kr(0.3);
	var sustain = \sustain.kr(0.5);
	var release = \release.kr(1);
	// overall envelope
	// var env = EnvGen.ar(Env.adsr(attack, decay, sustain, release), gate , // timeScale:dur,
	var env = EnvGen.ar(Env.perc(attack, release), gate , // timeScale:dur,
		doneAction:2);
	var amp = \amp.kr(1);
	var width = \width.kr(0.5);
	var sound = Pulse.ar(freq: freq * env, width: width, mul: env);
    // var sound = \in.ar;
	sound = RLPF.ar(in: sound, freq: freq * env, rq: env + 0.01, mul: env);
	sound = sound * amp;
	// sound = sound * (-10.dbamp);
	OffsetOut.ar(out, Pan2.ar(sound, pan));
}).store;
)

// Pdef(\a, Pbind(\instrument, \lpg, \octave, Pwhite(3,7), \dur, 0.25, \degree, Pwhite(0,7), \release, 2, \lfofreq,10, \lfodepth, 0.05, \width, Pwhite(0.1,0.9))).play

