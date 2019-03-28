; SD-card marking
; Kubov V.V. 2014
;-------------- Read Preference from *.ini ----------------------------
#iniName$="SDmarking.ini"
If OpenPreferences(#iniName$)
  Else: MessageRequester("Error",#iniName$+" not Found")
EndIf
marker$=ReadPreferenceString("marker","Kubov V.I.")
fileName$=ReadPreferenceString("fileName","Logger.bin")
blocks.l=ReadPreferenceLong("blocks",2000)
ClosePreferences()
;---------------------End Preference ----------------------------------

#blockSize=512

marker$=LSet(marker$,16) ; expande or truncate to 16 chars

Enumeration 
  #File
  #Directory
  #window
  #barGadget
EndEnumeration


fileName$ = OpenFileRequester("Set SD-file for Marking",fileName$,"Binary (*.bin)|*.bin; All (*.*)|*.*",0)
;MessageRequester("File",fileName$)
If FileSize(fileName$)>0
  s$="File: "+fileName$+" alredy exist!"+Chr(13)+Chr(10)+"Overwrite it?" 
  If MessageRequester("Attention",s$,#PB_MessageRequester_YesNo)=#PB_MessageRequester_No
     End 
  EndIf  
EndIf
If OpenFile(#File,fileName$)=0 
  MessageRequester("Error",fileName$+" Open Error")
  End
EndIf 

OpenWindow(#window,0,0,300,40,"SD-file Formatting Progress",#PB_Window_ScreenCentered)
CreateGadgetList(WindowID(#window))
ProgressBarGadget(#barGadget,10,10,280,20,0,blocks)
SetGadgetState(#barGadget,0) 

*bufferID=AllocateMemory(#blockSize)
; first block with marker
offset=0
PokeS(*bufferID,marker$) ; marker
offset=offset+16 
PokeL(*bufferID+offset,blocks) ; file size in blocks 
offset=offset+4 
For i=offset To #blockSize-1
  PokeB(*bufferID+i,$ff) 
Next i 
WriteData(#File,*bufferID,#blockSize)

; fill empty file
For i=0 To #blockSize-1
  PokeB(*bufferID+i,$ff) 
Next i 
For b=1 To blocks
  WriteData(#File,*bufferID,#blockSize)
  SetGadgetState(#barGadget,b) 
Next b

CloseFile(#File)

s$="File: "+fileName$+ " created."+Chr(13)+Chr(10)
s$=s$+"Marker='"+marker$+"'"+Chr(13)+Chr(10)
s$=s$+"512-byte blocks file size is "+StrD(blocks,0) 
MessageRequester("Done",s$,#PB_MessageRequester_Ok)


End

; IDE Options = PureBasic 4.10 (Windows - x86)
; CursorPosition = 38
; FirstLine = 33
; Folding = -
; EnableXP
; Executable = SDmarking.exe