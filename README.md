# Code Visibility Extension

This extension implements some directives for filtering code and stream
output included within a document.

Use this extension within a Quarto project by first installing it from within the project working directory:

``` bash
quarto install extension jjallaire/code-visibility
```

Then add the `code-visibility` filter to your project:

```yaml
filters:
  - code-visibility
```

## `#| hide_line`

The `hide_line` directive hides a specific line of code in an input
cell. For example, this code:

```` python
```{python}
def _secret(): ...

for i in range(3):
    _secret() #| hide_line
    print(i)
```
````

Becomes this:

``` python
def _secret(): ...

for i in range(3):
    print(i)
```

## `#| filter_stream: <keyword> ...`

The `filter_stream` directive filters lines containing specific keywords
in cell outputs. For example, the following code:

```` python
```{python}
#| filter_stream: FutureWarning MultiIndex
print('\n'.join(['A line', 'Foobar baz FutureWarning blah', 
                 'zig zagMultiIndex zoom', 'Another line.']))
```
````

Produces this output:

    A line
    Another line.
