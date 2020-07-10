// Created by QBRNTHSS
// supernoise + feedback loop
//
// supernoise original notes:
// digital noise in several flavors with a bandpass filter
// "voice" at 0 is a digital noise for which "n" controls rate, at 1 is Brown+White noise for which "n" controls knee frequency
// "accelerate" causes glide in n, "speed" will cause it to repeat
// "pitch1" scales the bandpass frequency (which tracks "n")
// "slide" works like accelerate on the bandpass
// "resonance" is the filter resonance
(
	SynthDef(\snoisefb, {|out, sustain=1, pan, freq, accelerate, slide=0, pitch1=1, speed=1, resonance=0, voice=0|
	var env, basefreq, sound, ffreq, acc, fbNode, processing, dspeed;
	env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01,1,-1), timeScale:sustain, doneAction:2);
	acc = accelerate * freq * 4;
	basefreq = freq * 8 + wrap2(acc* Line.kr(-1,1+(2*speed-2), sustain), acc);
	ffreq = basefreq*5*pitch1* Line.kr(1,1+slide, sustain);
	ffreq = clip(ffreq, 60,20000);
	sound = XFade2.ar( LFDNoise0.ar(basefreq.min(22000), 0.5),
	XFade2.ar(BrownNoise.ar(0.5), WhiteNoise.ar(0.5), basefreq.cpsmidi/127),
	2*voice-1);
	sound = HPF.ar(BMoog.ar(sound, ffreq, resonance, 3), 20);
	sound = clip(sound, -1,1) * 0.3;

	// feedback loop
	fbNode = FbNode(1);
	dspeed = LFNoise0.kr(0.25, 1, 0.25);
  	processing = sound + LeakDC.ar((DelayN.ar(fbNode, 2.5, dspeed, 1.1)));

    	// use a resonant low-pass filter that moves at various rates
	// determined by the 'speed' variable with frequencies between 200 - 900
	processing = RLPF.ar(processing, LFNoise0.kr(speed, 200, 900), 0.5);

	// square off the wave form (distortion)
	processing = processing.clip;
	// processing = Limiter.ar(processing, 1);

	// write the feedback loop
	fbNode.write(processing);

	OffsetOut.ar(out, DirtPan.ar(processing, ~dirt.numChannels, pan, env));
}).add
);
