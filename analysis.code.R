##############################################################################
# remove all objects in the environment
rm(list=ls())
# load required packages
library(easypackages)
libraries("iCARE","survival","eeptools","data.table","dplyr","RISCA")

##############################################################################
# DEVELOPING THE COX MODEL - FEMALE 
##############################################################################

# load in the training data
trfem = readRDS("/users/skim1/01282023/data_created/female.final.noimputation.train.02092023")
# load in the test data 
tefem = readRDS("/users/skim1/01282023/data_created/female.final.noimputation.test.02092023")

# Cox model
cox.female = coxph(Surv(age_at_study_entry, cancer_incidence_age, female_overall_cancer_incidence) ~ blad_std + brea_std + colo_std + endo_std + kidn_std + lung_std + mela_std + nhl_std + ovar_std + panc_std + bmi+ fhx_yes_no + smoking + pc1 + pc2 + pc3 + pc4 + pc5 + pc6 + pc7 + pc8 + pc9 + pc10, data = trfem)

#bmi: body mass index
#fhx_yes_no: family history of cancer (yes = 1, no = 0 )
#smoking: smoking status/pack years of history
#pc: genetic prinicpal components

# summary of the cox model 
summary(cox.female)

# extract the names of the predictors in the cox.female model object and store it in termL 
termL <- attr(terms(cox.female), "term.labels")

# compute the linear predictor for the training data 
lpnew.train = rowSums(predict(cox.female, trfem, type="terms", terms=termL[c(1:13)]))
lpnew.train.std = lpnew.train/sd(lpnew.train)
trfem$lp = lpnew.train.std

# compute the linear predictor for the test data 
lpnew.test = rowSums(predict(cox.female, tefem, type="terms", terms=termL[c(1:13)]))
lpnew.test.std = lpnew.test/sd(lpnew.test)
tefem$lp = lpnew.test.std

# cox model validation in the test data 
cox.female.test=coxph(Surv(age_at_study_entry, cancer_incidence_age, female_overall_cancer_incidence)~ lp + pc1 + pc2 + pc3 + pc4 + pc5+ pc6 + pc7 + pc8 + pc9 + pc10 ,data = tefem)

# summary of the cox model (test data )
summary(cox.female.test)

# 5-Year AUC 
tefem$futime=tefem$cancer_incidence_age - tefem$age_at_study_entry

auc5=roc.time(times="futime", failures="female_overall_cancer_incidence", variable = "lp",
              confounders= ~ pc1 + pc2 + pc3 + pc4 + pc5+ pc6 + pc7 + pc8 + pc9 + pc10, data = tefem, 
              pro.time = 5, precision = seq(0.01,0.99, by=0.01))
auc5$auc

##############################################################################
# Absolute Risk Calculation using iCARE 
##############################################################################
# beta coefficients 
beta=as.matrix(cox.female.test$coefficients[1])

row.names(beta)="cPRS"
trfem$cPRS=trfem$lp

row.names(beta)="cPRS"
trfem$cPRS=trfem$lp

test=as.vector(tefem$lp)
test=data.frame(test)
colnames(test)="cPRS"

# simulating reference dataset 
reference.dataset=data.frame(rnorm(10000, mean=mean(trfem$lp), sd=sd(trfem$lp)))
colnames(reference.dataset)="cPRS"

# model covariate info 
v1 = list(); v1$name = "cPRS"; v1$type = "continuous"
cov_info_0=list(v1)

# model formula 
model_form_0=female_overall_cancer_incidence ~ cPRS

# incidence rates (SEER)
incidence_rate=read.csv("/users/skim1/052020/FINAL_SNP_PROJECT/incidence_rate_seer_stat_08122020_female.csv")
inc = incidence_rate[,c(2,16)]
inc[,2]=inc[,2]/100000

# calculate yearly absolute risk from age 50 -85
age_from=c(50:85)

risk.data = matrix(data = NA, nrow = length(age_from), ncol = dim(tefem)[1], byrow = FALSE, dimnames = NULL)

for (i in 1:length(age_from)){
  res_covs_snps = computeAbsoluteRisk(model.formula = model_form_0, 
                                    model.cov.info = cov_info_0, 
                                    model.log.RR = beta,
                                    model.ref.dataset = reference.dataset,
                                    model.disease.incidence.rates = inc,
                                    apply.age.start = age_from[i],
                                    apply.age.interval.length = 1,
                                    apply.cov.profile=test)
  risk.data[i,c(1:dim(tefem)[1])] = as.vector(res_covs_snps$risk)}
