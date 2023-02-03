/*
Exemplo PowerQuery de Login em API utilizando autenticação "Basic" e POST para buscar o Token Bearer
Autor: Wanderlei Hüttel
Data: 03/02/2023

Exemplo de JSON de retorno
{
	"access_token":  "123456",
	"token_type": "bearer",
	"refresh_token": "123456a",
	"expires_in": 42999,
	"scope": "read write trust",
	"jti": "9550e02d-e294-3fbf-5208-ab63b0ff2d2e"
}

*/

let
    // Parâmetros da API
    Params = [
        client_id = "pz9fciyyyhz81c6zacgb",
        client_secret = "66znjmrsgitzq6wgpba5x1wvp61k900o4y0oj106",
        username = "email@dominio.com.br",
        password = "TW4Pi87AnRToctpqH5jNFvDYrwSa8@mHdVuZxjQf",
        grant_type = "password",
        credentials = Binary.ToText(Text.ToBinary(client_id & ":" & client_secret, BinaryEncoding.Base64))
    ],
    
    // Cabeçalhos da API
    Headers = [
        #"Content-Type"  = "application/x-www-form-urlencoded",
        #"Authorization" = "Basic " & Params[credentials]
    ],
    
    // Body da API (Formulário) (POST)
    Body = [
		username = Params[username],
        password = Params[password],
        grant_type = Params[grant_type]
    ],
    BaseURL = "https://api.dominio.com.br",
    Options = [
        RelativePath = "/oauth/token",
        Headers = Headers,
        Content = Text.ToBinary(
            Uri.BuildQueryString(Body)
        ),
        ManualStatusHandling = {400, 404},
        IsRetry = true
    ],
    response = Web.Contents(BaseURL, Options),
    response_metadata = Value.Metadata(response),
    response_binary = Binary.Buffer(response),
    status_code = response_metadata[Response.Status],
    access_token = if status_code = 200 then Record.AddField(Json.Document(response_binary), "last_execution", DateTime.FixedLocalNow()) 
                   else [access_token = false]
in
    access_token
