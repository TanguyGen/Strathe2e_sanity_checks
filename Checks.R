library(StrathE2E2)

rm(list=ls())

model10 <- e2e_read("Norwegian_Basin", "2010-2019-ssp370", models.path="..")
model20 <- e2e_read("Norwegian_Basin", "2020-2029-ssp370", models.path="..")
model30 <- e2e_read("Norwegian_Basin", "2030-2039-ssp370", models.path="..")
model40 <- e2e_read("Norwegian_Basin", "2040-2049-ssp370", models.path="..")


HR<-c(0.50,1.00,1.25,1.50)
name<-c("model10","model20","model30","model40")
list_model<-list()
for (i in name){
  for (j in HR){
    new_model<-get(i)
    new_model$data$fleet.model$HRscale_vector_multiplier[1]<- j
    harvest_ratio<-format(j,nsmall=2)
    new_model$setup$model.ident<-paste0(i,"_HR",harvest_ratio)
    assign(paste0(i,"_HR",harvest_ratio),new_model)
  }
}
rm(model10,model20,model30,model40)
names_model <- ls(pattern="^model")


for (i in names_model){
  model<-get(i)
  new_res<-e2e_run(model,nyear=10)
  assign(gsub("model", "res_", i), new_res)
}

e2e_compare_obs(model10_HR1.00,results = res_10_HR1.00,selection="ANNUAL")
e2e_compare_obs(model10_HR1.00,results = res_10_HR1.00,selection="MONTHLY")
e2e_plot_migration(model10_HR1.00, results=res_10_HR1.00)
e2e_plot_edrivers(model10_HR1.00)
e2e_plot_eco(model10_HR1.00, , selection="NUT_PHYT",results=res_10_HR1.00)
e2e_plot_eco(model10_HR1.00, , selection="ZOOPLANKTON",results=res_10_HR1.00)
e2e_plot_eco(model10_HR1.00, , selection="FISH",results=res_10_HR1.00)
e2e_plot_eco(model10_HR1.00, , selection="PREDATORS",results=res_10_HR1.00)
e2e_plot_eco(model10_HR1.00, , selection="MACROPHYTE",results=res_10_HR1.00)
e2e_plot_fdrivers(model10_HR1.00, selection="ACTIVITY")
e2e_plot_fdrivers(model10_HR1.00, selection="HARVESTR")
e2e_plot_fdrivers(model10_HR1.00, selection="DISCARDS")
e2e_plot_trophic(model10_HR1.00,results=res_10_HR1.00)
e2e_plot_catch(model10_HR1.00,results=res_10_HR1.00, selection = "BY_GEAR")
e2e_plot_catch(model10_HR1.00,results=res_10_HR1.00, selection = "BY_GUILD")