// Exemplo de Mesclar Tabelas com Table.SelectRows
let
    //Tabela 1
    Fonte1 = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("TY85EoQwDAT/opgAYWwg5FjOXXiAi/9/gxmJYIOp6i7b0jhnUSmkR7SRu8hSAQckRNMAHJE6mNbACYmlaQR++LY1TcAZqVwb4MJR/rYFrhzlizrghiQ11RK8c1ZyZ6+Dwzp3FvvSfbWy2Y/333NWO//us9v1fuR+AA==", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [CODIGO = _t, NOME = _t, IDADE = _t]),
    Tabela1 = Table.TransformColumnTypes(Fonte1,{{"CODIGO", Int64.Type}, {"IDADE", Int64.Type}}),
    
    //Tabela 2
    Fonte2 = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMlaK1YlWMgeThgYQylQpNhYA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [CODIGO = _t]),
    Tabela2 = Table.TransformColumnTypes(Fonte2,{{"CODIGO", Int64.Type}}),
    
    //Fazer o join e expandir os campos
    AddCampoJoin = Table.AddColumn(Tabela2, "NomeCampoNovo", each Table.SelectRows(Tabela1, (tabela) => tabela[CODIGO] = [CODIGO]), type table),
    MesclarCampoJoin = Table.ExpandTableColumn(AddCampoJoin, "NomeCampoNovo", {"NOME", "IDADE"}, {"NOME", "IDADE"}),
    TipoAlterado = Table.TransformColumnTypes(MesclarCampoJoin,{{"NOME", type text}, {"IDADE", Int64.Type}})    
in
    TipoAlterado
