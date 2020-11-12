(
SynthDef(\echo, { arg out=0, in=0, maxdelaytime=8, delaytime=0.2, decay=2, gate=1;
    var env, insig;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    insig = In.ar(in, 2);
    XOut.ar(out, env, CombL.ar(insig * env, maxdelaytime, delaytime, decay, 1, insig));
}, [\ir, \ir, 0.1, 0.1, 0]).store;

// same as \echo but with feedback
SynthDef(\delay, {
	var out = \out.ir(0);
	var maxdelaytime = \maxdelaytime.ir(8);
	var delaytime = \delayt.kr(0.2);
	var feedback = \fb.kr(0.5);
	var gate = \gate.kr(1);
    var env, in, local, del;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    in = In.ar(\in.kr(0), 2);
	local = LocalIn.ar(2) + in;
	del = DelayN.ar(
		local,
		maxdelaytime: maxdelaytime,
		delaytime: delaytime,
		mul: feedback
	);
	LocalOut.ar(del);
    XOut.ar(out, env, del);
}).store;

// SynthDef(\distort, { arg out=0, pregain=40, amp=0.2, gate=1;
// 	var env;
// 	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
// 	XOut.ar(out, env, (In.ar(out, 2) * pregain).distort * amp);
// }, [\ir, 0.1, 0.1, 0]).store;

SynthDef(\distort, {|out =0 gate= 1|
	var source = In.ar(out,2);
	var env = Linen.kr(gate, 0.0, 1, 0.1, 2);
	var abs, excess,output;

	abs = source.abs;

	excess = (abs-0.1).max(0.0).min(0.9)/0.9;

	//original plus sinusoidal perturbation of amount based on absolute amplitude
	output = source+(excess*(sin(excess*2pi*5)*0.5-0.5));

	XOut.ar(out,env,output*env);

}).store;

// from SuperDirt
SynthDef(\superdistort, { |out, distort = 0|
		var signal, mod;
		signal = In.ar(out, 2);
		mod = CrossoverDistortion.ar(signal, amp: 0.2, smooth: 0.01);
		mod = mod + (0.1 * distort * DynKlank.ar(`[[60,61,240,3000 + SinOsc.ar(62,mul: 100)],nil,[0.1, 0.1, 0.05, 0.01]], signal));
		mod = (mod.cubed * 8).softclip * 0.5;
		mod = SelectX.ar(distort, [signal, mod]);
		ReplaceOut.ar(out, mod);
}).store;

SynthDef(\wah, {
	var out = \out.kr(0);
	var gate = \gate.kr(1);
	var rate = \rate.kr(0.3);
	var rq = \rq.kr(0.1);
	var amp = \amp.kr(1);
    var env = Linen.kr(gate, 0.05, 1, 0.4, 2);
    var in = In.ar(out, 2);
	XOut.ar(out, env, RLPF.ar(in, LinExp.kr(LFNoise1.kr(rate), -1, 1, 200, 8000), rq: rq, mul:amp).softclip * 0.8);
}, [\ir, 0]).store;

SynthDef(\chorus, {|out =0 gate= 1 amp=1|
	var source = In.ar(out,2);
	var chorus;
	var env = Linen.kr(gate, 0.1, amp, 0.1, 2);

	chorus= Mix.fill(7, {

		var maxdelaytime= rrand(0.005,0.02);

		DelayC.ar(source, maxdelaytime,LFNoise1.kr(Rand(4.5,10.5),0.25*maxdelaytime,0.75*maxdelaytime) )

	});

	XOut.ar(out,env, chorus * env);

}).store;

SynthDef(\choruscompress, {|out =0 gate= 1 amp=1|
	var source = In.ar(out,2);
	var chorus;
	var env = Linen.kr(gate, 0.1, 1, 0.1, 2);

	chorus= Splay.ar(Array.fill(4,{
		var maxdelaytime= rrand(0.005,0.02);

		DelayC.ar(source[0], maxdelaytime,LFNoise1.kr(Rand(0.1,0.6),0.25*maxdelaytime,0.75*maxdelaytime) )
	}));

	chorus = Compander.ar(4*(source + chorus),source,0.4,1,4);
	chorus = chorus * amp * (-6.dbamp);
	XOut.ar(out,env,chorus);

//From Steal This Sound SC Example
//By Nick Collins
}).store;

SynthDef(\rlpf, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var gate = \gate.kr(1);
	var freq = \freq.kr(440);
	var rq = \rq.kr(0.1);
	var env = Linen.kr(gate, 0.05, 1, 0.4, 2);
	// var attack = \attackTime.kr(0.01);
	// var decay = \decayTime.kr(0.3);
	// var sustain = \sustainLevel.kr(0.5);
	// var release = \releaseTime.kr(1);
	// var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
    var in = In.ar(out, 2);
	XOut.ar(out, env, RLPF.ar(in, freq * env, rq, amp));
}).store;

SynthDef(\rhpf, {
	var out = \out.kr(0);
	var amp = \amp.kr(0.2);
	var gate = \gate.kr(1);
	var freq = \freq.kr(440);
	var rq = \rq.kr(0.1);
    var env = Linen.kr(gate, 0.05, 1, 0.4, 2);
    var in = In.ar(out, 2);
	XOut.ar(out, env, RHPF.ar(in, freq, rq, amp));
}).store;

SynthDef(\lopag, {
	var out = \out.kr(0);
	var amp = \amp.kr(1);
	var gate = \gate.kr(1);
	var freq = \freq.kr(440);
	var rq = \rq.kr(0.1);
	// var env = Linen.kr(gate, 0.05, 1, 0.4, 2);
	var attack = \attackTime.kr(0.01);
	var decay = \decayTime.kr(0.3);
	var sustain = \sustainLevel.kr(0.5);
	var release = \releaseTime.kr(1);
	var env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);
    var in = In.ar(out, 2);

	XOut.ar(out, env, RLPF.ar(in, freq * env, rq, amp * env));
}).store;

SynthDef(\freeverb, {
	var out = \out.kr(0);
	var gate = \gate.kr(1);
	var mix = \mix.kr(0.33);
	var room = \room.kr(0.5);
	var damp = \damp.kr(0.5);
	var in, env;
	env = Linen.kr(gate, 0.05, 2, 0.2, 2);
	in = In.ar(out, 2);
    XOut.ar(out, env, FreeVerb.ar(in, mix, room, damp).softclip * 0.8);
}).store;

SynthDef(\gverb, {
	var out = \out.kr(0);
	var amp = \amp.kr(0.2);
	var gate = \gate.kr(1);
	var room = \room.kr(10);
	var revtime = \revtime.kr(3);
	var damp = \damp.kr(0.5);
	// var in = In.ar(\in.kr(0));
	var in = In.ar(out, 2);
	var env;
	env = Linen.kr(gate, 0.05, 2, 0.2, 2);
	XOut.ar(out, env, GVerb.ar(Mix.ar(in), room, revtime, damp, mul:amp).softclip * env * 0.8);
}).store;

SynthDef(\jpverb, {
	var out = \out.kr(0);
	var amp = \amp.kr(0.2);
	var gate = \gate.kr(1);
	var room = \room.kr(10);
	var size = \size.kr(1);
	var damp = \damp.kr(0.0);
	var in = In.ar(out, 2);
	var env = Linen.kr(gate, 0.05, 2, 0.2, 2);
	var sig = JPverb.ar(Mix.ar(in), damp: damp, size: size);
	XOut.ar(out, env, sig);
}).store;
)


SynthDef(\reverb, {
	arg out = 0, gate = 1, roomsize = 100, revtime = 1, damping = 0.6, inputbw = 0.5, spread = 15, drylevel = 1, earlyreflevel = 0.7, taillevel = 0.5, maxroomsize = 300, amp = 0.5;
	var source = In.ar(out,8);
	var reverb;
	var env = Linen.kr(gate, 0.1, 1, 0.1, 2);


	reverb = GVerb.ar(source, roomsize, revtime, damping, inputbw, spread, drylevel, earlyreflevel, taillevel, maxroomsize);
	reverb = reverb * amp ;
	XOut.ar(out,env,reverb);
//By Zé Craum

}).store;
