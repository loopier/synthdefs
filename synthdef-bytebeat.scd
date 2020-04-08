// 8-bit magic
(
SynthDef(\bytebeat, {
	var algo = \voice.kr(0);
	var gate = \gate.kr(1);
	var dur = \dur.kr(1);
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var t = PulseCount.ar(Impulse.ar(freq));
	var algos = [
		t,
		t/2%64 | t*2%127.1,
		(t%8000<4000) | (t&8),
		(t%255&t)-(t>>13&t),
		(t&t%255)-(t>>13&(t%(t>>8|t>>16))),
		(t*8&t)&(t*15&t), //Ambient
		t%(t*freq*10>>8|t*freq*10>>16),  //Acts like t and can be used for cool effect. Generates interesting and infinite rhythm variations.
		t%(t*13&t), //Quiet, do -1 for to make louder and change the rhythm slightly.
		((t*8&t>>4)>>(t*16&t>>8))*t, //Not really sure.
		(((t*t) & t*8)/t)-1, //t>>8&t variation?
		t*8&t,
		t*(t>>(t*13&t)), //i don't even
	];
	var sig = HPF.ar(
		Select.ar(algo.mod(algos.size), algos),
		20
	);
	// var sig = Select.ar(algo, algos);
	var env = EnvGen.kr(Env.new([0,1,1,0],[0.01,0.98,0.01]), gate, timeScale:dur, doneAction:2);
	sig = sig * env * amp;
	sig = Limiter.ar(sig, (-12.dbamp));
	Out.ar(out, Pan2.ar(Mix.ar(sig), pan));
}).store
)
// (
// Pdef(\a, Pbind(\instrument, \bytebeat,
// 	\voice, 13,
// 	// \dur, 0.5,
// 	// \degree, Pseq((0..7),inf),
// 	\octave, 6,
// 	\amp, 0.125,
// 	)
// ).play.quant_(1);
// )
