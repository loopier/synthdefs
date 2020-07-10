(
// FM7 synth with array arguments
// \amps Array(6) of operators amplitudes (carriers)
// \ratios Array(6) of operators frequency ratios
// \eglevelsN Array(4) of 4-stage envelope levels for operator N
// \egratesN Array(4) of 4-stage rates for operator N
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
	sig = sig * amp;
	sig = sig * (-10.dbamp);
	Out.ar(out, Pan2.ar(Mix.ar(sig), pan));
}).store;
)

