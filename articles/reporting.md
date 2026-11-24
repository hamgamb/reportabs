# Reporting ABS Time Series Data

``` r

library(reportabs)
labour_force <- read_absdata("labour_force")
```

``` r

average_over(data = labour_force, filter_with = list(indicator = "Employed total"), between = c("2010-01-01", "2020-01-01"))
#> [1] 1975.497
```

``` r

change(data = labour_force, filter_with = list(indicator = "Employed total"))
#> Warning: implied series_type = 'Trend'
#> [1] "increased by 161 (1.1%) to 14,798"
```

Numbers can be formatted nicely for inclusion in documents using
[`as_comma()`](https://amwu-nrc.github.io/reportabs/reference/as_comma.md),
[`as_percent()`](https://amwu-nrc.github.io/reportabs/reference/as_percent.md)
and
[`as_percentage_point()`](https://amwu-nrc.github.io/reportabs/reference/as_percentage_point.md).
