(
SynthDef(\granular, {
	var freq = \freq.kr(440);
	var amp = \amp.kr(0.3);
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var attackTime = \attackTime.kr(0.01);
	var decayTime = \decayTime.kr(0.3);
	var sustainLevel = \sustainLevel.kr(0.5);
	var releaseTime = \releaseTime.kr(0.01);
	var gate = \gate.kr(1);
	var buf = \buf.kr(0);
	var grainChannels = \grainChannels.kr(1);
	var trigRate = \grainTrigRate.kr(10);
	var grainDur = \grainDur.kr(0.2);
	var grainRate = \grainRate.kr(1);
	var grainPos = \grainPos.kr(0);
	var grainInterp = \grainInterp.kr(2);
	var grainEnvBuf = \grainEnvBuf.kr(-1);

	var sig, env;
	sig = GrainBuf.ar(
		numChannels: 2,
		trigger: Impulse.kr(trigRate),
		dur: grainDur,
		sndbuf: buf,
		rate: grainRate,
		pos: grainPos,
		interp: grainInterp,
		pan: pan,
		envbufnum: grainEnvBuf,
	);
	env = Env.adsr(attackTime, decayTime, sustainLevel, releaseTime).kr(2, gate);

	Out.ar(out, sig * env * amp);
}).store
)

(
var stereobuf = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav", channels: [0]);
var monobuf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
var synthname = \granular;
Pdef((synthname++"pat").asSymbol,
	Pbind(\instrument, synthname,
		\buf, stereobuf,
		\grainPos, Pwhite(),
		\grainTrigRate, Pwhite(1,60),
		\grainDur, Pwhite(0.1, 0.5),
		\grainRate, Pwhite(0.5,2),
		\pan, Pwhite(-1.0, 1.0),
		\legato, 1,
		// \degree, 0,
		// \dur, 1,
		// \attackTime, 1,
		// \decayTime, 0.3,
		// \sustainLevel, 0.5,
		// \releaseTime, 2,
		\amp, 0.5,
	)
).play
)