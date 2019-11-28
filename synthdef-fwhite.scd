SynthDef(\fwhite, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var gate = \gate.kr(1);
	var attack = \attackTime.kr(0.01);
	var decay = \decayTime.kr(0.3);
	var sustain = \sustainLevel.kr(0.5);
	var release = \releaseTime.kr(1);
	var freq = \freq.kr(440);
	var rq = \rq.kr(0.1);
	var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	var sig = RLPF.ar(WhiteNoise.ar(amp), freq, rq);
	Out.ar(out, sig * env);
}).store;
