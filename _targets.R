library(tidyquant)
library(targets)
library(ggplot2)
library(dplyr)
library(arrow)

tar_option_set(
  memory = "transient",
  garbage_collection = TRUE
)

stocks <- c("AAPL", "GOOG", "NFLX", "MSFT")

list(
  tar_target(
    stock_data,
    tq_get(
      x = stocks,
      get  = "stock.prices",
      from = "2010-01-01",
      to   = "2015-12-31")
  ),
  tar_target(
    monthly_return,
    stock_data %>%
      group_by(symbol) %>%
      tq_transmute(
        select = adjusted,
        mutate_fun = periodReturn,
        period = "monthly",
        col_rename = "Ra"
      )
  ),
  tar_target(
    chart,
    stock_data %>%
      ggplot(aes(x = date, y = close, group = symbol)) +
      geom_candlestick(aes(open = open, high = high, low = low, close = close)) +
      geom_ma(ma_fun = SMA, n = 15, color = "darkblue", size = 1) +
      facet_wrap(~ symbol, ncol = 2, scale = "free_y") +
      theme_tq()
  ),
  tar_target(
    save_returns,
    monthly_return %>%
      write_dataset("data/Index_monthly_returns")
  )
)




