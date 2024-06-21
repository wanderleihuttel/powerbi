let func =   
    (vTable as table, vColumnName as text, optional vRows as number) =>
    let
        vRows = if vRows = null then 1 else vRows,
        Source = Table.Buffer(vTable),
        NullList = List.Repeat({null}, Number.Abs(vRows)),
        ShiftedList = if vRows < 0 then List.RemoveFirstN( Table.Column(Source, vColumnName), Number.Abs(vRows)) & NullList 
                      else NullList & List.RemoveLastN( Table.Column(Source, vColumnName), vRows),
        TableToColumns = Table.ToColumns(Source) & {ShiftedList},
        Output = Table.FromColumns(TableToColumns, Table.ColumnNames(Source) & {vColumnName & "New"})
    in
        Output,
        documentation = [
            Documentation.Name =  "fxDeslocRows",
            Documentation.Description = "Desloc row values from a column to top or bottom",
            Documentation.Category = "",
            Documentation.Source = "https://github.com/wanderleihuttel/powerbi",
            Documentation.Version = "1.0 ",
            Documentation.Author = "Wanderlei Hüttel",
            Documentation.Examples = {[Description =  "Create a custom column and include the following code:", Code = "fxDeslocRows(Source, ""ColumnName"", optional vRows)", Result = "Source[NewColumn]"]}
        ]

in
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))

//https://www.thebiccountant.com/2018/07/12/fast-and-easy-way-to-reference-previous-or-next-rows-in-power-query-or-power-bi/
