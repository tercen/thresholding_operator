library(tercen)
library(dplyr)

do.flag = function(df, operand = ">=", pass.flag = "pass", fail.flag = "fail") {
  
  values <- df %>% group_by(.axisIndex) %>% 
    summarise(value = mean(.y, na.rm = TRUE)) %>% 
    filter(.axisIndex == 0)
  val <- values$value
  
  if(length(val) == 0) val <- NaN
  
  thresholds <- df %>% group_by(.axisIndex) %>% 
    summarise(value = mean(.y, na.rm = TRUE)) %>% 
    filter(.axisIndex == 1)
  thres <- thresholds$value
  
  if(length(thres) == 0) thres <- NaN
  
  flag <- ifelse(
    eval(parse(text = paste0("val ", operand, " thres"))),
    pass.flag,
    fail.flag
  )

  return(data.frame(
    .ri = df$.ri[1],
    .ci = df$.ci[1],
    flag = flag
  ))
}

ctx = tercenCtx()

if (nrow(unique(ctx$select(c('.axisIndex')))) != 2)
  stop("Two layers are required.")

operand <- ifelse(
  !is.null(ctx$op.value('operand')),
  as.character(ctx$op.value('operand')),
  ">="
)

pass.flag <- "pass"
if(!is.null(ctx$op.value("pass.flag"))) pass.flag <- ctx$op.value("pass.flag")
fail.flag <- "fail"
if(!is.null(ctx$op.value("fail.flag"))) fail.flag <- ctx$op.value("fail.flag")

df_out <- ctx %>%
  select(.ci, .ri, .y, .axisIndex) %>%
  group_by(.ci, .ri) %>%
  do(do.flag(., operand, pass.flag, fail.flag)) %>%
  ctx$addNamespace() %>%
  ctx$save()
