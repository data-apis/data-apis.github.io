+++
date = "2023-05-25"
author = "Marco Gorelli"
title = "Want to super-charge your library by writing dataframe-agnostic code? We'd love to hear from you"
tags = ["APIs", "standard", "consortium", "dataframes", "community", "pandas", "polars", "cudf", "modin", "vaex", "koalas", "ibis", "dask"]
categories = ["Consortium", "Standardization"]
description = "An RFC for a dataframe API Standard"
draft = true
weight = 40
+++

<h1 align="center">
	<img
		width="400"
		alt="standard-compliant dataframe"
		src="https://github.com/MarcoGorelli/impl-dataframe-api/assets/33491632/fb4bc907-2b85-4ad7-8d13-c2b9912b97f5">
</h1>

Tired of getting lost in if-then statements when dealing with API differences
between dataframe libraries? Would you like to be able to write your code
once, have it work with all major dataframe libraries, and be done?
Let's learn about an initiative which will enable you to write
cross-dataframe code - no special-casing nor data conversions required!

## Why would I want this anyway?

Say you want to write a function which selects rows of a dataframe based
on the [z-score](https://en.wikipedia.org/wiki/Standard_score) of a given
column, and you want it to work with any dataframe library. How might
you write that?

### Solution 1

Here's a typical solution:
```python
def remove_outliers(df: object, column: str) -> pd.DataFrame:
    if isinstance(df, pandas.DataFrame):
        z_score = (df[column] - df[column].mean())/df[column].std()
        return df[z_score.between(-3, 3)]
    if isinstance(df, polars.DataFrame):
        z_score = ((pl.col(column) - pl.col(column).mean()) / pl.col(column).std())
        return df.filter(z_score.is_between(-3, 3))
    if isinstance(df, some_other_library.DataFrame):
        ...
```
This quickly gets unwieldy. Libraries like `cudf` and `modin` _might_ work
in the `isinstance(df, pandas.DataFrame)` arm, but there's no guarantee -
their APIs are similar, but subtly different. Furthermore, as new libraries
come out, you'd have to keep updating your function to add new `if` statements.

Can we do better?

### Solution 2: Interchange Protocol

An alternative, which wouldn't involve special-casing, could be to
leverage the [DataFrame interchange protocol](https://data-apis.org/dataframe-protocol/latest/index.html):
```python
def remove_outliers(df: object, column: str) -> pd.DataFrame:
    df_pd = pd.api.interchange.from_dataframe(df)
    z_score = (df_pd[column] - df_pd[column].mean())/df_pd[column].std()
    return df_pd[z_score.between(-3, 3)]
```
We got out of having to write if-then statements (🥳), but there's still a
couple of issues:
1. we had to convert to pandas: this might be expensive if your data was
   originally stored on GPU;
2. the return value is a `pandas.DataFrame`, rather than an object of your
   original dataframe library.

Can we do better? Can we really have it all?

### Solution 3: Introducing the Dataframe Standard

Yes, we really can. To write cross-dataframe code, we'll take these steps:
1. enable the Standard using ``.__dataframe_standard__``. This will return
   a Standard-compliant dataframe;
2. write your code, using the [Dataframe Standard specification](https://data-apis.org/dataframe-api/draft/API_specification/index.html)
3. (optional) return a dataframe from your original library by calling `.dataframe`.

Let's see how this would look like for our ``remove_outliers`` example function:
```python
def remove_outliers(df, column):
    # Get a Standard-compliant dataframe.
    # NOTE: this has not yet been upstreamed, so won't work out-of-the-box!
    # See 'resources' below for how to try it out.
    df_standard = df.__dataframe_standard__()
    # Use methods from the Standard specification.
    col = df_standard.get_column_by_name(column)
    z_score = (col - col.mean()) / col.std()
    df_standard_filtered = df_standard.get_rows_by_mask((z_score > -3) & (z_score < 3))
    # Return the result as a dataframe from the original library.
    return df_standard_filtered.dataframe
```
This will work, as if by magic, on any dataframe with a Standard-compliant implementation.
But it's not magic, of course, it's the power of standardisation!

## Standard Philosophy - will all dataframe libraries have the same API one day?

Let's start with what this isn't: the Standard isn't an attempt to force all dataframe
libraries to have the same API. It also isn't a way to convert
between dataframes: the [Interchange Protocol](https://data-apis.org/dataframe-protocol/latest/index.html),
whose adoption is increasing, already does that. It also doesn't aim to standardise
domain or industry specific functionality.

Rather, it is minimal set of essential dataframe functionality which will work
the same way across libraries. It will behave in a strict and predictable manner
across dataframe libraries. Library authors trying to write dataframe-agnostic
code are expected to greatly benefit from this, as are their users.

## Who's this for? Do I need to learn yet another API?

If you're a casual user, then probably not.
The Dataframe Standard is currently mainly targeted towards library developers,
who wish to support multiple dataframe libraries. Users of non-pandas dataframe
would then be able to seamlessly use the dataframe tools (e.g. visualisation,
feature engineering, data cleaning) without having to do any expensive data
conversions.

If you're a library author, then we'd love to hear from you. Would this be
useful to you? We expect it to, as the demand for dataframe-agnostic tools
certainly seems to be there:
- https://github.com/mwaskom/seaborn/issues/3277,
- https://github.com/scikit-learn/scikit-learn/issues/25896
- https://github.com/plotly/plotly.py/issues/3637
- (many, many more...)

## Are we there yet? What lies ahead?

No, not yet. This is just a first draft, and a request for comments.

Future plans include:
- increasing the scope of the Standard (currently, the spec is very minimal);
- creating implementations of the Standard for several major dataframe libraries;
- creating a cross-dataframe test-suite;
- aiming to ensure each major dataframe library has a `__dataframe_standard__` method.

## Conclusion

We've introduced the Dataframe Standard, which allows you to write cross-dataframe code.
We learned about its philosophy, as well as what it doesn't aim to be. Finally, we saw
what plans lie ahead - the Standard is in active development, so please watch this space!

## Resources

- Read more on the [official website](https://data-apis.org/dataframe-api/)
- Try out the [proof-of-concept implementation for pandas and polars](https://github.com/MarcoGorelli/impl-dataframe-api)!