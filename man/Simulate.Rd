% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ColorAdjustments.R
\name{Simulate}
\alias{Simulate}
\title{Simulates what a colorblind person would see for any dittoSeq plot!}
\usage{
Simulate(
  type = c("deutan", "protan", "tritan"),
  plot.function,
  ...,
  color.panel = dittoColors()
)
}
\arguments{
\item{type}{The type of colorblindness that you want to simulate for. Options: "deutan", "protan", "tritan". Anything else, and you will get an error.}

\item{plot.function}{The plotting function that you want to use/simulate. not quoted. and make sure to remove the () that R will try to add.}

\item{...}{other paramters that can be given to dittoSeq plotting functions, including color.panel, used in exactly the same way they are used for those functions. (contrary to the look of this documentation, color.panel will still default to dittoColors() when not provided.)}

\item{color.panel}{The set of colors to be used.  Not required to be given, as contrary to the look of this documentation, it will still default to dittoColors() when not provided.}
}
\value{
Outputs a dittoSeq plot with the color.panel updated as it might look to a colorblind individual. Note: Does not currently work for DBHeatmap or for continuous variable plotting in DBDimPlot.
}
\description{
Essentially a wrapper function for colorspace's deutan(), protan(), and tritan() functions. This function will output any dittoSeq plot as it might look to an individual with one of the common forms of colorblindness: deutanopia/deutanomaly, the most common, is when the cones mainly responsible for red vision are defective. Protanopia/protanomaly is when the cones mainly responsible for green vision are defective. In tritanopia/tritanomaly, the defective cones are responsible for blue vision. Note: there are more severe color deficiencies that are even more rare. Unfortunately, for these types of color vision deficiency, only non-color methods, like lettering or shapes, will do much to help.
}
\examples{
library(Seurat)
pbmc <- Seurat::pbmc_small
Simulate("deutan", dittoDimPlot, var = "RNA_snn_res.1", object = "pbmc", size = 2)
Simulate("protan", dittoDimPlot, "RNA_snn_res.1", "pbmc", size = 2)
Simulate("tritan", dittoDimPlot, "RNA_snn_res.1", "pbmc", size = 2)

}
\author{
Daniel Bunis
}
