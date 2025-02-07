#' The RNAseq Class
#' @importFrom methods new slotNames
#' @importFrom stats median prcomp sd
#'
#' @description The RNAseq object stores RNAseq data in a structure that dittoSeq plotting functions know how to handle.
#' All that is needed to create an RNAseq object is a DESeqDataSet, the output from the DESeq() function.
#' In future, outputs of Limma Voom and EdgeR will work as well.
#' @slot counts a matrix. The raw genes x samples counts data. It is recommended, but not required, that one of these should be given when a new RNBAseq object is created.
#' @slot DEobject A DESeqDataSet. The output of having run DESeq() on your data.
#' @slot DEtype String, the type of object. (Will become more meaningful after support for Limma and EdgeR is added)
#' @slot data matrix, the normalized data, often the regularized log correction of the counts data generated by a call to DESeq's rlog function.
#' @slot meta.data a data.frame containing meta-information about each sample.
#' Autopopulated from the DESeqDataSet upon import, or added to manually afterward.
#' Can be sample names, conditions, timepoints, Nreads, etc.
#' @slot reductions a list of dimensional reductions that have been run.
#' Each should be a list containing 3 elements:
#' \itemize{
#' \item embeddings: a matrix containing the dimensional reduction values, with individual dimensions as the columns
#' \item key: How the components of this dimensionality reduction should be refered to in plot axes (ex: "PC" for pca)
#' \item raw.object: the original data from the initial calculation. Not used by any dittoSeq funcitons, but this is still a nice place to store the object to keep all the data together.
#' }
#' @slot samples a string vector, the names of the samples.
#' @slot misc A great place to store any other data associated with your bulk experiment that does not fit elsewhere in the object. Left \code{NULL} by default, and dittoSeq functions do not use or adjust this slot in any way.
#'
#' This slot can hold data of any type, including a list of multiple data objects.
#' @slot version The version of dittoSeq used to create this RNAseq object.
#' @seealso
#' \code{\link{importDESeq2}} for automated import of DESeq objects into an \code{RNAseq} class object
#'
#' \code{\link{addMetaRNAseq}} for how to add metadata to an \code{RNAseq} object
#'
#' \code{\link{addPrcomp}} and \code{\link{addDimReduction}} for how to add dimensionality reductions to an \code{RNAseq} object for use in
#' \code{\link{dittoDimPlot}} visualizations.
#'
#' @author Daniel Bunis
#' @export

Class <- setClass(
    "RNAseq",
    representation(
        counts = "matrix",
        DEobject = "ANY",
        DEtype = "character",
        data = "matrix",
        meta.data = "data.frame",
        reductions = "list",
        samples = "character",
        misc = "ANY",
        version = "ANY"
    ))

#' Add a prcomp pca calculation to an RNAseq object
#'
#' @param prcomp a prcomp output which will be added to the \code{object}
#' @param object the \code{\linkS4class{RNAseq}} object. REQUIRED, unless \code{DEFAULT <- "object"} has been run.
#' @param name String name for the reduction slot. Example: "pca".
#' This will become the name of the slot, what should should be provided to the \code{reduction.use} input when making a \code{\link{dittoDimPlot}}.
#' @param key String, like "PC", which sets the default axes-label prefix when this reduction is used for making a \code{\link{dittoDimPlot}}
#' @return Outputs an \code{\linkS4class{RNAseq}} object with a new \code{@reductions$'name'} slot.
#' @seealso
#' \code{\link{addDimReduction}} for adding other types of dimensionality reductions
#'
#' \code{\link{addMetaRNAseq}} for how to add metadata to an \code{RNAseq} object
#'
#' \code{\link{importDESeq2}} for initial import of \code{RNAseq} data analyzed with DESeq2
#'
#' \code{\link{dittoDimPlot}} for visualizing how samples group within this PCA
#'
#' \code{\linkS4class{RNAseq}} for learning more about the \code{RNAseq} object type
#' @examples
#'
#' # Import mock data
#' myRNA <- RNAseq_mock
#'
#' # Add PCA calculated with prcomp using addPrcomp
#' #   NOTE: This is typically not done with all genes in a dataset.
#' #   The inclusion of this example code is not an endorsement of a particular
#' #   method of PCA. Consult yourself, a bioinformatician, or literature for
#' #   tips on proper techniques.
#' myRNA <- addPrcomp(
#'     prcomp = prcomp(t(myRNA@data), center = TRUE, scale = TRUE),
#'     object = myRNA)
#'
#' # Visualize Nreads metadata on a PCA plot
#' #   Note: For RNAseq objects, reduction.use defaults to "pca"
#' #   so just dittoDimPlot("Nreads", myRNA, size = 3) would work the same!
#' dittoDimPlot("Nreads", myRNA, reduction.use = "pca", size = 3)
#'
#' @author Daniel Bunis
#' @export

addPrcomp <- function(prcomp, object = DEFAULT, name = "pca", key = "PC") {
    #Turn the "name" of the object into the object itself if name was given
    if (typeof(object)=="character") {
        object <- eval(expr = parse(text = object))
    }
    addDimReduction(prcomp$x,object,name,key,prcomp)
}

#' Add any dimensionality reduction space to an RNAseq object
#'
#' @param embeddings a numeric matrix containing the coordinates of all samples within the dimensionality reduction space.
#' @param object the \code{\linkS4class{RNAseq}} object. REQUIRED, unless \code{DEFAULT <- "object"} has been run.
#' @param name String name for the reduction slot. Example: "pca".
#' This will become the name of the slot, what should should be provided to the \code{reduction.use} input when making a \code{\link{dittoDimPlot}}.
#' @param key String, like "PC", which sets the default axes-label prefix when this reduction is used for making a \code{\link{dittoDimPlot}}.
#' If nothing is provided, a key will be automatically generated.
#' @param raw.object Optional, but recommended as this keeps the data all together: the output of the original calculation.
#' @return Outputs an \code{\linkS4class{RNAseq}} object with a new \code{@reductions$'name'} slot.
#' @seealso
#' \code{\link{addPrcomp}} for a prcomp specific PCA import wrapper function
#'
#' \code{\link{addMetaRNAseq}} for how to add metadata to an \code{RNAseq} object
#'
#' \code{\link{importDESeq2}} for initial import of \code{RNAseq} data analyzed with DESeq2
#'
#' \code{\link{dittoDimPlot}} for visualizing how samples group within this dimensionality reduction space after adding it to the object
#'
#' \code{\linkS4class{RNAseq}} for learning more about the \code{RNAseq} object type
#' @examples
#'
#' # Import mock data
#' myRNA <- RNAseq_mock
#'
#' # Add a dimensionality reduction to myRNA
#' #   NOTE: This is typically not done with all genes in a dataset.
#' #   The inclusion of this example code is not an endorsement of a particular
#' #   method of PCA. Consult yourself, a bioinformatician, or literature for
#' #   tips on proper techniques.
#' PCA <- prcomp(t(myRNA@data), center = TRUE, scale = TRUE)
#' myRNA <- addDimReduction(
#'     embeddings = PCA$x,
#'     object = myRNA,
#'     name = "pca",
#'     key = "PC",
#'     raw.object = PCA)
#'
#' # Visualize Nreads metadata on a PCA plot
#' #   Note: For RNAseq objects, reduction.use defaults to "pca"
#' #   so just dittoDimPlot("Nreads", myRNA, size = 3) would work the same!
#' dittoDimPlot("Nreads", myRNA, reduction.use = "pca", size = 3)
#'
#' @author Daniel Bunis
#' @export

addDimReduction <- function(
    embeddings, object = DEFAULT, name, key = .gen_key(name),
    raw.object = NULL) {

    # Turn the "name" of the object into the object itself if name was given
    if (typeof(object)=="character") {
        object <- eval(expr = parse(text = object))
    }

    # Make the reduction
    new <- list(list(
        embeddings = embeddings,
        key = key,
        raw.object = raw.object))
    if (name %in% names(object@reductions)) {
        object@reductions[names(object@reductions) %in% name] <- new
    } else {
        object@reductions[length(object@reductions) + 1] <- new
        names(object@reductions)[length(object@reductions)] <- name
    }
    object
}

#' Add metadata slot to an RNAseq object
#'
#' @param value Vector of any type with length equal to the number of samples in the \code{object}
#' @param object the \code{\linkS4class{RNAseq}} object. REQUIRED, unless \code{DEFAULT <- "object"} has been run.
#' @param name String name for the metadata slot. Example: "age".
#' By default, the name of the object provided to value is used.
#'
#' This will become the name of the slot AND the string that should be provided to \code{var}-type inputs of dittoSeq plotting funcitons.
#' @return Outputs an \code{\linkS4class{RNAseq}} object with a new \code{@meta.data$'name'} slot.
#' @seealso
#' \code{\link{importDESeq2}} for initial import of \code{RNAseq} data analyzed with DESeq2
#'
#' \code{\link{addDimReduction}} and \code{\link{addPrcomp}} for adding dimensionality reductions
#'
#' \code{\linkS4class{RNAseq}} for learning more about the \code{RNAseq} object type
#' @examples
#'
#' # Import mock data
#' myRNA <- RNAseq_mock
#'
#' ### Add a batch metadata
#' # Option 1, all in the funciton:
#' myRNA <- addMetaRNAseq(
#'     value = rep(1:2, each = 5),
#'     name = "batch",
#'     object = myRNA)
#' # Options 2 & 3, create variable beforehand, and provide that.
#' #     FOr both, the name of the variable will be name of the metadata slot.
#' batch <- rep(1:2, each = 5)
#' myRNA <- addMetaRNAseq(batch, object = myRNA)
#' # OR
#' addMeta(myRNA) <- batch
#'
#' # Visualize batch on a PCA plot
#' #   Note: For RNAseq objects, reduction.use defaults to "pca"
#' #   so just dittoDimPlot("Sample", myRNA, size = 3) would work the same!
#' dittoDimPlot("batch", myRNA, reduction.use = "pca", size = 3)
#'
#' @author Daniel Bunis
#' @export
addMetaRNAseq <- function(
    value, name = deparse(substitute(value)), object = NULL) {

    if (is.null(object) || is.character(object)) {
        stop("object must be given directly.")
    }
    if (name %in% names(object@meta.data)) {
        object@meta.data[names(object@meta.data) %in% name] <- value
    } else {
        object@meta.data[length(object@meta.data)+1] <- value
        names(object@meta.data)[length(object@meta.data)] <- name
    }
    object
}

#' @rdname addMetaRNAseq
#' @export
`addMeta<-` <- function(object, value)
{
    UseMethod('addMeta<-', object)
}

#' @rdname addMetaRNAseq
#' @export
`addMeta<-.RNAseq` <- function (object, value) {
    addMetaRNAseq(value, deparse(substitute(value)), object)
}


