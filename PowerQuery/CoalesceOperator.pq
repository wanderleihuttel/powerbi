The Coalesce Operator
https://gorilla.bi/power-query/coalesce/
Since handling nulls is a common requirement, the M-language also offers the Coalesce Operator to achieve the same. The coalesce operator is represented by ??.

Example transform columns replacing nulls by 0
= Table.TransformColumns(Source, {{"Amount", each _ ?? 0, Currency.Type}})
