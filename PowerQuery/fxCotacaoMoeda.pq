/*
    Função p/ Buscar Cotação de Moedas Banco Central (USD, EUR, GBP)
    Nome:     fxCotacaoMoeda
    Autor:    Wanderlei Hüttel
    Email:    wanderlei.huttel (at) gmail (dot) com
    Linkedin: https://www.linkedin.com/in/wanderleihuttel/
    Versão:   1.1 - 07/10/2023
*/
(vMoeda as text) =>
let
    /*
    Consultar Moedas Disponíveis
    https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/Moedas?$top=100&$format=json
    AUD,CAD,CHF,DKK,EUR,GBP,JPY,NOK,SEK,USD
    */
    vDataInicial = "01-01-2018",
    vDataFinal = Date.ToText(Date.From(DateTimeZone.SwitchZone(DateTimeZone.UtcNow(),-3)), "MM-dd-yyyy"),
    
    /* URL Base da consulta da API */
    vBaseURL = "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1",

    /* Campos que são informados como parâmetros (GET) */
    vQuery = [
        #"@moeda"             = "'" & vMoeda & "'", 
        #"@dataInicial"       = "'" & vDataInicial & "'", 
        #"@dataFinalCotacao"  = "'" & vDataFinal & "'",
        #"$filter"            = "tipoBoletim eq 'Fechamento'",
        #"$top"               = "10000",
        #"$select"            = "dataHoraCotacao,cotacaoCompra,cotacaoVenda",
        #"$format"            = "json"
    ],

    /* Criar a opções da Requisição */
    vOptions = [
        RelativePath = "/odata/CotacaoMoedaPeriodo(moeda=@moeda,dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)",
        Headers = [ 
            #"Content-Type"  = "application/json;charset=UTF-8" 
        ],
        Query = vQuery,
        ManualStatusHandling = {400, 404},
        IsRetry = true
    ],

    Response = Web.Contents(vBaseURL, vOptions),
    ResponseMetadata = Value.Metadata(Response),
    ResponseBinary = Binary.Buffer(Response),
    StatusCode = ResponseMetadata[Response.Status],
    Retorno =  if StatusCode = 200 then Json.Document(ResponseBinary,65001)[value] else {[dataHoraCotacao = null ,cotacaoCompra = null ,cotacaoVenda = null]},
    ConverterRetorno = List.Transform(Retorno, each Table.FromRecords({_}) ),
    CombinarTabelas = Table.Combine(ConverterRetorno),
    AlterarTipo = Table.TransformColumnTypes(CombinarTabelas,{{"cotacaoCompra", type number}, {"cotacaoVenda", type number}, {"dataHoraCotacao", type datetime}})
in
    AlterarTipo
