(
// 6-op FM synth for TidalCycles (DX7-like)
SynthDef(\fmbass, {
	var sustain = \sustain.kr(1);
	var lfofreq = \lfofreq.kr(1);
	var lfodepth = \lfodepth.kr(0);
	var freq = \freq.kr(440) * (1 + (LFTri.kr(lfofreq) * lfodepth));
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	// overall envelope
	var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1,-3), timeScale:sustain, doneAction:2);
	// operator output levels
	var amps = [1,0,0,0,0,0];
	// operator frequency ratios
	var ratios = [2,1,1,2,1,1];
	// operator frequency detuners
	var detunes = Array.fill(6, {|i| (\detune++(i+1)).asSymbol.kr(rand2(0.1))});
	// operator envelopes [[levels][rates]]
	var envs = [
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1.5,0.1,1.5], [0.2 + rand2(0.05), 0.1 + rand2(0.05), 0.5 + rand2(0.1), 0.3 + rand2(0.1)]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
	];
	var ctls = Array.fill(6, { |i| [
		freq * ratios[i] + detunes[i],
		0,
		EnvGen.kr(Env.new([0]++envs[i][0]++[0], envs[i][1]), timeScale:sustain)
	]});
	// modulation matrix
	var mods = [
		[0.25, 0.83, 0.9, 0.83, 0, 0],
		[0, 0.63, 0, 0.53, 0, 0],
		[0, 0, 0, 0.53, 0, 0],
		[0, 0, 0, 0.7, 0, 0],
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0],
	];

	var sound = FM7.ar(ctls, mods) * amps;
	// FM7 outputs 6 channels.  Splay.ar() maps them to stereo.
	// sound = Splay.ar(sound);
	sound = Mix.ar(sound);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;
)