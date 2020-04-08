// 2-bit sequencer
// receives 2 inputs that can be either 0 or 1 to form  a 2-bit binary digit.
// outputs the slot at the sequence corresponding to the binary number.
// e.g.: [0,0] outputs first element, [0,1] outputs second element, ...
// The sequence can also be set with an 4-size array.
SynthDef(\bit2sequencer, {
	var a = \inA.kr(0) *  2.pow(0);
	var b = \inB.kr(0) *  2.pow(1);
	var sequence = \sequence.kr(#[ 0, 1, 2, 3]);
	var out = \out.kr(0);
	var decimal = a + b;
	Out.ar(out, K2A.ar(Select.kr( decimal, sequence )));
}).store;
// 3-bit sequencer
// receives 3 inputs that can be either 0 or 1 to form  a 3-bit binary digit.
// outputs the slot at the sequence corresponding to the binary number.
// e.g.: [0,0,0] outputs first element, [0,0,1] outputs second element, ...
// The sequence can also be set with an 8-size array.
SynthDef(\bit3sequencer, {
	var a = \inA.kr(0) *  2.pow(0);
	var b = \inB.kr(0) *  2.pow(1);
	var c = \inC.kr(0) *  2.pow(2);
	var sequence = \sequence.kr(#[ 0, 1, 2, 3, 4, 5, 6, 7 ]);
	var out = \out.kr(0);
	var decimal = a + b + c;
	Out.ar(out, K2A.ar(Select.kr( decimal, sequence )));
}).store;
// 4-bit sequencer
// receives 4 inputs that can be either 0 or 1 to form  a 4-bit binary digit.
// outputs the slot at the sequence corresponding to the binary number.
// e.g.: [0,0,0,0] outputs first element, [0,0,0,1] outputs second element, ...
// The sequence can also be set with an 16-size array.
SynthDef(\bit4sequencer, {
	var a = \inA.kr(0) *  2.pow(0);
	var b = \inB.kr(0) *  2.pow(1);
	var c = \inC.kr(0) *  2.pow(2);
	var d = \inD.kr(0) *  2.pow(3);
	var sequence = \sequence.kr(#[ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
	var out = \out.kr(0);
	var decimal = a + b + c + d;
	Out.ar(out, K2A.ar(Select.kr( decimal, sequence )));
}).store;
// 5-bit sequencer
// receives 4 inputs that can be either 0 or 1 to form  a 4-bit binary digit.
// outputs the slot at the sequence corresponding to the binary number.
// e.g.: [0,0,0,0] outputs first element, [0,0,0,1] outputs second element, ...
// The sequence can also be set with an 16-size array.
SynthDef(\bit5sequencer, {
	var a = \inA.kr(0) *  2.pow(0);
	var b = \inB.kr(0) *  2.pow(1);
	var c = \inC.kr(0) *  2.pow(2);
	var d = \inD.kr(0) *  2.pow(3);
	var e = \inE.kr(0) *  2.pow(4);
	var sequence = \sequence.kr(#[ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 ]);
	var out = \out.kr(0);
	var decimal = a + b + c + d + e;
	Out.ar(out, K2A.ar(Select.kr( decimal, sequence )));
}).store;