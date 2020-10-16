/*
Tabela Calendário - ptBR
Autor:            Wanderlei Hüttel
Última alteração: 16/10/2020
*/

let
    DataMin = Date.FromText("01/01/2019"), //List.Min(Fato1[Data] & Fato2[Data]),
    DataMax = Date.FromText("31/12/2020"), //List.Max(Fato1[Data] & Fato2[Data]),
    DataInicial = #date(Date.Year(DataMin), 1, 1),
    DataFinal = #date(Date.Year(DataMax), 12, 31),
    Duracao = Duration.Days(DataFinal - DataInicial) + 1,
    ListDates = List.Buffer(List.Sort(List.Dates (DataInicial, Duracao, #duration(1,0,0,0)), Order.Ascending)),
    ListaParaTabela = Table.FromList(ListDates, Splitter.SplitByNothing(), {"DataId"}, null, ExtraValues.Error),
    ColunaIndice = Table.AddIndexColumn(ListaParaTabela, "Indice", 1, 1),
    AlterarTipo = Table.TransformColumnTypes(ColunaIndice,{{"DataId", type date}, {"Indice", Int64.Type}}),
    ReordenarColunas = Table.ReorderColumns(AlterarTipo,{"Indice", "DataId"}),
    ColunaAno = Table.AddColumn(ReordenarColunas, "Ano", each Date.Year([DataId]), Int64.Type),
    ColunaMês = Table.AddColumn(ColunaAno, "Mês", each Date.Month([DataId]), Int64.Type),
    ColunaDia = Table.AddColumn(ColunaMês, "Dia", each Date.Day([DataId]), Int64.Type),
    ColunaDiasNoMês = Table.AddColumn(ColunaDia, "Dias No Mês", each  Date.DaysInMonth([DataId]), Int64.Type),
    ColunaNomeDoMês = Table.AddColumn(ColunaDiasNoMês, "Nome do Mês", each Text.Proper(Date.MonthName([DataId])), type text),
    ColunaNomeDoMêsCurto = Table.AddColumn(ColunaNomeDoMês, "Nome Do Mês Curto", each Text.Proper(Date.ToText([DataId],"MMM", Culture.Current)), type text),
    ColunaDiaDaSemana = Table.AddColumn(ColunaNomeDoMêsCurto, "Dia Da Semana", each Date.DayOfWeek([DataId]), Int64.Type),
    ColunaDiaÚtil = Table.AddColumn(ColunaDiaDaSemana, "Dia Útil", each if [Dia Da Semana] <> 0 and [Dia Da Semana] <> 6 then true else false, type logical),
    ColunaHoje = Table.AddColumn(ColunaDiaÚtil, "Hoje", each if [DataId] = Date.From( DateTimeZone.SwitchZone(DateTimeZone.UtcNow(),-3) ) then true else false, type logical),
    ColunaNomeDiaDaSemana = Table.AddColumn(ColunaHoje, "Nome Dia Da Semana", each Text.Proper(Date.DayOfWeekName([DataId])), type text),
    ColunaNomeDiaDaSemanaCurto = Table.AddColumn(ColunaNomeDiaDaSemana, "Nome Dia Da Semana Curto", each Text.Proper(Date.ToText([DataId],"ddd", Culture.Current)), type text),
    ColunaDiaMês= Table.AddColumn(ColunaNomeDiaDaSemanaCurto, "Dia/Mês", each Date.ToText([DataId], "dd/MM"), type text),
    ColunaMêsAno= Table.AddColumn(ColunaDiaMês, "Mês/Ano", each Date.ToText([DataId], "MM/yyyy"), type text),
    ColunaNomeMêsAno = Table.AddColumn(ColunaMêsAno, "Nome Mês/Ano", each Text.Proper(Date.ToText([DataId], "MMMM/yyyy")), type text),
    ColunaSemanaDoMês = Table.AddColumn(ColunaNomeMêsAno, "Semana Do Mês", each Date.WeekOfMonth([DataId]), Int64.Type),
    ColunaSemanaDoAno = Table.AddColumn(ColunaSemanaDoMês, "Semana Do Ano", each Date.WeekOfYear([DataId]), Int64.Type),
    ColunaBimestre = Table.AddColumn(ColunaSemanaDoAno, "Bimestre", each if Number.Mod([Mês],2) = 0 then [Mês]/2 else ([Mês]+1)/2, Int64.Type),
    ColunaTrimestre = Table.AddColumn(ColunaBimestre, "Trimestre", each Date.QuarterOfYear([DataId]), Int64.Type),
    ColunaSemestre = Table.AddColumn(ColunaTrimestre, "Semestre", each if [Mês] <= 6 then 1 else 2, Int64.Type),
    ColunaAnoMes = Table.AddColumn(ColunaSemestre, "AnoMêsNúmero", each Number.FromText(Date.ToText([DataId], "yyyyMM")), Int64.Type),
    ColunaDataSerial = Table.AddColumn(ColunaAnoMes, "DataSerial", each Number.FromText(Date.ToText([DataId], "yyyyMMdd")), Int64.Type)
in
    ColunaDataSerial
