// Roland TB-303 emulator
// https://www.sccode.org/1-4Wy
SynthDef ( "sc303" , {  arg  out=0, pan=0, freq=440, wave=0, pw=0.5, ctf=100, rq=0.2,
		attackTime=0.01, sustainLevel=1, decayTime=1, releaseTime=1, env=1000, gate=1, amp=0.2, filtAttack=0.01, filtSustain=1, filtRelease=1;
	 var  filEnv, volEnv, waves, sig;

	 // can't use adsr with exp curve???
	 //volEnv = EnvGen.ar(Env.adsr(1, 0, 1, dec, vol, 'exp'), In.kr(bus));
	// volEnv =  EnvGen .ar( Env .new([0, 1, sustainLevel, 0], [attackTime, decayTime, releaseTime] ), gate, doneAction:2);
	volEnv = EnvGen.ar(Env.adsr(attackTime, decayTime, sustainLevel, releaseTime), gate, doneAction:2);
	// filEnv =  EnvGen .ar( Env .new([0, 1, 0], [0.01, releaseTime] ), gate);
	filEnv = EnvGen.ar(Env.asr(filtAttack, filtSustain, filtRelease), gate);

	waves = [ Saw .ar(freq, volEnv),  Pulse .ar(freq, pw, volEnv)];

	sig = RLPF .ar(  Select .ar(wave, waves), ctf + (filEnv * env), rq).dup;

	Out .ar(out,  Pan2.ar(sig  * amp, pan));
}).store;


// (
// Pdef(\a, Pbind(\instrument, \sc303,
// 	\degree, Ptuple([Pwhite(0.7) , Pwhite(0,7)],inf),
// 	\dur, 1,
// 	\octave, Ptuple([Prand([2,3],inf),Prand([4,5,6],inf)],inf),
// 	\wave, Prand([0,1],inf),
// 	\ctf, Ptuple([Prand([100,200,500,1000],inf),Prand([100,200,500,1000],inf)]),
// 	\env, Ptuple([Prand([100,200,500,1000],inf),Prand([100,200,500,1000],inf)]),
// 	\attackTime, Ptuple([Pwhite(0.01,0.3), Pwhite(0.01,0.3)]),
// 	\decayTime, Ptuple([Pwhite(0.1,0.3), Pwhite(0.1,0.3)]),
// 	\sustainLevel, Ptuple([Pwhite(0.1,1), Pwhite(0.1,1)]),
// 	\releaseTime, Ptuple([Prand([0,1],inf), Prand([0,1],inf)]),
// 	\rq, Ptuple([Pwhite(0.1,0.2), Pwhite(0.1,0.2)],inf),
// 	\filtAttack, Ptuple([Pwhite(0.01,0.3), Pwhite(0.01,0.3)],inf),
// 	\filtSustain, Ptuple([Pwhite(0.1,1), Pwhite(0.1,1)],inf),
// 	\filtRelease, Ptuple([Pwhite(), Pwhite()],inf),
// )).play
// )
