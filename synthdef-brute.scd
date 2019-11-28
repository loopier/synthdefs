(
SynthDef(\brute, {
	var freq = \freq.kr(440);
	var overtone = min(\overtone.kr(0), 1);
	var sub = min(\sub.kr(0), 1) * overtone;
	var fifth = min(\fifth.kr(0), 1) * overtone;
	var amp = \amp.kr(0.3);
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var attackTime = \attackTime.kr(0.01);
	var decayTime = \decayTime.kr(0.3);
	var sustainLevel = \sustainLevel.kr(0.5);
	var releaseTime = \releaseTime.kr(0.01);
	var gate = \gate.kr(1);
	var wave = \wave.kr(0);
	var pw = \pw.kr(0.5);
	// var distort = \distort.kr(20);

	var sig, env;

	freq = [
		freq,
		freq / 2, // sub
		freq * 2.pow(7/12), // fifth
	];
	sig = Select.ar(wave, [
		Saw.ar(freq),
		Pulse.ar(freq, pw),
		DPW3Tri.ar(freq)
	]) * [1, sub, fifth];
	env = Env.adsr(attackTime, decayTime, sustainLevel, releaseTime).kr(2, gate);

	// sig = Select.ar(distort > 1, [sig, (sig * max(distort, 1)).distort]);

	Out.ar(out, Pan2.ar(sig.sum * env * amp, pan));
}).add
)

(
var synthname = \brute;
Pdef((synthname++"pat").asSymbol,
	Pfx(
	Pbind(\instrument, synthname,
		\octave, 3,
		\degree, 0,
		\dur, 1,
		// \attackTime, 0.01,
		// \decayTime, 0.3,
		// \sustainLevel, 0.5,
		// \releaseTime, 1,
		// \amp, 0.3,
		\wave, 0,//Prand((0..2),inf),
		\pw, 0.5,//Pseq([0.1, 0.5, 0.9], inf), //  only with wave=1 -- square
		\sub, 1,//Pn(Pseries(0, 0.2,10)),
		\fifth, 1,//Pn(Pseries(0, 0.2,11)),
		\overtone, 0,
		\distort, 20,
	),
		\wah
	)
).play
)

Synth(\brute, [pw: 0.1, wave:1]);
Synth(\brute, [pw: 0.5, wave:1]);

s.scope