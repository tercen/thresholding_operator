# Thresholding

##### Description

Return a pass/fail value based on a thresholding value, per cell

##### Usage

Input projection|.
---|---
`y-axis - Layer 1`        | numeric, value to flag
`y-axis - Layer 2`        | numeric, threshold value

Input parameters|.
---|---
`operand`        | operand for comparison of values to threshold
`pass.flag`        | Name to give to observations that satisfy the condition.
`fail.flag`        | Name to give to observations that do not satisfy the condition.

Output relations|.
---|---
`flag`        | pass / fail flag

##### See Also

[flag_operator](https://github.com/tercen/flag_operator)

