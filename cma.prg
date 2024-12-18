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