(
SynthDef(\mogo , {
    var out = \out.kr(0);
    var amp = \amp.kr(1);
    var freq = \freq.kr(440);
    var ratio = \ratio.kr(1);
    var ffreq = \ffreq.kr(440);
    var rq = \rq.kr(0.1);
    var gate = \gate.kr(1);
    var dur = \dur.kr(1);
    var env = EnvGen.ar(Env.adsr(
        \attackTime.kr(0.01),
        \decayTime.kr(0.3),
        \sustainLevel.kr(0.5),
        \releaseTime.kr(1)
    ), gate, timeScale: dur, doneAction:2);
    var sig = //Pulse.ar(freq) * Pulse.ar(freq * [1.01,1.02]);
        Pulse.ar(freq * [1.01, 1.02]) *
        RLPF.ar(
            Pulse.ar(freq * ratio),
            ffreq,
            rq
        );
    sig = sig * env;
	// sig = sig + GVerb.ar(sig, mul:0.3);
	sig = sig * amp * (-12.dbamp);
    Out.ar(out, sig);
}).store;
);
//
// (
// Pdef(\m, Pbind(\instrument, \mogo,
// 	\dur, 4,
// 	\degree, 0,
// 	\degree, Place([0, Array.rand(7,0,14)], inf),
// 	\ratio, Place([1.01, Array.rand(4, 1,3)+0.01],inf) /  2,
// 	\octave, Pseq(Array.rand(4,3,5),inf),
// 	// \ffreq, Pseq((24..72),inf).midicps,
// 	\ffreq, Pn(Pseries(500, 10, 10)),
// 	\rq, Pn(Pseries(0, 0.01, 30)),
// 	// \legato, Pwhite(0.1,1.2),
// 	// \attackTime, 0.3,
// 	// \releaseTime, 2,
// 	// \amp, 0.21 * Ptuple([
// 	// 	Pbjorklund(5,8),
// 	// 	Pbjorklund(5,8),
// 	// ]),
// )).play
// )
