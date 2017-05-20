## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(data.frame(Arm = c("Placebo",
                   "Dose L",
                   "Dose M",
                   "Dose H"),
           Mean = c(16,
                    19.5,
                    21,
                    21),
           SD = rep(18,4)))

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(data.frame(Sample = c("Placebo M-",
                         "Placebo M+",
                         "Treament M-",
                         "Treatment M+"),
              Mean = c(0.12,
                       0.12,
                       0.24,
                       0.30),
              SD = rep(0.45,4)))

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(data.frame(Endpoint = c("Progression-free survival",
                         "",
                         "",
                         "Overall survival",
                         "",
                         ""),
              Statistic = c(rep(c("Median time (months)",
                                  "Hazard rate",
                                  "Hazard ratio"),2)),
              Placebo = c(6, 0.116, 0.67,
                          15, 0.046, 0.79),
              Treatment = c(9, 0.077,"",19,0.036,"")))

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(data.frame(Endpoint = c("ACR20 (%)",
                                             "",
                                             "",
                                             "HAQ-DI (mean (SD))",
                                             "",
                                             ""),
                                "Outcome parameter set" = c(rep(c("Conservative",
                                                                "Standard",
                                                                "Optimistic"),2)),
                                Placebo = c("30%", "30%", "30%",
                                            "-0.10 (0.50)", "-0.10 (0.50)", "-0.10 (0.50)"),
                                "Dose L" = c("40%", "45%", "50%",
                                           "-0.20 (0.50)", "-0.25 (0.50)", "-0.30 (0.50)"),
                                "Dose H" = c("50%", "55%", "60%",
                                           "-0.30 (0.50)", "-0.35 (0.50)", "-0.40 (0.50)")))

## ---- results = "asis", echo = FALSE-------------------------------------
pander::pandoc.table(data.frame("Outcome parameter set" = c("Standard",
                                                            "",
                                                            "",
                                                            "",
                                                            "Optimistic",
                                                            "",
                                                            "",
                                                            ""),
                                "Arm" = c(rep(c("Placebo",
                                                "Dose L",
                                                "Dose M",
                                                "Dose H"),2)),
                                "Mean" = c(16, 19.5, 21, 21,
                                           16, 20, 21, 22),
                                "SD" = c(rep(18,8))))

