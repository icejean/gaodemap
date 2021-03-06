% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geoconv.R
\name{geoconv}
\alias{geoconv}
\title{Convert geocode
Take in geocode from the other source to GaoDe's geocode}
\usage{
geoconv(geocode, coordsys = "gps", map_ak = "")
}
\arguments{
\item{coordsys}{takes strings from "gps";"mapbar";"baidu";"autonavi"(no change). See more in details.}

\item{geocde}{geocode from the other source}
}
\description{
Convert geocode
Take in geocode from the other source to GaoDe's geocode
}
\details{
Go to https://lbs.amap.com/api/webservice/guide/api/convert to read more.
}
