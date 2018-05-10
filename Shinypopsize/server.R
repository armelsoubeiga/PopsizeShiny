
library("shiny")
library("xtable")
library("gstat")
library("rgdal")
library("sp")
library("maptools")
library("tcltk")

#packages Rcpp
library('Rcpp')  

## My packages
library("popsize")
data(MyData)

shinyServer(function(input, output) {
  Base <- base

output$message1 <- renderPrint({ 
  
  #using S3
  if (input$choix=="ouga")
  tkmessageBox(title = "Title of message box",message = "Attention! L'estimation est uniquement possible pour la premiére région d'abord", icon = "info", type = "ok")
  })

output$message2 <- renderPrint({ 
  
  if (input$checkGroup=="Longlat")
    tkmessageBox(title = "Title of message box",message = "Attention! Les coordonnées doivent être converti en UTM avant l'estimation", icon = "info", type = "ok")
})  

##Using my package
table <- eventReactive(input$conv,{  
    LongLatToUTM<-function(x,y){
      zone <- 30
      xy <- data.frame(ID = 1, X=as.double(x), Y=as.double(y))
      coordinates(xy) <- c("X", "Y")
      proj4string(xy) <- CRS("+proj=longlat +datum=WGS84")  
      res <- spTransform(xy, CRS(paste("+proj=utm +zone=",zone," +north +datum=WGS84 +ellps=WGS84",sep='')))
      longitude <- as.character(res$X)
      latitude <- as.character(res$Y)
      return(as.data.frame(rbind(cbind("GPS",input$long2,input$lat2),cbind("UTM",longitude,latitude))))
      }
LongLatToUTM(input$long2,input$lat2)
})
##
output$table <- renderTable({
    table()
})
##
##
text <- eventReactive(input$estime,{  
  estimation(as.double(input$long),as.double(input$lat))
})
output$text <- renderText({ 
  text()
})
##
##
carto <- eventReactive(input$view,{
  comune<-rgdal::readOGR("C:\\Users\\Soubeiga Armel\\Desktop\\Mes COURS\\SSD_UGA\\M1\\S7\\R\\ProjetR_Armel\\Shinypopsize\\data\\Adm\\Bf_dept.shp")
  x <- c(302161.5+input$n,393166.1+input$n)
  y <- c(1207962+input$n,1266789+input$n)
  par(mar=c(0, 0, 0, 0))
  plot(comune[comune$NOMDEP=="BOBO-DIOULASSO",],col="gray",xlim=x,ylim=y)
  points(as.double(input$long3),as.double(input$lat3),col="red",pch=20, cex=1)
})

output$carto <- renderPlot({
  carto()
})
## 
output$data <-renderTable({
  Base <- head(Base)
  Base[, c("Id_lieudit","Secteur",input$Variables), drop = FALSE]
}, rownames = TRUE)

##
summary1 <- eventReactive(input$view2,{  
  as.matrix(summary(Base$pop))
})

output$summary1<- renderTable({
  summary1()
})
##
histogramme1 <- eventReactive(input$view3,{
  par(mfrow=c(1,2))
  hist(Base$pop,col="yellow",main="Histogramme",xlab="Densités",ylab="Frenquences")
  hist(Base$pop,breaks=seq(0,400, by=1),main="Histogramme individuellement",xlab="Densités",ylab="Frenquences")
})

output$histogramme1 <- renderPlot({
  histogramme1()
})

##
Boxplot <- eventReactive(input$view4,{
  boxplot(Base$pop,main="Boite à Moustache des densités",col="orange",ylab="Densit?")
})

output$Boxplot <- renderPlot({
  Boxplot()
})

##
Qqplot <- eventReactive(input$view5,{
  qqnorm(Base$pop,pch="+",col="blue",main="le Qqplot de la densité",xlab="densité théorique",ylab="densité observées")
  qqline(Base$pop,col="red")
})
output$Qqplot <- renderPlot({
  Qqplot()
})
##
output$Nue1 <- renderPlot({
  coordinates(Base)= ~POINT_X+POINT_Y
  vgm<-variogram(Base$pop~1, Base, cloud=TRUE)
  pp<-plot(vgm,col="blue",main="Nuéé Variographique omnidirectionnelle",id=TRUE)
  abline(h=mean(vgm$gamma), col="red",lwd=2, lty=2)
  vgmreg <- lm(vgm$gamma~vgm$dist)
  abline(vgmreg, col=3, lwd=2)  
})
##
output$Nue2 <- renderPlot({
  coordinates(Base)= ~POINT_X+POINT_Y
  bubble(Base,"pop",main="Dispersion des Lieudits en fonction de la densité")
})

output$Nue3 <- renderPlot({
  coordinates(Base) <- ~POINT_X+POINT_Y
  pop.vgm<- gstat::variogram(pop~ 1 , Base, cutoff=10000)
  pop.fit<-gstat::fit.variogram(pop.vgm,vgm("Sph"))
  plot(pop.vgm , pop.fit, main= "Variogramme estimé par un modéle spherique")
})

# RCPP
cppFunction('double sigmapop(NumericVector x) {
  double sigma = sd(x);
            return sigma;
}')

## Mean
cppFunction('double meanpop(NumericVector x) {
            int n = x.size();
            double total = 0;
            
            for(int i = 0; i < n; ++i) {
            total += x[i];
            }
            return total / n;
            }')

## Test normalité
test <- eventReactive(input$view6,{
  mm <- meanpop(Base$pop)
  sd <- sigmapop(Base$pop)
  ks.test(Base$pop,"pnorm",mm,sd)
})

output$test <- renderPrint({
  test()
})

#### RCPP en PLot

nuage <- eventReactive(input$view7,{
  plot(Base$pop,type="p",
       main=paste("NUage de point"))
  abline(h=0,col="blue",lty=2)
  grid()
})

output$nuage <- renderPlot({
  nuage()
})


})
