create_caption <- function(data_name, plot_data, over) {
  switch(data_name,
         "australian_industry" = create_caption_australian_industry(plot_data),
         "labour_force" = create_caption_labour_force(plot_data, over),
         "wpi" = create_caption_wpi(plot_data, over)

  )
}

create_caption_wpi <- function(plot_data, over) {
  table_no <-"2b:7b"
  caption_source <- "Source: ABS Wage Price Index, Australia"
  date <- paste0(release(plot_data, "month"),
                 " ",
                 release(plot_data, "year"))
  caption <- paste0(caption_source, " ", date, " (", table_no, ")")

}

create_caption_australian_industry <- function(plot_data) {
  table_no <- "Manufacturing"
  caption_source <- "Source: ABS Australian Industry"
  date <- paste0(lubridate::year(max(plot_data$date))-1,"-",stringr::str_sub(lubridate::year(max(plot_data$date)), 3, 4), " financial year")

  caption <- paste0(caption_source, " ", date, " (", table_no, ")")
  caption
}

create_caption_labour_force <- function(plot_data, over) {

  table_no <- dplyr::case_when(
    over$indicator == "Monthly hours worked in all jobs" ~ "19",
    over$indicator == "Underutilised total" ~ "23",
    over$indicator == "Underemployed total" ~ "23",
    over$indicator == "Underutilisation rate" ~ "23",
    over$indicator == "Underemployment rate" ~ "23",
    TRUE ~ "12"
  )

  if (length(table_no) != 1) {
    table_no <- unique(table_no)
  }

  series_types <- unique(over$series_type)

  caption_table <-  paste0("Source: ABS Labour Force, Australia, ",
                           release(plot_data, "month"), " ",
                           release(plot_data, "year"),
                           " (Table ", paste0(table_no, collapse = ","), ", ", series_types, ")")

  if (length(caption_table) != 1) {
    caption_table <- unique(caption_table)
  }

  caption_table


}

create_caption_treasury <- function(plot_data, indicator) {
  grepl("jobseeker|jobkeeper", over$indicator, ignore.case = TRUE) ~ ""
  grepl("payroll", over$indicator, ignore.case = TRUE) ~ "4"
  dplyr::case_when(

    grepl("jobseeker", over$indicator, ignore.case = TRUE) ~ paste0("Source: Department of Social Services, ",
                                                                    lubridate::month(max(plot_data$date), abbr = FALSE, label = TRUE), " ",
                                                                    lubridate::year(max(plot_data$date))),
    grepl("payroll", over$indicator, ignore.case = TRUE) ~ paste0("Source: ABS Weekly Payroll Jobs and Wages in Australia, ",
                                                                  release(plot_data, "month"), " ",
                                                                  release(plot_data, "year")),
    grepl("jobkeeper", over$indicator, ignore.case = TRUE) ~ paste0("Source: Treasury, ",
                                                                    lubridate::month(max(plot_data$date), abbr = FALSE, label =TRUE), " ",
                                                                    lubridate::year(max(plot_data$date)))
  )
    }
