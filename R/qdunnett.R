# QDunnett is a secondary function which computes a quantile of the
# Dunnett distribution in one-sided hypothesis testing problems
# with a balanced one-way layout and equally weighted null hypotheses
qdunnett<-function(x,df,m)
  # X, Argument
  # DF, Number of degrees of freedom
  # M, Number of comparisons
{
  # Correlation matrix
  corr = matrix(0.5,m,m)
  diag(corr) = 1
  temp<-mvtnorm::qmvt(x,interval=c(0,4),tail="lower.tail",df=df, delta=rep(0,m),corr=corr, algorithm=mvtnorm::GenzBretz(maxpts=25000, abseps=0.00001, releps=0))[1]
  return(temp$quantile)
}
# End of qdunnett
