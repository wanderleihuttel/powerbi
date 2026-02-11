# Alterar o Tipo das colunas com base nos nomes

= Table.TransformColumns(ColunasReordenadas, 
    List.Transform(
        List.Select(Table.ColumnNames(ColunasReordenadas), each Text.StartsWith(Text.Lower(_), "data")),
        each { _ , each Date.From(_), type date}
    ) &
    List.Transform(
        List.Select(Table.ColumnNames(ColunasReordenadas), each Text.StartsWith(Text.Lower(_), "valor")),
        each { _ , each Number.From(_), Currency.Type}
    ) &
    List.Transform(
        List.Select(Table.ColumnNames(ColunasReordenadas), each not Text.StartsWith(Text.Lower(_), "data") and not Text.StartsWith(Text.Lower(_), "valor")),
        each { _ , each Text.From(_), type text}
     )    
)
