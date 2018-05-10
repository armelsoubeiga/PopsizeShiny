

#' @title Estimation de la taille de population
#' @description Prend en parametres des coordonnées géographique et retour la taille de population à ce lieudit
#' @return la taille de population
#' @param Y0
#' @param X0
#' @export
#'
#'
estimation <- function(X0,Y0)
{
  
  data(MyData)
  pop <- base[,17]
  #matrice de distance
  cords<-base[c("POINT_X","POINT_Y")]
  S0<-c(X0,Y0)
  cords<-as.matrix(rbind(S0,cords))
  dist <- as.matrix(dist(cords)) 
  
  #Fonction S3
  MatrixCor<- function(x,pa,ep, maybe = "some", other = "arguments", ...) {
    UseMethod("MatrixCor")
  }
  
  MatrixCor.matrix<-function(x,pa,ep)
  {
    po=mean(x)

    for( i in 1:length(x)){
      
      dist1 <- x
      
      if(dist1[i]==0){
        dist1[i]=0
      }
      
      else if(dist1[i] > 0 & dist1[i] <= po){
        dist1[i]= ep+(pa-ep)*(1.5*(dist1[i]/po)-0.5*(dist1[i]/po)^3)
      }
      
      else if(dist1[i]> po){}
      dist1[i]=pa
    }
    return(dist1)
  }
  pa=4593.973
  ep=2267.514 
  #covariance
  dist2=MatrixCor(dist,pa,ep)
  for( i in 1:length(dist2))
    dist2[i]<- (pa-dist2[i]) 
  
  #calcul des coeficient (K*coef=k0)
  #K
  K1<- dist2[-1,-1]
  K2<- cbind(K1,1)
  v1<-rep(1,length(K1[,1]))
  v2<-c(v1,0)
  K<-rbind(K2,v2)
  
  #k0
  kk<-dist2[1,]
  k0<-c(kk[-1],1)
  
  #coef
  coef<-k0%*%solve(K)
  coefs<-coef[-length(coef)]
  Z0<-sum(coefs%*%pop)
  
  #resultat
  return(Z0)
}