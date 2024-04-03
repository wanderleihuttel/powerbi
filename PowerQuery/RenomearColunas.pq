= Table.RenameColumns(UltimaEtapa, List.Zip({
    Table.ColumnNames(UltimaEtapa),
    {"Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7"}
  }), MissingField.Ignore)
