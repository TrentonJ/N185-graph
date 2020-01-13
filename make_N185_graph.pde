/*
The purpose of this Processing sketch is to display and optionally to save in scalable vector 
graphics (svg) file format a graph sheet used to show water supply and fire sprinkler
system water demand.  This graph is typically called N185 paper or N^1.85 paper.  If you do 
not want the svg file then just comment out the three lines having "// SVG" appended to them.
*/
import processing.svg.*;  // SVG
size(1100,720);  // these constants are also used below
background(255);
stroke(0);

beginRecord(SVG, "N185_graph.svg");  // SVG
int stopAt = 2000;  //a graph to 2000 gpm for example
int incr = 200;  // major and minor flow lines
int leftMarg = 50;  // left margin, etc.
int rightMarg = 10;
int topMarg = 20;
int bottomMarg = 70;
float xfactor = (1100-leftMarg-rightMarg)/exp(log(stopAt)/.54); // scaling factor
int c = 0;
int x;
float yAxisIncr = (720 - topMarg - bottomMarg)/15;  // number of y axis increments for pressure
int Yline;
int tickWidth = 10; // extend major flow and pressure lines for ease of labelling
float interval;
float flowTick;
int n;

strokeWeight(2);  // draw image rectangle and major vertical flow lines of the graph
rect(leftMarg,topMarg,1100 - leftMarg - rightMarg,720 - topMarg - bottomMarg);
while (c <= stopAt) {
  x = leftMarg + round(xfactor*exp(log(c)/.54));
  line(x,topMarg,x,720 - bottomMarg + tickWidth);
  c = c + incr;
}

stopAt = 1900;  // now draw the minor vertical flow lines with lighter line weight
c = round(incr/2);
strokeWeight(1);
while (c <= stopAt) {
  x = leftMarg + round(xfactor*exp(log(c)/.54));
  line(x,topMarg,x,720 - bottomMarg);
  c = c + incr;
}

flowTick = incr;  // draw the little flow tick marks in between major and minor lines
interval = incr/10;
while (flowTick <= stopAt) {
  c = 1;
  while (c < 5) {
    x = leftMarg + round(xfactor*exp(log(flowTick + c*interval)/.54));
    line(x,720 - bottomMarg,x, 720 - bottomMarg - tickWidth);
    c = c + 1;
  }
  flowTick = flowTick + incr/2;
}

Yline = 0 + topMarg;  // draw major horizontal pressure lines
while (Yline < (720 - topMarg - bottomMarg)) {
  line(leftMarg - tickWidth,Yline,1100 - rightMarg,Yline);
  Yline = round(Yline + yAxisIncr);
}

Yline = 0 + topMarg + round(yAxisIncr/2);  //draw minor horizontal pressure lines
while (Yline < (720 - topMarg - bottomMarg)) {
  line(leftMarg,Yline,1100 - rightMarg,Yline);
  Yline = round(Yline + yAxisIncr);
}

// label the graph:
textSize(16);
fill(0);
text("N1.85 Graph For Fire Protection", 450, topMarg-4);

textSize(16);  // put "flow" text on bottom margin
fill(0);
text("flow", 530, 710);

textSize(16);  // put "pressure" text on left margin vertically aligned
fill(0);
translate(20,370);
rotate(-PI/2);
textAlign(CENTER);
text("pressure", 0,0);

endRecord();  // SVG

/*
A sprinkler system demand curve has the following formula for a demand flow Q at pressure P including
elevation pressure E:  p = (q/K)^1.85 where K = Q/P^0.54

A water supply curve has the following formula given a flow test with results static S, flow F at pressure R:
p = S - (S-R)*(q/F)^1.85
*/
