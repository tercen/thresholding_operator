library(tercen)
library(dplyr)
library(data.table)

ctx = tercenCtx()

if(length(ctx$yAxis) != 2) stop("Two layers are required.")

operand <- ctx$op.value('operand', as.character, ">=")
pass.flag <- ctx$op.value("pass.flag", as.character, "pass")
fail.flag <- ctx$op.value("fail.flag", as.character, "fail")

df <- ctx %>%
  select(.ci, .ri, .y, .axisIndex) %>%
  as.data.table()

df_out <- df[, {
  if(nrow(.SD) != 2) flag = NaN
  else flag <- do.call(operand, list(.y[.axisIndex == 0], .y[.axisIndex == 1]))
  list(flag = flag)
}, by = c(".ci", ".ri")]

df_out %>%
  as_tibble() %>%
  mutate(flag = if_else(flag, pass.flag, fail.flag)) %>%
  ctx$addNamespace() %>%
  ctx$save()
