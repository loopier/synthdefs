SynthDef(\piano, { |out=1, freq=440, gate=1|
                var sig = MdaPiano.ar(freq, gate, release: 0.9, stereo: 0.3, sustain: 0);
                sig = FreeVerb.ar(sig,0.67,0.7,0.6);
                DetectSilence.ar(sig, 0.01, doneAction:2);
                Out.ar(out, sig * 0.7);
}).store;