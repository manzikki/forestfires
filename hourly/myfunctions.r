#For truncating very long label numbers
scalef <- function(x) sprintf("%.2f", x)

#Draws the maps
draw_map_with_data <- function(title, unit, maxlim, daydata, breaks, labels, col) {
    ThaiBound <- raster::getData(name = "GADM", country = "THA", level = 0)
    LaoBound <- raster::getData(name = "GADM", country = "LAO", level = 0)
    KhmBound <- raster::getData(name = "GADM", country = "KHM", level = 0)
    VnmBound <- raster::getData(name = "GADM", country = "VNM", level = 0)
    MyaBound <- raster::getData(name = "GADM", country = "MMR", level = 0)
    aPlot = ggplot()+
          geom_raster(data=daydata,aes(x,y,fill=col))+
          scale_fill_gradient(low = "white",
                              high = "red",
                              na.value = NA,
                              limits = c(0,maxlim),
                              breaks = breaks,
                              labels = labels) +
          scale_x_continuous(name=expression(paste("Longitude")),
                             limits=c(90,111),
                             expand=c(0,0)) +
          scale_y_continuous(name=expression(paste("Latitude")),
                             limits=c(5,30),
                             expand=c(0,0)) +
          geom_polygon(data=ThaiBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          geom_polygon(data=LaoBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          geom_polygon(data=MyaBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          geom_polygon(data=KhmBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          geom_polygon(data=KhmBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          geom_polygon(data=VnmBound,
                       aes(x=long, y=lat, group=group),
                       fill=NA,
                       color="black",
                       size=0.1)+
          ggtitle(title,
                  subtitle = paste0("Date : ", aMapDate))+
          labs(fill = unit)+
          theme(panel.ontop=FALSE,
                panel.background=element_blank(),
                panel.border = element_rect(colour = "black", fill=NA, size=0.1),
                legend.title = element_text(color = "black", size = 10)) +
          coord_equal()
          print(aPlot)
          dev.off()
}

