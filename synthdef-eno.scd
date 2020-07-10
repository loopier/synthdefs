(
SynthDef(\enotamboura, {
	var sig;
	var feedback = \feedback.kr(0.07);
	var freq = \freq.kr(100);
	var amp = \amp.kr(0.3);
	var out = \out.kr(1);
	var pan = \pan.kr(0);
	var gate = \gate.kr(1);
	// var gate = Impulse.kr(1);
	var env = EnvGen.kr(Env.new( [ 0, 0.5, 0.5, 0.5, 0.5], [1, 1, 1, 1] ), gate, doneAction:2);
	// var env = EnvGen.kr(Env.adsr( \attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5), \releaseTime.kr(1)), gate, doneAction:2);
	sig = FM7.arAlgo(16,
		[
			[freq * 1, 0,    EnvGen.kr(Env.new( [ 0, 1, 0, 1, 0], [0.93, 0.29, 0.18, 0.39] ), gate, doneAction:2) * 1],
			[freq * 0.5, 0, EnvGen.kr(Env.new( [ 0, 1, 1, 0, 0], [0.78, 0.98, 0.25, 0.22] ), gate, doneAction:2) * 0.76],
			[freq * 3, 0,    EnvGen.kr(Env.new( [ 0, 1, 0, 1, 0], [0.29, 0.35, 0.22, 0.38] ), gate, doneAction:2) * 0.67],
			[freq * 3, 0,    EnvGen.kr(Env.new( [ 0, 1, 0, 1, 0], [0.33, 0.35, 0.25, 0.99] ), gate, doneAction:2) * 0.76],
			[freq * 12, 0,  EnvGen.kr(Env.new( [ 0, 1, 0, 1, 0], [0.36, 0.35, 0.15, 0.38] ), gate, doneAction:2) * 0.72],
			[freq * 13, 0,  EnvGen.kr(Env.new( [ 0, 1, 0, 1, 0], [0.33, 0.35, 0.25, 0.99] ), gate, doneAction:2) * 0.81],
		],
		feedback;
	);

	sig = sig + (sig * LFTri.kr(0.35 * 19, mul: 0.51));

	Out.ar(out, Pan2.ar(sig  * env * amp, pan));
}).add;

SynthDef(\enoviolin3, {
	var sig;
	var feedback = \feedback.kr(0.05);
	var freq = \freq.kr(100);
	var amp = \amp.kr(0.3);
	var out = \out.kr(1);
	var pan = \pan.kr(0);
	var gate = \gate.kr(1);
	var velocity = 1;
	// var gate = Impulse.kr(1);
	var env = EnvGen.kr(Env.new( [ 0, 0.5, 0.5, 0.5, 0.5], [1, 1, 1, 1] ), gate, doneAction:2);
	// var env = EnvGen.kr(Env.adsr( \attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5), \releaseTime.kr(1)), gate, doneAction:2);
	sig = FM7.arAlgo(17,
		[
			[freq * 2 + 1, 0,    EnvGen.kr(Env.new( [ 0, 1.00, 0.90, 0.97, 0], [0.42, 0.00, 0.12, 0.45] ), gate, doneAction:2) * 1],// * (velocity * 4)],
			[freq * 6 - 1, 0, EnvGen.kr(Env.new( [ 0, 1.00, 0.96, 0.89, 0], [0.55, 0.95, 0.00, 0.00] ), gate, doneAction:2) * 0.68],// * (velocity * 1)],
			[freq * 8 + 0, 0,    EnvGen.kr(Env.new( [ 0, 0.87, 0.86, 0.00, 0], [0.54, 0.87, 0.00, 0.00] ), gate, doneAction:2) * 0.92],// * (velocity * 2)],
			[freq * 6 + 0, 0,    EnvGen.kr(Env.new( [ 0, 1.00, 0.90, 0.00, 0], [0.67, 0.92, 0.28, 0.60] ), gate, doneAction:2) * 0.59],// * (velocity * 1)],
			[freq * 8 - 2, 0,  EnvGen.kr(Env.new( [ 0, 1.00, 0.65, 0.60, 0], [0.85, 0.70, 0.97, 0.00] ), gate, doneAction:2) * 0.92],// * (velocity * 1)],
			[freq * 10 + 0, 0,  EnvGen.kr(Env.new( [ 0, 1.00, 1.00, 0.97, 0], [0.73, 0.70, 0.60, 0.00] ), gate, doneAction:2) * 0.76],// * (velocity * 1)],
		],
		feedback;
	);

	sig = sig + (sig * SinOsc.kr(0.35 * 19, mul: 0.35));
	sig = sig * CombC.ar(sig, 0.2, 0.2 * 0.42, 1);

	Out.ar(out, Pan2.ar(sig  * env * amp, pan));
}).add;

SynthDef(\enoglide, {
	var sig;
	var feedback = \feedback.kr(0.0);
	var freq = \freq.kr(100);
	var amp = \amp.kr(0.3);
	var out = \out.kr(1);
	var pan = \pan.kr(0);
	var gate = \gate.kr(1);
	var velocity = 1;
	var sustain = \sustain.kr(1);
	// var gate = Impulse.kr(1);
	var env = EnvGen.ar(Env.new( [ 0, 0.5, 0.5, 0.5, 0.0], [0.01, 1, 1, 0.1] ), gate, timeScale: sustain, doneAction:2);
	// var env = EnvGen.kr(Env.adsr( \attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5), \releaseTime.kr(1)), gate, doneAction:2);
	sig = FM7.arAlgo(3,
		[
			[freq * 1 + 0,        0,  EnvGen.kr(Env.new( [ 0, 0.99, 0.99, 0.99, 0], [0.62, 0.21, 0.46, 0.29] ), gate, doneAction:2) * 0.99],// * (velocity * 4)],
			[freq * 1 + 4,        0,  EnvGen.kr(Env.new( [ 0, 0.49, 0.50, 0.50, 0], [0.33, 0.45, 0.45, 0.14] ), gate, doneAction:2) * 0.00],// * (velocity * 1)],
			[freq * 1 - 4,         0,  EnvGen.kr(Env.new( [ 0, 0.49, 0.50, 0.50, 0], [0.19, 0.45, 0.45, 0.14] ), gate, doneAction:2) * 0.00],// * (velocity * 2)],
			[freq * 2 + 0,        0,  EnvGen.kr(Env.new( [ 0, 0.99, 0.99, 0.99, 0], [0.32, 049, 0.46, 0.29] ), gate, doneAction:2) * 0.94],// * (velocity * 1)],
			[freq * 9 + 0,        0,  EnvGen.kr(Env.new( [ 0, 0.49, 0.50, 0.50, 0], [0.85, 0.45, 0.45, 0.14] ), gate, doneAction:2) * 0.89],// * (velocity * 1)],
			[freq * 2.884 + 0, 0,  EnvGen.kr(Env.new( [ 0, 0.99, 0.99, 0.99, 0], [0.18, 0.47, 0.48, 0.21] ), gate, doneAction:2) * 0.73],// * (velocity * 1)],
		],
		feedback;
	);

	sig = sig + (sig * LFTri.kr(0.35 * 19, mul: 0.35));
	// sig = sig * CombC.ar(sig, 0.2, 0.2 * 0.42, 1);
    sig = Splay.ar(sig, 0.2);

	Out.ar(out, Pan2.ar(sig  * env * amp, pan));
}).add;
)

Pbindef(\a, \instrument, \enotamboura, \dur, Prand([0.5,1,2,0.25],inf), \scale, Scale.harmonicMinor, \degree, Pwhite(0,7), \amp, Pwhite(0.3, 0.5), \octave, Pseq((2..7),inf)).play
Pbindef(\a, \instrument, \enoviolin3, \scale, Scale.harmonicMinor, \degree, Pwhite(0,7), \amp, Pwhite(0.3, 0.5), \octave, Pseq((2..7),inf)).play
Pbindef(\a, \instrument, \enoglide, \dur, 1, \scale, Scale.harmonicMinor, \degree, Pwhite(0,7), \amp, Pwhite(0.3, 0.5), \octave, Pseq((2..7),inf)).play
