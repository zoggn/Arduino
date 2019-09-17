/* 
  Stoboscopee generator with analog control and LCD
  Kubov V.I. 2012
  --------------

  Digital outputs: 
   Control LED output: digital pin 13, Gnd
   Main LED output : digital pin 9, Gnd
   The LCD circuit:
   * LCD RS pin to digital pin 7
   * LCD En pin to digital pin 6
   * LCD D4 pin to digital pin 5
   * LCD D5 pin to digital pin 4
   * LCD D6 pin to digital pin 3
   * LCD D7 pin to digital pin 2
   * LCD VO pin to Ground
   * Gnd.
  Frequencie control: Variable Resistor 1K - 100K.
   * Vcc;
   * AnalogIn_0 - VR middle point; 
   * Gnd.
*/

#include <Ticker.h>

#define _cLEDpin 2
#define _mLEDpin 4

#define _cDuty 16
#define _minFreq 10 //*0.1Hz
#define _maxFreq  1200 //*0.1Hz
#define _maxOn 1000 // *0.1ms
#define _Pause 100 //ms


Ticker tick1;

/*void setTimer2(){ 
  TCCR2 = 2<<CS20;
  TCCR2 |= (1<<WGM21);
  OCR2=199;
  TIMSK |= 1<<OCIE2;
}// setTimer2 */
//-----------------------------------------------------------------
//Devider=1; OCR2=0 ->Fmax=75KHz WRONG!!!, OCR2=255 ->Fmin=62.5KHz 
//Devider=8; OCR2=31 ->Fmax=62.5KHz, OCR2=255 ->Fmin=7.8KHz
//Devider=8; OCR2=199 ->Fmax=10KHz

unsigned int count=0;
unsigned int cPeriod=200; //*0.1ms
unsigned int cOn=cPeriod/_cDuty; 
  
void myInterrupt(){ // -------- Interupt routine ----------------
  Serial.println("Interrupt fucn was called");
  Serial.println(count);
  if (count==0){ 
    Serial.println("Сount == 0");
    digitalWrite(_cLEDpin,HIGH); //LED On 
    digitalWrite(_mLEDpin,HIGH); //LED On 
  }//  
  if (count>=cOn){ // 
    digitalWrite(_cLEDpin,LOW); //LED Off 
    digitalWrite(_mLEDpin,LOW); //LED Off 
  }//
  count++;
  if (count>=cPeriod) count=0;
}//ISR 

void setup(){
  Serial.begin(115200);
  digitalWrite(_cLEDpin,LOW); //LED Off 
  digitalWrite(_mLEDpin,LOW); //LED Off 
  pinMode(_cLEDpin,OUTPUT);
  pinMode(_mLEDpin,OUTPUT);

  tick1.attach_ms(0.1, myInterrupt);

}//setup  

#define _aMin 0  
#define _aMax 1023  

void loop(){
  char p=0; 
  // ----------  Check analog control and set Frequencie -------
  int Freq10=10; //*0.1Hz
  unsigned int Period=100000/Freq10; //*0.1ms 
  unsigned int On=Period/_cDuty; //*0.1ms  
  if (On<_maxOn) cOn=On; else cOn=_maxOn;
  cPeriod=Period;
  
  // ---------------- DEBUG SERIAL FREQ PRINT --------------------
  Serial.print("Freq, Hz");  Serial.print(" ");
  // Right adjusment
  if (Freq10>=1000) p=2;
  else if (Freq10>=100) p=3;
  else p=4;
  LCDprintHz(Freq10); 
    
  delay(_Pause);  
}//loop  

void LCDprintHz(int dHz){
  int Hz=dHz/10;
  int rHz=dHz-Hz*10;
  Serial.print(Hz,DEC); Serial.print('.'); Serial.print(rHz,DEC);
  Serial.println(); 
}//LCDprintHz   
