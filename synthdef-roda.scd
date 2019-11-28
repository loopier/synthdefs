SynthDef(\roda, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var buf = \buf.kr(0);
	var rate = \rate.kr(1);
	var trig = \trig.kr(1);
	var tape = \tape.kr(1) * MouseButton.kr(lag:0.01) * MouseY.kr(-0.2, 0.2, lag:0.01);
	var player = PlayBuf.ar(1, buf, rate + tape, trig, loop:1);

	// var in = SoundIn.ar;
	// var in = In.ar(\in.kr(0));
	var in = \in.ar;
	var inlevel = \inlevel.kr(1);
	var feedback = \feedback.kr(0.7);
	var rec = \rec.kr(1);
	var dur = \dur.kr(4);

	var sig = player * feedback + (in * inlevel);
	var del = DelayN.ar(sig, dur, dur);

	RecordBuf.ar(del, buf, run: rec, trigger: trig);
	Out.ar(out, player * amp);
}).store;

