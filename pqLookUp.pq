/*
    Function pqLookUp
    Lookup for a value in a table column and return a value in the same position of another column
    Author: Wanderlei Hüttel
    Email:  wanderlei.huttel at gmail dot com 
    Date:   18/08/2020
*/

(vTabela as table, vCampos as list, vTexto as any, optional vNaoEncontrou as any) as any =>
let
    vListaProcurar = List.Buffer(Table.Column(vTabela, vCampos{0})),
    vListaRetornar = List.Buffer(Table.Column(vTabela, vCampos{1})),
    count = List.Count(vListaProcurar),
    idx = 
    List.PositionOf(
        List.Generate(
            ()=>[i=0],
            each [i] < count,
            each [i = if Text.Contains(vTexto, vListaProcurar{[i]}) = false then [i]+1 else count],
            each Text.Contains(vTexto, vListaProcurar{[i]})
        ),
        true
    ),
    output = if idx < 0 then vNaoEncontrou else vListaRetornar{idx}
in
    output
