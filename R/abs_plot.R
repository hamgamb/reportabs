#' Generate a time-series plot for ABS labour force indicators.
#'
#' \code{abs_plot()} can automatically generate appropriate plots for ABS
#' Time Series indicators for both static display in documents, or RMarkdown,
#' as well as interactive plots through plotly.
#'
#' @param indicators string. One or more of the indicators to be plot from the labour_force dataset. Allowed values are:
#' \itemize{
#' \item{Employed total}
#' \item{Employed full-time}
#' \item{Employed part-time}
#' \item{Unemployed total}
#' \item{Unemployed looked for full-time work}
#' \item{Unemployed looked for only part-time work}
#' \item{Labour force total}
#' \item{Underemployed total}
#' \item{Underutilised total}
#' \item{Monthly hours worked in all jobs}
#' \item{Monthly hours worked in all jobs (employed full-time)}
#' \item{Monthly hours worked in all jobs (employed part-time)}
#' \item{Not in the labour force (NILF)}
#' \item{Civilian population aged 15 years and over}
#' \item{Employment to population ratio}
#' \item{Unemployment rate}
#' \item{Unemployment rate looked for full-time work}
#' \item{Unemployment rate looked for only part-time work}
#' \item{Participation rate}
#' \item{Underemployment ratio (proportion of employed)}
#' \item{Underemployment rate (proportion of labour force)}
#' \item{Underutilisation rate}
#' }
#'
#' @param states string. Australia, or any State or Territory.
#' Multiple regions are allowed if sex and series_type are both NULL.
#'
#' @param years numeric. The year from which the plot should begin. The default is 2015
#' @param ages (option) string. Defaults to Total (age) which is the sum of all ages.
#' Supply an ABS age range to filter the indicator to only that age group, or multiple ages to compare across age groups.
#' ABS age ranges are:
#' \itemize{
#' \item{15-19 years}
#' \item{15-24 years}
#' \item{15-64 years}
#' \item{20-24 years}
#' \item{25-34 years}
#' \item{35-44 years}
#' \item{45-54 years}
#' \item{55 years and over}
#' \item{55-64 years}
#' \item{65 years and over}
#' \item{Total (age)}
#' }
#'
#' @param sex (option) string. Defaults to Persons which is the sum of Males and Females.
#' Supply a gender to filter the indicator to only that age group, or multiple sex to compare across sex.
#' Applicable sex are:
#' \itemize{
#' \item{Males}
#' \item{Females}
#' \item{Persons}
#' }
#' @param series_types (option) string. Defaults to Seasonally Adjusted. Supply a series_type to show only that series.
#' Available series_types are:
#' \itemize{
#' \item{Seasonally Adjusted}
#' \item{Original}
#' }
#' @param compare_aus (optional) logical. Defaults to TRUE which adds the Australian data for selected indicators.
#' @param plotly (optional) logical. Defaults to FALSE which creates a ggplot2 plot. Select TRUE to create a plotly plot.
#' Note that some aspects of the plot are unavailable if plotly = TRUE, including subtitles, and captions.
#' @param data (optional) NULL by default. Specify a data frame or tibble object to use data other than the labour_force data
#' included in the `aitidata` package.
#' @param void (optional) logical. Defaults to FALSE. Specify TRUE to remove all plot elements except for the line.
#'
#' @return A ggplot2 time-series plot or a plotly time-series plot if plotly = TRUE
#'
#' @name abs_plot
#'
#' @importFrom rlang .data
#' @export
#'
abs_plot <- function(data = NULL,
                     indicators,
                     states,
                     years = 2015,
                     ages = "Total (age)",
                     sex = "Persons",
                     series_types = "Seasonally Adjusted",
                     compare_aus = TRUE,
                     plotly = FALSE,
                     void = FALSE) {

  #Error checking - only one variable is allowed to be of length > 1

  if ((length(ages) > 1 & length(states) > 1 ) |
    (length(sex) > 1 & length(states) > 1) |
    (length(ages) > 1 & length(sex) > 1)) {
    stop("You can't combine multiple states with multiple other variables")
  }



  #Determine what is being plot

  if (length(states) == 1 & length(sex) > 1) {
    col_var <- "gender"
    n_cols <- length(sex)
    compare_aus <- FALSE
  } else if (length(states) == 1 & length(ages) > 1) {
    col_var <- "age"
    n_cols <- length(ages)
    compare_aus <- FALSE
  } else if (length(ages == 1) & length(sex) == 1) {
    col_var <- "state"
    n_cols <- length(states)
  }

  #Should Australia be added?
  if (compare_aus & !"Australia" %in% states) {
    states <- c(states, "Australia")
    n_cols <- n_cols + 1
  }

  if (is.null(data)) {
    plot_data <- aitidata::labour_force
  } else if (is.data.frame(data)) {
    plot_data <- data
  } else if (any(grepl(".xls", data))) {
    plot_data <- readabs::read_abs_local(filenames = data, path = here::here("data"))
    plot_data <- reportabs::aitify(plot_data)
  }

  if (indicators %in% c("Monthly hours worked in all jobs (employed full-time)",
                                 "Monthly hours worked in all jobs (employed part-time)",
                                 "Employed part-time",
                                 "Unemployed looked for full-time work",
                                 "Unemployed looked for only part-time work",
                                 "Unemployment rate looked for full-time work",
                                 "Unemployment rate looked for only part-time work")) {
    series_types <- "Original"
  }

  #Make a couple of assumptions about the data - ie non labour force data is unlikely to have a gender or age dimension..?

  plot_data <- plot_data %>%
    dplyr::filter(.data$indicator == indicators,
                  .data$gender %in% sex,
                  .data$series_type == series_types,
                  .data$age %in% ages,
                  .data$year >= years) %>%
    dplyr::group_by(.data$state, .data$gender, .data$age) %>%
    dplyr::mutate(index = 100 * .data$value / .data$value[1]) %>%
    dplyr::ungroup() %>%
    dplyr::filter(.data$state %in% states)


  #Should the plot be indexed?
  #Index if: Comparing 2 or more states & the indicator is not a rate

  if (length(states) >= 2 & (!grepl(pattern = "rate", x = indicators) & !grepl(pattern = "ratio", x = indicators))) {
    plot_index <- TRUE
    y_label <- scales::comma_format(scale = 1)
  } else if ((length(states) == 1) & (grepl(pattern = "rate", x = indicators) & grepl(pattern = "ratio", x = indicators))) {
    plot_index <- FALSE
    y_label <- scales::percent_format(scale = 1)
  } else if (grepl(pattern = "rate", x = indicators)) {
    plot_index <- FALSE
    y_label <- scales::percent_format(scale = 1)
  } else {
    plot_index <- FALSE
    plot_scale <- ifelse(min(plot_data$value > 1e6), 1e-6, 1)
    plot_suffix <- ifelse(min(plot_data$value > 1e6), "m", "")
    y_label <- scales::comma_format(scale = plot_scale, suffix = plot_suffix)
  }

  table_no <- dplyr::case_when(
    unique(plot_data$indicator) == "Monthly hours worked in all jobs" ~ 19,
    unique(plot_data$indicator) == "Underutilised total" ~ 23,
    unique(plot_data$indicator) == "Underemployed total" ~ 23,
    unique(plot_data$indicator) == "Underutilisation rate" ~ 23,
    unique(plot_data$indicator) == "Underemployment rate" ~ 23,
    TRUE ~ 12
  )

  num_months <- as.numeric(max(plot_data$month))

  plot_month <- lubridate::month(min(plot_data$date), abbr = FALSE, label = TRUE)
  plot_year <- lubridate::year(min(plot_data$date))
  plot_caption <- stringr::str_c("Source: ABS Labour Force, Australia, ",
                                 reportabs::release(plot_data, "month"), " ",
                                 reportabs::release(plot_data, "year"),
                                 " (Table ", table_no,  ", ",
                                 series_types, ")")

  if(plot_index) {
    plot_title <- toupper(paste0(indicators, ": ", paste0(strayr::strayr(states), collapse = " & " )))

    plot_subtitle <- paste("Index (Base:", plot_month, plot_year, "= 100)")
    y_var <- "index"
  } else {
    plot_title <- toupper(paste0(indicators, ": ", paste0(strayr::strayr(states), collapse = " & " )))
    plot_subtitle <- NULL
    y_var <- "value"
  }

  p <- ggplot2::ggplot(plot_data,
                       ggplot2::aes_(x = ~ date,
                                     y = as.name(y_var),
                                     colour = as.name(col_var))) +
    ggplot2::geom_line() +
    ggplot2::scale_x_date(breaks = scales::pretty_breaks(n = min(num_months, 6)), date_labels = "%b-%Y") +
    ggplot2::scale_y_continuous(labels = y_label) +
    aititheme::aiti_colour_manual(n = n_cols, breaks = states)

  if (!void) {
    p <- p + ggplot2::labs(
      x = NULL,
      y = NULL,
      title = plot_title,
      subtitle = plot_subtitle,
      caption = plot_caption
    ) + ggplot2::guides(colour = ggplot2::guide_legend()) +
      aititheme::theme_aiti(legend = 'bottom')
  } else { p <- p + ggplot2::theme_void() + ggplot2::theme(legend.position = "none")}


  if(plotly) {

    hover_format <- ifelse(plot_data$unit[1] == "000", as_comma, as_percent)


    p <- p +
      ggplot2::aes(group = 1,
                   text = paste0(.data$state,
                                 "<br>Gender: ", .data$gender,
                                 "<br>Age: ", .data$age,
                                 "<br>Date: ", format(date, "%b-%Y"),
                                 "<br>", .data$indicator, ": ", hover_format(.data$value))) +
      ggplot2::geom_point(shape = 1, size = 1) +
      aititheme::theme_aiti(legend = "bottom", base_family = "Roboto")

    p <- plotly::ggplotly(p, tooltip = "text") %>%
      plotly::layout(autosize = TRUE,
                     legend = list(orientation = "h",
                                   y = -0.15),
                     annotations = list(
                       x = 1,
                       y = -0.2,
                       showarrow = FALSE,
                       xref = "paper",
                       yref = "paper",
                       xanchor = "right",
                       yanchor = "auto",
                       text = "Source: AITI Economic Indicators"
                     )
                     # images = list(
                     #   list(source = "https://raw.githubusercontent.com/hamgamb/aitidash/master/www/statz.png",
                     #        x = 0.95,
                     #        y = -0.125,
                     #        sizex = 0.15,
                     #        sizey = 0.15,
                     #        opacity = 0.8))
                     )


  }

  return(p)

}




