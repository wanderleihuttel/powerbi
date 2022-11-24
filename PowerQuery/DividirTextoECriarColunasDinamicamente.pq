let
    Fonte = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("jZDLCsIwEEV/JWTtxscPaFGkWJFmWboY24EE84BpIuTvTbooIga6nHMP8+o6vuUb/oCgWTNUQN5iTKAGg9MX6TcFUXjUGtaYJwRPasA1bgMU13jX1FMi/ai7lLTwVkxIsC+gVN4dgWS1sziVFCHDU6IdCRaYzX1enRRY1kAeeTZKR9YGL2fwT6mVMbGY3lxQEyzxIaELpXlMKJs+BHlbsENc6uL1R+vm6+egkkqPvO8/", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [CODIGO = _t, NOME = _t, DEPENDENTE = _t]),
    LinhasAgrupadas = Table.Group(Fonte, {"CODIGO", "NOME"}, {{"NUMERO_DEPENDENTES", each Table.RowCount(_), Int64.Type}, {"DEPENDENTE", each List.Sort( Table.ToList( Table.SelectColumns(_,{"DEPENDENTE"}))), type list}}),
    ListaExtraida = Table.TransformColumns(LinhasAgrupadas, {"DEPENDENTE", each Text.Combine(List.Transform(_, Text.From), ","), type text}),
    DividirColuna = Table.SplitColumn(ListaExtraida, "DEPENDENTE", Splitter.SplitTextByDelimiter(",", QuoteStyle.Csv), 
    List.Transform(List.Generate(() => 1, each _ <= List.Max(ListaExtraida[NUMERO_DEPENDENTES]), each _ +1 ), each "DEPENDENTE_"&Text.From(_))
)
in
    DividirColuna
