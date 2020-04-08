// results will vary with blocksize. this is tuned for 64.

(
SynthDef(\guitar,    {
    var out = \out.kr(0);
    var pan = \pan.kr(0);
    var sustain = \sustain.kr(1);
    var freq = \freq.kr(440);
    var amp = \amp.kr(1) * (-12.dbamp);
    var snd, string;
	var env = EnvGen.ar(Env.linen(0.01, 0.98, 0.01, 1,-3), timeScale:sustain, doneAction:2);
    string = { |sfreq|
        var delay;
        delay = sfreq.reciprocal;
        Pluck.ar(
            SinOsc.ar(Line.ar(1000, 50, 0.01)) 
            * 
            Env.perc(0.001, 0.1).ar, 
            Impulse.ar(0.01), delay, delay, 5, 0.5)
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
    }).store;
)

