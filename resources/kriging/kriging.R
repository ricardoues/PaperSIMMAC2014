### Loading package 


library(maptools)
library(sp)
library(lattice)
library(ggmap)
library(proj4)
library(rgdal)
library(scales)
library(RgoogleMaps)
library(RColorBrewer)
library(gstat)
library(raster)

### The file DeslizamientosAMSS contains the projection system 


###########################################################
###########################################################
###########################################################




deslizamientos <- readOGR(".","DeslizamientosAMSS")

print(proj4string(deslizamientos))

coord.ref.sys <- proj4string(deslizamientos)


datos <- read.csv(file="data.csv", header=TRUE); 


coordinates(datos) <- c("long", "lat")

# Proj4 string from the original shape files 
#
#"+proj=lcc +lat_1=13.31666666 +lat_2=14.25 +lat_0=13.78333333333333 +lon_0=-89 +x_0=500000 +y_0=295809.184 +datum=NAD27 +units=m +no_defs +ellps=clrk66 +nadgrids=@conus,@alaska,@ntv2_0.gsb,@ntv1_can.dat"
proj4string(datos) <- CRS(coord.ref.sys)


datos <- sp::spTransform(datos, CRS("+proj=longlat +datum=WGS84"))


datos2 <- data.frame(prob=datos$prob, cat=datos$cat)
datos2 <- cbind(datos2, datos@coords)

### Ploting the map without the points 

map <- get_map(location = c( -89.2 , 13.75 ), zoom = 11, maptype = "roadmap")

p <- ggmap(map)
plot(p)


### Ploting the map with the points 

p <- p + geom_point(aes(x=datos2$long, y = datos2$lat), 
                    data = datos2, alpha = 0.5, 
                    color = "darkred", size = 3)

plot(p)


###########################################################

a <- data.frame(x=datos2$long, y=datos2$lat, z=datos2$prob)


indices <- sample(1:978252,1500)

e <- a[indices,];


coordinates(e) <- c("x", "y")

pal = brewer.pal(5,"OrRd")


spplot(e, "z", colorkey = FALSE, 
       col.regions = pal, ylab = "Probability of landslide occurrence", 
       scales = list(draw=T))


##############################################
##############################################
#############################################



############################################################
##Estimating Spatial Correlation: The Variogram ############
############################################################



# The maximun distance in my data is:  0.4000753
# The minimun distance in my data is: 0.0002259847

hscat(z ~ 1, e , c(0.0002,0.001))

hscat(z ~ 1, e , c(0.001,0.002))

hscat(z ~ 1, e , c(0.01,0.02))

hscat(z ~ 1, e , c(0.30,0.40))


variog2 <- variogram(z ~ 1, e, cloud = FALSE)

plot(variog2)


variog4 <- variogram(z ~ 1, e, cloud = FALSE, alpha=c(0,45,90,135))
plot(variog4)



###########################################################
###########################################################
###########################################################



##############################################
################ Variogram Modelling ########
#############################################


v.fit <-  fit.variogram(variog2, vgm(1,"Sph",1,1), fit.method=6)
v.fit
attr(v.fit, "SSErr")


v.fit2 <-  fit.variogram(variog2, vgm(1,"Gau",0.01,0.01), fit.method=6)
v.fit2
attr(v.fit2, "SSErr")


v.fit3 <-  fit.variogram(variog2, vgm(1,"Exp",0.01,0.01), fit.method=6)
v.fit3
attr(v.fit3, "SSErr")

plot(variog2, model=v.fit)

plot(variog2, model=v.fit2)

plot(variog2, model=v.fit3)


##############################################
##############################################
#############################################



##############################################
################ Spatial Prediction ##########
##############################################



#xx <- seq(min(a$x), max(a$x), length.out=1000)
#yy <- seq(min(a$y), max(a$y), length.out=1000)

xx <- seq(min(a$x), max(a$x), length.out=1500)
yy <- seq(min(a$y), max(a$y), length.out=1500)



a2 <- expand.grid(x=xx, y=yy)

gridded(a2) = ~x+y

# Exponential model 
# using ordinary kriging 

lz.uk <- krige(z ~ 1, e, a2, model=v.fit3) ; 

save.image(file="imagen.RData")
save(lz.uk, file="krige.RData")





##############################################
##############################################
#############################################


load(file="imagen.RData")


mg <- as.data.frame(slot(a2, "coords"))
mg$pred <- slot(lz.uk, "data")$var1.pred


pal = brewer.pal(9,"OrRd")


### Other alternative source = "osm"


map.in <- get_map(location = c(min(mg$x),
                               min(mg$y),
                               max(mg$x),
                               max(mg$y)),
                  source = "google")


theme_set(theme_bw(base_size = 8))



pred.stat.map <- ggmap(map.in) %+% mg + 
  aes(x = x,
      y = y,
      z = pred) +
  stat_summary2d(fun = median, 
                 binwidth = c(.005, .005),
                 alpha = 0.5) + 
  scale_fill_gradientn(name = "Median",
                       colours = pal,
                       space = "Lab") + 
  labs(x = "Longitude",
       y = "Latitude") +
  coord_map()


print(pred.stat.map)

ggsave(filename = "imagen.png",
       plot = pred.stat.map,
       scale = 1,
       width = 5, height = 3,
       dpi = 300)



### Exporting to raster 

spg <- mg

coordinates(spg) <- ~ x + y

proj4string(spg) <- CRS("+proj=longlat +datum=WGS84")


gridded(spg) <- TRUE

rasterDF <- raster(spg)

rasterDF

rf <- writeRaster(rasterDF, filename="krigepred.tif", format="GTiff", overwrite=TRUE)
rf



