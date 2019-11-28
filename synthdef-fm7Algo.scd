(
SynthDef(\fm7algo, {
	arg out=0, amp=0.3, spread=0, freq=440, attack=0.01, decay=0.3, sustain=0.5, release=1, gate=1, algo;
	var sig, env, ctls, mods, chans, envs, freqs, amps;
	// frequencies of oscillators are in partials of main frequency, they
	// multiply the base frequency
	freqs = Array.fill(6, { |i|
		freq * ((\freq++i).asSymbol).kr((i+1)) + 0.1.rand2;
	});

	envs = Array.fill(6, { |i|
		EnvGen.kr(
			Env.new(
				[
					// amplitudes
					((\envlevel0++i).asSymbol).kr(0),
					((\envlevel1++i).asSymbol).kr(1),
					((\envlevel2++i).asSymbol).kr(0.5),
					((\envlevel3++i).asSymbol).kr(0.3),
					((\envlevel4++i).asSymbol).kr(0),
				],[
					// time to reach next level
					((\envtime0++i).asSymbol).kr(0.01),
					((\envtime1++i).asSymbol).kr(0.3),
					((\envtime2++i).asSymbol).kr(1),
					((\envtime3++i).asSymbol).kr(1),
				],[
					// \lin or \exp
					((\envcurve0++i).asSymbol).kr(\lin),
					((\envcurve1++i).asSymbol).kr(\lin),
					((\envcurve2++i).asSymbol).kr(\lin),
					((\envcurve3++i).asSymbol).kr(\lin),
				]
			),
			gate);//((\gate++i).asSymbol).kr(0));
	});

	// freq, phase (initialization only), amp
	ctls = Array.fill(6, { |i| [freqs[i], 0, envs[i]] });
	// use this instead if you prefer using a [6][6] array
	//mods = \mods.kr(0!6!6);

	amps = Array.fill(6, { |i|
		((\amp++i).asSymbol).kr((i.mod(6)==0).asInt);
	});

	env = EnvGen.ar(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	sig = FM7.arAlgo(16, ctls);
	sig = Splay.ar( sig * amps * env, spread);
	Out.ar(out, sig * amp);
}).add;
)
