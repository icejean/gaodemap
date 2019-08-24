library(png)
library(utils)
library(ggmap)
library(RgoogleMaps)
library(maptools)
library(ggplot2)
library(rjson)
library(RCurl)
library(XML)
library(stringr)
library(scales)
library(gaodemap)
library(sqldf)

#高德访问key
gaodeKey<-"xxx"
options(gaode.key='xxx')
getOption("gaode.key")

#测试地理编码函数
coor<-getCoordinate("珠海市")
coor<-getCoordinate("珠海市", formatted = T)
coor<-getCoordinate("香洲区",output = "xml", formatted = T)
regions<-c("香洲区","斗门区","金湾区","澳门")
coor<-getCoordinate(regions, formatted = T)
coor<-getCoordinate(regions,output = "xml", formatted = T)

#测试静态地图函数
map<- getGaoDeMap("珠海市", width=800, height=800, zoom=8, scale = 2)
ggmap(map)

#测试行政区域边界函数
coords1<-getRegionCoordinates("珠海市",gaodeKey,id="1")
p<-ggplot()+
  geom_path(aes(x = lon, y = lat, group = group),data=coords1,alpha=0.5,colour = "red")+
  geom_polygon(aes(x=lon, y=lat, fill=group), data=coords1, alpha=0.5,show.legend = FALSE)
print(p)

coords2<-getRegionCoordinates("香洲区",gaodeKey,id="2")
coords3<-getRegionCoordinates("斗门区",gaodeKey,id="3")
coords4<-getRegionCoordinates("金湾区",gaodeKey,id="4")

coords<-rbind(coords2,coords3,coords4)
p<-ggplot()+
  geom_path(aes(x = lon, y = lat, group = group),data=coords1,alpha=0.5,colour = "red",size=2)+
  geom_polygon(aes(x=lon, y=lat, group=group,fill=id), data=coords, alpha=0.5,show.legend = FALSE)
print(p)

cors2<-as.data.frame(coor)
#珠海下辖3区人口数据，澳门填0不显示
rk<-data.frame(c(102.39,46.09,28.06,50))
ds<-c("2","3","4","5")
cors2<-cbind(cors2,rk)
names(cors2)<-c("longtitude","latitude","rk")
cors2$id<-ds
cors2$rn<-row.names(cors2)
cors2<-head(cors2,3)

#画人口数据泡泡图
#注意geom_point函数要加上shape=21, colour="black"参数，fill=DS才能正确显示
#并且因子DS变量要在行政区域边界与泡泡图上保持一致。
colors<-c("blue","pink","green","yellow")
p<-ggplot()+
  geom_path(aes(x = lon, y = lat, group = group),data=coords1,alpha=0.5,colour = "red",size=2)+
  geom_polygon(aes(x=lon, y=lat, group=group,fill=id), data=coords, alpha=0.5)+
  geom_point(aes(x=longtitude,y=latitude,fill=id),data = cors2,size=round(cors2$rk/2),alpha=0.5,
             show.legend=FALSE,shape=21, colour="black")+
  with(cors2, annotate(geom="text", x = longtitude, y=latitude, label = rk,col="red",size=6))+
  scale_fill_manual(name = "区域",labels=c("香洲","斗门","金湾","澳门"),values=colors)+
  ggtitle('珠海市人口分布图')+
  labs(x="经度",y="纬度")+
  theme(panel.background = element_blank(),plot.title = element_text(hjust = 0.5,size=20))
print(p) 

#获取静态地图，注意增加了变焦调整参数，以使静态地图与前面的矢量地图匹配，矢量地图刚好覆盖静态地图
q <- getGaoDeMap('珠海市', width=800, height=800, zoom=8, scale = 2)
ggmap(q)

#静态图、矢量图及数据标注各图层整合到一起
p<-ggmap(q) +
  geom_path(aes(x = lon, y = lat, group = group),data=coords1,alpha=0.5,colour = "red",size=1)+
  geom_polygon(aes(x=lon, y=lat, group=group,fill=id), data=coords, alpha=0.5)+
  geom_point(aes(x=longtitude,y=latitude,fill=id),data = cors2,size=round(cors2$rk/2),alpha=0.5,
             show.legend=FALSE,shape=21, colour="black")+
  with(cors2, annotate(geom="text", x = longtitude, y=latitude, label = rk,col="red",size=6))+
  scale_fill_manual(name = "区域",labels=c("香洲","斗门","金湾","澳门"),values=colors)+
  ggtitle('珠海市人口分布图')+
  labs(x="经度",y="纬度")+
  theme(panel.background = element_blank(),plot.title = element_text(hjust = 0.5,size=20))
print(p) 

#尝试用几种不同的变焦参数与矢量地图合并画图，看那个参数合适，结果对于这幅图，zoom=9比较合适。
#焦点坐标
coor_zh<-getCoordinate("珠海市", formatted = T)
#变焦参数
q<-changeZoom(map=q,location=coor_zh,width=800,height=800,zoom=9)
#静态图、矢量图及数据标注各图层整合到一起
p<-ggmap(q) +
  geom_path(aes(x = lon, y = lat, group = group),data=coords1,alpha=0.5,colour = "red",size=1)+
  geom_polygon(aes(x=lon, y=lat, group=group,fill=id), data=coords, alpha=0.5)+
  geom_point(aes(x=longtitude,y=latitude,fill=id),data = cors2,size=round(cors2$rk/2),alpha=0.5,
             show.legend=FALSE,shape=21, colour="black")+
  with(cors2, annotate(geom="text", x = longtitude, y=latitude, label = rk,col="red",size=6))+
  scale_fill_manual(name = "区域",labels=c("香洲","斗门","金湾","澳门"),values=colors)+
  ggtitle('珠海市人口分布图')+
  labs(x="经度",y="纬度")+
  theme(panel.background = element_blank(),plot.title = element_text(hjust = 0.5,size=20))
print(p) 


#反向地理编码
lon = matrix(c(116.339303,40.01116, 116.452562, 39.936404,117.23530, 24.64210, 117.05890, 24.74860), byrow=T, ncol=2)
### json 
location_json = getLocation(lon[1,], output='json')
### xml
location_xml = getLocation(lon[1, ], output='xml')
## formatted
location = getLocation(lon[1, ], formatted = T) 
location = getLocation(lon, formatted = T) 


#地址查询
## colleges in beijing
bj_college = getPlace('大学', '北京')
## Mcdonald's in shanghai
sh_mcdonald = getPlace('麦当劳', '上海')
## colleges in beijing
zh_taxation = getPlace('税务局', '珠海市')
zh_taxation<-zh_taxation[order(zh_taxation$name,zh_taxation$address),]


#路径导航
bjMap = getGaoDeMap('北京', zoom=11)
coor<-getCoordinate("海淀区明德路",city="北京",formatted = T)
coor2<-getCoordinate("工人体育场西门(公交站)",city="北京", formatted = T)
df = getRoute(paste(coor[1],",",coor[2],sep=""),paste(coor2[1],",",coor2[2],sep=""),
            mode="driving",strategy=2)
#writeLines(rawData,file("gaodeRoute.xml",encoding="UTF-8"))
ggmap(bjMap) + geom_path(data = df, aes(lon, lat), alpha = 0.5, col = 'red',size=2,show.legend = TRUE)

bjMap2 = getGaoDeMap('北京', zoom=13)
coor<-getCoordinate("前门大街",city="北京",formatted = T)
coor2<-getCoordinate("故宫博物院南门",city="北京", formatted = T)
df = getRoute(paste(coor[1],",",coor[2],sep=""),paste(coor2[1],",",coor2[2],sep=""),
              mode="walking")
ggmap(bjMap2) + geom_path(data = df, aes(lon, lat), alpha = 0.5, col = 'red',size=2)

coor<-getCoordinate("海淀区明德路",city="北京",formatted = T)
coor2<-getCoordinate("工人体育场西门(公交站)",city="北京", formatted = T)
df = getRoute(paste(coor[1],",",coor[2],sep=""),paste(coor2[1],",",coor2[2],sep=""),
              mode="bicycling")
ggmap(bjMap) + geom_path(data = df, aes(lon, lat), alpha = 0.5, col = 'red',size=2)

coor<-getCoordinate("天安门",city="北京",formatted = T)
coor2<-getCoordinate("颐和园",city="北京", formatted = T)
df = getRoute(paste(coor[1],",",coor[2],sep=""),paste(coor2[1],",",coor2[2],sep=""),
              city="北京", mode="transit",strategy = 0)
ggmap(bjMap) + geom_path(data = df, aes(lon, lat), alpha = 0.5, col = 'red',size=2)

coor<-getCoordinate("天安门",city="北京",formatted = T)
coor2<-getCoordinate("颐和园",city="北京", formatted = T)
df = getRoute(paste(coor[1],",",coor[2],sep=""),paste(coor2[1],",",coor2[2],sep=""),
              city="北京", mode="truck",strategy = 3)
ggmap(bjMap) + geom_path(data = df, aes(lon, lat), alpha = 0.5, col = 'red',size=2)


#坐标转换
lon = matrix(c(116.339303,40.01116, 116.452562, 39.936404,117.23530, 24.64210, 117.05890, 24.74860), byrow=T, ncol=2)
coor3<-geoconv(c(116.339303,40.01116),coordsys="baidu")
coor3<-geoconv(lon,coordsys="baidu")


