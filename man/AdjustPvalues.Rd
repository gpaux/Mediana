\name{AdjustPvalues}
\alias{AdjustPvalues}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
AdjustPvalues function
}

\description{Computation of adjusted p-values for commonly used multiple testing procedures based on univariate
p-values (Bonferroni, Holm, Hommel, Hochberg, fixed-sequence procedures), commonly used parametric multiple testing procedures (single-step and step-down Dunnett procedures) and multistage gatepeeking procedure.
}

\usage{
AdjustPvalues(pval, proc, par = NA)
}


\arguments{
  \item{pval}{
defines the raw p-values.
}
  \item{proc}{
defines the multiple testing procedure. Several procedures are already implemented in the Mediana package (listed below, along with the required or optional parameters to specify in the \code{par} argument):
\itemize{
\item \code{BonferroniAdj}: Bonferroni procedure. Optional parameter: \code{weight}.
\item \code{HolmAdj}: Holm procedure. Optional parameter: \code{weight}.
\item \code{HochbergAdj}: Hochberg procedure. Optional parameter: \code{weight}.
\item \code{HommelAdj}: Hommel procedure. Optional parameter: \code{weight}.
\item \code{FixedSeqAdj}: Fixed-sequence procedure.
\item \code{DunnettAdj}: Single-step Dunnett procedure. Required parameters:\code{n}.
\item \code{StepDownDunnettAdj}: Step-down Dunnett procedure. Required parameters:\code{n}.
\item \code{ChainAdj}: Family of chain procedures. Required parameters: \code{weight} and \code{transition}.
\item \code{FallbackAdj}: Fallback procedure. Required parameters: \code{weight}.
\item \code{NormalParamAdj}: Parametric multiple testing procedure derived from a multivariate normal distribution. Required parameter: \code{corr}. Optional parameter: \code{weight}.
\item \code{ParallelGatekeepingAdj}: Family of parallel gatekeeping procedures. Required parameters: \code{family}, \code{proc}, \code{gamma}.
\item \code{MultipleSequenceGatekeepingAdj}: Family of multiple-sequence gatekeeping procedures. Required parameters: \code{family}, \code{proc}, \code{gamma}.
\item \code{MixtureGatekeepingAdj}: Family of mixture-based gatekeeping procedures. Required parameters: \code{family}, \code{proc}, \code{gamma}, \code{serial}, \code{parallel}.
}
}

  \item{par}{
defines the parameters associated to the multiple testing procedure
}
}

\details{
This function can be used to adjust p-values according to a multiple testing procedure defines in the \code{proc} argument.

This function computes adjusted p-values and generates decision rules for the Bonferroni, Holm (Holm, 1979), Hommel (Hommel, 1988), Hochberg (Hochberg, 1988) and fixed-sequence (Westfall and Krishen, 2001) procedures. The adjusted p-values are computed using the closure principle (Marcus, Peritz and Gabriel, 1976) in general hypothesis testing problems (equally or unequally weighted null hypotheses). For more information on the algorithms used in the function, see Dmitrienko et al. (2009, Section 2.6).

This function computes adjusted p-values for the single-step Dunnett procedure (Dunnett, 1955) and step-down Dunnett procedure (Naik, 1975; Marcus, Peritz and Gabriel, 1976) in one-sided hypothesis testing problems with a balanced one-way layout and equally weighted null hypotheses. For the Dunnett procedures, it is assumed that the test statistics follow a t distribution. For more information on the algorithms used in the function, see Dmitrienko et al. (2009, Section 2.7).

This function computes adjusted p-values and generates decision rules for multistage parallel gatekeeping procedures in hypothesis testing problems with multiple families of null hypotheses (null hypotheses are assumed to be equally weighted within each family) based on the methodology presented in Dmitrienko, Tamhane and Wiens (2008), Dmitrienko, Kordzakhia and Tamhane (2011) and Dmitrienko, Kordzakhia and Brechenmacher (2016). For more information on parallel gatekeeping procedures (computation of adjusted p-values, independence condition, etc), see Dmitrienko and Tamhane (2009, Section 5.4).
}
\value{ Return a vector of adjusted p-values.
}

\references{
http://gpaux.github.io/Mediana/

Dmitrienko, A., Bretz, F., Westfall, P.H., Troendle, J., Wiens, B.L.,
Tamhane, A.C., Hsu, J.C. (2009). Multiple testing methodology.
\emph{Multiple Testing Problems in Pharmaceutical Statistics}.
Dmitrienko, A., Tamhane, A.C., Bretz, F. (editors). Chapman and
Hall/CRC Press, New York. \cr

Dmitrienko, A., Kordzakhia, G., Tamhane, A.C. (2011). Multistage and mixture
parallel gatekeeping procedures in clinical trials. \emph{Journal of
Biopharmaceutical Statistics}. 21, 726--747.

Dmitrienko, A., Tamhane, A.C. (2009). Gatekeeping procedures in
clinical trials. \emph{Multiple Testing Problems in Pharmaceutical
Statistics}. Dmitrienko, A., Tamhane, A.C., Bretz, F. (editors).
Chapman and Hall/CRC Press, New York. \cr

Dmitrienko, A., Kordzakhia, G., Brechenmacher, T. (2016). Mixture-based gatekeeping procedures for multiplicity problems with multiple sequences of hypotheses. \emph{Journal of Biopharmaceutical Statistics}. 26, 758--780.

Dunnett, C.W. (1955). A multiple comparison procedure for
comparing several treatments with a control. \emph{Journal of the American
Statistical Association}. 50, 1096--1121. \cr

Hochberg, Y. (1988). A sharper Bonferroni procedure for multiple significance testing.
\emph{Biometrika}. 75, 800--802. \cr

Holm, S. (1979). A simple sequentially rejective multiple test procedure.
\emph{Scandinavian Journal of Statistics}. 6, 65--70. \cr

Hommel, G. (1988). A stagewise rejective multiple test procedure based on a
modified Bonferroni test. \emph{Biometrika}. 75, 383--386. \cr

Marcus, R. Peritz, E., Gabriel, K.R. (1976). On closed testing
procedures with special reference to ordered analysis of variance.
\emph{Biometrika}. 63, 655--660. \cr

Naik, U.D. (1975). Some selection rules for comparing \eqn{p} processes
with a standard. \emph{Communications in Statistics. Series A}.
4, 519--535.

Westfall, P. H., Krishen, A. (2001). Optimally weighted, fixed
sequence, and gatekeeping multiple testing procedures. \emph{Journal of
Statistical Planning and Inference}. 99, 25--40. \cr

Wiens, B. (2003). A fixed-sequence Bonferroni procedure for
testing multiple endpoints. \emph{Pharmaceutical Statistics}. 2, 211--215. \cr
Dmitrienko, A., Tamhane, A., Wiens, B. (2008). General multistage
gatekeeping procedures. \emph{Biometrical Journal}. 50, 667--677. \cr

}

\seealso{
See Also \code{\link{MultAdjProc}} and \code{\link{AdjustCIs}}.
}

\examples{
# Bonferroni, Holm, Hochberg, Hommel and Fixed-sequence procedure
proc = c("BonferroniAdj", "HolmAdj", "HochbergAdj", "HommelAdj", "FixedSeqAdj")
rawp = c(0.012, 0.009, 0.023)

# Equally weighted
sapply(proc, function(x) {AdjustPvalues(rawp,
                                        proc = x)})

# Unequally weighted (no effect on the fixed-sequence procedure)
sapply(proc, function(x) {AdjustPvalues(rawp,
                                        proc = x,
                                        par = parameters(weight = c(1/2, 1/4, 1/4)))})

# Dunnett procedures
# Compute one-sided adjusted p-values for the single-step Dunnett procedure
# Three null hypotheses of no effect are tested in the trial:
# Null hypothesis H1: No difference between Dose 1 and Placebo
# Null hypothesis H2: No difference between Dose 2 and Placebo
# Null hypothesis H3: No difference between Dose 3 and Placebo

# Treatment effect estimates (mean  dose-placebo differences)
est = c(2.3,2.5,1.9)

# Pooled standard deviation
sd = 9.5

# Study design is balanced with 180 patients per treatment arm
n = 180

# Standard errors
stderror = rep(sd*sqrt(2/n),3)

# T-statistics associated with the three dose-placebo tests
stat = est/stderror

# One-sided pvalue
rawp = 1-pt(stat,2*(n-1))

# Adjusted p-values based on the Dunnett procedures
# (assuming that each test statistic follows a t distribution)
AdjustPvalues(rawp,proc = "DunnettAdj",par = parameters(n = n))
AdjustPvalues(rawp,proc = "StepDownDunnettAdj",par = parameters(n = n))

# Parallel gatekeeping
# Consider a clinical trial with two families of null hypotheses
# Family 1: Primary null hypotheses (one-sided p-values)
# H1 (Endpoint 1), p1=0.0082
# H2 (Endpoint 2), p2=0.0174
# Family 2: Secondary null hypotheses (one-sided p-values)
# H3 (Endpoint 3), p3=0.0042
# H4 (Endpoint 4), p4=0.0180

# Define raw p-values
rawp<-c(0.0082,0.0174, 0.0042,0.0180)

# Define hHypothesis included in each family
family = families(family1 = c(1, 2),
                  family2 = c(3, 4))

# Define component procedure of each family
component.procedure = families(family1 ="HolmAdj",
                               family2 = "HolmAdj")

# Truncation parameter of each family
gamma = families(family1 = 0.5,
                 family2 = 1)

adjustp = AdjustPvalues(rawp,
                        proc = "ParallelGatekeepingAdj",
                        par = parameters(family = family,
                                         proc = component.procedure,
                                         gamma = gamma))

}
