#!/bin/bash -e

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

function eloszoba() {
	 x2     4 ECHO: PLANAR: FRONT DoorXZ 420 244 #2;2;2;0.4
x2      1 ECHO: PLANAR: FRONT DoorXZ 420 612 #.501 #2;2;2;0.4
x2      2 ECHO: PLANAR: FRONT DoorXZ 420 444 #2;2;2;0.4
x2      2 ECHO: PLANAR: FRONT DoorXZ 1170 244 #2;2;2;0.4
x2      4 ECHO: PLANAR: FRONT DoorXZ 370 244 #2;2;2;0.4
x2      1 ECHO: PLANAR: FRONT DoorXZ 370 612 #.501 #2;2;2;0.4
x2      1 ECHO: PLANAR: FRONT DF150XZ 120 894 #2;2;2;0.4
x2      3 ECHO: PLANAR: FRONT DF300XZ 270 894 #2;2;2;0.4

}


#jobb2
#gardrob
eloszoba

#bash gen.sh && 
#TexturePacker --disable-rotation  --algorithm MaxRects  --multipack --max-width 2800  --max-height 2070 --sheet 'out/main{n1}.png' --data out/sheet{n1}.list in/ 
#TexturePacker --enable-rotation  --algorithm MaxRects  --multipack --max-width 2800  --max-height 2070 --sheet 'out/main{n1}.png' --data out/sheet{n1}.list in/ 
TexturePacker --disable-rotation  --algorithm MaxRects  --multipack --max-width 2800  --max-height 1220 --sheet 'out/main{n1}.png' --data out/sheet{n1}.list in/ 

