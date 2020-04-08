// FM operator that can be used as carrier or modulator.
// Multiple instances of this synth may be used for FM synthessis.  Plug outputs to inputs.

SynthDef(\fmop, {
	var freq = \freq.kr(440);
	var freqRatio = \freqRatio.kr(1);
	// If used as a Modulator make sure to crank amp up to several hundreds (e.g. 200 or 400)
	var amp = \amp.kr(1);
	var modlevel = \modlevel.kr(0) * 500;
	var in = InFeedback.ar(\in.kr) * modlevel;
	var out = \out.kr;
	var gate = \gate.kr(1);
	var dur = \dur.kr(1);
	var wave = \wave.kr(0);
	var lag = \lag.kr(0);
	// var sustain = \sustain.kr(1);
	var feedback = \feedback.kr(0);
	// var pw = \pw.kr(0.5);
	// var env = EnvGen.ar(Env.adsr(\attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5), \releaseTime.kr(1)), gate doneAction:2);
	// var eglevels = \eglevels.kr(#[1,1,1,0]);
	// var egrates = \egrates.kr(#[1,1,1,1]);
	// var egcurves = \egcurves.kr(#[0, -4, 0, -4]);
	// var env = EnvGen.ar(Env.new(eglevels, 0.1 * egrates, egcurves), gate, doneAction:2);
	var env = EnvGen.ar(Env.new(
		[
			0,
			\eglevel1.kr(1),
			\eglevel2.kr(0.5), // sustain start
			\eglevel3.kr(0.5), // sustain end
			\eglevel4.kr(0),
		],[

			max(0.001, 0.01 / \egrate1.ir(1)),
			max(0.001, 0.01 / \egrate2.ir(1)),
			max(0.001, 0.01 / \egrate3.ir(1)),
			max(0.001, 0.01 / \egrate4.ir(1)),
			// \rate1.kr(0.01), // attack
			// \rate2.kr(0.3), // decay
			// \rate3.kr(1),
			// \rate4.kr(1), // release
		].normalizeSum,[
			\egcurve1.kr(0),
			\egcurve2.kr(-4),
			\egcurve3.kr(0),
			\egcurve4.kr(-4),
	]), gate, timeScale: dur, doneAction:2);
	var sig =	SinOscFB.ar(freq.lag(lag) * freqRatio + in, feedback, mul: amp);
	// var sig = Select.ar(wave, [
	// 	SinOsc.ar(freq + in, mul: amp),
	// 	LFTri.ar(freq + in, mul: amp),
	// 	Saw.ar(freq + in, mul: amp),
	// 	Pulse.ar(freq + in, pw, mul: amp),
	// ]);
	Out.ar(out, sig * env);
}).store;

