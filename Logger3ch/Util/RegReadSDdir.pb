; Registrator SD-card file Read
; Kubov V.V. 2016
;-------------- Read Preference from *.ini ----------------------------
#iniName$="RegistratorReadSD.ini"
If OpenPreferences(#iniName$)
  Else: MessageRequester("Error",#iniName$+" not Found")
EndIf
fileName$=ReadPreferenceString("fileName","Logger.bin")
currentDate=Date()
Global outFileNameFormat$=ReadPreferenceString("outFileNameFormat","sb123_%yyyy%mm%dd")
Global outFileExt$=ReadPreferenceString("outFileExt","Log")
Global outFileRecLen=ReadPreferenceLong("outFileRecLen",0)
Global outFileName$=FormatDate(outFileNameFormat$,currentDate)
Global outFile$=outFileName$+RSet("0",outFileRecLen,"_")+"."+outFileExt$
;Debug outfile$
wWidth=ReadPreferenceLong("wWidth",600)
wHeight=ReadPreferenceLong("wHeight",400)
Global sLength=ReadPreferenceLong("sLength",8)
Global numberChanels=ReadPreferenceLong("numberChanels",3)
Global dateLength=ReadPreferenceLong("dateLength",4)
Global dateOrder$=ReadPreferenceString("dateOrder","mdhi")
Global dateFileStamp$=ReadPreferenceString("dateFileStamp","%dd.%mm.%yyyy %hh:%ii:%ss")
Global dateScrStamp$=ReadPreferenceString("dateScrStamp","%dd.%mm.%yyyy %hh:%ii:%ss")
Global defaultDate$=ReadPreferenceString("defaultDate",FormatDate("%dd.%mm.%yyyy %hh:%ii:%ss",currentDate))
Global maxOutputSize=ReadPreferenceLong("maxOutputSize",10)
ClosePreferences()
;---------------------End Preference ----------------------------------

#blockSize=512
Enumeration 
  #inFile
  #outFile
  #window
  #FileGadget
  #OpenFileGadget
  #Text0Gadget
  #Text1Gadget
  #Text2Gadget
  #Text3Gadget
  #Text4Gadget
  #Text5Gadget
  #Text6Gadget
  #Text7Gadget
  #Text8Gadget
  #Text9Gadget
  #Text10Gadget
  #Text11Gadget
  #Text12Gadget
  #Text13Gadget
  #CurrentRecordGadget
  #SelectGadget
  #RecordSizeGadget
  #RecordsGadget
  #EditorGadget
  #OutFileGadget
  #WriteFileGadget
  #MarkerGadget
  #FileSizeGadget
  #TotalSizeGadget
  #dateOrderGadget
  #chanelsGadget
  #dateStampGadget
  #dateLengthGadget
  #defDateGadget
  #offsetGadget
  #LeftSelectGadget
  #RightSelectGadget
  #BlockGadget
EndEnumeration

#dXg=5: #dYg=5: #dsYg=20 
OpenWindow(#window,0,0,wWidth,wHeight,"SD-file Read",#PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
CreateGadgetList(WindowID(#window))

xG=#dXg: yG=#dYg: wXg=50
TextGadget(#Text0Gadget,xG,yG,wXg,#dsYg,"Input File:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=wWidth-wXg-#dXg-60
StringGadget(#FileGadget,xG,yG,wXg,#dsYg,fileName$)
xG=xG+wXg+#dXg: wXg=40 
ButtonGadget(#OpenFileGadget,xG,yG,wXg,#dsYg,"Open")

xG=#dXg+100: yG=yG+#dYg+#dsYg: wXg=60
TextGadget(#Text1Gadget,xG,yG,wXg,#dsYg,"Marker:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=100
StringGadget(#MarkerGadget,xG,yG,wXg,#dsYg,"",#PB_Text_Right)
xG=xG+#dXg+wXg+20: wXg=80
TextGadget(#Text2Gadget,xG,yG,wXg,#dsYg,"512-bytes Size:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=50
StringGadget(#FileSizeGadget,xG,yG,wXg,#dsYg,"",#PB_Text_Right)

xG=#dXg: yG=yG+#dYg+#dsYg: wXg=80
TextGadget(#Text3Gadget,xG,yG,wXg,#dsYg,"Current Record:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=40
StringGadget(#CurrentRecordGadget,xG,yG,wXg,#dsYg,"",#PB_String_Numeric | #PB_Text_Right)
xG=xG+wXg+#dXg: wXg=40 
ButtonGadget(#SelectGadget,xG,yG,wXg,#dsYg,"Select")
xG=xG+#dXg+wXg: wXg=25
TextGadget(#Text4Gadget,xG,yG,wXg,#dsYg,"Size:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=40
StringGadget(#RecordSizeGadget,xG,yG,wXg,#dsYg,"",#PB_Text_Right)
xG=xG+#dXg+wXg: wXg=60
TextGadget(#Text5Gadget,xG,yG,wXg,#dsYg,"All Records:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=40
StringGadget(#RecordsGadget,xG,yG,wXg,#dsYg,"",#PB_Text_Right)
xG=xG+#dXg+wXg: wXg=50
TextGadget(#Text6Gadget,xG,yG,wXg,#dsYg,"Total Size:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=40
StringGadget(#TotalSizeGadget,xG,yG,wXg,#dsYg,"",#PB_Text_Right)
xG=xG+#dXg+wXg: wXg=35
TextGadget(#Text12Gadget,xG,yG,wXg,#dsYg,"Offset:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=60
StringGadget(#OffsetGadget,xG,yG,wXg,#dsYg,"0",#PB_String_Numeric |#PB_Text_Right)

xG=#dXg+80: yG=yG+#dYg+#dsYg: wXg=20
ButtonGadget(#LeftSelectGadget,xG,yG,wXg,#dsYg,"<")
xG=xG+wXg+#dXg: wXg=20
ButtonGadget(#RightSelectGadget,xG,yG,wXg,#dsYg,">")
xG=xG+#dXg+wXg+15: wXg=35
TextGadget(#Text13Gadget,xG,yG,wXg,#dsYg,"Start:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=60
StringGadget(#BlockGadget,xG,yG,wXg,#dsYg,"",#PB_String_Numeric |#PB_Text_Right)

xG=#dXg: yG=yG+#dYg+#dsYg: wXg=40
TextGadget(#Text8Gadget,xG,yG,wXg,#dsYg,"Chanels:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=20
StringGadget(#chanelsGadget,xG,yG,wXg,#dsYg,"",#PB_String_Numeric | #PB_Text_Right)
SetGadgetText(#chanelsGadget,Str(numberChanels))
xG=xG+wXg+#dXg: wXg=60
TextGadget(#Text9Gadget,xG,yG,wXg,#dsYg,"Date bytes:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=20
StringGadget(#dateLengthGadget,xG,yG,wXg,#dsYg,"",#PB_String_Numeric | #PB_Text_Right)
SetGadgetText(#dateLengthGadget,Str(dateLength))
xG=xG+wXg+#dXg: wXg=120
TextGadget(#Text10Gadget,xG,yG,wXg,#dsYg,"Date order (y.m.d h:i:s):",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=60
StringGadget(#dateOrderGadget,xG,yG,wXg,#dsYg,"")
SetGadgetText(#dateOrderGadget,dateOrder$)
xG=xG+wXg+#dXg: wXg=80
TextGadget(#Text11Gadget,xG,yG,wXg,#dsYg,"Default Date:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=130
StringGadget(#defDateGadget,xG,yG,wXg,#dsYg,"", #PB_Text_Right)
SetGadgetText(#defDateGadget,defaultDate$)

xG=#dXg: yG=yG+#dYg+#dsYg: 
wXg=wWidth-2*#dXg: hYg=wHeight-yG-2*#dYg-#dsYg 
EditorGadget(#EditorGadget,xG,yG,wXg,hYg,#PB_Editor_ReadOnly)
LoadFont(0,"Courier",10)
SetGadgetFont(#EditorGadget,FontID(0))

xG=#dXg: yG=yG+#dYg+hYg: wXg=60
TextGadget(#Text7Gadget,xG,yG,wXg,#dsYg,"Output File:",#PB_Text_Right)
xG=xG+wXg+#dXg: wXg=wWidth-wXg-#dXg-60
StringGadget(#OutFileGadget,xG,yG,wXg,#dsYg,outFile$)
xG=xG+wXg+#dXg: wXg=40 
ButtonGadget(#WriteFileGadget,xG,yG,wXg,#dsYg,"Write")

Structure Date
  year.w: month.b: day.b: hour.b: minute.b: second.b
EndStructure
Global secDate.l
Global defDate.Date: curDate.Date

Declare DecodeDate()
Declare FillContent()
Declare ClearContent()
Declare ReadRecord(record)
Declare WriteToFile(record)
Declare ChangeOutFileName(rec)
Declare ReadContent()

Global *bufferID=AllocateMemory(#blockSize)
Global *memoryID=AllocateMemory(#blockSize)
Global FileSize=0
Global Dim RecordsStart.l($FFFF)
Global lastRecordM=$FFFF
Global lastRecord=0
Global totalSize=0
Global memoryOffset=0

FileOpen.b=#False

DecodeDate()
;Debug defDate\year
Global printPos=0
Global printStr$=""
; ---------- ------------- Main Loop ---------------------------   
Repeat
  Event=WaitWindowEvent()
  If Event=#PB_Event_Gadget
    Select EventGadget()
      ;---------------------------------------------------------
      Case #OpenFileGadget 
          If Not FileOpen  
            fileName$=GetGadgetText(#FileGadget)
            fileName$=OpenFileRequester("Set SD-file for Reading",fileName$,"Binary (*.bin)|*.bin; All (*.*)|*.*",0)
            SetGadgetText(#FileGadget,fileName$)   
            If OpenFile(#inFile,fileName$)=0 
              MessageRequester("Error",fileName$+" Open Error")
            Else 
              FileOpen=#True
              SetGadgetText(#OpenFileGadget, "Close") 
              FillContent()
              If lastRecord<>$FFFF 
                ;ReadRecord(lastRecord)
                ReadContent()
              EndIf 
              ChangeOutFileName(lastRecord)
            EndIf
          Else 
            CloseFile(#inFile)
            FileOpen=#False
            SetGadgetText(#OpenFileGadget, "Open")
            ClearContent()  
          EndIf             
      ;---------------------------------------------------------
      Case #SelectGadget
          If FileOpen And lastRecord<>$FFFF
            Record=Val(GetGadgetText(#CurrentRecordGadget))
            ReadRecord(Record)
            ChangeOutFileName(Record)
          Else
            MessageRequester("Error","No any records")
          EndIf
      ;---------------------------------------------------------
      Case #LeftSelectGadget
          Debug "Left"
          Record=Val(GetGadgetText(#CurrentRecordGadget))
          Record=Record-1: If Record<1: Record=1: EndIf
          SetGadgetText(#CurrentRecordGadget,Str(Record))
          SetGadgetText(#BlockGadget,Str(RecordsStart(Record)))     
      ;---------------------------------------------------------
      Case #RightSelectGadget
          Debug "Right" 
          Record=Val(GetGadgetText(#CurrentRecordGadget))
          Record=Record+1:If record>lastRecord: Record=lastRecord: EndIf 
          SetGadgetText(#CurrentRecordGadget,Str(Record)) 
          SetGadgetText(#BlockGadget,Str(RecordsStart(Record)))                             
      ;---------------------------------------------------------
      Case #WriteFileGadget
          outFile$=GetGadgetText(#OutFileGadget)
          outFile$=OpenFileRequester("Set output file for Writing",outFile$,"Log (*.Log)|*.Log; All (*.*)|*.*",0)
          SetGadgetText(#OutFileGadget,outFile$)  
          If FileSize(outFile$)>0
            s$="File: "+outFile$+" alredy exist!"+Chr(13)+Chr(10)+"Overwrite it?" 
            If MessageRequester("Attention",s$,#PB_MessageRequester_YesNo)=#PB_MessageRequester_No
              Goto Skip
            EndIf  
          EndIf
          If OpenFile(#outFile,outFile$)=0 
            MessageRequester("Error",fileName$+" Open Error")
            Goto Skip           
          EndIf
          If lastRecord<>$FFFF 
            Record=Val(GetGadgetText(#CurrentRecordGadget))
            WriteToFile(Record)
          Else
            MessageRequester("Error","No any records")
          EndIf  
          CloseFile(#outFile);
      ;---------------------------------------------------------
      Case #chanelsGadget
          If EventType()=#PB_EventType_Change          
            numberChanels=Val(GetGadgetText(#chanelsGadget))
            Debug numberChanels
          EndIf    
      ;---------------------------------------------------------
      Case #dateLengthGadget
          If EventType()=#PB_EventType_Change          
            dateLength=Val(GetGadgetText(#dateLengthGadget))
            Debug dateLength
          EndIf    
      ;---------------------------------------------------------
      Case #dateOrderGadget
          If EventType()=#PB_EventType_Change          
            dateOrder$=GetGadgetText(#dateOrderGadget)
            Debug dateOrder$
          EndIf    
      ;---------------------------------------------------------
      Case #defDateGadget
          If EventType()=#PB_EventType_Change          
            DecodeDate()
            Debug FormatDate("%yyyy.%mm.%dd %hh:%ii.%ss",secDate)
          EndIf    
      ;---------------------------------------------------------
      Case #offsetGadget
          If EventType()=#PB_EventType_Change          
            memoryOffset=Val(GetGadgetText(#offsetGadget))
            Debug memoryOffset
          EndIf    
       ;---------------------------------------------------------
    EndSelect 
  EndIf; Event
  
Skip: ;----------------------------------------------------Label
  
Until Event=#PB_Event_CloseWindow
; -----------------------  End Main Loop ----------------------

End

Procedure ChangeOutFileName(rec)
  recS$=Right(Str(rec),outFileRecLen)
  recS$=RSet(recS$,outFileRecLen,"_")
  outFile$=outFileName$+recS$+"."+outFileExt$
  SetGadgetText(#OutFileGadget,outFile$)
EndProcedure

Procedure FillContent()
  ; Read Marker Block
  ReadData(#inFile,*bufferID,#blockSize)
  Marker$=PeekS(*bufferID,16,#PB_Ascii)
  SetGadgetText(#MarkerGadget,Marker$)
  FileSize=PeekL(*bufferID+16)
  SetGadgetText(#FileSizeGadget,Str(FileSize))
  
  *memoryID=ReAllocateMemory(*memoryID,#blockSize*FileSize)
  If *memoryID=#NUL
    MessageRequester("Error","No such Memory")
  EndIf 
     
  ; Read Data Blocks
  lastRecordM=$FFFF
  lastRecord=0
  recordSize=0 
  For b=1 To FileSize
    ReadData(#inFile,*bufferID,#blockSize)
    RecordM=PeekW(*bufferID) & $FFFF
    ;Debug Hex(RecordM)
    If RecordM=$FFFF 
      Break
    Else
      ;Debug Hex(RecordM)
      If RecordM<>lastRecordM
       lastRecord=lastRecord+1     
       RecordsStart(lastRecord)=b-1; without marker block  
        lastRecordM=RecordM
        recordSize=1 
        SetGadgetText(#CurrentRecordGadget,Str(lastRecord)) 
        SetGadgetText(#BlockGadget,Str(RecordsStart(lastRecord)))
      Else
        recordSize=recordSize+1          
      EndIf
      CopyMemory(*bufferID,*memoryID+#blockSize*(b-1),#blockSize)
    EndIf 
   Next b
  If lastRecordM=$FFFF
    SetGadgetText(#RecordsGadget,"0")
    TotalSize=0
  Else
    SetGadgetText(#RecordsGadget,Str(lastRecord))
    TotalSize=b-1
    RecordsStart(lastRecord+1)=TotalSize; begin of empty space
  EndIf

  SetGadgetText(#RecordSizeGadget,Str(recordSize))   
  SetGadgetText(#TotalSizeGadget,Str(TotalSize))
EndProcedure

Declare clearPrint()

Procedure ClearContent()
  SetGadgetText(#RecordsGadget,"")
  SetGadgetText(#RecordSizeGadget,"")
  SetGadgetText(#CurrentRecordGadget,"")
  SetGadgetText(#RecordSizeGadget,"")   
  SetGadgetText(#TotalSizeGadget,"")
  SetGadgetText(#MarkerGadget,"")
  SetGadgetText(#FileSizeGadget,"")
  SetGadgetText(#BlockGadget,"")
  ClearPrint()
EndProcedure

Procedure addToPrint(v.w)
  printStr$=printStr$+RSet(Str(v),4," ")+";"
  printPos=printPos+1
  If printPos>=sLength
    printPos=0
    printStr$=printStr$+Chr(13)
  EndIf
  SetGadgetText(#EditorGadget,printStr$)  
EndProcedure

Procedure addWordToPrint(v.l,Len)
  printStr$=printStr$+RSet(StrU(v,#Word),Len," ")+";"
  printPos=printPos+1
  If printPos>=sLength
    printPos=0
    printStr$=printStr$+Chr(13)
  EndIf
  SetGadgetText(#EditorGadget,printStr$)  
EndProcedure

Procedure addStrToPrint(str.s)
  printStr$=printStr$+str
  printPos=printPos+1
  If printPos>=sLength
    printPos=0
    printStr$=printStr$+Chr(13)
  EndIf
  SetGadgetText(#EditorGadget,printStr$)  
EndProcedure

Procedure addDateToPrint(date)
  printStr$=printStr$+FormatDate(dateScrStamp$,date)+";"
  printPos=printPos+1
  If printPos>=sLength
    printPos=0
    printStr$=printStr$+Chr(13)
  EndIf
  
  SetGadgetText(#EditorGadget,printStr$)  
EndProcedure

Procedure addSkipToPrint()
  printStr$=printStr$+Chr(13)+"..."+Chr(13)
  printPos=0
  SetGadgetText(#EditorGadget,printStr$)  
EndProcedure

Procedure addNLtoPrint()
  printStr$=printStr$+Chr(13)
  printPos=0
  SetGadgetText(#EditorGadget,printStr$)  
EndProcedure

Procedure clearPrint()
  printPos=0
  printStr$=""
  SetGadgetText(#EditorGadget,"")
EndProcedure

Procedure DecodeDate()
  sDate$=GetGadgetText(#defDateGadget)
  secDate=ParseDate("%dd.%mm.%yyyy %hh:%ii.%ss",sDate$)
  defDate\year=Year(secDate): defDate\month=Month(secDate): defDate\day=Day(secDate):
  defDate\hour=Hour(secDate): defDate\minute=Minute(secDate): defDate\second=Second(secDate)
EndProcedure

Procedure.l ReadDate(*inBuffer)
  Date.Date
  dateSec.l
  Date\year=defDate\year: Date\month=defDate\month: Date\day=defDate\day
  Date\hour=defDate\hour: Date\minute=defDate\minute: Date\second=defDate\second
  For i=1 To dateLength
    v=PeekB(*inBuffer+i-1)
    Select Asc(Mid(dateOrder$,i,1))
      Case 'y': Date\year=v
      Case 'm': Date\month=v
      Case 'd': Date\day=v
      Case 'h': Date\hour=v
      Case 'i': Date\minute=v
      Case 's': Date\second=v     
    EndSelect    
  Next i
  dateSec=Date(Date\year,Date\month,Date\day,Date\hour,Date\minute,Date\second) 
  ProcedureReturn dateSec
EndProcedure


Procedure ReadRecord(record)
  If record>lastRecord
    MessageRequester("Error","No such Record") 
    ProcedureReturn
  EndIf 
  CurrentSize=RecordsStart(record+1)-RecordsStart(record)
  SetGadgetText(#RecordSizeGadget,Str(CurrentSize)) 
  clearPrint()
  bytePos=RecordsStart(record)*#blockSize+memoryOffset
  stopByte=RecordsStart(record+1)*#blockSize
  Debug bytePos
  Debug stopByte
  If CurrentSize>maxOutputSize
    startSkip=bytePos+maxOutputSize*#blockSize/2+2
    stopSkip=stopByte-maxOutputSize*#blockSize/2
  Else 
    startSkip=stopByte+1
    stopSkip=startSkip
  EndIf
  Debug startSkip
  Debug stopSkip
  fierstSkip.b=#True
  
  While bytePos<stopByte
    If bytePos%#blockSize=0: bytePos=bytePos+2: EndIf ; skip record#
    cDate=ReadDate(*memoryID+bytePos): bytePos=bytePos+dateLength
    If (bytePos<startSkip) Or (bytePos>stopSkip)  
      addDateToPrint(cDate)
    Else 
      If fierstSkip=#True: fierstSkip=#False
        addSkipToPrint()
      EndIf  
    EndIf
    For i=0 To numberChanels-1 
      v=PeekW(*memoryID+bytePos) & $FFFF: bytePos =bytePos+2
      If (bytePos<startSkip) Or (bytePos>stopSkip)  
        addToPrint(v)
      EndIf
    Next i   
  Wend   
EndProcedure

Procedure WriteToFile(record)
  
  If record>lastRecord
    MessageRequester("Error","No such Record") 
    ProcedureReturn
  EndIf
  CurrentSize=RecordsStart(record+1)-RecordsStart(record)
  SetGadgetText(#RecordSizeGadget,Str(CurrentSize)) 
  bytePos=RecordsStart(record)*#blockSize+memoryOffset
  stopByte=RecordsStart(record+1)*#blockSize
  While bytePos<stopByte
    If bytePos%#blockSize=0: bytePos=bytePos+2: EndIf ; skip record#
    cDate=ReadDate(*memoryID+bytePos): bytePos=bytePos+dateLength
    str$=FormatDate(dateFileStamp$,cDate)
    For i=0 To numberChanels-1 
      v.w=PeekW(*memoryID+bytePos) & $FFFF: bytePos=bytePos+2
      str$=str$+RSet(Str(v),5," ")+";"
    Next i
    WriteStringN(#outFile,str$,#PB_Ascii)   
  Wend
EndProcedure

Procedure ReadContent()
  clearPrint()
  If lastRecordM=$FFFF
    ProcedureReturn
  EndIf 
  addStrToPrint("Rec_#; Mark; Rec_Start; ___Date__ ;")
  addNLtoPrint()
  For record=1 To lastRecord
    addWordToPrint(record,5)
    bytePos=RecordsStart(record)*#blockSize+memoryOffset
    v=PeekW(*memoryID+bytePos) & $FFFF: bytePos =bytePos+2
    addWordToPrint(v,5)
    addWordToPrint(RecordsStart(record),10)
    cDate=ReadDate(*memoryID+bytePos): bytePos=bytePos+dateLength
    addDateToPrint(cDate)
    addNLtoPrint()
  Next record
EndProcedure

; IDE Options = PureBasic 4.10 (Windows - x86)
; CursorPosition = 528
; FirstLine = 499
; Folding = ---
; EnableXP
; Executable = RegReadSDdir.exe