/* 
Filtrar Valores de um Record Não Nulos ou Vazios 
Utilizado para filtrar apenas colunas com valores.

1) Primeiro procura a linha do cabeçalho onde tem informação para gerar o _Record
= Tabela{ List.PositionOf(Tabela[Column1], "Código") }

2) Efetua o filtro na colunas do Record, e gera uma lista com o nome das colunas

3) Utiliza a lista com o nome das colunas para filtrar as colunas da tabela
*/


let
    _Record = [
    Column1 = "Código",
    Column2 = null,
    Column3 = "Nome",
    Column4 = "",
    Column5 = "Endereço",
    Column6 = "Município",
    Column7 = null,
    Column8 = "Estado",
    Column9 = null,
    Column10 = null
],
    FiltrarNãoNulos = Record.SelectFields(_Record, List.Select(Record.FieldNames(_Record), each not List.Contains({"", null}, Record.Field(_Record, _))) ),
    RecordFieldNames = Record.FieldNames( FiltrarNãoNulos )
in
    RecordFieldNames
