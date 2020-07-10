(
// 6-op FM synth for TidalCycles (DX7-like)
SynthDef(\fmbass, {
	var sustain = \sustain.kr(1);
	var lfofreq = \lfofreq.kr(1);
	var lfodepth = \lfodepth.kr(0);
	var freq = \freq.kr(440) * (1 + (LFTri.kr(lfofreq) * lfodepth));
	var out = \out.kr(0);
	var pan = \pan.kr(0);
    var amp = \amp.kr(1);
	// overall envelope
	var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1,-3), timeScale:sustain, doneAction:2);
	// operator output levels
	var amps = [1,0,0,0,0,0];
	// operator frequency ratios
	var ratios = [2,1,1,2,1,1];
	// operator frequency detuners
	var detunes = Array.fill(6, {|i| (\detune++(i+1)).asSymbol.kr(rand2(0.1))});
	// operator envelopes [[levels][rates]]
	var envs = [
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1.5,0.1,1.5], [0.2 + rand2(0.05), 0.1 + rand2(0.05), 0.5 + rand2(0.1), 0.3 + rand2(0.1)]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
	];
	var ctls = Array.fill(6, { |i| [
		freq * ratios[i] + detunes[i],
		0,
		EnvGen.kr(Env.new([0]++envs[i][0]++[0], envs[i][1]), timeScale:sustain)
	]});
	// modulation matrix
	var mods = [
		[0.25, 0.83, 0.9, 0.83, 0, 0],
		[0, 0.63, 0, 0.53, 0, 0],
		[0, 0, 0, 0.53, 0, 0],
		[0, 0, 0, 0.7, 0, 0],
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0],
	];

	var sound = FM7.ar(ctls, mods) * amps;
	sound = Mix.ar(sound) * (-10.dbamp) * amp;
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).store;
);
(
//
SynthDef(\lpg, {
	var sustain = \sustain.kr(1);
	var lfofreq = \lfofreq.kr(1);
	var lfodepth = \lfodepth.kr(0);
	var freq = \freq.kr(440) * (1 + (LFTri.kr(lfofreq) * lfodepth));
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	// overall envelope
	var env = EnvGen.ar(Env.perc, timeScale:sustain, doneAction:2);
	var amp = \amp.kr(0.5);
	var width = \width.kr(0.5);
	var sound = Pulse.ar(freq: freq, width: width, mul: env);
	sound = RLPF.ar(in: sound, freq: freq * env, rq: env + 0.01, mul: env);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).store;
);
(
// 6-op FM synth for TidalCycles (DX7-like)
SynthDef(\hammondserrano, {
	var sustain = \sustain.kr(1);
	var lfofreq = \lfofreq.kr(3 + 1.0.rand);
	var lfodepth = \lfodepth.kr(rrand(0.01,0.03));
	var freq = \freq.kr(440) * (1 + (LFTri.kr(lfofreq) * lfodepth));
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var amp = \amp.kr(0.5);
	var metalizer = \metalizer.kr(0);
	// var distortion = (\octave.kr(5)-4);
	var distortion = ((60 - freq.cpsmidi) / 60);
	// overall envelope
	var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1,-3), timeScale:sustain, doneAction:2);
	// operator output levels
	var amps = [1,1,1,1,1,1] - ([0]++rand(0.3!5));
	// operator frequency ratios
	var ratios = [1,2,4,7,8,10];
	// operator frequency detuners
	var detunes = Array.fill(6, {|i| (\detune++(i+1)).asSymbol.kr(rand2(1.0)) + (distortion * i * 10)});
	// operator envelopes [[levels][rates]]
	var envs = [
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
		[[1,1,1], [0.01, 0.3, 1, 1]],
	];
	var ctls = Array.fill(6, { |i| [
		freq * ratios[i] + detunes[i],
		0,
		EnvGen.kr(Env.new([0]++envs[i][0]++[0], envs[i][1]), timeScale:sustain)
	]});
	// modulation matrix
	var mods = [
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0],
	];

	var sound = FM7.ar(ctls, mods) * amps;
	sound = Splay.ar(sound, spread: 0.5);
	sound = sound + GVerb.ar(sound, roomsize: 5, revtime: 1, damping: 0.8, mul: 0.5);
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).store;
);
(
SynthDef(\bytebeat, {
	var algo = \voice.kr(0);
	var gate = \gate.kr(1);
	var dur = \dur.kr(1);
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var amp = \amp.kr(1);
	var freq = \freq.kr(440);
	var sustain = \sustain.kr(1);
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
	var env = EnvGen.ar(Env.linen(0.002, 0.996, 0.002, 1,-3), timeScale:sustain, doneAction:2);
	sig = Limiter.ar(sig, (-12.dbamp));
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).store
);
(
// by Retroriff - https://github.com/retroriff/Supercollider-Live-To-Tell/blob/master/tb303.scd
SynthDef (\tb303, {
	var ctf = \cutoff.kr(100);
	var attack = \attack.kr(1.0);
	var sustain = \hold.kr(1.0);
	var release = \release.kr(1.0);
	var env = \env.kr(1000);
	var freq = \freq.kr(440);
	var gate = \gate.kr(1);
	var out = \out.kr(0);
	var res = \resonance.kr(0.2).linlin(0.0, 1.0, 1.0, 0.0);
	var sus = \sustain.kr(1);
	var amp = \amp.kr(0.2);
	var wave = \voice.kr(0);
	var filEnv, ampEnv, waves;
	var pan = \pan.kr(0);
	// ampEnv =  EnvGen.ar( Env.new([10e-10, 1, 1, 10e-10], [0.01, 1, dec],  'exp' ), gate, timeScale: sus, doneAction: Done.freeSelf);
	// filEnv =  EnvGen.ar( Env.new([10e-10, 1, 10e-10], [0.01, dec],  'exp' ), gate, doneAction: Done.freeSelf);
	var sig;
	ampEnv = EnvGen.ar(Env.linen(0.002, 0.996, 0.002, 1,-3), timeScale:sustain, doneAction:2);
	filEnv = EnvGen.ar(Env.perc(attack, release), gate, doneAction:2);
	waves = [ Saw.ar(freq, ampEnv),  Pulse.ar(freq, 0.5, ampEnv)];
	sig = Mix.ar(RLPF.ar( Select.ar(wave.mod(waves.size), waves), ctf + (filEnv * env), res).dup) * amp * (-60.dbamp);

	// sig = Limiter.ar(sig, (-12.dbamp));
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).store;
);
(
SynthDef(\mogo , {
    var out = \out.kr(0);
    var amp = \amp.kr(1);
    var freq = \freq.kr(440);
	var ratio = \voice.kr(1).max(0.01);
    var ffreq = \ffreq.kr(440);
    var rq = \rq.kr(0.1);
    var gate = \gate.kr(1);
    var dur = \dur.kr(1);
	var pan = \pan.kr(0);
	var sustain = \sustain.kr(1);
	var env = EnvGen.ar(Env.linen(0.002, 0.996, 0.002, 1,-3), timeScale:sustain, doneAction:2);
    var sig =
        Pulse.ar(freq * [1.01, 1.02]) *
        RLPF.ar(
            Pulse.ar(freq * ratio),
            ffreq,
            rq
        );
    sig = sig * env;
    sig = sig + GVerb.ar(sig, mul:0.3);
	sig = sig * amp * (-12.dbamp);
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).store;
);
(

SynthDef(\velobass,{//|out= 0 freq = 440 amp = 0.1 gate=1 cutoff= 12000 rq=0.25 lagTime=0.01 pan = 0.0|
    var out = \out.kr(0);
    var amp = \amp.kr(1);
	var voice = \voice.kr(1);
    var freq = \freq.kr(440);
	var ratio = \voice.kr(1).max(0.01);
    var cutoff = \cutoff.kr(440);
    var rq = \resonance.kr(0.25);
    var gate = \gate.kr(1);
    var dur = \dur.kr(1);
	var pan = \pan.kr(0);
	var sustain = \sustain.kr(1);
	var lagTime = \lag.kr(0.01);
	var basefreq =  ((freq.lag(lagTime).cpsmidi)+[0,11.95,31.03]).midicps;
	var env = EnvGen.ar(Env.linen(0.002, 0.996, 0.002, 1,-3), timeScale:sustain, doneAction:2);
	var lfo, osc, filter, sig;
	osc = Saw.ar(basefreq,[0.5,0.4,0.1]); //+PinkNoise.ar(Line.kr(1.0,0,0.03));
	filter = BLowPass4.ar(osc,100+((amp.squared)*(freq+cutoff))+((voice.squared)*(freq+cutoff)),rq);
	sig = Mix(filter)*env*amp*0.8 * (-10.dbamp);

	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));

}).store
);
(
SynthDef(\reslab, {
	var freq = \freq.kr(440);
	var amp = \amp.kr(1);
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	// var attackTime = \attackTime.kr(0.01);
	// var decayTime = \decayTime.kr(0.01);
	var sustain = \sustain.kr(0.5);
	// var releaseTime = \releaseTime.kr(0.5);
	var gate = \gate.kr(1);
	var cutoff = \cutoff.kr(1000);
	var rq = \resonance.kr(0.1);
	var env = EnvGen.ar(Env.linen(0.002, 0.996, 0.002, 1,-3), timeScale:sustain, doneAction:2);

	var sig, filter;

	sig = Mix([Saw.ar(freq), Pulse.ar(freq / 2, 0.5)]);
	sig = sig * amp * (-12.dbamp);
	sig = RLPF.ar(sig, cutoff, rq, env);

	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).store
);
(
SynthDef(\supersine, {
	var freq = \freq.kr(440);
	var amp = \amp.kr(1);
	var out = \out.kr(0);
	var pan = \pan.kr(0);
	var sustain = \sustain.kr(0.5);
	var gate = \gate.kr(1);
	var cutoff = \cutoff.kr(1000);
	var rq = \resonance.kr(0.1);
	var env = EnvGen.ar(Env.linen(0.002, 0.996, 0.002, 1,-3), timeScale:sustain, doneAction:2);

	var sig, filter;

	sig = SinOsc.ar(freq);
	sig = sig * amp * (-12.dbamp);

	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).store
);

(
SynthDef(\guitar,    {
    var out = \out.kr(0);
    var pan = \pan.kr(0);
    var gate = \gate.kr(1);
    var sustain = \sustain.kr(1);
    var freq = \freq.kr(440);
    var amp = \amp.kr(1) * (-12.dbamp);
    var snd, string;
    var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1,-3), timeScale:sustain, doneAction:2);
    string = { |sfreq|
        var delay;
        delay = sfreq.reciprocal;
        Pluck.ar(
            SinOsc.ar(env.range(1000,50)) 
            * 
            EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1,-3), timeScale:sustain, doneAction:2),
            // Impulse.ar(0.01), 
            gate,
            delay, 
            delay, 
            5, 
            0.3
        )
    };
    snd = string.(freq) + string.(freq * 1.5) + string.(freq * 2);
    snd = (snd * 32.dbamp).tanh;
    snd = RLPF.ar(snd, 3000, 0.5);
    snd = (snd * 32.dbamp).tanh;
    snd = RLPF.ar(snd, 500, 0.5);
    snd = (snd * 32.dbamp).tanh;
    snd = LeakDC.ar(snd);
    snd = DelayC.ar(snd, 0.1, SinOsc.kr(2, [0, 1pi]).range(0, 1e-4));
    // uncomment for reverb 3.10
    // snd = snd + (NHHall.ar(snd, 1) * -5.dbamp);
    snd * -20.dbamp;
    // Out.ar(out, Pan2.ar(snd, pan));
    OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));
}).add;
);
