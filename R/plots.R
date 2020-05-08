#' Employment Time Series
#'
#' @param states which states to include in the plot
#' @param dbf how many years does the data span? this adjsuts the x axis scale accordingly
#'
#' @return a ggplot2 object
#' @export abs_employment
#'
#' @examples
abs_employment <- function(states,  years = 5, compare_aus = TRUE, ages = "Total (age)", genders = "Persons", series_types = "Trend") {


  plot_data <- labour_force %>%
    dplyr::filter(indicator == "Employed total",
      gender %in% genders,
      series_type == series_types,
      age %in% ages,
      year >= max(.$year) - years) %>%
    dplyr::group_by(state) %>%
    dplyr::mutate(index = 100*value/value[1]) %>%
    dplyr::ungroup()

  plot_month <- lubridate::month(min(plot_data$date), abbr = FALSE, label = TRUE)
  plot_year <- lubridate::year(min(plot_data$date))

  if(compare_aus) {
    plot_title <- stringr::str_c("EMPLOYMENT: ", stringr::str_to_upper(strayr::strayr(states)), " & AUSTRALIA")
    plot_data <- plot_data %>%
      dplyr::filter(state %in% c(states, "Australia"))
    y_lab <- paste("Index (Base:", plot_month, plot_year, "=100)")
    y_var <- "index"
  } else {
    plot_title <- stringr::str_c("EMPLOYMENT: ", stringr::str_to_upper(states))
    plot_data <- plot_data %>%
      dplyr::filter(state %in% states)
    y_lab <- NULL
    y_var <- "value"
  }

  plot_caption <- stringr::str_c("Source: ABS Labour Force Survey (6202.0, Table 12, ", series_types, ")")

  plot <- ggplot2::ggplot(plot_data, ggplot2::aes_(x = ~date, y = as.name(y_var), colour = ~state)) +
    ggplot2::geom_line() +
    ggplot2::labs(
      x = NULL,
      y = y_lab,
      title = plot_title,
      caption =  plot_caption
      ) +
    ggplot2::scale_x_date(date_breaks = date_breaks_format(years), labels = scales::date_format("%b-%y")) +
    ggplot2::theme_classic() +
    ggplot2::theme(legend.position = 'bottom',
      legend.title = ggplot2::element_blank(),
      legend.background = ggplot2::element_blank(),
      legend.box.background = ggplot2::element_rect(colour = 'black'))

  return(plot)

}

#' Unemployment (level) Time Series
#'
#' @param states
#' @param dbf
#'
#' @return
#' @export abs_unemployment
#'
#' @examples
abs_unemployment <- function(states, years, compare_aus = TRUE,  ages = "Total (age)", genders = "Persons", series_types = "Trend") {

  plot_data <- labour_force %>%
    dplyr::filter(indicator == "Unemployed total",
      gender == genders,
      age == ages,
      series_type == series_types,
      year >= max(.$year) - years) %>%
    dplyr::group_by(state) %>%
    dplyr::mutate(index = 100*value/value[1])

  plot_month <- lubridate::month(min(plot_data$date), abbr = FALSE, label = TRUE)
  plot_year <- lubridate::year(min(plot_data$date))

  if(compare_aus) {
    plot_title <- stringr::str_c("UNEMPLOYMENT: ", stringr::str_to_upper(strayr::strayr(states)), " & AUSTRALIA")
    plot_data <- plot_data %>%
      dplyr::filter(state %in% c(states, "Australia"))
    y_lab <- paste("Index (Base:", plot_month, plot_year, "=100)")
    y_var <- "index"
  } else {
    plot_title <- stringr::str_c("UNEMPLOYMENT: ", stringr::str_to_upper(states))
    plot_data <- plot_data %>%
      dplyr::filter(state %in% states)
    y_lab <- NULL
    y_var <- "value"
  }

  plot <- ggplot2::ggplot(plot_data, ggplot2::aes(x = date, y = index, colour = state)) +
    ggplot2::geom_line() +
    ggplot2::labs(x = NULL,
      y = paste("Index (Base:", plot_month, plot_year, "=100)"),
      title = plot_title,
      caption = stringr::str_c("Source: ABS Labour Force Survey (6202.0, Table 12, ", series_types,")")) +
    ggplot2::scale_x_date(date_breaks = date_breaks_format(years), labels = scales::date_format("%b-%y")) +
    ggplot2::theme_classic() +
    ggplot2::theme(legend.position = 'bottom',
      legend.title = ggplot2::element_blank(),
      legend.background = ggplot2::element_blank(),
      legend.box.background = ggplot2::element_rect(colour = 'black'))


  return(plot)

}

#' ABS Unemployment Rate Time Series
#'
#' @param states
#' @param dbf
#'
#' @return
#' @export abs_unemployment_rate
#'
#' @examples
abs_unemployment_rate <- function(states, years, compare_aus = TRUE,  ages = "Total (age)", genders = "Persons", series_types = "Trend") {

  plot_data <- labour_force %>%
    filter(indicator == "Unemployment rate",
      gender == "Persons",
      age == "Total (age)",
      series_type == series_types,
      year >= max(.$year) - years)

  plot_month <- lubridate::month(min(plot_data$date), abbr = FALSE, label = TRUE)
  plot_year <- lubridate::year(min(plot_data$date))

  if(compare_aus) {
    plot_title <- stringr::str_c("UNEMPLOYMENT RATE: ", stringr::str_to_upper(strayr::strayr(states)), " & AUSTRALIA")
    plot_data <- plot_data %>%
      dplyr::filter(state %in% c(states, "Australia"))
    y_lab <- paste("Index (Base:", plot_month, plot_year, "=100)")
    y_var <- "index"
  } else {
    plot_title <- stringr::str_c("UNEMPLOYMENT RATE: ", stringr::str_to_upper(states))
    plot_data <- plot_data %>%
      dplyr::filter(state %in% states)
    y_lab <- NULL
    y_var <- "value"
  }

  plot <- ggplot2::ggplot(plot_data, ggplot2::aes(x = date, y = value, colour = state)) +
    ggplot2::geom_line() +
    ggplot2::labs(x = NULL,
      y = NULL,
      title = plot_title,
      caption = stringr::str_c("Source: ABS Labour Force Survey (6202.0, Table 12, ", series_types)) +
    ggplot2::scale_x_date(date_breaks = date_breaks_format(years), labels = scales::date_format("%b-%y")) +
    ggplot2::theme_classic() +
    ggplot2::theme(legend.position = 'bottom',
      legend.title = ggplot2::element_blank(),
      legend.background = ggplot2::element_blank(),
      legend.box.background = ggplot2::element_rect(colour = 'black'))

  return(plot)
  }

#' Convenience function to draw a bar chart of employment growth, by different types
#'
#' @param data
#' @param filter_with
#' @param year_since
#'
#' @return
#' @export employment_growth
#'
#' @examples
employment_growth <- function(states, years = 2010) {

  plot_data <- labour_force %>%
    dplyr::filter(indicator %in% c("Employed total", "Employed full-time", "Employed part-time"),
                  state == states,
                  gender == "Persons") %>%
    dplyr::group_by(year, indicator) %>%
    dplyr::summarise(value = mean(value)) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(indicator) %>%
    dplyr::mutate(value = (value - dplyr::lag(value))/value) %>%
    dplyr::ungroup() %>%
    dplyr::filter(year >= years)

  p_emp_growth <- plot_data %>%
    ggplot2::ggplot(ggplot2::aes(x = as.factor(year), y = value, fill = indicator)) +
    ggplot2::geom_bar(stat = 'identity', position = 'dodge') +
    ggplot2::scale_y_continuous(labels = scales::percent_format(scale = 100)) +
    ggplot2::labs(x = NULL,
      y = "Average Annual Growth (%)",
      title = stringr::str_c("EMPLOYMENT GROWTH: ", states),
      caption = stringr::str_c("Source: ABS 6202.0, ", format(max(labour_force$date), "%B %Y"))) +
    ggplot2::theme(legend.position = 'bottom',
                   legend.title = ggplot2::element_blank(),
                   legend.background = ggplot2::element_blank(),
                   legend.box.background = ggplot2::element_rect(colour = 'black'))

  return(p_emp_growth)

}

#' Draw employment by industry bar chart, coloured by underemployment levels
#'
#' @return ggplot2 object
#' @export underemployment_industry
#'
#' @examples
underemployment_industry <- function() {

  data <- reportabs::employment_industry %>%
    dplyr::filter(indicator %in% c("Underemployment ratio (proportion of employed)", "Employed total"),
                  state == "Australia",
                  gender == "Persons",
                  age == "Total (age)",
                  industry != "Total (industry)") %>%
    dplyr::group_by(year, industry, indicator) %>%
    dplyr::summarise(value = mean(value)/1e6) %>%
    dplyr::ungroup() %>%
    tidyr::pivot_wider(names_from = indicator, values_from = value) %>%
    dplyr::filter(year == max(.$year))

  plot <- data %>%
    ggplot2::ggplot(ggplot2::aes(x = reorder(industry, `Employed total`), y = `Employed total`, fill = `Underemployment ratio (proportion of employed)`)) +
    ggplot2::geom_bar(stat = 'identity') +
    ggplot2::coord_flip() +
    ggplot2::labs(
      y = "Total Employment (Millions)",
      x = NULL
    ) +
    ggplot2::theme(legend.position = 'none',
                   plot.background = ggplot2::element_blank())
  return(plot)

}


abs_hoursworked <- function(states, years, series_types = "Trend") {

}