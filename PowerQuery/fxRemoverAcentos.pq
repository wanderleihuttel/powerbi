(texto as text) =>
let
    ListaComAcentos = Text.ToList("àáâãäèéêëìíîïòóôõöùúûüÀÁÂÃÄÈÉÊËÌÍÎÒÓÔÕÖÙÚÛÜçÇñÑ"),
    ListaSemAcentos = Text.ToList("aaaaaeeeeiiiiooooouuuuAAAAAEEEEIIIOOOOOUUUUcCnN"),
    ParesAcentos = List.Zip({ListaComAcentos, ListaSemAcentos}),
    TextoComAcentos = Text.ToList(texto),
    AcentosSubstituidos = List.ReplaceMatchingItems(TextoComAcentos, ParesAcentos),
    TextoSemAcentos = Text.Combine(AcentosSubstituidos)
in
    TextoSemAcentos
