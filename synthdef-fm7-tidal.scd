(
// 6-op FM synth for TidalCycles (DX7-like)
SynthDef(\dxt, {
	var sustain = \sustain.kr(1);
	var lfofreq = \lfofreq.kr(1);
	var lfodepth = \lfodepth.kr(0);
	var freq = \freq.kr(440) * (1 + (LFTri.kr(lfofreq) * lfodepth));
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	// overall envelope
	var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1,-3), timeScale:sustain, doneAction:2);
	// operator output levels
	var amps = Array.fill(6, { |i| (\amp++(i+1)).asSymbol.kr(1)});
	// operator frequency ratios
	var ratios = Array.fill(6, {|i| (\ratio++(i+1)).asSymbol.kr(i+1)});
	// operator frequency detuners
	var detunes = Array.fill(6, {|i| (\detune++(i+1)).asSymbol.kr(rand2(0.1))});
	// operator envelopes
	var envs = Array.fill(6, { |i|
		EnvGen.kr(
			Env.new(
				[0]++Array.fill(3, { |n| (\eglevel++(i+1)++(n+1)).asSymbol.kr(1) })++[0],
				[
					// Supercollider envelopes use seconds for the durations of segments.
					// So higher values mean transitions are slower.
					// DX7s envelopes use rates, which is the inverse of time, 1/time.
					// Higher values in DX7 mean transitions are faster.
					max(0.1 / ((\egrate++(i+1)++1).asSymbol).kr(10), 0.001),
					max(0.1 / ((\egrate++(i+1)++2).asSymbol).kr(0.3), 0.001),
					max(0.1 / ((\egrate++(i+1)++3).asSymbol).kr(0.1), 0.001),
					max(0.1 / ((\egrate++(i+1)++4).asSymbol).kr(0.1), 0.001),
				]
			),
			timeScale:sustain,
			// doneAction:2
		);
	});
	var ctls = Array.fill(6, { |i| [freq * ratios[i] + detunes[i], 0, envs[i]]});
	// modulation matrix
	var mods = Array.fill(6, { |i|
		Array.fill(6, { |n| (\mod++(i+1)++(n+1)).asSymbol.kr(0)});
	});

	var sound = FM7.ar(ctls, mods) * amps;
	// FM7 outputs 6 channels.  Splay.ar() maps them to stereo.
	// sound = Splay.ar(sound);
	sound = Mix.ar(sound);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).store;
)