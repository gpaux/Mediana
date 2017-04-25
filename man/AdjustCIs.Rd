\name{AdjustCIs}
\alias{AdjustCIs}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
AdjustCIs function
}

\description{Computation of simultaneous confidence intervals for selected multiple testing procedures based on univariate p-values (Bonferroni, Holm and fixed-sequence procedures) and commonly used parametric multiple testing procedures (single-step and step-down Dunnett procedures)
}

\usage{
AdjustCIs(est, proc, par = NA)
}


\arguments{
  \item{est}{
defines the point estimates.
}
  \item{proc}{
defines the multiple testing procedure. Several procedures are already implemented in the Mediana package (listed below, along with the required or optional parameters to specify in the \code{par} argument):
\itemize{
\item \code{BonferroniAdj}: Bonferroni procedure. Required parameters:\code{n}, \code{sd} and \code{covprob}. Optional parameter: \code{weight}.
\item \code{HolmAdj}: Holm procedure. Required parameters:\code{n}, \code{sd} and \code{covprob}. Optional parameter: \code{weight}.
\item \code{FixedSeqAdj}: Fixed-sequence procedure. Required parameters:\code{n}, \code{sd} and \code{covprob}.
\item \code{DunnettAdj}: Single-step Dunnett procedure. Required parameters:\code{n}, \code{sd} and \code{covprob}.
\item \code{StepDownDunnettAdj}: Step-down Dunnett procedure. Required parameters:\code{n}, \code{sd} and \code{covprob}.
}
}
\item{par}{
defines the parameters associated to the multiple testing procedure.
}
}

\details{
This function computes one-sided simultaneous confidence limits for the Bonferroni, Holm (Holm, 1979) and fixed-sequence (Westfall and Krishen, 2001) procedures in in general one-sided hypothesis testing problems (equally or unequally weighted null hypotheses), as well as for the single-step Dunnett procedure (Dunnett, 1955) and step-down Dunnett procedure (Naik, 1975; Marcus, Peritz and Gabriel, 1976) in one-sided hypothesis testing problems with a balanced one-way layout and equally weighted null hypotheses.

For non-parametric procedure, the simultaneous confidence intervals are computed using the methods developed in Hsu and Berger (1999), Strassburger and Bretz (2008) and Guilbaud (2008). For more information on the algorithms used in the function, see Dmitrienko et al. (2009, Section 2.6).

For the Dunnett procedures, the simultaneous confidence intervals are computed using the methods developed in Bofinger (1987) and Stefansson, Kim and Hsu (1988). For more information on the algorithms used in the function, see Dmitrienko et al. (2009, Section 2.7).
}
\value{Return a vector of lower simultaneous confidence limits.
}

\references{
http://gpaux.github.io/Mediana/

Bofinger, E. (1987). Step-down procedures for comparison with a control.
\emph{Australian Journal of Statistics}. 29, 348--364. \cr

Dmitrienko, A., Bretz, F., Westfall, P.H., Troendle, J., Wiens, B.L.,
Tamhane, A.C., Hsu, J.C. (2009). Multiple testing methodology.
\emph{Multiple Testing Problems in Pharmaceutical Statistics}.
Dmitrienko, A., Tamhane, A.C., Bretz, F. (editors). Chapman and
Hall/CRC Press, New York. \cr

Dunnett, C.W. (1955). A multiple comparison procedure for
comparing several treatments with a control. \emph{Journal of the American
Statistical Association}. 50, 1096--1121. \cr

Marcus, R. Peritz, E., Gabriel, K.R. (1976). On closed testing
procedures with special reference to ordered analysis of variance.
\emph{Biometrika}. 63, 655--660. \cr

Naik, U.D. (1975). Some selection rules for comparing \eqn{p} processes
with a standard. \emph{Communications in Statistics. Series A}.
4, 519--535. \cr

Stefansson, G., Kim, W.-C., Hsu, J.C. (1988). On confidence sets in multiple
comparisons. \emph{Statistical Decision Theory and Related Topics IV}. Gupta, S.S.,
Berger, J.O. (editors). Academic Press, New York, 89--104.
}

\seealso{
See Also \code{\link{MultAdjProc}} and \code{\link{AdjustPvalues}}.
}

\examples{
# Consider a clinical trial conducted to evaluate the effect of three
# doses of a treatment compared to a placebo with respect to a normally
# distributed endpoint

# Three null hypotheses of no effect are tested in the trial:
# Null hypothesis H1: No difference between Dose 1 and Placebo
# Null hypothesis H2: No difference between Dose 2 and Placebo
# Null hypothesis H3: No difference between Dose 3 and Placebo

# Null hypotheses of no treatment effect are equally weighted
weight<-c(1/3,1/3,1/3)

# Treatment effect estimates (mean  dose-placebo differences)
est<-c(2.3,2.5,1.9)

# Pooled standard deviation
sd<-rep(9.5,3)

# Study design is balanced with 180 patients per treatment arm
n<-180

# Bonferroni, Holm, Hochberg, Hommel and Fixed-sequence procedure
proc = c("BonferroniAdj", "HolmAdj", "FixedSeqAdj", "DunnettAdj", "StepDownDunnettAdj")

# Equally weighted
sapply(proc, function(x) {AdjustCIs(est,
                                    proc = x,
                                    par = parameters(sd = sd,
                                                     n = n,
                                                     covprob = 0.975,
                                                     weight = weight))})
}
