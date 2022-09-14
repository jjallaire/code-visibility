# Code Visibility Extension

This extension implements some directives for filtering code and stream
output included within a document.

Use this extension within a Quarto project by first installing it:

``` bash
```

## `#| hide-line`

The `hide-line` directive hides a specific line of code in an input
cell. For example, this code:

```` markdown
```{python}
def _secret(): ...

for i in range(3):
    _secret() #| hide-line
    print(i)
```
````

Becomes this:

``` python
def _secret(): ...

for i in range(3):
    print(i)
```

## `#| filter-stream: <keyword> ...`

The `filter-stream` directive filters lines containing specific keywords
in cell outputs. For example, the following code:

```` markdown
```{python}
#| filter-stream: FutureWarning MultiIndex
print('\n'.join(['A line', 'Foobar baz FutureWarning blah', 
                 'zig zagMultiIndex zoom', 'Another line.']))
```
````

Produces this output:

    A line
    Another line.
