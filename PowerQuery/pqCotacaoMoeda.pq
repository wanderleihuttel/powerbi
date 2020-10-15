/*
    Função p/ Buscar Cotação de Moedas Banco Central (USD, EUR, GBP)
    Autor:    Wanderlei Hüttel
    Email:    wanderlei.huttel (at) gmail (dot) com
    Linkedin: https://www.linkedin.com/in/wanderleihuttel/

*/

(moeda as text) =>
let
    vUrl = "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1",
    vMoeda = moeda, //USD, EUR, GBP
    vDataInicial = "01-01-2018",
    vDataFinal = Date.ToText( Date.From(DateTimeZone.SwitchZone(DateTimeZone.UtcNow(),-3)), "MM-dd-yyyy"),
    vRelativePath = "/odata/CotacaoMoedaPeriodo(moeda=@moeda,dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)?@moeda='" & vMoeda & "'&@dataInicial='" & vDataInicial & "'&@dataFinalCotacao='" & vDataFinal & "'&$top=10000&$filter=tipoBoletim%20eq%20'Fechamento'&$format=json&$select=paridadeCompra,paridadeVenda,cotacaoCompra,cotacaoVenda,dataHoraCotacao,tipoBoletim",
    Retorno = Json.Document(Web.Contents(vUrl, [RelativePath=vRelativePath]))[value],
    ConverterParaTabela = Table.FromList(Retorno, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    TabelaExpandida = Table.ExpandRecordColumn(ConverterParaTabela, "Column1", {"paridadeCompra", "paridadeVenda", "cotacaoCompra", "cotacaoVenda", "dataHoraCotacao", "tipoBoletim"}, {"paridadeCompra", "paridadeVenda", "cotacaoCompra", "cotacaoVenda", "dataHoraCotacao", "tipoBoletim"}),
    ColunaMoeda = Table.AddColumn(TabelaExpandida, "Moeda", each vMoeda, type text),
    TipoAlterado = Table.TransformColumnTypes(ColunaMoeda,{{"paridadeCompra", Int64.Type}, {"paridadeVenda", Int64.Type}, {"cotacaoCompra", type number}, {"cotacaoVenda", type number}, {"dataHoraCotacao", type datetime}, {"tipoBoletim", type text}})
in
    TipoAlterado
