/*
pqBuscaParcial
Autor:            Wanderlei Hüttel
Última alteração: 10/03/2023

https://www.linkedin.com/in/wanderleihuttel
https://github.com/wanderleihuttel/powerbi

É preciso existir uma tabela com 2 colunas com a seguinte ordem
    - Coluna1 - DE   = texto à procurar (1 ou mais palavras)
    - Coluna2 - PARA = texto de retorno 

Adicionar uma nova coluna na Tabela desejada e usar a função da seguinte maneira:
    - pqBuscaParcial([CAMPO_CONTENDO_STRING], TabelaDeParaCom2Colunas)

*/

(vTexto as text, vTabelaDePara as table ) as any =>
let
	vListaProcurar = List.Buffer(Table.Column(vTabelaDePara, Table.ColumnNames(vTabelaDePara){0})),
	vListaRetorno = List.Buffer(Table.Column(vTabelaDePara, Table.ColumnNames(vTabelaDePara){1})),
	count = List.Count(vListaProcurar),
	idx = List.PositionOf(
		List.Generate(
			()=>[i=0],
			each [i] < count,
			each [i = if Text.Contains(vTexto, vListaProcurar{[i]}) = false then [i]+1 else count],
			each Text.Contains(vTexto, vListaProcurar{[i]})
		),
		true
	),
	vOutput = if idx < 0 then null else vListaRetorno{idx}
in
	vOutput
