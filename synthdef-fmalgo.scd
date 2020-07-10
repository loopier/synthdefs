(
// FM7 synths with DX7 algorithms 1-32
// instantiated by calling \fmalgo1 .. \fmalgo32
32.do { |algo|
	SynthDef(\fmalgo++(algo+1).asSymbol, {
		var feedback = \feedback.kr(1);
		var amp = \amp.kr(0.3);
		var spread = \spread.kr(0.8);
		var out = \out.kr(0);
		var pan = \pan.kr(0);
		var gate = \gate.kr(1);
		var freq = \freq.kr(440);
		var env = EnvGen.ar(Env.adsr(\attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5), \releaseTime.kr(1)), gate, doneAction:2);
		var amps = Array.fill(6, { |i| (\amp++(i+1)).asSymbol.kr(0)});
		var freqs = Array.fill(6, { |i| (\freq++(i+1)).asSymbol.kr(i + 1)});

		var envs = Array.fill(6, { |i|
			EnvGen.kr(
				Env.new(
					[
						((\level++(i+1)++1).asSymbol).kr(0),
						((\level++(i+1)++2).asSymbol).kr(1),
						((\level++(i+1)++3).asSymbol).kr(1),
						((\level++(i+1)++4).asSymbol).kr(1),
						0
					],
					[
						((\rate++(i+1)++1).asSymbol).kr(0.01),
						((\rate++(i+1)++2).asSymbol).kr(0.3),
						((\rate++(i+1)++3).asSymbol).kr(1),
						((\rate++(i+1)++4).asSymbol).kr(1),
					]
				),
				gate,
				doneAction:2
			);
		});

		var ctls = Array.fill(6, { |i|
			[freq * freqs[i], 0, envs[i]];
		});

		var sig = FM7.arAlgo(algo, ctls, feedback);
		Out.ar(out, Pan2.ar(Mix.ar(sig * amp * env), pan));
	}).store;
}
)
