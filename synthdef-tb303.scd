// by Retroriff - https://github.com/retroriff/Supercollider-Live-To-Tell/blob/master/tb303.scd
SynthDef (\tb303, {
	var ctf = \cutoff.kr(100);
	var attack = \attackTime.kr(1.0);
	var decay = \decayTime.kr(1.0);
	var sustain = \sustainLevel.kr(1.0);
	var release = \releaseTime.kr(1.0);
	var env = \env.kr(1000);
	var freq = \freq.kr(440);
	var gate = \gate.kr(1);
	var out = \out.kr(0);
	var res = \res.kr(0.2);
	var sus = \sustain.kr(0);
	var amp = \amp.kr(0.2);
	var wave = \wave.kr(0);
	var filEnv, ampEnv, waves;
	var pan = \pan.kr(0);
	// ampEnv =  EnvGen.ar( Env.new([10e-10, 1, 1, 10e-10], [0.01, 1, dec],  'exp' ), gate, timeScale: sus, doneAction: Done.freeSelf);
	// filEnv =  EnvGen.ar( Env.new([10e-10, 1, 10e-10], [0.01, dec],  'exp' ), gate, doneAction: Done.freeSelf);
	ampEnv = EnvGen.ar(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	filEnv = EnvGen.ar(Env.perc(attack, release), gate, doneAction:2);
	waves = [ Saw.ar(freq, ampEnv),  Pulse.ar(freq, 0.5, ampEnv)];
	Out.ar(out,  Pan2.ar(Mix.ar(RLPF.ar( Select.ar(wave, waves), ctf + (filEnv * env), res).dup) * amp, pan));
}).store;

// (
// TempoClock.default.tempo = 120/60;
//
// ~bass1 = Pdef(\bass1,
// 	Pbind(
// 		\instrument, \tb303,
// 		\dur, Pseq([0.25], inf),
// 		\freq, Pseq([ 0, 12, 0, 0, -12, 0, 0, 0, -12, 0, 12, 0, 0, 0, 0, 0 ] + 36, inf).midicps,
// 		\amp, 1,
// 		\env, 10000, // From 0 to 10000
// 		\ctf, Pseq((1..10)*100,inf), // From 0 to 10000
// ));
// ~bass1.play.quant_(4, -1);
//
// ~bass2 = Pdef(\bass2,
// 	Pbind(
// 		\instrument, \tb303,
// 		\dur, 0.75,
// 		\freq, 65,
// 		\amp, 0.7,
// 		\env, 1000, // From 0 to 10000
// 		\ctf, 100, // From 0 to 10000
// 		\wave, 1
// ));
// ~bass2.play.quant_(4, -1);
//
//
// // ~bass1.stop;
// // ~bass2.stop;
// )
