(
SynthDef(\loopbuf, {
	arg buf=0, rate=1, startpos=0, startloop=0, endloop=1, gate=1, attack=0.1, decay=0.3, sustain=1, release=1, out=0, pan=0, amp=0.5;
	var sig, env;
	endloop = BufFrames.kr(buf) * endloop;
	sig = LoopBuf.ar(buf.numChannels, buf, BufRateScale.kr(buf) * rate, 1, startpos, startloop, endloop);
	env = EnvGen.ar(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
	Out.ar(out, Pan2.ar(sig * env * amp, pan));
}).store;
)