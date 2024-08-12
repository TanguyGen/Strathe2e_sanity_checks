library(StrathE2E2)
library(dplyr)
library(tidyr)
library(ggplot2)
library(patchwork)


rm(list=ls())

model <- e2e_read("Norwegian_Basin", "2010-2019-ssp370", models.path="..")
res=e2e_run(model,nyear=50)

elt<-function(var,name){
  return(var[[name]])
}
C_to_chl<-20   # Assumed carbon to chlorophyll ratio
data		<- elt(model, "data")
out<-elt(res,"output")
physical.parms	<- elt(data, "physical.parameters")
chemistry.drivers	<- elt(data, "chemistry.drivers")
si_phyt<-elt(out, "phyt_si")
so_phyt<-elt(out, "phyt_so")
si_depth	<- elt(physical.parms, "si_depth")
so_depth	<- elt(physical.parms, "so_depth")

xvolume_si<-si_depth*x_shallowprop
xvolume_so<-so_depth*(1-x_shallowprop)
final_s_phyt<-data.frame(rep(0,12))

for(mon in 1:12){
final_s_phyt[mon,1]<-mean(((((si_phyt[((50-1)*360+((mon-1)*30)+1):((50-1)*360+(mon*30))]))*12*106)/16)/C_to_chl)/xvolume_si
final_s_phyt[mon,2]<-mean(((((so_phyt[((50-1)*360+((mon-1)*30)+1):((50-1)*360+(mon*30))]))*12*106)/16)/C_to_chl)/xvolume_so
final_s_phyt[mon,3]<-mon
}
colnames(final_s_phyt)<-c("Inshore","Offshore","Months")
final_s_phyt<-final_s_phyt%>%
  pivot_longer(cols=Inshore:Offshore)

ggplot(final_s_phyt,aes(x=Months,y=value,color=name))+
  geom_point(shape=16,size=4)+
  scale_x_continuous(breaks = seq(1, 12), labels = month.name)+
  theme_minimal()
