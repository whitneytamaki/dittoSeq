% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dittoHeatmap.R
\name{dittoHeatmap}
\alias{dittoHeatmap}
\title{Outputs a heatmap of given genes}
\usage{
dittoHeatmap(
  genes = NULL,
  object = DEFAULT,
  cells.use = NULL,
  main = NA,
  cell.names.meta = NULL,
  data.type = "normalized",
  order.by = NULL,
  heatmap.colors = colorRampPalette(c("blue", "white", "red"))(50),
  scaled.to.max = FALSE,
  heatmap.colors.max.scaled = colorRampPalette(c("white", "red"))(25),
  annotation.metas = NULL,
  annotation.colors = c(rep(dittoColors(), 9), dittoColors()[seq_len(7)]),
  data.out = FALSE,
  highlight.genes = NULL,
  show.colnames = TRUE,
  show.rownames = TRUE,
  ...
)
}
\arguments{
\item{genes}{String vector, c("gene1","gene2","gene3",...) = the list of genes to put in the heatmap. REQUIRED.}

\item{object}{A Seurat, SingleCellExperiment, or \linkS4class{RNAseq} object to work with, OR the name of the object in "quotes".
REQUIRED, unless '\code{DEFAULT <- "object"}' has been run.}

\item{cells.use}{String vector of cells'/samples' names which should be included.
Alternatively, a Logical vector, the same length as the number of cells in the object, which sets which cells to include.
For the typically easier logical method, provide \code{USE} in \code{object@cell.names[USE]} OR \code{colnames(object)[USE]}).}

\item{main}{String that sets the title for the heatmap.}

\item{cell.names.meta}{quoted "name" of a meta.data slot to use for naming the columns instead of using the raw cell/sample names.}

\item{data.type}{String. Options are "normalized" (data slot, default), "raw" (raw.data or counts slot), "scaled" (the scale.data slot of Seurat objects). Note: scaling is performed on the data matrix by default.}

\item{order.by}{Single string or numeric vector which sets the ordering of cells/samples.
Can be the name of a gene, or metadata slot.
Alternatively, can be a numeric vector of length equal to the total number of cells/samples in object.}

\item{heatmap.colors}{the colors to use within the heatmap.
Default is a ramp from navy to white to red with 50 slices.}

\item{scaled.to.max}{Logical which sets whether expression shoud be scaled between [0, 1].
This is recommended for single-cell datasets as they are generally enriched in 0s.}

\item{heatmap.colors.max.scaled}{the colors to use within the heatmap when \code{scaled.to.max} is set to \code{TRUE}.
Default is a ramp from white to red with 25 slices.}

\item{annotation.metas}{String name of a metadata slot containing how the cells/samples should be annotated.}

\item{annotation.colors}{String (color) vector where each color will be assigned to an individual annotation in the generated annotation bars.}

\item{data.out}{Logical that changes the output of the function.
If set to \code{TRUE}, the output will be a list containing the data that would have been used for generating the heatmap,
and a String showing how \code{pheatmap} would have been called.}

\item{highlight.genes}{String vector of genes whose names you would like to show. Only these genes will be named in the resulting heatmap.}

\item{show.rownames, show.colnames}{Logical which sets whether rownames or colnames will be shown.
Note: if gene names are provided to \code{highlight.genes}, the \code{show.colnames} parameter is ignored.}

\item{...}{other arguments passed to \code{pheatmap}.}
}
\value{
A \code{pheatmap} object.
Alternatively, if \code{data.out} was set to \code{TRUE}, a list containing
\code{args}, a list of arguments passed to \code{pheatmap}, and
and \code{call}, a string showing how \code{pheatmap} would have been called.
}
\description{
Given a set of genes, cells/samples, and metadata names for column annotations, it will retrieve the expression data for those genes and cells, and the annotation data for those cells.
It will then utilize these data to make a heatmap using the \code{\link[pheatmap]{pheatmap}} function of the \code{pheatmap} package.
}
\details{
This function serves as a wrapper for creating pheatmap heatmaps from bulk or single-cell RNAseq data,
by essentially automating the data extraction and annotation building steps.
In order to use this function, you will need to have it installed.

Provided with a set of \code{genes}, and an optional set of cells / samples to use (with the \code{cells.use} input),
the function will extract the expression matrix for each of those genes for each of those cells / samples.
This matrix is either left as is, default (for scaling within the ultimate call to pheatmap), or scaled by dividing each row by its maximum value (\code{scaled.to.max = TRUE}).

When provided with a set of metadata slot names to use for building annotations (with the \code{annotation.metas} input),
the relevant metadata is retrieved from the \code{object} and \code{pheatmap}-ready \code{annotation_col} input is generated.
The input \code{annotation.colors} is used to establish the set of colors that should be used for building a \code{pheatmap}-ready \code{annotation_colors} input as well,
unless such an input has been provided by the user.
Note: Users can also provide an \code{annotation_row} dataframe for adding gene-annotations (See \code{\link[pheatmap]{pheatmap}} for details).
Colors for row annotations will still come from the \code{annotation.colors} input unless a \code{pheatmap}-ready \code{annotation_colors} input is provided by the user.

When \code{data.out} is set to \code{TRUE}, a list is output instead of running pheatmap and providing the heatmap plot as output.
This list will contain a slot named \code{args} which includes the data matrix and all other arguments that would have been provided to the pheatmap call,
as well as a slot named \code{call} which shows how pheatmap would have been called.

Many additional characteristics of the plot can be adjusted using discrete inputs:
\itemize{
\item The cells can be ordered by in a set way using the \code{order.by} input.
Note: It can take a long time to cluster thousands of samples or cells, so adding \code{order.by = 'useful-method'} can be quite useful.
\item A plot title can be added with \code{main}.
\item Gene or cell/sample annotations can be turned off with \code{show.rownames} and \code{show.colnames}, respectively, or...
\itemize{
\item Particular genes can also be selected for labeling using the \code{highlight.genes} input.
\item Names of all cells/samples replaced with the contents of a metadata slot using the \code{cell.names.meta} input.
}
\item Additional tweaks are possible through use of \code{\link[pheatmap]{pheatmap}} inputs which will be directly passed through.
Some examples of useful \code{pheatmap} parameters are:
\itemize{
\item \code{cluster_cols} and \code{cluster_rows} for controlling clustering.
Note: cluster_cols will always be over-written to be \code{FALSE} when the input \code{order.by} is used above.
\item \code{treeheight_row} and \code{treeheight_col} for setting how large the trees on the side/top should be drawn.
\item \code{cutree_col} and \code{cutree_row} for spliting the heatmap based on kmeans clustering
}
}
}
\examples{
library(Seurat)
pbmc <- Seurat::pbmc_small
dittoHeatmap(c("MS4A1","GNLY","CD3E","CD14","FCER1A",
    "FCGR3A","LYZ","PPBP","CD8A"),
    object = pbmc,
    annotation.metas = "ident")

#' # Note: if DEFAULT <- "pbmc" is run beforehand, the object input can be skipped completely.
DEFAULT <- "pbmc"
dittoHeatmap(c("MS4A1","GNLY","CD3E","CD14","FCER1A",
    "FCGR3A","LYZ","PPBP","CD8A"),
    annotation.metas = "ident")

# Using the 'order.by' input:
#   For real single cell data, you will typically have more cells than in
#   this truncated dataset, so turning off cell clustering off and instead
#   ordering by a useful metadata or gene can help speed the process a lot!
dittoHeatmap(c("MS4A1","GNLY","CD3E","CD14","FCER1A",
    "FCGR3A","LYZ","PPBP","CD8A"),
    object = pbmc,
    annotation.metas = "ident",
    order.by = "ident")

# When there are many cells, showing names becomes less useful.
#   Names can be turned off with the show.colnames parameter.
dittoHeatmap(c("MS4A1","GNLY","CD3E","CD14","FCER1A",
    "FCGR3A","LYZ","PPBP","CD8A"),
    object = pbmc,
    annotation.metas = "ident",
    order.by = "ident",
    show.colnames = FALSE)

# Additionally, it is recommended for single-cell data that the parameter
#   scaled.to.max be set to TRUE, or scaling be turned off altogether,
#   because these data are generally enriched for zeros that otherwise get
#   scaled to a negative value.
dittoHeatmap(c("MS4A1","GNLY","CD3E","CD14","FCER1A",
    "FCGR3A","LYZ","PPBP","CD8A"),
    object = pbmc,
    annotation.metas = "ident",
    order.by = "ident",
    show.colnames = FALSE,
    scaled.to.max = TRUE)
dittoHeatmap(c("MS4A1","GNLY","CD3E","CD14","FCER1A",
    "FCGR3A","LYZ","PPBP","CD8A"),
    object = pbmc,
    annotation.metas = "ident",
    order.by = "ident",
    show.colnames = FALSE,
    scaled.to.max = FALSE,
    scale = "none",
    heatmap.colors = colorRampPalette(c("white", "red"))(25))

}
\seealso{
\code{\link[pheatmap]{pheatmap}}, for how to add additional heatmap tweaks.
}
\author{
Daniel Bunis
}
