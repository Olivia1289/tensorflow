% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract.R
\name{[.tensorflow.tensor}
\alias{[.tensorflow.tensor}
\title{Subset tensors with \code{[}}
\usage{
\method{[}{tensorflow.tensor}(x, ..., drop = TRUE,
  style = getOption("tensorflow.extract.style"),
  options = tf_extract_opts(style))
}
\arguments{
\item{x}{Tensorflow tensor}

\item{...}{slicing specs. See examples and details.}

\item{drop}{whether to drop scalar dimensions}

\item{style}{One of \code{"python"} or \code{"R"}.}

\item{options}{An object returned by \code{tf_extract_opts()}}
}
\description{
Subset tensors with \code{[}
}
\examples{
\dontrun{
sess <- tf$Session()

x <- tf$constant(1:15, shape = c(3, 5))
sess$run(x)
# by default, numerics supplied to `...` are interperted R style
sess$run( x[,1] )# first column
sess$run( x[1:2,] ) # first two rows
sess$run( x[,1, drop = FALSE] )

# strided steps can be specified in R syntax or python syntax
sess$run( x[, seq(1, 5, by = 2)] )
sess$run( x[, 1:5:2] )
# if you are unfamiliar with python-style strided steps, see:
# https://docs.scipy.org/doc/numpy-1.13.0/reference/arrays.indexing.html#basic-slicing-and-indexing

# missing arguments for python syntax are valid, but they must by backticked
# or supplied as NULL
sess$run( x[, `::2`] )
sess$run( x[, NULL:NULL:2] )
sess$run( x[, `2:`] )

# Another python features that is available is a python style ellipsis `...`
# (not to be confused with R dots `...`)
# a all_dims() expands to the shape of the tensor
y <- tf$constant(1:(3^5), shape = c(3,3,3,3,3))
identical(
  sess$run( y[all_dims(), 1] ),
  sess$run( y[,,,,1] )
  )

# tf$newaxis are valid
sess$run( x[,, tf$newaxis] )

# negative numbers are always interperted python style
# The first time a negative number is supplied to `[`, a warning is issued
# about the non-standard behavior.
sess$run( x[-1,] ) # last row, with a warning
sess$run( x[-1,] )# the warning is only issued once

# specifying `style = 'python'` changes the following:
# +  zero-based indexing is used
# +  slice sequences in the form of `start:stop` do not include `stop`
#    in the returned value
# +  out-of-bounds indices in a slice are valid

# The style argument can be supplied to individual calls of `[` or set
# as a global option

# example of zero based  indexing
sess$run( x[0, , style = 'python'] ) # first row
sess$run( x[1, , style = 'python'] ) # second row

# example of slices with exclusive stop
options(tensorflow.extract.style = 'python')
sess$run( x[, 0:1] ) # just the first column
sess$run( x[, 0:2] ) # first and second column

# example of out-of-bounds index
sess$run( x[, 0:10] )
options(tensorflow.extract.style = NULL)

# slicing with tensors is valid too, but note, tensors are never
# translated and are always interperted python-style.
# A warning is issued the first time a tensor is passed to `[`
sess$run( x[, tf$constant(0L):tf$constant(2L)] )
# just as in python, only scalar tensors are valid
# https://www.tensorflow.org/api_docs/python/tf/Tensor#__getitem__

# To silence the warnings about tensors being passed as-is and negative numbers
# being interperted python-style, set
options(tensorflow.extract.style = 'R')

# clean up from examples
options(tensorflow.extract.style = NULL)
}
}
