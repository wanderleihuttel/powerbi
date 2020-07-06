let func =   
    (value as text) =>
    let
        check = try Number.From(value) otherwise false,
        result = if check = false then false else true
    in
        result,
        documentation = [
            Documentation.Name =  "fnIsNumber",
            Documentation.Description = "Checks whether a string/substring is a number",
            Documentation.Category = "Text",
            Documentation.Source = "https://github.com/wanderleihuttel/powerbi",
            Documentation.Version = "1.0 ",
            Documentation.Author = "Wanderlei Hüttel",
            Documentation.Examples = {[Description =  "Create a custom column and include the following code:", Code = "if fnIsNumber([Column1]) then true else false", Result = "true/false"]}
        ]
in  
    Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
