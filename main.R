library(tercen)
library(dplyr)

do.flag = function(df, operand = ">=") {
  
  values <- df %>% group_by(.axisIndex) %>% 
    summarise(value = mean(.y)) %>% 
    filter(.axisIndex == 1)
  val <- values$value
  
  if(length(val) == 0) val <- NaN
  
  thresholds <- df %>% group_by(.axisIndex) %>% 
    summarise(value = mean(.y)) %>% 
    filter(.axisIndex == 0)
  thres <- thresholds$value
  
  if(length(thres) == 0) thres <- NaN
  
  flag <- ifelse(
    eval(parse(text = paste0("val ", operand, " thres"))),
    "pass",
    "fail"
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

ctx %>%
  select(.ci, .ri, .y, .axisIndex) %>%
  group_by(.ci, .ri) %>%
  do(do.flag(., operand)) %>%
  ctx$addNamespace() %>%
  ctx$save()