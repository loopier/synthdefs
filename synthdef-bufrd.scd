(
SynthDef(\bufrd, {
	arg buf, rate=1.0, start=0.0, dur=1.0, t_reset=0, phase=0.0, amp=1, out=0, syncbus=2;
	var sig, pos, end, resetpos, sync;
	sync = In.kr(syncbus);
	// dur = BufDur.kr(buf) * dur;
	rate = BufRateScale.kr(buf) * rate;
	resetpos = BufFrames.kr(buf) * start;
	end = BufFrames.kr(buf) * (start + dur);
	// phase = BufFrames.kr(buf) * phase;
	pos = Phasor.ar(
		trig: Impulse.kr(1/dur, phase) + t_reset + sync,
		rate: rate,
		start: resetpos,
		end: end,
		resetPos:resetpos
	);
	sig = BufRd.ar(2, buf, pos, 0);
	sig = Mix.ar(sig) * amp;
	Out.ar(out, Mix.ar(sig));
}).add;
)