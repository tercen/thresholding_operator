library(tercen)
library(dplyr)
library(data.table)

do.flag <- function(df, operand = ">=") {
  
  val <- df[.axisIndex == 0]$.y
  if(length(val) != 1) val <- NaN
  
  thres <- df[.axisIndex == 1]$.y
  if(length(thres) != 1) thres <- NaN
  
  flag <- do.call(operand, list(val, thres))
  return(list(flag = flag))
}

ctx = tercenCtx()

if(length(ctx$yAxis) != 2) stop("Two layers are required.")

operand <- ctx$op.value('operand', as.character, ">=")
pass.flag <- ctx$op.value("pass.flag", as.character, "pass")
fail.flag <- ctx$op.value("fail.flag", as.character, "fail")

df <- ctx %>%
  select(.ci, .ri, .y, .axisIndex) %>%
  as.data.table()

df_out <- df[, do.flag(.SD, operand), by = .(ci = .ci, ri = .ri)]

df_out %>%
  as_tibble() %>%
  mutate(flag = if_else(flag, pass.flag, fail.flag)) %>%
  ctx$addNamespace() %>%
  ctx$save()
