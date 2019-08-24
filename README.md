gaodemap
========

R interface of baidu map api，just like ggmap but get map from baidu api instead of google or openstreet.

## Installation
```
library(devtools)
install_github('badbye/gaodemap')
```

## Usage

Apply an application from [lbsyun.baidu.com](http://lbsyun.baidu.com/apiconsole/key). Then register you key here.
```
library(gaodemap)
options(gaode.key = 'XXX fill your key here XXX')
```


### Function: getLocation
Get location from coordinates data.
```
lon = matrix(c(117.93780, 24.55730, 117.93291, 24.57745, 117.23530, 24.64210, 117.05890, 24.74860), byrow=T, ncol=2)
### json 
location_json = getLocation(lon[1,], output='json')

### xml
location_xml = getLocation(lon[1, ], output='xml')

## formatted
location = getLocation(lon[1, ], formatted = T) 
```

### Function: GetCoordinate
Given a address, return the corresponding coordinates
```
getCoordinate('北京大学') # json
getCoordinate('北京大学', output='xml') # xml
getCoordinate('北京大学', formatted = T) # character
getCoordinate(c('北京大学', '清华大学'), formatted = T) # matrix
```


### Function: getGaoDeMap

```
p <- getGaoDeMap(c(lon=116.354431, lat=39.942333))
library(ggmap)
ggmap(p)
```

### Function: geoconv

Convert your coordinate data to gaodemap's coordinate system. Document: http://lbsyun.baidu.com/index.php?title=webapi/guide/changeposition

## Example

```
library(gaodemap)
library(ggplot2)
options(gaode.key='xxx')
ruc_map = getGaoDeMap('中国人民大学', zoom=12)
ruc_coordinate = getCoordinate('中国人民大学', formatted = T)
ruc_coordinate = data.frame(t(ruc_coordinate))
ggmap::ggmap(ruc_map) +
  geom_point(aes(x=longtitude, y=latitude), data=ruc_coordinate, col='red', size=5)
```