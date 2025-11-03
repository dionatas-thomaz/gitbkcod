
********************************************
Function ValCodSev(vCodSev_)
Local lValCod:=.T.
If !lValCod:=(Len(AllTrim(vCodSev_))>4
   MGT(Len(AllTrim(vCodSev_)))
   MsgStop("Esse Codigo de serviço:" +vCodSev_+"Existe apenas para ser consultado."+chr(13)+,;
            "Por facor Selecione um codigo de serviço valido, que tenha no minimo os 6 digitos necessarios."+chr(13)+,;
            " Exemplo de formatação valida:(00.00.00)","Tipo do Serviço"))
EndIf
Retur lValCod