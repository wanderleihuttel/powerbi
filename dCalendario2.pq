/*
Tabela Calendário Modelo 2
Autor:            Wanderlei Hüttel
Última alteração: 25/09/2020

https://www.linkedin.com/in/wanderleihuttel
https://github.com/wanderleihuttel/powerbi

Dicas do Joviano Silveira
https://joviano.com/
*/

let
    DataMin = Date.FromText("01/01/2019"), //List.Min(Fato1[Data] & Fato2[Data]),
    DataMax = Date.FromText("31/12/2020"), //List.Max(Fato1[Data] & Fato2[Data]),
    DataInicial = #date(Date.Year(DataMin), 1, 1),
    DataFinal = #date(Date.Year(DataMax), 12, 31),
    Duracao = Duration.Days(DataFinal - DataInicial) + 1,
    ListDates = List.Buffer(List.Sort(List.Dates (DataInicial, Duracao, #duration(1,0,0,0)), Order.Ascending)),
    AdicionarColunas = List.Transform(ListDates, each 
        {
            _, //DataId
            List.PositionOf(ListDates, _)+1, // Índice
            Date.Year(_), //Ano
            Date.Month(_), //Mês
            Date.Day(_), //Dia
            Date.DaysInMonth(_), //Dias no mês
            Text.Upper(Date.MonthName(_)), //Nome do mês
            Text.Upper(Date.ToText(_,"MMM", Culture.Current)), //Nome do mês curto
            Date.DayOfWeek(_), //Dia da semana
            if not List.Contains({0,6}, Date.DayOfWeek(_)) then true else false, //Dia útil
            Text.Upper(Date.DayOfWeekName(_)), //Nome do dia da semana
            Text.Upper(Date.ToText(_,"ddd", Culture.Current)), //Nome do dia da semana curto
            Date.ToText(_, "dd/MM"), //Dia/mês
            Date.ToText(_, "MM/yyyy"), //Mês/ano
            Text.Upper(Date.ToText(_, "MMMM/yyyy")), //Nome mês/ano
            Date.WeekOfMonth(_), //Semana do mês
            Date.WeekOfYear(_), //Semana do ano
            if Number.Mod(Date.Month(_),2) = 0 then Date.Month(_)/2 else (Date.Month(_)+1)/2, //Bimestre
            Date.QuarterOfYear(_), //Trimestre
            if Date.Month(_) <= 6 then 1 else 2, //Semestre
            Number.FromText(Date.ToText(_, "yyyyMM")), //AnoMêsNúmero
            Number.FromText(Date.ToText(_, "yyyyMMdd")) //Data serial
        }
    ),
    ListaParaTabela = #table(
        type table [
            #"DataId"  = date,
            #"Indice"   = Int64.Type,
            #"Ano"   = Int64.Type,
            #"Mês"   = Int64.Type,
            #"Dia"   = Int64.Type,
            #"Dias No Mês" = Int64.Type,
            #"Nome do Mês" = text,
            #"Nome Do Mês Curto" = text,
            #"Dia Da Semana" = Int64.Type,
            #"Dia Útil" = logical,
            #"Nome Dia Da Semana" = text,
            #"Nome Dia Da Semana Curto" = text,
            #"Dia/Mês" = text,
            #"Mês/Ano" = text,
            #"Nome Mês/Ano" = text,
            #"Semana Do Mês" = Int64.Type,
            #"Semana Do Ano" = Int64.Type,
            #"Bimestre" = Int64.Type,
            #"Trimestre" = Int64.Type,
            #"Semestre" = Int64.Type,
            #"AnoMêsNúmero" = Int64.Type,
            #"DataSerial" = Int64.Type
        ],
        AdicionarColunas
    )
in
    ListaParaTabela
