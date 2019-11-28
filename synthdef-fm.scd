(
SynthDef(\fm, {
	arg freq=500, mRatio=1, cRatio=1,
	index=1, iScale=5, iAtk=0.01, iRel=1, ciAtk=4, ciRel=(-4),
	atk=0.01, rel=1, cAtk=4, cRel=(-4),
	amp=0.2, pan=0,
	out=0, fx=0, fxsend=(-25);
	var car, mod, env, iEnv;

	//index of modulation
	iEnv = EnvGen.kr(
		Env(
			[index, index*iScale, index],
			[iAtk, iRel],
			[ciAtk, ciRel]
		)
	);

	//amplitude envelope
	env = EnvGen.kr(Env.perc(atk,rel,curve:[cAtk,cRel]),doneAction:2);

	//modulator/carrier
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;

	car = Pan2.ar(car, pan);

	//direct out/reverb send
	Out.ar(out, car);
	// Out.ar(fx, car * fxsend.dbamp);
}).store;
)
StageLimiter.activate
(
Pdef(\a, Ppar([
	Pfx(
		Pfx(
	Pbind(\instrument, \fm,
		\scale, Scale.harmonicMinor,
			\degree, Pwhite(0,7) + [0, 4],
			\octave, Prand([3,4,5],inf),
			\dur, Pwhite(0.1,1),
			\cRatio, Pwhite(1,10) + Pwhite(-0.1, 0.1),
			\mRatio, Pwhite(1, 40) / 4 + Pwhite(-0.1, 0.5),
		// \index, Pwhite(1,10),
			\index, Pwhite(1,20),
			\iScale, Pwhite(0.5,5),
			// \iAtk, Pkey(\dur)/2,
			// \ciAtk, Pwhite(-4,4),
			\iRel, Pwhite(0.0, Pkey(\dur)),
			// \ciRel, Pwhite(-4,4),
		// \rel, Pkey(\iRel) + 1,
		// \rel, Pwhite(0.2,3),
			\rel, Pwhite(0.1, Pkey(\dur)*2),
			\atk, Pwhite(0.01,0.5),
			// \rel, 0.1,
			\cRel, Pwhite(-4,4),
		// \amp, Pseq([Pgeom(0.28,-3.dbamp,4)],inf),
		\pan, Pwhite(-1.0, 1.0),
		\out, 0,
		// \fx, ~vbus,
		// \fxsend, -20,
	),
		\echo,
		\dtime, Pwhite(0.1,0.9),
		\decay, 4,
			// \mul, Pwhite(),
	),
		\gverb,
		\room, 10,
		\revtime, 7,
		\damp, 0.2,
		\mul, Pwhite(),
	)
])).play.quant_(4,-1);
)
