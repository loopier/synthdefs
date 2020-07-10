(
SynthDef(\chant, {
	var sig;
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var gate = \gate.kr(1);
	var amp = \amp.kr(1);
	var freq = \freq.kr(98);
	var env;
	var attack = \attack.kr(0.01);
	var decayTime = \decaytTime.kr(0.3);
	var sustainLevel = \sustainLevel.kr(0.5);
	var releaseTime = \releaseTime.kr(1);
	var vowel = Select.kr(\vowel.kr(1), Vowel.formLib.asArray);
	var register = Select.kr(\register.kr(1), Vowel.formLib.asArray);
	var vowels = [\a, \e, \i, \o, \u];
	var registers = [\bass, \tenor, \counterTenor, \alto, \soprano];

	var va = Vowel(vowels.choose, registers.choose);
	var ve = Vowel(vowels.choose, registers.choose);
	var vi = Vowel(vowels.choose, registers.choose);
	var vo = Vowel(vowels.choose, registers.choose);
	var vu = Vowel(vowels.choose, registers.choose);
/*	var va = Vowel(Select.kr(\va.kr(0), vowels), Select.kr(\ra.kr(0), registers));
	var ve = Vowel(vowels.choose, registers.choose);
	var vi = Vowel(vowels.choose, registers.choose);
	var vo = Vowel(vowels.choose, registers.choose);
	var vu = Vowel(vowels.choose, registers.choose);*/

	env = Env.adsr(attack, decayTime, sustainLevel, releaseTime).kr(2, gate);

	sig = Formants.ar(
		freq.lag(0.2) + LFNoise2.kr(10).range(-4,4),
		va.blend(ve, LFNoise2.kr(1.0.rand))
		.blend(vi, LFNoise2.kr(1.0.rand))
		.blend(vo, LFNoise2.kr(1.0.rand))
		.blend(vu, LFNoise2.kr(1.0.rand))
		// .brig
	);

	sig = sig!2 * LFNoise2.kr( LFNoise2.kr(10) ).range(0.3,0.5) * amp * env;
	// sig = AllpassC.ar(sig, 0.2, LFNoise2.kr(1.2).range(0.1,0.2));
	// sig = FreeVerb.ar(sig, 0.63,0.15,0.5);
	sig = LPF.ar(sig, (freq*15));
	// sig = GVerb.ar(sig, 100, 0.4, 0.79);
	// sig = CombC.ar(sig, 0.2, 0.2, LFNoise2.kr(1.1).range(0.01,1), LFNoise2.kr(0.5).range(0.01,1));
	Out.ar(out, Pan2.ar(sig , pan));
}).store;
)
// (
// Pdef(\a,
// 	Ppar([
// 		// Pbind( \instrument, \chant,
// 		// 	\amp, 0.1,
// 		// 	\octave, 5,//Pseq(Array.rand(6,3,4), inf),
// 		// 	\degree, Pseq(Array.rand(6, 0,7), inf),
// 		// 	\dur, Pseq(Array.rand(6, 0.125, 0.5), inf),
// 		// 	\attack, Pseq(Array.rand(6, 0.1, 0.5), inf),
// 		// 	\decayTime, 0.01,//Pseq(Array.rand(6, 0.01, 0.5), inf),
// 		// 	\sustainLevel, 0.5,//Pseq(Array.rand(6, 0.5, 0.75), inf),
// 		// 	\releaseTime, 2,//Pseq(Array.rand(6, 0.5, 2), inf),
//             // \vowel, 0,
// 		// ),
// 		Pbind( \instrument, \chant,
// 			\amp, 0.1,
// 			\octave, 3,//Pseq(Array.rand(6,3,4), inf),
// 			\degree, Pseq(Array.rand(6, 0,7), inf),
// 			\dur, Pseq(Array.rand(6, 0.125, 0.5), inf),
// 			\attack, Pseq(Array.rand(6, 0.1, 0.5), inf),
// 			\decayTime, 0.1,//Pseq(Array.rand(6, 0.01, 0.5), inf),
// 			\sustainLevel, 0.1,//Pseq(Array.rand(6, 0.5, 0.75), inf),
// 			\releaseTime, 0.05,//Pseq(Array.rand(6, 0.5, 2), inf),
//             \vowel, 1,
// 		),
// 	])
// ).play
// )

// Vowel.formLib.postTree
