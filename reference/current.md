# Return the most recent (current) value for an indicator

Return the most recent (current) value for an indicator

## Usage

``` r
current(data, filter_with, print = TRUE)
```

## Arguments

- data:

  a dataframe of cleaned ABS Time Series data returned from readabs

- filter_with:

  a list of variables to filter the dataframe on. Valid variables
  include gender, age, indicator, and series type.

- print:

  logical. If TRUE (default) current() returns a string. Specify FALSE
  to return a number.

## Value

String if print == TRUE. Number if print == FALSE

## Examples

``` r
library(reportabs)
labour_force_briefing <- read_absdata("labour_force_briefing")
#> Reading labour_force_briefing file found in /tmp/RtmpbgUnA5
current(labour_force_briefing, list(indicator = "Employed total",
series_type = "Seasonally Adjusted"))
#> # A tibble: 21 × 7
#>    date       sex     state             series_type       unit  indicator  value
#>    <date>     <chr>   <chr>             <chr>             <chr> <chr>      <dbl>
#>  1 2026-10-01 Persons Australia         Seasonally Adjus… 000   Employed… 14739.
#>  2 2026-10-01 Persons New South Wales   Seasonally Adjus… 000   Employed…  4505.
#>  3 2026-10-01 Persons Victoria          Seasonally Adjus… 000   Employed…  3826.
#>  4 2026-10-01 Persons Queensland        Seasonally Adjus… 000   Employed…  3031.
#>  5 2026-10-01 Persons South Australia   Seasonally Adjus… 000   Employed…   986.
#>  6 2026-10-01 Persons Western Australia Seasonally Adjus… 000   Employed…  1689.
#>  7 2026-10-01 Persons Tasmania          Seasonally Adjus… 000   Employed…   281.
#>  8 2026-10-01 Males   Australia         Seasonally Adjus… 000   Employed…  7645.
#>  9 2026-10-01 Males   New South Wales   Seasonally Adjus… 000   Employed…  2350.
#> 10 2026-10-01 Males   Victoria          Seasonally Adjus… 000   Employed…  1982.
#> # ℹ 11 more rows
```
