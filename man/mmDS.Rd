% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mmDS.R, R/utils-mmDS.R
\name{mmDS}
\alias{mmDS}
\alias{.mm_dream}
\alias{.mm_vst}
\title{DS analysis using mixed-models (MM)}
\usage{
mmDS(x, coef = NULL, covs = NULL, method = c("dream", "vst",
  "poisson", "nbinom", "hybrid"), n_cells = 10, n_samples = 2,
  min_count = 1, min_cells = 20, n_threads = 8, verbose = TRUE,
  dup_corr = FALSE, trended = FALSE, vst = c("sctransform",
  "DESeq2"), bayesian = FALSE, blind = TRUE, REML = TRUE,
  ddf = c("Satterthwaite", "Kenward-Roger", "lme4"))

.mm_dream(x, coef = NULL, covs = NULL, dup_corr = FALSE,
  trended = FALSE, ddf = c("Satterthwaite", "Kenward-Roger"),
  n_threads = 1, verbose = FALSE)

.mm_vst(x, vst = c("sctransform", "DESeq2"), coef = NULL,
  covs = NULL, bayesian = FALSE, blind = TRUE, REML = TRUE,
  ddf = c("Satterthwaite", "Kenward-Roger", "lme4"), n_threads = 1,
  verbose = FALSE)
}
\arguments{
\item{x}{a \code{\link[SingleCellExperiment]{SingleCellExperiment}}.}

\item{coef}{character specifying the coefficient to test. 
If NULL (default), will test the last level of \code{"group_id"}.}

\item{covs}{character vector of \code{colData(x)} 
column names to use as covariates.}

\item{method}{a character string. 
Either \code{"dream"} (default, lme4 with voom-weights), 
\code{"vst"} (variance-stabilizing transformation), 
\code{"poisson"} (poisson GLM-MM), 
\code{"nbinom"} (negative binomial GLM-MM), 
\code{"hybrid"} (combination of pseudobulk and poisson methods)
or a function accepting the same arguments.}

\item{n_cells}{number of cells per cluster-sample 
required to consider a sample for testing.}

\item{n_samples}{number of samples per group 
required to consider a cluster for testing.}

\item{min_count}{numeric. For a gene to be tested in a given cluster, 
at least \code{min_cells} must have a count >= \code{min_count}.}

\item{min_cells}{number (or fraction, if < 1) of cells with a count >
\code{min_count} required for a gene to be tested in a given cluster.}

\item{n_threads}{number of threads to use.}

\item{verbose}{logical specifying whether messages 
on progress and a progress bar should be displayed.}

\item{dup_corr}{logical; whether to use
\code{\link[limma:dupcor]{duplicateCorrelation}}.}

\item{trended}{logical; whether to use expression-dependent variance priors
in \code{\link[limma]{eBayes}}.}

\item{vst}{method to use as variance-stabilizing transformations.
\code{"sctransform"} for \code{\link[sctransform]{vst}}; \code{"DESeq2"} 
for \code{\link[DESeq2]{varianceStabilizingTransformation}}.}

\item{bayesian}{logical; whether to use bayesian mixed models.}

\item{blind}{logical; whether to ignore experimental design for the vst.}

\item{REML}{logical; whether to maximize REML instead of log-likelihood.}

\item{ddf}{character string specifying the method for estimating
the effective degrees of freedom. For \code{method = "dream"},
either \code{"Satterthwaite"} (faster) or \code{"Kenward-Roger"}
(more accurate); see \code{?variancePartition::dream} for details.
For \code{method = "vst"}, method \code{"lme4"} is also valid;
see \code{\link[lmerTest]{contest.lmerModLmerTest}}.}

\item{...}{additional parameters passed to the method function.}
}
\value{
a data.frame
}
\description{
Performs cluster-wise DE analysis by fitting cell-level models.
}
\details{
\code{.mm_dream} and \code{.mm_vst} expect cells from a single cluster,
and do not perform filtering or handle incorrect parameters well.
Meant to be called by \code{mmDS} with \code{method = c("dream", "vst")} and
\code{vst = c("sctransform", "DESeq2")} to be applied across all clusters.
\describe{
\item{\code{method = "dream"}}{
  \code{variancePartition}'s voom-lme4-implementation
  of mixed models for RNA-seq data; function \code{dream}.}
\item{\code{method = "vst"}}{
  \describe{
  \item{\code{vst = "sctransform"}}{
    \code{lmer} or \code{blmer} mixed models on
    \code{\link[sctransform]{vst}} transformed counts.}
  \item{\code{vst = "DESeq2"}}{
    \code{\link[DESeq2]{varianceStabilizingTransformation}}
    followed by \code{lme4} mixed models.}}}}
}
\section{Functions}{
\itemize{
\item \code{.mm_dream}: see details.

\item \code{.mm_vst}: see details.
}}

\examples{
data(sce)
# subset "B cells" cluster
sce <- sce[, sce$cluster_id == "B cells"]
sce$cluster_id <- droplevels(sce$cluster_id)

# downsample to 100 genes
cs_by_s <- split(colnames(sce), sce$sample_id)
gs <- sample(nrow(sce), 100)
sce <- sce[gs, ]

res <- mmDS(sce, method = "dream", 
    n_threads = 1, verbose = FALSE)
head(res$`B cells`)

}
\references{
Crowell, HL, Soneson, C, Germain, P-L, Calini, D, 
Collin, L, Raposo, C, Malhotra, D & Robinson, MD: 
On the discovery of population-specific state transitions from 
multi-sample multi-condition single-cell RNA sequencing data. 
\emph{bioRxiv} \strong{713412} (2018). 
doi: \url{https://doi.org/10.1101/713412}
}
\author{
Pierre-Luc Germain & Helena L Crowell
}
