// 6-op FM synth (DX7-like)
//
// Works a bit different from the original DX7.  Instead of algorithms, you set the amount
// of modulation every operator receives from other operators and itself (feedback), virtually
// providing an endless number of possible combinations (algorithms).
//
// Responds to
//   voice (preset number: [0] is user-defined; [1-5] are randomly generated presets).
//   lfofreq (overall pitch modulation frequency)
//   lfodepth (overall pitch modulation amplitude)
//
// Each operator responds to
//   amp (operator volume - becomes carrier)
//   ratio (frequency ratio)
//   detune (in Hz)
//   eglevel[1-4] (4 envelope generator levels)
//   egrate[1-4] (4 envelope generator rates)
//
// The syntax for operator arguments is <argumentName + opIndex>[modulatorIndex | egIndex]
//
// For example:
// amp1 1      (op1 as carrier with full volume)
// ratio2 2.3  (op2 frequency ratio)
// mod11 0.5   (op1 feedback)
// mod12 0.78  (op1 modulation amount by op2)
// detune1 0.2 (op1 detune)
// eglevel12 0.1  (op1 EG level2)
// egrate11 0.01  (op1 EG rate1) -- WARNING: higher values go FASTER!
(
SynthDef(\superfm, {
	var sustain = \sustain.kr(1);
	var speed = \speed.kr(1);
	var begin = \begin.kr(0);
	var end = \end.kr(1);
	var lfofreq = \lfofreq.kr(1);
	var lfodepth = \lfodepth.kr(0);
	var freq = \freq.kr(440);
	var tremolo = 1 + (LFTri.kr(lfofreq) * lfodepth);
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var voice = \voice.kr(0);
	// overall envelope
	var line = Line.ar(begin, end, sustain, doneAction: 2);
	var env = Env.new(levels: [0.02,1,0.9,0.02], times: [0.1, 0.5, 1], curve: [-5, 0 , -5]);
	var volume = IEnvGen.ar(env, line);
	// operator output levels
	var amps = [1] ++ Array.fill(5, { |i| (\amp++(i+2)).asSymbol.kr(0)});
	// operator frequency ratios
	var ratios = Array.fill(6, {|i| (\ratio++(i+1)).asSymbol.kr(1)});
	// operator frequency detuners
	var detunes = Array.fill(6, {|i| (\detune++(i+1)).asSymbol.kr(rand2(0.1))});
	// feedback -- for presets only
	var feedback = \feedback.kr(1.0);
	// operator envelopes
	var eglevels = Array.fill(6, {|i|
		Array.fill(4, { |n| (\eglevel++(i+1)++(n+1)).asSymbol.kr(1) })
	});
	var egrates = Array.fill(6, {|i| [
		// Supercollider envelopes use seconds for the durations of segments.
		// So higher values mean transitions are slower.
		// DX7s envelopes use rates, which is the inverse of time, 1/time.
		// Higher values in DX7 mean transitions are faster.
		max(0.1 / ((\egrate++(i+1)++1).asSymbol).ir(10), 0.001),
		max(0.1 / ((\egrate++(i+1)++2).asSymbol).ir(0.3), 0.001),
		max(0.1 / ((\egrate++(i+1)++3).asSymbol).ir(0.1), 0.001),
		max(0.1 / ((\egrate++(i+1)++4).asSymbol).ir(0.1), 0.001),
	]});
	// modulation matrix
	var mods = Array.fill2D(6, 6, { |r, c|
		(\mod++(r+1)++(c+1)).asSymbol.kr(0) * if(r == c, feedback, 1)
	});
	var presets = SelectX.kr(voice, [
		[ // user-defined
			ratios,	detunes, amps, eglevels, egrates, mods,
		],
	] ++
	// randomly generated presets
	Array.fill(5, { [
		// ratios
		Array.fill(6, {
			[0.25, 0.5, 1, 2, 3, 4, 5, 6, 7, 11.rand + 1, 13.rand + 1, 15.rand + 1].wchoose(
				[1, 2, 8, 4, 3, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25, 0.25].normalizeSum)
		}),
		// detunes
		Array.fill(6, {rand2(7)}),
		// amps
		Array.fill(6, {1.0.rand * 0.5.coin.asInt}),
		// EG levels
		Array.fill2D(6, 4, {1.0.rand}),
		// EG rates
		Array.fill2D(6, 4, {1.0.rand}),
		// mods
		Array.fill2D(6, 6, {|r,c| 1.0.rand * 0.25.coin.asInt * if(r == c, feedback, 1)}),
	]})
	);

	var envs = Array.fill(6, { |i|
		EnvGen.kr(
			Env.new(
				// EG levels
				[0]++Array.fill(4, { |n| presets[3][i][n] }),
				// EG rates
				Array.fill(4, { |n| presets[4][i][n] })
			),
			timeScale:sustain,
		);
	});

	var ctls = Array.fill(6, { |i|
		[freq * tremolo * presets[0][i] + presets[1][i], 0, envs[i]]
	});

	var sound = FM7.ar(ctls, presets[5]) * amps;
	sound = Mix.ar(sound) * (-15.dbamp);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, volume));
}).add;
)
