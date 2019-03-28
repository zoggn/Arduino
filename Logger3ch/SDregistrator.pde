/* 
  SD-card Registrator
*/

#define _markLen 16
#define _marker "Kubov V.I. 2016 "
#define _sizeOffset 16

// 512-byte block format: Record#(word); 127*(word) Data  
#define _samples 255
#define _samplingPause 50
#define _alignPause 45

#define _aPin 7

#include "Fat16.h"

// define SDcard params
#define _blockSize 512 //fixed in Fat16 Libraries
byte Buffer[_blockSize]; 
int curPos=0;

SdCard SD;

long SDsize=0;
long fileStart=0; long fileSize=0; long fileEnd=0;
long startBlock=0; long curBlock=0;
char Marker[_markLen+1]=_marker;
unsigned int curRecord=0xFFFF;

//-------------------------------------------------------------------

void setup() {
  Serial.begin(115200);
  // initialize SD card
  Serial.println("start");
  Serial.println(SD.init(),DEC); // return 1 independnt on SD
  //while(!SD.init());//Waite to SD-card
  Serial.println("SD Ok");
  // initialize File Record
  if (!recordInit()){ // Error. Stop conditions
    while(true); //infinite loop
  }//if recordInit 
  Serial.println("File Ok");  
}//setup  
//-------------------------------------------------------------------

void loop() {
  return;
  curPos=0; // start from 0-postion in Buffer
  addToBuffer(curRecord); // Current Record#
  for (int i=1; i<_samples; i++){
    addToBuffer(analogRead(_aPin)); // read analogPin and write to Buffer
    delay(_samplingPause);
  }//for i
  addToBuffer(analogRead(_aPin)); // read analogPin and write to Buffer

  SD.writeBlock(curBlock,Buffer); //write data block to SD-card
  curBlock++; // next block
  if (curBlock>fileEnd){ // Stop conditions
    while(true); //infinite loop
  }//if curBlock  
  delay(_alignPause); 
}//loop
//-------------------------------------------------------------------

void addToBuffer(unsigned int code){ //write 2-bytes code to buffer
  Buffer[curPos]=lowByte(code); curPos++;
  Buffer[curPos]=highByte(code); curPos++;  
}//addToBuffer

// ----------------------  SD-file system ---------------------------

boolean markerSearch(){ // search for marker
  for (int i=0; i<_markLen; i++){
    if (Buffer[i]!=Marker[i]) return false;
  }//for i  
  return true;
}//markerSearch 
//--------------------------------------------------------------------

boolean recordInit(){ // initialize file system
  SDsize=SD.cardSize(); 
  
  // search for File marker
  boolean isMarking=false;
  for (long b=0; b<SDsize; b++){
    SD.readBlock(b,Buffer); 
    isMarking=markerSearch();
    if (isMarking) {
      fileStart=b;
      break;
    }//if    
  }//for b 
  if (!isMarking)  return false; // Error

  // Decode File Size
  for (int i=3; i>=0; i--){ 
    fileSize=fileSize<<8 | Buffer[_sizeOffset+i];
  }//for i  
  fileEnd=fileStart+fileSize;
  if (fileEnd>SDsize){
    fileEnd=SDsize;
  }//if size 
 
  //search for empty record
  unsigned int record;
  for (long b=fileStart+1; b<fileEnd; b++){
    SD.readBlock(b,Buffer);
    record=Buffer[0] | Buffer[1]<<8; // Record # 
    if (record==0xFFFF) {
      startBlock=b;
      break;
    }else curRecord=record;
  }//for b
  if (curRecord==0xFFFF) curRecord=0;
  else curRecord=curRecord+1;  

  if (startBlock==0) return false; // Error. No empty space
  curBlock=startBlock; 
 
  return true; //Ok
}//recordInit   

