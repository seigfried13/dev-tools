### `ccpm/ccpm/rules/use-ast-grep.md`

```sh
ast-grep --pattern '$PATTERN' --lang $LANGUAGE $PATH
command -v ast-grep >/dev/null 2>&1 || echo "ast-grep not installed, skipping AST search"
command -v ast-grep >/dev/null 2>&1 && ast-grep --pattern 'perform($$$)' --lang ruby app/services/
```
