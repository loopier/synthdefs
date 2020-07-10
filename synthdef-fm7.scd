(
SynthDef(\fm7, {
	var sig, env;
	var gate = \gate.kr(1);
	var freq = \freq.kr(440);
	var amp = \amp.kr(1);
	var spread = 0;// = \spread.kr(0.8);
	var out = \out.kr(0);
	var amps = Array.fill(6, { |i| (\amp++(i+1)).asSymbol.kr(0)});
	var ctls, mods;

	ctls = Array.fill(6, { |i|
		[freq * (\ratio++(i+1)).asSymbol.kr(i+1), 0, (\level++(i+1)).asSymbol.kr(1)];
	});

	mods = Array.fill(6, { |i|
		Array.fill(6, { |n| (\mod++(i+1)++(n+1)).asSymbol.kr(0)});
	});

	sig = FM7.ar(ctls, mods) * amps;
	sig = Gate.ar(sig, gate);
	spread = amps.sum / amps.size;
	sig = sig * (-10.dbamp);
	Out.ar(out, Splay.ar(sig * amp, spread));
}).store;
)
(
SynthDef(\fmx7, {
	var amp = \amp.kr(1) * (-12.dbamp);
	var spread = \spread.kr(0.8);
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var gate = \gate.kr(1);
	var freq = \freq.kr(440);
	var dur = \dur.kr(1);
	var env = EnvGen.ar(Env.adsr(\attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5), \releaseTime.kr(1)), gate, timeScale: dur, doneAction:2);
	var levels = Array.fill(6, { |i| (\level++(i+1)).asSymbol.kr(1)});
    // first amp is always 1, the rest are 0
	var amps = Array.fill(5, { |i| (\amp++(i+1)).asSymbol.kr(((0-i)>=0).asInteger)});
	var ratios = Array.fill(6, { |i| (\ratio++(i+1)).asSymbol.kr(1)});
	var detunes = Array.fill(6, { |i| (\detunes++(i+1)).asSymbol.kr(0)});
	// !!! TODO: add modwheel and LFO
	// lfo sensitivity
	var modsenses = Array.fill(6, { |i| (\modsens++(i+1)).asSymbol.kr(0)});
	// selects between FM = 0 and AM = 1
	var lfomode = \lfomode.kr(0);
	var lfofreq = \lfofreq.kr(1);
	var lfodepth = \lfodepth.kr(0.0);
	var lfo = SinOsc.ar(lfofreq, 0, lfodepth);

	var envs = Array.fill(6, { |i|
		EnvGen.kr(
			Env.new(
				[0]++Array.fill(3, { |n| (\eglevel++(i+1)++(n+1)).asSymbol.kr(1) * levels[i] })++[0],
				// Array.fill(4, { |n| (\rate++(i+1)++(n+1)).asSymbol.kr(n/4) })
				[
					1 / ((\egrate++(i+1)++1).asSymbol).kr(1),
					1 / ((\egrate++(i+1)++2).asSymbol).kr(1),
					1 / ((\egrate++(i+1)++3).asSymbol).kr(1),
					1 / ((\egrate++(i+1)++4).asSymbol).kr(1),
				].normalizeSum
			),
			gate: gate,
			timeScale: dur,
			doneAction:2
		);
	});

	var ctls = Array.fill(6, { |i|[
		freq * ratios[i]/* * Select.kr(lfomode, [lfo, 1])*/ + detunes[i],
		0,
		envs[i]/* * Select.kr(lfomode, [1, lfo])*/,
	]});

	var mods = Array.fill(6, { |i|
		Array.fill(6, { |n| (\mod++(i+1)++(n+1)).asSymbol.kr(0)});
	});

	var sig = FM7.ar(ctls, mods) * amps;
	// amps[0] = 1;
	// sig = sig * amps.normalizeSum;
	sig = sig * env;
	Out.ar(out, Pan2.ar(Mix.ar(sig * amp), pan));
}).store;
)

(
SynthDef(\fmous, {
	var amp = \amp.kr(1);
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var gate = \gate.kr(1);
	var freq = \freq.kr(440);
	var dur = \dur.kr(1);
	var envArray = [\attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5)].normalizeSum;
	var env = EnvGen.ar(Env.adsr(envArray[0], envArray[1], envArray[2], \releaseTime.kr(1)), gate, doneAction:2);
	var amps = \amps.kr(#[1,0,0,0,0,0]).min(1); // clip at 1
	var levels = \levels.kr(#[1,1,1,1,1,]);
	var ratios = \ratios.kr(#[1,1,1,1,1,1]);
	var egrates = Array.fill(6, {|i| (\egrates++(i+1)).asSymbol.kr(#[1,1,1,1])});
	var eglevels = Array.fill(6, {|i| (\eglevels++(i+1)).asSymbol.kr(#[1,1,1,0])});
	var envs = Array.fill(6, { |i| EnvGen.kr(Env.new(
		([0]++eglevels[i]) * levels,
		egrates[i].normalizeSum
	), timeScale: dur, doneAction:2);});
	var ctls = Array.fill(6, { |i|[freq * ratios[i], 0, envs[i]];});
	var mods = Array.fill(6, { |i| (\mods++(i+1)).asSymbol.kr(#[0,0,0,0,0,0])});
	var sig = FM7.ar(ctls, mods);
	sig = sig * amps.normalizeSum;
	sig = sig * env;
	// sig = sig * envs[0];
	sig = sig * amp;
	sig = sig * (-10.dbamp);
	Out.ar(out, Pan2.ar(Mix.ar(sig), pan));
}).store;
)

/*(
SynthDef(\fmalgo7, {
var algo = \algo.ir(0);
var feedback = \feedback.kr(1);
var amp = \amp.kr(1);
var spread = \spread.kr(0.8);
var out = \out.kr(0);
var gate = \gate.kr(1);
var freq = \freq.kr(440);
var env = EnvGen.ar(Env.adsr(\attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5), \releaseTime.kr(1)), gate, doneAction:2);
var amps = Array.fill(6, { |i| (\amp++(i+1)).asSymbol.kr(0)});
var freqs = Array.fill(6, { |i| (\freq++(i+1)).asSymbol.kr(i+1)});

var envs = Array.fill(6, { |i|
EnvGen.kr(
Env.new(
[0]++Array.fill(3, { |n| (\eglevel++(i+1)++(n+1)).asSymbol.kr(1) })++[0],
// Array.fill(4, { |n| (\egrate++(i+1)++(n+1)).asSymbol.kr(n/4) })
[
((\egrate++(i+1)++1).asSymbol).kr(0.01),
((\egrate++(i+1)++2).asSymbol).kr(1),
((\egrate++(i+1)++3).asSymbol).kr(1),
((\egrate++(i+1)++4).asSymbol).kr(1),
]
),
gate,
doneAction:2
);
});

var ctls = Array.fill(6, { |i|
[freq * freqs[i], 0, envs[i]];
});

var mods = Array.fill(6, { |i|
Array.fill(6, { |n| (\mod++(i+1)++(n+1)).asSymbol.kr(0)});
});

var sig = FM7.arAlgo(algo, ctls, feedback) * amps;
// var sig = FM7.arAlgo(algo, ctls, feedback) * amps;
Out.ar(out, Splay.ar(sig * amp * env, spread));
}).store;
)*/

(
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
		/*		var env = EnvGen.kr(
		Env.new(
		[
		0,
		((\eglevel++1).asSymbol).kr(1),
		((\eglevel++2).asSymbol).kr(1),
		((\eglevel++3).asSymbol).kr(1),
		((\eglevel++4).asSymbol).kr(0),
		// 0
		],
		[
		((\egrate++1).asSymbol).kr(0.01),
		((\egrate++2).asSymbol).kr(1),
		((\egrate++3).asSymbol).kr(1),
		((\egrate++4).asSymbol).kr(1),
		]
		),
		gate,
		doneAction:2
		);*/
		var amps = Array.fill(6, { |i| (\amp++(i+1)).asSymbol.kr(0)});
		var freqs = Array.fill(6, { |i| (\freq++(i+1)).asSymbol.kr(i + 1)});

		var envs = Array.fill(6, { |i|
			/*			EnvGen.ar(
			Env.adsr(
			(\attackTime++(i+1)).asSymbol.kr(0.01),
			(\decayTime++(i+1)).asSymbol.kr(0.3),
			(\sustainLevel++(i+1)).asSymbol.kr(1),
			(\releaseTime++(i+1)).asSymbol.kr(1),
			(\sustainLevel++(i+1)).asSymbol.kr(1), // peak
			),
			gate,
			doneAction:2);*/
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

		/*    var mods = Array.fill(6, { |i|
		Array.fill(6, { |n| (\mod++(i+1)++(n+1)).asSymbol.kr(0)});
		});*/

		var sig = FM7.arAlgo(algo, ctls, feedback);
		// var sig = FM7.arAlgo(algo, ctls, feedback) * amps;
		// Out.ar(out, Pan2.ar(Splay.ar(sig * amp * env, spread), pan));
		Out.ar(out, Pan2.ar(Mix.ar(sig * amp * env), pan));
	}).store;
}
)

// fmx7 Pbindef random EXAMPLE
/*(
Pbindef(\a, \instrument, \fmx7).play;
Pbindef(\a, \amp, 1);
6.do { |i|
6.do { |n|
Pbindef(\a, (\mod++(i+1)++(n+1)).asSymbol, 1.0.rand);
};
4.do { |n|
Pbindef(\a, (\egrate++(i+1)++(n+1)).asSymbol, rrand(0.0,0.25));
Pbindef(\a, (\eglevel++(i+1)++(n+1)).asSymbol, 1.0.rand);
};
Pbindef(\a, (\amp++(i+1)).asSymbol, 1.0.rand);
Pbindef(\a, (\freq++(i+1)).asSymbol, ([0.25,0.5]++(1..8)).wchoose((0.2!4)++(0.02!6)).postln);
Pbindef(\a, \attack, rrand(0.01, 0.2));
Pbindef(\a, \decay, rrand(0.01, 0.5));
Pbindef(\a, \sustainLevel, rrand(0.3, 0.95));
Pbindef(\a, \releaseTime, 1.0.rand);
};
)*/
