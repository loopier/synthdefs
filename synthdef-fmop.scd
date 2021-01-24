// Single FM operator that can be modulated with other synths of this same class through
// the 'mod' and 'modamt' parameters.
// It has a 4-stage envelope.
(
SynthDef(\fmop, {
    var out = \out.kr(0);
    var pan = \pan.kr(0);
    var freq = \freq.kr(440);
	var ratio = \ratio.kr(1);
	var detune = \detune.kr(0);
    var amp = \amp.kr(1) * (-10.dbamp);
    var mod = \mod.ar(0);
    var modamt = \modamt.ar(1);
    var feedback = \feedback.kr(0);
    var atkt = \atkt.kr(0.01);
    var atkl = \atkl.kr(1);
    var dect = \dect.kr(0.3);
    var decl = \decl.kr(1);
    var sust = \sust.kr(1);
    var susl = \susl.kr(1);
    var relt = \relt.kr(0.01);
    var rell = \rell.kr(0);
    var gate = \gate.kr(1);
    var timescale = \dur.kr(1) * \legato.kr(1);
    var vibrato = \vibrato.kr(0);
    var tremolo = \tremolo.kr(0);
    // var timescale = \legato.kr(1);
    // var timescale = \dur.kr(1);
    var env = EnvGen.ar(Env.new(
        levels:[0,atkl,decl,susl,susl,rell],
        times:[atkt,dect,sust,1.0-atkt-dect-sust,relt],
        // times:[atkt,dect,1.0-atkt-dect,relt],
        curve: 'lin',
        releaseNode: nil,
        loopNode: nil,
        offset: 0
    ), 
    gate: gate, 
    timeScale: timescale, 
    doneAction:2);
	var sig, fb;
    freq = freq * ratio + detune;
    // vibrato frequency follows envelope
    freq = freq * SinOsc.kr(SinOsc.kr(env * 8.23,  mul: env + 1), add: 1, mul: vibrato * 1 * env);
    // tremolo frequency follows envelope
    amp = amp * SinOsc.kr(SinOsc.kr(env * 8.23, mul: env + 1), add: 1, mul: tremolo * 10 * env);
    // fb = SinOsc.ar(freq, 0, feedback);
    // sig = SinOsc.ar(freq, mod * modamt + SinOsc.ar(freq, 0, feedback));
    sig = SinOsc.ar(freq, mod * modamt);
    Out.ar(out, Pan2.ar(sig * env * amp, pan));
}).store;
)

// (
// // p.parent.close;
// p = Env.new(levels:[0,1,1,1,0], times:[0.01,0.3,1,0.001]).plot;
// )
//
// Pdef.removeAll;
// Tocata.synth(\opa, \op);
// Tocata.synth(\ope, \op);
// Tocata.synth(\opi, \op);
// Tocata.synth(\opo, \op);
// Tocata.synth(\opu, \op);
// ~opa.quant_(1);
// ~ope.quant_(1);
// ~opa.play;
// ~ope.play;
// ~opi.stop;
// ~ope.dur_([5.5,1.5].pseq(inf)).amp_([1.5,0].pseq(inf));
// ~opa.dur_(1);
// ~opa.r_(Bjorklund(5,8).replace(0,\r).pseq(inf))
// ~opo.dur_(4);
// ~opo.amp_(1);
// ~ope.amp_(1);
// ~ope.stop;
// ~opi.detune_(1);
// ~opa.degree_([0,2,4,7].prand(inf));
// ~opi.degree_(0).octave_(5);
// ~opo.degree_([0,2,4,7].prand(inf)).octave_(3);
// ~opa.octave_([3,4,5,6].prand(inf));
// ~opa.legato_(Pbrown(0.1,2,0.5));
// ~opa.pan_(Pwhite(-1));
// ~opa.dur_(2);
// ~opa.atkt_(Pbrown(0.1,0.3));
// ~opa.dect_(0.3);
// ~opa.decl_(Pbrown());
// ~opa.susl_(1.5);
// ~opa.sust_(Pbrown(0.1,3,0.5));
// ~opa.legato_(1);
// ~opa.mod_([~opa.ndef]);
// ~opi.mod_([~opa.ndef]);
// ~opa.mod_([nil]);
// ~opi.mod_([nil]);
// ~opi.modamt_(50);
// ~opa.modamt_(Pbrown(10,30,10));
// ~opa.gverb(0.3);
// ~opa.freeverb(0);
// ~opa.delay(3,0.6);
