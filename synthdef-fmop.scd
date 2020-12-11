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
    var atkt = \atkt.kr(0.01);
    var atkl = \atkl.kr(1);
    var dect = \dect.kr(0.3);
    var decl = \decl.kr(1);
    var sust = \sust.kr(0.5);
    var susl = \susl.kr(0.5);
    var relt = \relt.kr(1);
    var rell = \rell.kr(0);
    var gate = \gate.kr(1);
    var timescale = \dur.kr(1) * \legato.kr(1);
    // var env = EnvGen.ar(Env.adsr(attack, decay, sustain, release), gate, timeScale: timescale, doneAction:2);
    var env = EnvGen.ar(Env.new(
        levels:[0,atkl,decl,susl,rell],
        times:[atkt,dect,sust,relt],
        curve: 'lin',
        releaseNode: nil,
        loopNode: nil,
        offset: 0
    ), gate: gate, timeScale: timescale, doneAction:2);
	var sig = SinOsc.ar(freq + detune, mod * modamt);
    Out.ar(out, Pan2.ar(sig * env * amp, pan));
}).store;
)

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
