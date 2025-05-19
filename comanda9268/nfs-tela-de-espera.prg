Function TmpEnvNfs(oDlg_,vChaNfs_)
Private oDlgTmp,oMsgTmp,oText,oTimer,oFont,;
        nTmpSeg := 1,;
        lMsgAler:=.F.,;
        cMsgTmp :="Verifique sua conexão com a internet ou disponibilidade" + Chr(13) + Chr(10) + ;
                  "do servidor devido à demora na consulta da NFSe.",cTxtLbl :="Consultando NFSe...",;
        bErrTmp
Define Font oFontSay Name "Arial" Size 0,-15
Begin Sequence
   Define Dialog oDlgTmp Resource "DlgTmp" OF If(Empty(oDlg_), oVentPrinc, oDlg_)
   Redefine SAY oMsgTmp Prompt cMsgTmp ID 104 OF oDlgTmp Update
   Redefine SAY oText   Prompt cTxtLbl ID 105 OF oDlgTmp Font oFontSay Update
   Set Font of oDlgTmp TO oFontSay
   Activate Dialog oDlgTmp Centered on Init( IniciaTimerNfs(oDlgTmp, vChaNfs_))
End Sequence
ErrorBlock(bErrTmp)
Return
*****************************
Function IniciaTimerNfs(oDlgTmp_, vChaNfs_)
Local oTimer,oFont,;
      nTmpSeg:=1,;
      vMsgApi:="",;
      aJsoRsp,;
      lExeCon:=.T.
Define Font oFont Name "Arial" Size 0,-26
Define Timer oTimer Interval 1000 OF oDlgTmp_ Action(oDlgTmp_:Say(3, 25,nTmpSeg++,AZULSUC,,oFont,.F.),;
                                                      If(lExeCon.Or.Mod(nTmpSeg,15)=0,(lExeCon:=.F.,aJsoRsp:=ConsultarNfs(vChaNfs_,@vMsgApi),;
                                                         If(aJsoRsp["codigo"]=101,;
                                                            (oDlgTmp_:End(),;
                                                            MsgInfo(AjuMsgApi(aJsoRsp["mensagem"]),aJsoRsp["codigo"]),;
                                                            SalvarPdfDecodificado(aJsoRsp["pdf"])),;
                                                            Nil)),;
                                                         Nil))
Activate Timer oTimer
Set Font Of oDlgTmp_ TO oFont
oFont:End()
Return
*****************************
Function ConsultarNfs(vChaNfs_, vMsgRet_)
Local nRetApi,;
      vMsgApi,;
      aJsoRsp
cTokGlo := "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbXAiOjI1NjYsInVzciI6NTg4LCJ0cCI6MiwiaWF0IjoxNzQ3MzE3NzExfQ.p5C4qPA-mGb2mEfx7ip-Ibnrwyihei70oibaLAZTmis"
cUrlApi := "https://hom-api.integranotas.com.br"
nRetApi := EnviaReqApi("S","/v1/nfse/"+vChaNfs_,"","GET",.T.,@vMsgApi)
vMsgRet_:= vMsgApi
aJsoRsp := ApiJsonDecode(vMsgApi)
?vMsgApi
Return aJsoRsp
*****************************
Function SalvarPdfDecodificado(cPdfBase64)
Local vXmlDec
vXmlDec := HB_Base64Decode(cPdfBase64)
MemoWrit(cCamPro_ + "\Log\axml.pdf", vXmlDec)
PreView(cCamPro_ + "Log\axml.pdf")
Return
*****************************