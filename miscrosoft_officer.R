library(officer)

ft <- flextable(airquality[ sample.int(10),])
ft <- add_header_row(ft,
                     colwidths = c(4, 2),
                     values = c("Air quality", "Time")
)
ft <- theme_vanilla(ft)
ft <- add_footer_lines(ft, "Daily air quality measurements in New York, May to September 1973.")
ft <- color(ft, part = "footer", color = "#666666")
ft <- set_caption(ft, caption = "New York Air Quality Measurements")
