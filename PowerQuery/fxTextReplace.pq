/* https://chandoo.org/wp/multiple-find-replace-list-accumulate/ */
/* Replace text using a table replacement */

(vText as text, vTable as table) as any =>
let
    vColumnFrom = Table.ToList(Table.SelectColumns(vTable, Table.ColumnNames(vTable){0})),
    vColumnTo = Table.ToList(Table.SelectColumns(vTable, Table.ColumnNames(vTable){1})),
    vCount = Table.RowCount(vTable),
    vOutput =  List.Accumulate(
        List.Numbers(0, vCount), 
        vText, 
        (state, current) => 
        Text.Replace(state, 
            vColumnFrom{current},
            vColumnTo{current}
        )
    )
in
    vOutput
