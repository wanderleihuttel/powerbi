/*
Tabela Calendário
Autor:            Wanderlei Hüttel
Última alteração: 23/06/2020
*/

let
    DataMin = Date.FromText("01/01/2019"), //List.Min(Fato1[Data] & Fato2[Data]),
    DataMax = Date.FromText("31/12/2020"), //List.Max(Fato1[Data] & Fato2[Data]),
    AnoMin = Date.Year(DataMin),
    AnoMax = Date.Year(DataMax),
    DataInicial = #date(AnoMin,1,1),
    DataFinal = #date(AnoMax,12,31),
    Duracao = Duration.Days(DataFinal - DataInicial) + 1,
    Fonte = List.Sort(List.Dates (DataInicial, Duracao, #duration(1,0,0,0)),Order.Ascending),
    ListaParaTabela = Table.FromList(Fonte, Splitter.SplitByNothing(), {"IdData"}, null, ExtraValues.Error),
    ColunaIndice = Table.AddIndexColumn(ListaParaTabela, "Indice", 1, 1),
    AlterarTipo = Table.TransformColumnTypes(ColunaIndice,{{"IdData", type date}, {"Indice", Int64.Type}}),
    ReordenarColunas = Table.ReorderColumns(AlterarTipo,{"Indice", "IdData"}),
    ColunaAno = Table.AddColumn(ReordenarColunas, "Ano", each Date.Year([IdData]), Int64.Type),
    ColunaMês = Table.AddColumn(ColunaAno, "Mês", each Date.Month([IdData]), Int64.Type),
    ColunaDia = Table.AddColumn(ColunaMês, "Dia", each Date.Day([IdData]), Int64.Type),
    ColunaDiasNoMês = Table.AddColumn(ColunaDia, "Dias No Mês", each  Date.DaysInMonth([IdData]), Int64.Type),
    ColunaNomeDoMês = Table.AddColumn(ColunaDiasNoMês, "Nome do Mês", each Text.Proper(Date.MonthName([IdData])), type text),
    ColunaNomeDoMêsCurto = Table.AddColumn(ColunaNomeDoMês, "Nome Do Mês Curto", each Text.Proper(Date.ToText([IdData],"MMM", Culture.Current)), type text),
    ColunaDiaDaSemana = Table.AddColumn(ColunaNomeDoMêsCurto, "Dia Da Semana", each Date.DayOfWeek([IdData]), Int64.Type),
    ColunaDiaÚtil = Table.AddColumn(ColunaDiaDaSemana, "Dia Útil", each if [Dia Da Semana] <> 0 and [Dia Da Semana] <> 6 then true else false, type logical),
    ColunaNomeDiaDaSemana = Table.AddColumn(ColunaDiaÚtil, "Nome Dia Da Semana", each Text.Proper(Date.DayOfWeekName([IdData])), type text),
    ColunaNomeDiaDaSemanaCurto = Table.AddColumn(ColunaNomeDiaDaSemana, "Nome Dia Da Semana Curto", each Text.Proper(Date.ToText([IdData],"ddd", Culture.Current)), type text),
    ColunaDiaMês= Table.AddColumn(ColunaNomeDiaDaSemanaCurto, "Dia/Mês", each Date.ToText([IdData], "dd/MM"), type text),
    ColunaMêsAno= Table.AddColumn(ColunaDiaMês, "Mês/Ano", each Date.ToText([IdData], "MM/yyyy"), type text),
    ColunaNomeMêsAno = Table.AddColumn(ColunaMêsAno, "Nome Mês/Ano", each Text.Proper(Date.ToText([IdData], "MMMM/yyyy")), type text),
    ColunaSemanaDoMês = Table.AddColumn(ColunaNomeMêsAno, "Semana Do Mês", each Date.WeekOfMonth([IdData]), Int64.Type),
    ColunaSemanaDoAno = Table.AddColumn(ColunaSemanaDoMês, "Semana Do Ano", each Date.WeekOfYear([IdData]), Int64.Type),
    ColunaBimestre = Table.AddColumn(ColunaSemanaDoAno, "Bimestre", each if Number.Mod([Mês],2) = 0 then [Mês]/2 else ([Mês]+1)/2, Int64.Type),
    ColunaTrimestre = Table.AddColumn(ColunaBimestre, "Trimestre", each Date.QuarterOfYear([IdData])),
    ColunaSemestre = Table.AddColumn(ColunaTrimestre, "Semestre", each if [Mês] <= 6 then 1 else 2, Int64.Type),   
    ColunaDataSerial = Table.AddColumn(ColunaSemestre, "DateSerial", each Number.FromText(Date.ToText([IdData], "yyyyMMdd")), Int64.Type)
in
    ColunaDataSerial
