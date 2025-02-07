% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gene-getters.R
\name{isGene}
\alias{isGene}
\title{Tests if input is the name of a gene in a target object.}
\usage{
isGene(test, object = DEFAULT, return.values = FALSE)
}
\arguments{
\item{test}{String or vector of strings, the "potential.gene.name"(s) to check for.}

\item{object}{A Seurat, SingleCellExperiment, or \linkS4class{RNAseq} object to work with, OR the name of the object in "quotes".}

\item{return.values}{Logical which sets whether the function returns a logical \code{TRUE}/\code{FALSE} versus the \code{TRUE} \code{test} values . Default = \code{FALSE}
REQUIRED, unless '\code{DEFAULT <- "object"}' has been run.}
}
\value{
Returns a logical or logical vector indicating whether each instance in \code{test} is a gene within the \code{object}.
Alternatively, returns the values of \code{test} that were indeed genes if \code{return.values = TRUE}.
}
\description{
Tests if input is the name of a gene in a target object.
}
\examples{

pbmc <- Seurat::pbmc_small

# To see all genes of an object
getGenes(pbmc)

# To test if something is a gene in an object:
isGene("CD14", object = "pbmc") # TRUE
isGene("CD12345", pbmc) # FALSE

# Note: if DEFAULT <- "pbmc" is run beforehand, the object input can be skipped.
DEFAULT <- "pbmc"
isGene("CD14")
  # TRUE

# To test if many things are genes of an object
isGene(c("CD14", "IL32", "CD3E", "CD12345"))

# return.values input is especially useful in these cases.
isGene(c("CD14", "IL32", "CD3E", "CD12345"), return.values = TRUE)

}
\seealso{
\code{\link{getGenes}} for returning all genes in an \code{object}

\code{\link{gene}} for obtaining the expression data of genes
}
\author{
Daniel Bunis
}
