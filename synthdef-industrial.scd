StageLimiter.activate;
(
SynthDef(\boom, {
	var amp = \amp.kr(0.2);
	// probability of hits per second
	var density = \density.kr(0.25);
	var freq = \freq.kr(440);
	var out = \out.kr(0);
	var gate = \gate.kr(1);
	var dur = \dur.kr(1);

	var sig = BrownNoise.ar(amp);
	var env = EnvGen.ar(
		envelope: Env.perc(releaseTime: 10, curve: -8),
		gate: gate,
		// gate: Impulse.ar(LFNoise0.ar(density).range(0.1,density)),
		doneAction: 2,
	);

	sig = sig * env;
	sig = RLPF.ar(
		in: GVerb.ar(
			in: sig,
			roomsize: 300,
			revtime: 5,
			damping: 0.15,
			inputbw: 0.5,
			spread: 30,
			drylevel: 1,
			earlyreflevel: 0.7,
			taillevel: 0.95,
			mul: 1,
		),
		freq: freq,
		rq: 0.5,
	);

	Out.ar(out, sig);
}).store;
)