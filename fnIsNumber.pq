/* Check is a string or substring is number */
(value as text) =>
let
    check = try Number.From(value) otherwise false,
    result = if check = false then false else true
in
    result
