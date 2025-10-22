Function Qrencode(vTexto)
Local cQrencode, vComand,oDlg, oImg
vTexto := AllTrim(vTexto)
vTexto := StrTran(vTexto, "{", "")
vTexto := StrTran(vTexto, "}", "")
vComando := '"' + "C:\qrencode\qrencode.exe" + '"'
vComando += ' -o "' + cCamPro_+"aqrs\QRCode.png" + '"'
vComando += ' -t PNG'
vComando += ' "' + vTexto + '"'
//MemoWrit(cCamPro_+"\Log\QRCode_Log.txt", vComando + CRLF + "TEXTO: " + vTexto)
WinExec(vComando,0)
Inkey(1)// Espera um pouco para garantir criação do arquivo
If File(cCamPro_+"aqrs\QRCode.png")
   MsgInfo("QR Code gerado em: " + cCamPro_+"aqrs\QRCode.png","sucesso")
   //WinExec('cmd /c start "" "' + cCamPro_ + "aqrs\QRCode.png" + '"', 0)
   DEFINE WINDOW oDlg TITLE "QR Code Gerado" FROM 20,20 TO 40,60
   @ 0,40 ACTIVEX oImg PROGID "Shell.Explorer.2" OF oDlg
   oImg:Do("Navigate2", cCamPro_+"aqrs\QRCode.png")
   ACTIVATE WINDOW oDlg
Else
   MsgStop("Falha ao gerar o QR Code! Veja o log: ","Falha QR Code")
EndIf
Return Nil