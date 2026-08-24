# Load .parquet file from a remote connection

Load .parquet file from a remote connection

## Usage

``` r
parquet_from_url(url)
```

## Arguments

- url:

  a character url

## Value

a dataframe as created by
[`arrow::read_parquet()`](https://arrow.apache.org/docs/r/reference/read_parquet.html);
a zero-row `data.table` when the download or read fails.
