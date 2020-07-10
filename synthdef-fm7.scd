(
// 6-op FM synth (DX7-like)
SynthDef(\fm7, {
	var sig, env;
	var gate = \gate.kr(1);
	var freq = \freq.kr(440);
	var amp = \amp.kr(1);
	var spread = 0;
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
