/*
DimDate English Model 2
Author: Wanderlei Hüttel
Last Update: 25/09/2020

https://www.linkedin.com/in/wanderleihuttel
https://github.com/wanderleihuttel/powerbi

Tips from Joviano Silveira
https://joviano.com/
*/
let
    DateMin = Date.FromText("01/01/2018"), //List.Min(fVendas[Data Venda]),
    DateMax = Date.FromText("31/12/2020"), //List.Max(fVendas[Data Venda]),
    StartDate = #date(Date.Year(DateMin), 1, 1),
    EndDate = #date(Date.Year(DateMax), 12, 31),
    Duration = Duration.Days(EndDate - StartDate) + 1,
    ListDates = List.Buffer(List.Sort(List.Dates (StartDate, Duration, #duration(1,0,0,0)), Order.Ascending)),
    AddColumns = List.Transform(ListDates, each 
        {
            _, //DateId
            List.PositionOf(ListDates, _)+1, // Index
            Date.Year(_), //Year
            Date.Month(_), //Month
            Date.Day(_), //Day
            Date.DaysInMonth(_), //DaysInMonth
            Text.Proper(Date.MonthName(_, "en-US")), //MonthName
            Text.Proper(Date.ToText(_,"MMM", "en-US")), //ShortMonthName
            Date.DayOfWeek(_), //DayOfWeek
            if not List.Contains({0,6}, Date.DayOfWeek(_)) then true else false, //BusinessDay
            Text.Proper(Date.DayOfWeekName(_, "en-US")), //DayOfWeekName
            Text.Proper(Date.ToText(_,"ddd", "en-US")), //DayOfWeekShortName
            Date.ToText(_, "dd/MM"), //Day/Month
            Date.ToText(_, "MM/yyyy"), //Month/Year
            Text.Proper(Date.ToText(_, "MMMM/yyyy", "en-US")), //MonthName/Year
            Date.WeekOfMonth(_), //WeekOfMonth
            Date.WeekOfYear(_), //WeekOfYear
            if Number.Mod(Date.Month(_),2) = 0 then Date.Month(_)/2 else (Date.Month(_)+1)/2, //TwoMonth
            Date.QuarterOfYear(_), //Quarter
            if Date.Month(_) <= 6 then 1 else 2, //HalfYear
            Number.FromText(Date.ToText(_, "yyyyMM")), //YearMonthNumber
            Number.FromText(Date.ToText(_, "yyyyMMdd")) //DateSerial
        }
    ),
    ListToTable = #table(
        type table [
            #"DateId"  = date,
            #"Index" = Int64.Type,
            #"Year"   = Int64.Type,
            #"Month"   = Int64.Type,
            #"Day"   = Int64.Type,
            #"DaysInMonth" = Int64.Type,
            #"MonthName" = text,
            #"ShortMonthName" = text,
            #"DayOfWeek" = Int64.Type,
            #"BusinessDay" = logical,
            #"DayOfWeekName" = text,
            #"DayOfWeekShortName" = text,
            #"Day/Month" = text,
            #"Month/Year" = text,
            #"MonthName/Year" = text,
            #"WeekOfMonth" = Int64.Type,
            #"WeekOfYear" = Int64.Type,
            #"TwoMonth" = Int64.Type,
            #"Quarter" = Int64.Type,
            #"HalfYear" = Int64.Type,
            #"YearMonthNumber" = Int64.Type,
            #"DateSerial" = Int64.Type
        ],
        AddColumns
    )
in
    ListToTable
