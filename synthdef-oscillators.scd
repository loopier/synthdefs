(
SynthDef(\white, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var gate = \gate.kr(1);
	var attack = \attackTime.kr(0.01);
	var decay = \decayTime.kr(0.3);
	var sustain = \sustainLevel.kr(0.5);
	var release = \releaseTime.kr(1);
	var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	var sig = WhiteNoise.ar(amp);
	Out.ar(out, sig * env);
}).store;

SynthDef(\sine, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var phase = \phase.kr(0);
	var gate = \gate.kr(1);
	var attack = \attackTime.kr(0.01);
	var decay = \decayTime.kr(0.3);
	var sustain = \sustainLevel.kr(0.5);
	var release = \releaseTime.kr(1);
	var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	var sig = SinOsc.ar(freq, phase, amp);
	Out.ar(out, sig * env);
}).store;

SynthDef(\saw, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var gate = \gate.kr(1);
	var attack = \attackTime.kr(0.01);
	var decay = \decayTime.kr(0.3);
	var sustain = \sustainLevel.kr(0.5);
	var release = \releaseTime.kr(1);
	var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	var sig = Saw.ar(freq, amp);
	Out.ar(out, sig * env);
}).store;

SynthDef(\pulse, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var width = \width.kr(0.5);
	var gate = \gate.kr(1);
	var attack = \attackTime.kr(0.01);
	var decay = \decayTime.kr(0.3);
	var sustain = \sustainLevel.kr(0.5);
	var release = \releaseTime.kr(1);
	var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	var sig = Pulse.ar(freq, width, amp);
	Out.ar(out, sig * env);
}).store;
)
