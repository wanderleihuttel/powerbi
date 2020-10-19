/*
    Função para importar arquivo de recebimentos Banco do Brasil TXT
    (Conforme modelo: pqRecebimentoBB_modelo.txt)
    
    Autor: Wanderlei Hüttel
    Última alteração: 19/10/2020

    https://www.linkedin.com/in/wanderleihuttel
    https://github.com/wanderleihuttel/powerbi
*/

(Caminho as text) =>
let
    Fonte = Folder.Files(Caminho),
    FiltrarArquivosTXT = Table.SelectRows(Fonte, each [Extension] = ".txt" and not Text.StartsWith([Name], "~")),
    ColunaConteúdo = Table.AddColumn(FiltrarArquivosTXT, "Conteúdo", each Csv.Document([Content], [Delimiter=";", Columns=1, Encoding=1252, QuoteStyle=QuoteStyle.None]), type table),
    SelecionarColunaConteúdo = Table.SelectColumns(ColunaConteúdo,{"Conteúdo"}),
    ConteúdoExpandido = Table.ExpandTableColumn(SelecionarColunaConteúdo, "Conteúdo", {"Column1"}, {"Column1"}),
    ColunaÉNúmero = Table.AddColumn(ConteúdoExpandido, "ColunaÉNúmero", each let
numero = try Number.From(Text.At(Text.Trim([Column1]), 0)) otherwise false
in if numero = false then false else true, type logical),
    FiltrarApenasNúmeros = Table.SelectRows(ColunaÉNúmero, each ([ColunaÉNúmero] = true)),
    DividirColunaPorDelimitador = Table.SplitColumn(FiltrarApenasNúmeros, "Column1", Splitter.SplitTextByDelimiter("#(tab)", QuoteStyle.Csv), {"NossoNúmero", "NomePagador", "DataVencimento", "DataOperação", "ValorTítulo", "Tarifa", "Acréscimo", "Abat/Desc.", "Operação", "ValorLíquido", "NúmeroBeneficiário", "AgênciaRecebimento", "Column1.13", "Column1.14"}),
    ColunasSelecionadas2 = Table.SelectColumns(DividirColunaPorDelimitador,{"NossoNúmero", "NomePagador", "DataVencimento", "DataOperação", "ValorTítulo", "Tarifa", "Acréscimo", "Abat/Desc.", "Operação", "ValorLíquido", "NúmeroBeneficiário", "AgênciaRecebimento"}),
    ArrumarValorLíquido = Table.TransformColumns(ColunasSelecionadas2, {{"ValorLíquido", each Text.Select(_, {"0".."9",".",","}), type text}}),
    TipoAlterado = Table.TransformColumnTypes(ArrumarValorLíquido,{{"NossoNúmero", type text}, {"NomePagador", type text}, {"DataVencimento", type date}, {"DataOperação", type date}, {"ValorTítulo", type number}, {"Tarifa", type number}, {"Acréscimo", type number}, {"Abat/Desc.", type number}, {"Operação", type text}, {"ValorLíquido", type number}, {"NúmeroBeneficiário", type text}, {"AgênciaRecebimento", type text}})
in
    TipoAlterado
