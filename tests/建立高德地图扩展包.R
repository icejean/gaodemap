#载入开发工具包
library(devtools)
#roxygen2扩展包用于从程序中的格式化注释生成文档
install.packages("roxygen2",type="win.binary",INSTALL_opts = "--no-multiarch")
library(roxygen2)
#项目目录，R源码在该目录的./R目录下，生成的文档在./man目录下
path<-c("D:/R/Rsources/gaodemap/gaodemap-beta")
setwd(path) 
#从R源码生成说明文档，在./man目录下
devtools::document(path)
#生成源码安装包，在上级目录D:/R/Rsources/gaodemap下。
devtools::build()
#从源码安装高德地图接口包
install.packages("D:/R/Rsources/gaodemap/gaodemap_0.1.0.tar.gz",repos = NULL,type="source",INSTALL_opts = "--no-multiarch")
#装入gaodemap
library(gaodemap)
#运行测试实例
source("C:/Users/pc/Documents/Rscripts/高德地图示例.R")
#build之前，要手工编辑文件D:/R/Rsources/gaodemap/gaodemap-beta/DESCRIPTION，内容如下(去掉#号)：
# Package: gaodemap
# Type: Package
# Title: A package for spatial visualization with GaoDe map
# Version: 0.1.0
# Date: 2019-08-24
# Encoding: UTF-8
# Author: yalei Du <yaleidu@163.com>,Jean Ye <1793893079@qq.com>
#   Maintainer: Jean Ye <1793893079@qq.com>
#   Description: Just like ggmap, but get map from GaoDe instead of google or openstreet
# Depends:
#   R (>= 3.1.1)
# Imports:
#   ggmap,
# RgoogleMaps,
# png,
# RCurl,
# rjson,
# XML,
# stringr,
# parallel
# License: GPL-2
# LazyData: true
# RoxygenNote: 6.1.1

#也可以从GitHub上直接安装 
install_github('icejean/gaodemap')
# If you get a message like this:
#   Downloading GitHub repo icejean/gaodemap@master
# Error in utils::download.file(url, path, method = download_method(), quiet = quiet,  : 
#                                 cannot open URL 'https://api.github.com/repos/icejean/gaodemap/tarball/master'
# Just copy and paste the URL to the browser and download the ziped source file,
# icejean-gaodemap-8de1771.tar.gz, for exmaple,and install it from source:
install.packages("D:/R/Rsources/icejean-gaodemap-8de1771.tar.gz",repos = NULL,type="source",INSTALL_opts = "--no-multiarch")
