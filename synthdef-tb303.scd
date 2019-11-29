// by Retroriff - https://github.com/retroriff/Supercollider-Live-To-Tell/blob/master/tb303.scd
SynthDef (\tb303, {
	var ctf = \ctf.kr(100);
	var dec = \dec.kr(1.0);
	var env = \env.kr(1000);
	var freq = \freq.kr(440);
	var gate = \gate.kr(1);
	var out = \out.kr(0);
	var res = \res.kr(0.2);
	var sus = \sus.kr(0);
	var vol = \vol.kr(0.2);
	var wave = \wave.kr(0);
	var  filEnv, volEnv, waves;
	volEnv =  EnvGen.ar( Env.new([10e-10, 1, 1, 10e-10], [0.01, sus, dec],  'exp' ), gate, doneAction: Done.freeSelf);
	filEnv =  EnvGen.ar( Env.new([10e-10, 1, 10e-10], [0.01, dec],  'exp' ), gate, doneAction: Done.freeSelf);
	waves = [ Saw.ar(freq, volEnv),  Pulse.ar(freq, 0.5, volEnv)];
	Out.ar(out,  RLPF.ar( Select.ar(wave, waves), ctf + (filEnv * env), res).dup * vol);
}).add;

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
