Procedure CarTelGbs(vCmGrSt_,oFldIte_,oBtnCod_,oBtnImg_,nPagAtu_,nMaxBtn_,oBtnFpi_,vImgGru_) //funcao para chamar a tela com as imagens de grupos e setores
   If !vCmGrSt_$"N "
      CriPosBtn(oBtnCod_,oBtnImg_,oFldIte_,vCmGrSt_,oBtnFpi_,vImgGru_)
      CarGruSet(oBtnCod_,oBtnImg_,nPagAtu_,nMaxBtn_,vCmGrSt_)
      ChgeFld(oFldIte_,2,1)
   Else
      oFldIte_:SetPrompts({"Pesquisa Itens"})
   EndIf
   Return
   *****************************
   Function CriPosBtn(oBtnCod_,oBtnImg_,oFldIte_,vCmGrSt_,oBtnFpi_,vImgGru_) //faz o calculo da posicao onde o botao deve ser criado
   Local nTolCol:=5,nConBtn:=0,nColIde:=0,nRowIde:=0,nRowImg:=0,nColImg:=0,nRowBtn:=0,nColBtn:=0
   For nConBtn := 1 To 20
       nRowIde := Int((nConBtn - 1) / nTolCol) + 1
       nColIde := (nConBtn - 1) % nTolCol + 1
       nRowImg := 0.8  + (nRowIde - 1) * 8.8  
       nColImg := 6.12 + (nColIde - 1) * 24
       nRowBtn := 6.9  + (nRowIde - 1) * 8.2  
       nColBtn := 8.12 + (nColIde - 1) * 32
      CriBtn(oBtnCod_,oBtnImg_,oFldIte_,vCmGrSt_,oBtnFpi_,vImgGru_,nConBtn,nRowImg,nColImg,nRowBtn,;
             nColBtn)
   Next
   Return
   *****************************
   Function CriBtn(oBtnCod_,oBtnImg_,oFldIte_,vCmGrSt_,oBtnFpi_,vImgGru_,nConBtn_,nRowImg_,nColImg_,nRowBtn_,; //cria os botoes de acordo com as posições passadas por CriPosBtn
                   nColBtn_)
   @ nRowBtn_,nColBtn_   Say     oBtnCod_[01,nConBtn_]  PROMPT ""     Size 150,18  OF oFldIte_:aDialogs[02] CENTER
   @ nRowImg_,nColImg_  image    oBtnImg_[nConBtn_]                   Size 150,90  OF oFldIte_:aDialogs[02] FILE (vImgGru_) Adjust  when!Empty(oBtnCod_[01,nConBtn_]:GetText());
   On Left Click (FilGruSet(oBtnCod_[01,nConBtn_]:GetText(),oBtnCod_[02,nConBtn_],vCmGrSt_,oFldIte_,oBtnFpi_))
   oBtnCod_[01,01]:SetFocus()
   Return
   *****************************
   Procedure FilGruSet(oBtnNom_,oBtnCod_,vCmGrSt_,oFldIte_,oBtnFpi_) //faz o filtro  de acordo com o grupo ou setor selecionado 
   Local vNomEgs:="",;
         nCodEgs:=0
   vNomEgs:=oBtnNom_
   nCodEgs:=oBtnCod_
   If(vCmGrSt_="G".Or.vCmGrSt_="B",(vNptGru:=vNomEgs,vCptGru:=nCodEgs),(vNptSet:=vNomEgs,vCptSet:=nCodEgs))
   ChgeFld(oFldIte_,1,2)
   oBtnFpi_:KeyDown(VK_RETURN)
   Return
   *****************************
   Procedure GetTotalItem(vCmGrSt_) // contabiliza a quantidade de registros na tabela selecionada, para determinar a  quantidade de "paginas"
   Local nTolIte:=0
   If (vCmGrSt_="G")
      TabGru->(DbGoTop())
      TabGru->(DbEval({||If(TabGru->Status4=="D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==2,nTolIte++,Nil)}))
   ElseIf(vCmGrSt_="B")
      TabGru->(DbGoTop())
      TabGru->(DbEval({||If(TabGru->Status4=="D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==4,nTolIte++,Nil)}))
   Else
      TabSet->(DbGoTop())
      TabSet->(DbEval({||If(TabSet->Status20=="D",nTolIte++,Nil)}))
   EndIf
   Return nTolIte
   *****************************
   Procedure PagDirEsq(nDirEsq_,nPagAtu_)
   nPagAtu_ := nPagAtu_ + nDirEsq_ // Atualiza a página atual com base na direção (anterior ou próxima)
   Return Nil
   *****************************
   Procedure CarGruSet(oBtnCod_,oBtnImg_,nNumPag_,nMaxBtn_,vCmGrSt_)
   Private nStaIte:=nNumPag_*nMaxBtn_,nConTai:=1,nConTaJ:=1,nPosAbs:=0
   If (vCmGrSt_=="G") 
      TabGru->(DbGoTop())  
      While nPosAbs < nStaIte.And.!TabGru->(Eof()) //posicionamento o ponteiro no ultimo registro de acordo com a ultima pagina
         If (TabGru->Status4=="D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==2)
            nPosAbs++
         EndIf
         TabGru->(DbSkip())
      End
      While !TabGru->(Eof()).And.nConTai <= nMaxBtn_
         If (TabGru->Status4=="D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==2)  // pega apenas grupos desbloqueados
            oBtnCod_[01,nConTai]:SetText(Alltrim(TabGru->Grupo4)) //capturando o nome do grupo no vetor
            oBtnCod_[02,nConTai]:=TabGru->Codigo4 //pega o codigo do grupo
            CarImg(.T.,@oBtnImg_[nConTai],+"I"+TabGru->Codigo4+If(TabGru->TipImg4="B",".bmp",".jpg"),@vImgGru) //carrega a imagem do campo
            oBtnImg_[nConTai]:show() // como estou usando o hider para "limpar" os botoes que estao vazios, caso eu volte para a pagina anterios,eles ficariam ocultos, ai uso o show para que isso apenas  exibir novamente os campos que seram usados
            nConTai++  
         EndIf
         TabGru->(DbSkip())
      End
   ElseIf(vCmGrSt_=="S")
      TabSet->(DbGoTop())  
      While nPosAbs < nStaIte.And.!TabSet->(Eof()) //posicionamento o ponteiro no ultimo registro de acordo com a ultima pagina
         If (TabSet->Status20=="D")
            nPosAbs++
         EndIf
         TabSet->(DbSkip())
      End
      While !TabSet->(Eof()).And.nConTai <= nMaxBtn_
         If (TabSet->Status20=="D") //pegando apenas setores com o status desbloqueado
            oBtnCod_[01,nConTai]:SetText(Alltrim(TabSet->Descric20))
            oBtnCod_[02,nConTai]:=TabSet->Codigo20
            CarImg(.T.,@oBtnImg_[nConTai],+"I"+TabSet->Codigo20+If(TabSet->TipImg4="B",".bmp",".jpg"),@vImgGru)
            oBtnImg_[nConTai]:show()
            nConTai++
         EndIf
         TabSet->(DbSkip())
      End
   Else
      TabGru->(DbGoTop())  
      While nPosAbs < nStaIte.And.!TabGru->(Eof())//posicionamento o ponteiro no ultimo registro de acordo com a ultima pagina
         If (TabGru->Status4=="D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==4)
            nPosAbs++
         EndIf
         TabGru->(DbSkip())
      End
      While !TabGru->(Eof()).And.nConTai <= nMaxBtn_ 
         If (TabGru->Status4=="D".And.Len(rTrim(StrTran(TabGru->Codigo4,Space(1),"")))==4) //pegando apenas subgrupos com o status desbloqueado
            oBtnCod_[01,nConTai]:SetText(Alltrim(TabGru->Grupo4))
            oBtnCod_[02,nConTai]:=TabGru->Codigo4
            CarImg(.T.,@oBtnImg_[nConTai],+"I"+TabGru->Codigo4+If(TabGru->TipImg4="B",".bmp",".jpg"),@vImgGru)
            oBtnImg_[nConTai]:show()
            nConTai++  
         EndIf
         TabGru->(DbSkip())
      End
   EndIf
   For nConTaJ := nConTai TO nMaxBtn_
       oBtnCod_[01,nConTaJ]:SetText("") // Limpa os botões restantes
       oBtnImg_[nConTaJ]:hide()
   Next
   Return Nil