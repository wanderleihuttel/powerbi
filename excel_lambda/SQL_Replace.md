### Função para substituir variáveis em um comando SQL pelos valores da colunas


Exemplo de comando SQL
```
# As variáveis do comando SQL precisam estar entre cerquilhas (#)
# E precisam ser iguais aos cabeçalhos das colunas da tabela

update tabela set datanascimento = '#datanascimento#', cidade = '#cidade#', estado = '#estado#', pais = '#país#' where id = #id#;
```
&nbsp;
| Id | Nome              | DataNascimento    | Cidade         | Estado             | País                |
|----|-------------------|-------------------|----------------|--------------------|---------------------|
| 1  | Bill Gates        | 28.10.1955        | Seattle        | Washington         | Estados Unidos      |
| 2  | Steve Jobs        | 24.02.1955        | San Francisco  | Califórnia         | Estados Unidos      |
| 3  | Jeff Bezos        | 12.01.1964        | Albuquerque    | Novo México        | Estados Unidos      |
| 4  | Mark Zuckerberg   | 14.05.1984        | White Plains   | Nova York          | Estados Unidos      |
| 5  | Elon Musk         | 28.06.1971        | Pretória       | Gauteng            | África do Sul       |






**Função Lambda**
```
fxSQLReplace = LAMBDA(CommandSQL;TableWithHeaders;
    LET(
       _header;PEGAR(TableWithHeaders;1);
       _data;DESCARTAR(TableWithHeaders;1);
       _sql;CommandSQL;
    
        _ReplaceSQL;LAMBDA(_sql;_header;_row;
        LET(
            _param; REGEX.EXTRAIR(_sql; "#\w+#"; 1);
            _value;ESCOLHERCOLS(
                _row;
                CORRESPX(SUBSTITUIR(_param;"#";"");_header;0)
            );
            REDUCE(
                _sql;
                SEQUÊNCIA(COLS(_param));
                LAMBDA(_text;idx; SUBSTITUIR(_text; ÍNDICE(_param; idx); ÍNDICE(_value; idx)))
            )
        ));
        BYROW(_data;LAMBDA(_row;_ReplaceSQL(_sql;_header;_row)))
    )
)
```


### Após definir a função *fxSQLReplace* no gerenciador de nomes, basta usar da sequinte forma:
```
=fxSQLReplace(ComandoSQL;TabelaInteiraComCabeçalhos)
```
