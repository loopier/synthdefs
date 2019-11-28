(
SynthDef(\cmos4051, {
	var in = In.ar(\in.kr(0));
	var out = \out.ar(0);
	// choose between external and internal clock 0=internal, 1=external
	var externalclock = \externalclock.kr(0);
	var internalclock = Impulse.kr(\clockrate.kr(1)); // overriden by external clock
	var clock = Select.kr(
		which: \clock.kr(0), // if != 0 then it will select external clock, internal otherwise
		array: [ internalclock, externalclock ]
	);

	var divisions = 2.pow((0..12));
	var divider = PulseDivider.ar(clock, divisions);
	// var notes = Array.series(12);
	// var count = PulseCount.kr(clock);
	// var note = Select.kr(Stepper.kr(trig), notes);

	var sig, gate;

	a = (\inputA.kr(0) > 0) * 2.pow(0); // first binary digit
	b = (\inputB.kr(0) > 0) * 2.pow(1); // second binary digit
	c = (\inputC.kr(0) > 0) * 2.pow(2); // third binary digit
	// (a+b+c).poll;
	// // Convert from binary digit to decimal
	gate = a+b+c;
	// gate.poll;
	// // Select the divider gate according to binary digit
	sig = Gate.ar( 1, Select.ar(gate, divider) );
	// sig.poll;

	Out.ar(out, sig);
}).add;
)
(
Ndef(\snd).clear;
Ndef(\cm).clear;
Ndef(\cm, \cmos4051);
Ndef(\snd, {
	var trig = Ndef(\cm).kr;
	var sig = SinOsc.ar(LFNoise0.kr(trig).range(36,96).midicps);
	var env = Env.perc.kr(2,  trig); // !!! FIX: doesn't quite work
	sig = sig * env;
	Out.ar(\out.kr(0), sig!2 * 0.2)
}).play;
)

Ndef(\cm).set(\inputA, 1);
Ndef(\cm).set(\inputA, 0);
Ndef(\cm).set(\inputB, 1);
Ndef(\cm).set(\inputB, 0);
Ndef(\cm).set(\inputC, 1);
Ndef(\cm).set(\inputC, 0);
Ndef(\cm).set(\clockrate, 8);
Ndef(\cm).set(\externalclock, Ndef(\immp, {Impulse.kr(8)}));
Ndef(\cm).set(\clock, 1);