SynthDef(\fmsine, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var gate = \gate.kr(1);
	var feedback = \feedback.kr(0);
	var in = \in.kr(Server.numChannels);
	var sig = SinOscFB.ar(freq + (InFeedback.ar(in) * 100), feedback, amp);
	Out.ar(out, sig * gate);
}).store;

b = Bus.audio(s);
a = Synth(\fmsine, [freq: 100, feedback:0, in: b]);
e = Synth(\fmsine, [feedback:0, out: b, amp: 1]);
e.set(\feedback, 0)
e.set(\amp, 1)
e.set(\freq, 200)
a.set(\freq, 200)
a.set(\feedback, 0.5)
