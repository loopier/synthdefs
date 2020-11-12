(
SynthDef(\white, {
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var amp = \amp.kr(1);
	var gate = \gate.kr(1);
	var attack = \attackTime.kr(0.01);
	var decay = \decayTime.kr(0.3);
	var sustain = \sustainLevel.kr(0.5);
	var release = \releaseTime.kr(1);
	var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	var sig = WhiteNoise.ar(amp);
	Out.ar(out, Pan2.ar(sig * env, pan));
}).store;

SynthDef(\sine, {
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var feedback = \feedback.kr(0);
	var gate = \gate.kr(1);
	var attack = \attackTime.kr(0.01);
	var decay = \decayTime.kr(0.3);
	var sustain = \sustainLevel.kr(0.5);
	var release = \releaseTime.kr(1);
	var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	var sig = SinOscFB.ar(freq, feedback, amp);
	Out.ar(out, Pan2.ar(sig * env, pan));
}).store;

SynthDef(\saw, {
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var gate = \gate.kr(1);
	var attack = \attackTime.kr(0.01);
	var decay = \decayTime.kr(0.3);
	var sustain = \sustainLevel.kr(0.5);
	var release = \releaseTime.kr(1);
	var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	var sig = Saw.ar(freq, amp);
	Out.ar(out, Pan2.ar(sig * env, pan));
}).store;

SynthDef(\pulse, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var pan = \pan.kr(0);
	var freq = \freq.kr(440);
	var width = \width.kr(0.5);
	var gate = \gate.kr(1);
	var attack = \attackTime.kr(0.01);
	var decay = \decayTime.kr(0.3);
	var sustain = \sustainLevel.kr(0.5);
	var release = \releaseTime.kr(1);
	var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	var sig = Pulse.ar(freq, width, amp);
	Out.ar(out, Pan2.ar(sig * env, pan));
}).store;
)
