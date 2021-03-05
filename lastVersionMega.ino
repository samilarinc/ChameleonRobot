int aS0=22, aS1=23, aS2=24, aS3=25, aOUT=26;
int aRedReading, aBlueReading, aGreenReading, aWhiteReading;
int aRedPin=4, aGreenPin=3, aBluePin=2;

int bS0=27, bS1=28, bS2=29, bS3=30, bOUT=31;
int bRedReading, bBlueReading, bGreenReading, bWhiteReading;
int bRedPin=7, bGreenPin=6, bBluePin=5;

//int cS0=32, cS1=33, cS2=34, cS3=35, cOUT=36;
//int cRedReading, cBlueReading, cGreenReading, cWhiteReading;
//int cRedPin=10, cGreenPin=9, cBluePin=8;
//
//int dS0=37, dS1=38, dS2=39, dS3=40, dOUT=41;
//int dRedReading, dBlueReading, dGreenReading, dWhiteReading;
//int dRedPin=13, dGreenPin=12, dBluePin=11;

void setup() {
  pinMode(aS0, OUTPUT);
  pinMode(aS1, OUTPUT);
  pinMode(aS2, OUTPUT);
  pinMode(aS3, OUTPUT);
  pinMode(aOUT, INPUT); 
  pinMode(aRedPin, OUTPUT);
  pinMode(aBluePin, OUTPUT);
  pinMode(aGreenPin, OUTPUT);
  digitalWrite(aS0, HIGH);
  digitalWrite(aS1, LOW);

  pinMode(bS0, OUTPUT);
  pinMode(bS1, OUTPUT);
  pinMode(bS2, OUTPUT);
  pinMode(bS3, OUTPUT);
  pinMode(bOUT, INPUT);
  pinMode(bRedPin, OUTPUT);
  pinMode(bBluePin, OUTPUT);
  pinMode(bGreenPin, OUTPUT);
  digitalWrite(bS0, HIGH);
  digitalWrite(bS1, LOW);

//  pinMode(cS0, OUTPUT);
//  pinMode(cS1, OUTPUT);
//  pinMode(cS2, OUTPUT);
//  pinMode(cS3, OUTPUT);
//  pinMode(cOUT, INPUT);
//  pinMode(cRedPin, OUTPUT);
//  pinMode(cBluePin, OUTPUT);
//  pinMode(cGreenPin, OUTPUT);
//  digitalWrite(cS0, HIGH);
//  digitalWrite(cS1, LOW);
//
//  pinMode(dS0, OUTPUT);
//  pinMode(dS1, OUTPUT);
//  pinMode(dS2, OUTPUT);
//  pinMode(dS3, OUTPUT);
//  pinMode(dOUT, INPUT);
//  pinMode(dRedPin, OUTPUT);
//  pinMode(dBluePin, OUTPUT);
//  pinMode(dGreenPin, OUTPUT);
//  digitalWrite(dS0, HIGH);
//  digitalWrite(dS1, LOW);

  Serial.begin(9600);
}

int detect_red(int num, int Sa, int Sb, int Sc){
  digitalWrite(Sa, LOW);
  digitalWrite(Sb, LOW);
  int red = pulseIn(Sc, LOW);
  if(num == 1)   
    red = 255 - (red + 160);
  else if(num == 2)   
    red = 255 - (red + 145);
  if(red < 0)
      red = 0;
  else if(red>255)
      red = 255;
  return red;
}
int detect_blue(int num, int Sa, int Sb, int Sc){
  digitalWrite(Sa, LOW);
  digitalWrite(Sb, HIGH);
  int blue = pulseIn(Sc, LOW);
  if(num == 1)   
    blue = 255 - (blue + 170);
  else if(num == 2)   
    blue = 255 - (blue + 95);
  if(blue < 0)
      blue = 0;
  else if(blue > 255)
      blue = 255;
  return blue;
}

int detect_green(int num, int Sa, int Sb, int Sc){
  digitalWrite(Sa, HIGH);
  digitalWrite(Sb, HIGH);
  int green = pulseIn(Sc, LOW);
  if(num == 1)   
    green = 255 - (green + 150);
  else if(num == 2)   
    green = 255 - (green + 80);
  if(green < 0)
      green = 0;
  else if(green > 255)
      green = 255;
  return green;
}

void loop() {
  aRedReading = detect_red(1, aS2, aS3, aOUT);  
  aBlueReading = detect_blue(1, aS2, aS3, aOUT);
  aGreenReading = detect_green(1, aS2, aS3, aOUT);

    bRedReading = detect_red(2, bS2, bS3, bOUT);  
    bBlueReading = detect_blue(2, bS2, bS3, bOUT);
    bGreenReading = detect_green(2, bS2, bS3, bOUT);

//    cRedReading = detect_red(cS2, cS3, cOUT);  
//    cBlueReading = detect_blue(cS2, cS3, cOUT);
//    cGreenReading = detect_green(cS2, cS3, cOUT);
//
//    dRedReading = detect_red(dS2, dS3, dOUT);  
//    dBlueReading = detect_blue(dS2, dS3, dOUT);
//    dGreenReading = detect_green(dS2, dS3, dOUT);

  setColors(aRedPin, aGreenPin, aBluePin, aRedReading, aGreenReading, aBlueReading);
  setColors(bRedPin, bGreenPin, bBluePin, bRedReading, bGreenReading, bBlueReading);
//  setColors(cRedPin, cGreenPin, cBluePin, cRedReading, cGreenReading, cBlueReading);
//  setColors(dRedPin, dGreenPin, dBluePin, dRedReading, dGreenReading, dBlueReading);
  
  delay(200);   
}

void setColors(int pin1, int pin2, int pin3, int red, int green, int blue)   { 
  analogWrite(pin1 , 255-red); 
  analogWrite(pin2 , 255-green); 
  analogWrite(pin3 , 255-blue);
}



//  // detect brightness
//  digitalWrite(aS2, HIGH);
//  digitalWrite(aS3, LOW);
//  aWhiteReading = pulseIn(aOUT, LOW);
//
//  // Calibration of the colors' read values
//  aWhiteReading = 255 - aWhiteReading;
//
//  if(aWhiteReading < 0)
//    aWhiteReading = 0;
//    
//  if(aWhiteReading > 255)
//    aWhiteReading = 255;


//  Serial.print("R: " + String(aRedReading));
//  Serial.print("\tG: " + String(aGreenReading));
//  Serial.print("\tB: " + String(aBlueReading));
//  Serial.print("\tW: " + String(aWhiteReading));
//  Serial.print("\r\n");
