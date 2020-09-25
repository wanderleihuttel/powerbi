let func = 
    (
        codigoempresa as any,
        senha as any,
        codigoservico as any, 
        datapostagem as any, 
        ceporigem as any, 
        cepdestino as any, 
        peso as any, 
        comprimento as any,
        largura as any,
        altura as any
    ) => 
    let
        vURL = "http://ws.correios.com.br",
        Sedex = Web.Contents(
            vURL, 
            [
                RelativePath="calculador/CalcPrecoPrazo.aspx?", 
                Query=
                [
                    nCdEmpresa = codigoempresa,
                    sDsSenha = senha,
                    nCdServico = Text.From(codigoservico),
                    dataPostagem = Text.From(datapostagem),
                    sCepOrigem = Text.From(ceporigem),
                    sCepDestino = Text.From(cepdestino),
                    nVlPeso = Text.From(peso),
                    nVlComprimento = Text.From(comprimento),
                    nVlLargura = Text.From(largura),
                    nVlAltura = Text.From(altura),
                    nCdFormato = "1",
                    nVlDiametro = "0",
                    sCdMaoPropria = "N",
                    nVlValorDeclarado = "0",
                    sCdAvisoRecebimento = "N",
                    StrRetorno = "xml"
                ]
            ]
        ),
        vOutput = Xml.Tables(Sedex){0}[Table]
    in
        vOutput
        ,documentation = [	
        Documentation.Name =  "Consulta Sedex", 
        Documentation.Description = "Consulta valores de Sedex",
        Documentation.LongDescription = "Retorna uma tabela com os dados da consulta de Sedex vindos do site dos Correios", 
        Documentation.Category = "API Correios", 
        Documentation.Source = "local", 
        Documentation.Author = "Wanderlei Hüttel: https://www.linkedin.com/in/wanderleihuttel/"]
	
 in	
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
