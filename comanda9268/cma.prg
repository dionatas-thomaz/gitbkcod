Procedure CarTelGbs(vCmGrSt_,oFldIte_,oBtnCod_,oBtnImg_,nPagAtu_,nMaxBtn_,oBtnFpi_,vImgGru_)
If !Empty(vCmGrSt_).And.vCmGrSt_!="N"
   CriPosBtn(oBtnCod_,oBtnImg_,oFldIte_,vCmGrSt_,oBtnFpi_,vImgGru_)
   RefResHitEms(oBtnCod_,oBtnImg_,nPagAtu_,nMaxBtn_,vCmGrSt_)
   ChgeFld(oFldIte_,2,1)
Else
   oFldIte_:SetPrompts({"Pesquisa Itens"})
EndIf 
Return
*****************************
Function CriPosBtn(oBtnCod_,oBtnImg_,oFldIte_,vCmGrSt_,oBtnFpi_,vImgGru_)
Local nTolCol:=5,nConBtn:=0,nColIde:=0,nRowIde:=0,nRowImg:=0,nColImg:=0,nRowBtn:=0,nColBtn:=0
For nConBtn := 1 To 20
   nRowIde := Int((nConBtn - 1) / nTolCol) + 1  
   nColIde := (nConBtn - 1) % nTolCol + 1       
   nRowImg := 1.8  + (nRowIde - 1) * 9.5
   nColImg := 6.12 + (nColIde - 1) * 24
   nRowBtn := 7.7  + (nRowIde - 1) * 8.9
   nColBtn := 8.12 + (nColIde - 1) * 32  
   CriBtn(oBtnCod_,oBtnImg_,oFldIte_,vCmGrSt_,oBtnFpi_,;
          vImgGru_,nConBtn,nRowImg,nColImg,nRowBtn,nColBtn)
Next
Return
*****************************
Function CriBtn(oBtnCod_,oBtnImg_,oFldIte_,vCmGrSt_,oBtnFpi_,vImgGru_,nConBtn_,nRowImg_,nColImg_,nRowBtn_,;
               nColBtn_)
@ nRowBtn_,nColBtn_   Say     oBtnCod_[01,nConBtn_]  PROMPT ""     Size 150,18  OF oFldIte_:aDialogs[02] CENTER
@ nRowImg_,nColImg_  image    oBtnImg_[nConBtn_]                   Size 150,90  OF oFldIte_:aDialogs[02] FILE (vImgGru_) Adjust  when!Empty(oBtnCod_[01,nConBtn_]:GetText());
On Left Click (FilKeyGruSet(oBtnCod_[01,nConBtn_]:GetText(),oBtnCod_[02,nConBtn_],vCmGrSt_,oFldIte_,oBtnFpi_))            
Return
****************************
Procedure FilKeyGruSet(oBtnNom_,oBtnCod_,vCmGrSt_,oFldIte_,oBtnFpi_)
Local vNomEgs:="",nCodEgs:=0
vNomEgs:=oBtnNom_
nCodEgs:=oBtnCod_
If(vCmGrSt_="G".Or.vCmGrSt_="B",(vNptGru:=vNomEgs,vCptGru:=nCodEgs),(vNptSet:=vNomEgs,vCptSet:=nCodEgs))
ChgeFld(oFldIte_,1,2)
(oBtnFpi_:KeyDown(VK_RETURN),Nil)
Return
*****************************
Procedure GetTotAliTem(vCmGrSt_)
Local ntolIte:=0
If (vCmGrSt_ = "G")
   TabGru->(DbGoTop())
   TabGru->(DbEval({||If(TabGru->status4=="D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==2,ntolIte++,Nil)}))
ElseIf(vCmGrSt_ = "B")
   TabGru->(DbGoTop())
   TabGru->(DbEval({||If(TabGru->status4=="D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==4,ntolIte++,Nil)}))
Else
   TabSet->(DbGoTop())
   TabSet->(DbEval({||If(TabSet->Descric20=="D",ntolIte++,Nil)}))
EndIf
Return ntolIte
*****************************
Procedure PagEchAng(nDirEsq_,nPagAtu_,nMaxPag_)
nPagAtu_ := nPagAtu_ + nDirEsq_ // Atualiza a página atual com base na direção (anterior ou próxima)
Return Nil
*****************************
Procedure RefResHitEms(oBtnCod_,oBtnImg_,nNumPag_,nMaxBtn_,vCmGrSt_)
Private nStaIte:=nNumPag_*nMaxBtn_,nConTai:=1,nConTaJ:=1,nPosAbs:=0
If (vCmGrSt_ == "G") 
   TabGru->(DbGoTop())  
   While nPosAbs < nStaIte .And. !TabGru->(Eof())
      If (TabGru->status4 == "D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==2)
         nPosAbs++
      EndIf
      TabGru->(DbSkip())
   End
   While !TabGru->(Eof()) .And. nConTai <= nMaxBtn_
      If (TabGru->status4 == "D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==2)
         oBtnCod_[01,nConTai]:SetText(Alltrim(TabGru->Grupo4)) 
         oBtnCod_[02,nConTai]:=TabGru->Codigo4
         CarImg(.T.,@oBtnImg_[nConTai],+"I"+TabGru->Codigo4+If(TabGru->TipImg4="B",".bmp",".jpg"),@vImgGru)
         nConTai++  
      EndIf
      TabGru->(DbSkip())
   End
ElseIf(vCmGrSt_ == "S")
   TabSet->(DbGoTop())  
   While nPosAbs < nStaIte.And.!TabSet->(Eof())
      If (TabSet->status20 == "D")
         nPosAbs++
      EndIf
      TabSet->(DbSkip())
   End
   While !TabSet->(Eof()).And.nConTai <= nMaxBtn_
      If (TabSet->status20 == "D")
          oBtnCod_[01, nConTai]:SetText(Alltrim(TabGru->Grupo4))
         oBtnCod_[01,nConTai]:SetText(Alltrim(TabSet->Descric20))
         oBtnCod_[02,nConTai]:=TabSet->Codigo20
         CarImg(.T.,@oBtnImg_[nConTai],+"I"+TabSet->Codigo20+If(TabSet->TipImg4="B",".bmp",".jpg"),@vImgGru)
         nConTai++
      EndIf
      TabSet->(DbSkip())
   End
Else
   TabGru->(DbGoTop())  
   While nPosAbs < nStaIte.And.!TabGru->(Eof())
      If (TabGru->status4 == "D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==4)
         nPosAbs++
      EndIf
      TabGru->(DbSkip())
   End
   While !TabGru->(Eof()).And.nConTai <= nMaxBtn_
      If (TabGru->status4 == "D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==4)
         oBtnCod_[01,nConTai]:SetText(Alltrim(TabGru->Grupo4))
         oBtnCod_[02,nConTai]:=TabGru->Codigo4
         CarImg(.T.,@oBtnImg_[nConTai],+"I"+TabGru->Codigo4+If(TabGru->TipImg4="B",".bmp",".jpg"),@vImgGru)
         nConTai++  
      EndIf
      TabGru->(DbSkip())
   End
EndIf
For nConTaJ := nConTai TO nMaxBtn_
    oBtnCod_[01,nConTaJ]:SetText("") // Limpa os botões restantes
Next
Return Nil