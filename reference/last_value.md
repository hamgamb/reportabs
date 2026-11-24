# Find the value for an indicator for this month last year, or the previous month.

Find the value for an indicator for this month last year, or the
previous month.

## Usage

``` r
last_value(data, filter_with, ym = "year", print = TRUE)
```

## Arguments

- data:

  a dataframe of cleaned ABS Time Series data returned from readabs

- filter_with:

  a list of variables to filter the dataframe on. Valid variables
  include gender, age, indicator, and series type.

- ym:

  one of "year", "quarter", or "month" to return the value this time
  last year (the default), quarter, or month.

- print:

  logical to pass the numeric on to as_comma or as_percent for printing.
  Defaults to TRUE

## Value

numeric if print == FALSE, character if print == TRUE

## Examples

``` r
library(reportabs)
labour_force_briefing <- read_absdata("labour_force_briefing")
#> Reading labour_force_briefing file found in /tmp/RtmpbgUnA5
last_value(labour_force_briefing, list(indicator = "Employed total",
series_type = "Seasonally Adjusted"))
#> [1] "14,655"
```
