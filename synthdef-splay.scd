// s.options.numInputBusChannels;
// s.options.numOutputBusChannels = 8;
// s.options.numOutputBusChannels;
// s.boot.meter;

(
// A mixer that spans many  channels  to stereo.
// Emulates multispeaker systems in sterero.
[4,6,8,12,16,24].do { |numChannels|
	(\splay++numChannels).postln;
	SynthDef((\splay++numChannels).asSymbol, {
		var out = \out.kr(0);
		// First IN bus.  It  will span along all the channels
		var in = \in.kr(0);
		var amp = \amp.kr(0.5) / numChannels;
		Out.ar(out, Splay.ar(In.ar(in, numChannels)) * amp);
	}).store;
}
)

// 8 channels  example
s.options.numOutputBusChannels = 8;
s.boot.meter;
s.plotTree;
m = Synth(\splay8);
Pbind(\out, Pseq((0..7),inf).trace, \dur, 1/4).play