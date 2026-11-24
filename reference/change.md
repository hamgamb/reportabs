# Create a string describing whether an indicator has increased or decreased over the year, or over the previous month

Create a string describing whether an indicator has increased or
decreased over the year, or over the previous month

## Usage

``` r
change(
  data,
  filter_with,
  type = "id",
  ym = "year",
  at_year = NULL,
  at_month = NULL
)
```

## Arguments

- data:

  a dataframe of cleaned ABS Time Series data returned from
  `readabs::read_abs()`

- filter_with:

  a list of variables on which to filter the dataframe.

- type:

  controls the wording of the text. Options are 'id' for increased or
  decreased, "ab" for above or below, "rf" for risen or fallen and
  "present" for an increase or a decrease.

- ym:

  ym = "year" to calculate the change over the year, or ym = "month" to
  calculate the change over the month

- at_year:

  By default, change() returns the difference over the past 12 months
  (to the current year). at_year and at_month can be specified to
  calculate the change between the current value, and the value as at
  at_year and at_month.

- at_month:

  By default, change() returns the difference over the past 12 months
  (to the current year). at_year and at_month can be specified to
  calculate the change between the current value, and the value as at
  at_year and at_month.

## Value

character

## Examples

``` r
library(reportabs)
labour_force_briefing <- read_absdata("labour_force_briefing")
#> Reading labour_force_briefing file found in /tmp/RtmpbgUnA5
change(labour_force_briefing,
filter_with = list(indicator = "Employed total", series_type = "Seasonally Adjusted"))
#> [1] "increased by 84 (0.6%) to 14,739"
```
