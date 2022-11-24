let
    Fonte = #table(
        type table[
            Coluna1 = date, 
            Coluna2 = text, 
            Coluna3 = Int64.Type, 
            Coluna4 = number, 
            Coluna5 = logical
        ],{{
            DateTime.LocalNow(), 
            "Valor Texto", 
            123, 
            123.45, 
            true
        }}
    )
in
    Fonte
