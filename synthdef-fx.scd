(
SynthDef(\echo, { arg out=0, maxdelayTime=1, delayTime=0.2, decay=2, gate=1;
    var env, in;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    in = In.ar(out, 2);
    XOut.ar(out, env, CombL.ar(in * env, maxdelayTime, delayTime, decay, 1, in));
}, [\ir, \ir, 0.1, 0.1, 0]).store;

SynthDef(\distort, { arg out=0, pregain=40, amp=0.2, gate=1;
    var env;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    XOut.ar(out, env, (In.ar(out, 2) * pregain).distort * amp);
}, [\ir, 0.1, 0.1, 0]).store;

SynthDef(\wah, {
	var out = \out.kr(0);
	var gate = \gate.kr(1);
	var rate = \rate.kr(0.3);
	var amp = \amp.kr(1);
    var env = Linen.kr(gate, 0.05, 1, 0.4, 2);
    var in = In.ar(out, 2);
    XOut.ar(out, env, RLPF.ar(in, LinExp.kr(LFNoise1.kr(rate), -1, 1, 200, 8000), 0.1, mul:amp).softclip * 0.8);
}, [\ir, 0]).store;

SynthDef(\rlpf, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var gate = \gate.kr(1);
	var freq = \freq.kr(440);
	var rq = \rq.kr(0.1);
	var env = Linen.kr(gate, 0.05, 1, 0.4, 2);
	// var attack = \attackTime.kr(0.01);
	// var decay = \decayTime.kr(0.3);
	// var sustain = \sustainLevel.kr(0.5);
	// var release = \releaseTime.kr(1);
	// var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
    var in = In.ar(out, 2);
	XOut.ar(out, env, RLPF.ar(in, freq * env, rq, amp));
}).store;

SynthDef(\rhpf, {
	var out = \out.kr(0);
	var amp = \amp.kr(0.2);
	var gate = \gate.kr(1);
	var freq = \freq.kr(440);
	var rq = \rq.kr(0.1);
    var env = Linen.kr(gate, 0.05, 1, 0.4, 2);
    var in = In.ar(out, 2);
	XOut.ar(out, env, RHPF.ar(in, freq, rq, amp));
}).store;

SynthDef(\freeverb, {
	var out = \out.kr(0);
	var gate = \gate.kr(1);
	var mix = \mix.kr(0.33);
	var room = \room.kr(0.5);
	var damp = \damp.kr(0.5);
	var in, env;
	env = Linen.kr(gate, 0.05, 2, 0.2, 2);
	in = In.ar(out, 2);
    XOut.ar(out, env, FreeVerb.ar(in, mix, room, damp).softclip * 0.8);
}).store;

SynthDef(\gverb, {
	var out = \out.kr(0);
	var amp = \amp.kr(0.2);
	var gate = \gate.kr(1);
	var room = \room.kr(10);
	var revtime = \revtime.kr(3);
	var damp = \damp.kr(0.5);
	var in = In.ar(\in.kr(0));
	var env;
	env = Linen.kr(gate, 0.05, 2, 0.2, 2);
    XOut.ar(out, env, GVerb.ar(in, room, revtime, damp, mul:amp).softclip * 0.8);
}).store;
)