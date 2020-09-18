/*
Dim Date English
Author:      Wanderlei Hüttel
Last Update: 18/09/2020
*/


let
    DateMin = List.Min(List.Buffer(ftSales[OrderDate] & ftReturns[OrderDate])),
    DateMax = List.Max(List.Buffer(ftSales[OrderDate] & ftReturns[OrderDate])),
    YearMin = Date.Year(DateMin),
    YearMax = Date.Year(DateMax),
    StartDate = #date(YearMin,1,1),
    EndDate = #date(YearMax,12,31),
    Duration = Duration.Days(EndDate - StartDate) + 1,
    ListDates = List.Sort(List.Dates(StartDate, Duration, #duration(1,0,0,0)), Order.Ascending),
    ListDatesToTable = Table.FromList(ListDates, Splitter.SplitByNothing(), {"DateId"}, null, ExtraValues.Error),
    ColumnIndex = Table.AddIndexColumn(ListDatesToTable, "Index", 1, 1),
    ChangeType = Table.TransformColumnTypes(ColumnIndex,{{"DateId", type date}, {"Index", Int64.Type}}),
    ReorderColumns = Table.Buffer(Table.ReorderColumns(ChangeType,{"Index", "DateId"})),
    ColumnYear = Table.AddColumn(ReorderColumns, "Year", each Date.Year([DateId]), Int64.Type),
    ColumnMonth = Table.AddColumn(ColumnYear, "Month", each Date.Month([DateId]), Int64.Type),
    ColumnDay = Table.AddColumn(ColumnMonth, "Day", each Date.Day([DateId]), Int64.Type),
    ColumnDaysInMonth = Table.AddColumn(ColumnDay, "DaysInMonth", each  Date.DaysInMonth([DateId]), Int64.Type),
    ColumnMonthName = Table.AddColumn(ColumnDaysInMonth, "MonthName", each Text.Proper(Date.MonthName([DateId], "en-US")), type text),
    ColumnShortMonthName = Table.AddColumn(ColumnMonthName, "ShortMonthName", each Text.Proper(Date.ToText([DateId],"MMM", "en-US")), type text),
    ColumnDayOfWeek = Table.AddColumn(ColumnShortMonthName, "DayOfWeek", each Date.DayOfWeek([DateId]), Int64.Type),
    ColumnBusinessDay = Table.AddColumn(ColumnDayOfWeek, "BusinessDay", each if not List.Contains({0,6}, [DayOfWeek]) then true else false, type logical),
    ColumnDayOfWeekName = Table.AddColumn(ColumnBusinessDay, "DayOfWeekName", each Text.Proper(Date.DayOfWeekName([DateId], "en-US")), type text),
    ColumnDayOfWeekShortName = Table.AddColumn(ColumnDayOfWeekName, "DayOfWeekShortName", each Text.Proper(Date.ToText([DateId],"ddd", "en-US")), type text),
    ColumnDayMonth= Table.AddColumn(ColumnDayOfWeekShortName, "Day/Month", each Date.ToText([DateId], "dd/MM"), type text),
    ColumnMonthYear= Table.AddColumn(ColumnDayMonth, "Month/Year", each Date.ToText([DateId], "MM/yyyy"), type text),
    ColumnMonthNameYear = Table.AddColumn(ColumnMonthYear, "MonthName/Year", each Text.Proper(Date.ToText([DateId], "MMMM/yyyy", "en-US")), type text),
    ColumnWeekOfMonth = Table.AddColumn(ColumnMonthNameYear, "WeekOfMonth", each Date.WeekOfMonth([DateId]), Int64.Type),
    ColumnWeekOfYear = Table.AddColumn(ColumnWeekOfMonth, "WeekOfYear", each Date.WeekOfYear([DateId]), Int64.Type),
    ColumnTwoMonth = Table.AddColumn(ColumnWeekOfYear, "TwoMonth", each if Number.Mod([Month],2) = 0 then [Month]/2 else ([Month]+1)/2, Int64.Type),
    ColumnQuarter = Table.AddColumn(ColumnTwoMonth, "Quarter", each Date.QuarterOfYear([DateId]), Int64.Type),
    ColumnHalfYear = Table.AddColumn(ColumnQuarter, "HalfYear", each if [Month] <= 6 then 1 else 2, Int64.Type),
    ColumnYearMonthNumber = Table.AddColumn(ColumnHalfYear, "YearMonthNumber", each Number.FromText(Date.ToText([DateId], "yyyyMM")), Int64.Type),
    ColumnDateSerial = Table.AddColumn(ColumnYearMonthNumber, "DateSerial", each Number.FromText(Date.ToText([DateId], "yyyyMMdd")), Int64.Type)
in
    ColumnDateSerial
