#!/bin/bash -e

#grep MAIN eloszoba.md |sort|uniq -c|tr '*;"' '  '|awk '{print "x",$5,$1,$6,$7}'

set -e 
function t() {

	label=$1
	n=$2
	w=$3
	h=$4
	
	x $label $n $h $w
}
function x() {
	label=$1
	n=$2
	w=$3
	h=$4
	echo "$label n:$n w:$w h:$h"

#	convert rose: -resize ${w}x${h}! \
#		 -gravity center    -annotate 0 "$label" \
#		in/$label.1.png
	for i in `seq 1 $n` ; do
		t=in/$label.$i.png
		[ -e $t ] && echo "error: $t exists" && exit 1
		convert -pointsize $[ 100+$i ]  -gravity center label:$label -resize ${w}x${h}! \
			in/$label.$i.png
echo		convert -pointsize $[ 100+$i ]  -gravity center label:$label -resize ${w}x${h}! \
			in/$label.$i.png
#		cp in/$label.1.png in/$label.$i.png
	done
}

rm -rf in
mkdir in

function gardrob() {
x LYZ	6	2226	450	ABS-04mm		ABS-04mm	ABS-04mm		
x LXY	21	564	450	ABS-04mm					
x S2YZ	2	890	350	ABS-04mm		ABS-04mm	ABS-04mm		
x S2XY	4	564	350	ABS-04mm					
x POLC1	1	1500	165		ABS-04mm	ABS-04mm			
x POLC2	1	1000	165		ABS-04mm	ABS-04mm			
x PP	8	1200	250	ABS-04mm		ABS-04mm	

#x LYZ	8	2226	450	ABS-04mm		ABS-04mm	ABS-04mm		
#x LXY	28	564	450	ABS-04mm					
#x S2YZ	8	890	300	ABS-04mm		ABS-04mm	ABS-04mm		
#x S2XY	16	564	300	ABS-04mm					

#x POLC1	1	1500	165		ABS-04mm	ABS-04mm			
#x POLC2	1	1000	165		ABS-04mm	ABS-04mm			
#x PP	4	1200	250	ABS-04mm		ABS-04mm	
}

function jobb2() {
x RX11U	4	958	568	ABS-2mm	hatlapmaras	ABS-2mm			
x RX11L	2	1542	568	ABS-2mm	hatlapmaras				
x RX13U	1	960	378	ABS-2mm					
x RX13L	1	1542	378	ABS-2mm					
x RU9	2	569	568	ABS-2mm	hatlapmaras				
x RU11	4	564	568	ABS-2mm	hatlapmaras				
x RP9	2	569	558	ABS-2mm					
x RP11	2	564	558	ABS-2mm					
x VEG	6	550	378	ABS-2mm	egyeb	

x CB	1	597	263	ABS-2mm	egyeb				
x A	1	1661	105	ABS-2mm	ABS-04mm	ABS-2mm	ABS-2mm		
x f230	2	230	555	ABS-04mm	ABS-04mm	ABS-04mm	ABS-04mm		
x ViragP	2	360	180	ABS-2mm				felkor alakra vagva a teljes iv 2mm el elzarva	
x QbackXZ	2	752	300	ABS-04mm	ABS-04mm	ABS-04mm	ABS-04mm		
x QsideYZ	2	335	270	ABS-04mm	ABS-04mm	ABS-04mm	ABS-04mm		
x Qu0XY	2	1400	270	ABS-04mm	ABS-04mm	ABS-04mm	ABS-04mm		
x Qu317XY	1	1382	270	ABS-04mm	ABS-04mm	ABS-04mm	ABS-04mm		
x f110	5	110	555	ABS-04mm	ABS-04mm	ABS-04mm	ABS-04mm		
x f80	2	80	555	ABS-04mm	ABS-04mm	ABS-04mm	ABS-04mm		
x f160	1	160	555	ABS-04mm	ABS-04mm	ABS-04mm	ABS-04mm	

x L60	3	61	599	ABS-04mm		ABS-04mm	ABS-04mm		
x L120	1	61	1199	ABS-04mm		ABS-04mm	ABS-04mm		
x L180	1	61	1799	ABS-04mm		ABS-04mm	ABS-04mm		
x L31	3	61	310	ABS-04mm		ABS-04mm	ABS-04mm		
x L18	1	61	180	ABS-04mm		ABS-04mm	ABS-04mm		
x L46	1	61	463	ABS-04mm		ABS-04mm	ABS-04mm	

}
function jobb2_0() {

x RX11L_T 	1 	1542 	568 	ABS-2mm 	hatlapmaras 				
x RX11U_T 	3 	958 	568 	ABS-2mm 	hatlapmaras 	ABS-2mm 			
x RX11U 	1 	958 	568 	ABS-2mm 	hatlapmaras 	ABS-2mm 			
x RX11L 	1 	1542 	568 	ABS-2mm 	hatlapmaras 				
x RX13U 	1 	960 	378 	ABS-2mm 					
x RX13L 	1 	1542 	378 	ABS-2mm 					
t RU9 	2 	569 	568 	ABS-2mm 	hatlapmaras 				
t RU11 	4 	564 	568 	ABS-2mm 	hatlapmaras 				
t RP9 	2 	569 	558 	ABS-2mm 					
t RP11 	1 	564 	558 	ABS-2mm 					
x VEG 	6 	550 	378 	ABS-2mm 	egyeb 				FÁJL 
x CB 	1 	597 	263 	ABS-2mm 	egyeb 				FÁJL 
x A 	1 	1661 	105 	ABS-2mm 	ABS-04mm 	ABS-2mm 	ABS-2mm 	

}
function x2() {
echo $1 $5$6$7 $6 $7
x $5$6$7  $1 $7 $6

}

function eloszobaFront() {
	 x2     4 ECHO: PLANAR: FRONT DoorXZ 420 244 #2;2;2;0.4
x2      1 ECHO: PLANAR: FRONT DoorXZ 420 612 #.501 #2;2;2;0.4
x2      2 ECHO: PLANAR: FRONT DoorXZ 420 444 #2;2;2;0.4
x2      2 ECHO: PLANAR: FRONT DoorXZ 1170 244 #2;2;2;0.4
x2      4 ECHO: PLANAR: FRONT DoorXZ 370 244 #2;2;2;0.4
x2      1 ECHO: PLANAR: FRONT DoorXZ 370 612 #.501 #2;2;2;0.4
x2      1 ECHO: PLANAR: FRONT DF150XZ 120 894 #2;2;2;0.4
x2      3 ECHO: PLANAR: FRONT DF300XZ 270 894 #2;2;2;0.4

}

function eloszoba() {
	x basicHStandXZ 1 196 846
x C-beamXY 2 100 864
x CBotXY 2 632 864
x CD150AXZ 2 93.6 837.8
x CD150BYZ 2 93.6 588
x CD300AXZ 6 243.6 837.8
x CD300BYZ 6 243.6 588
x CFootXZ 1 80 900
x C-S-IN864XY 1 616 864
x CTopXY 1 632 864
x CYZ 2 1047.6 632
x aCYZ 2 447.6 632
x L1-beamFXY 1 272 464
x L1BotXY 1 270 464
x L1-S-IN464XY 5 256 464
x L1YZ 2 1597.6 270
x L2-beamFXY 1 272 464
x L2BotXY 1 270 464
x L2FootXZ 1 80 1000
x L2-S-IN464XY 1 256 464
x L2YZ 2 397.6 270
x L30YZ 1 397.6 634
x L31YZ 1 397.6 272
x L3-beamFXY 1 272 498
x L3Foot1XZ 1 77.6 660.175
x SCover12XY 1 290 500
x ShoeTopXY 1 650 916
x SpacerLowLeYZ 2 419.2 269.6
x SpacerLowRYZ 1 1129.6 60.6
x SpacerTopRYZ 1 447.6 199.6
x U1BotXY 1 270 464
x U1-S-IN464XY 1 254 464
x U1TopXY 1 270 464
x U1YZ 2 447.6 270
x U2BotXY 1 270 464
x U2-S-IN464XY 1 254 464
x U2TopXY 1 270 464
x U2YZ 2 447.6 270
x U30YZ 1 447.6 634
x U31YZ 1 447.6 272
x U3-beamFXY 1 270 498

}


#jobb2
#gardrob
eloszoba

#bash gen.sh && 
#TexturePacker --disable-rotation  --algorithm MaxRects  --multipack --max-width 2800  --max-height 2070 --sheet 'out/main{n1}.png' --data out/sheet{n1}.list in/ 
TexturePacker --enable-rotation  --algorithm MaxRects  --multipack --max-width 2800  --max-height 2070 --sheet 'out/main{n1}.png' --data out/sheet{n1}.list in/ 
#TexturePacker --disable-rotation  --algorithm MaxRects  --multipack --max-width 2800  --max-height 1220 --sheet 'out/main{n1}.png' --data out/sheet{n1}.list in/ 

