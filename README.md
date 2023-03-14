# PCRSanalysis

Project Title: Potential Utility of Risk Stratification for Multicancer Screening with Liquid Biopsy Tests

Description: 

The code delineates the steps to develop a sex-specific pan-cancer risk prediction model to estimate the risk of developing at least one cancer over the course of follow-up. The multicancer model included eleven cancer types (bladder, breast [Female-only], colorectum, endometrium [Female-only], kidney, lung, melanoma, Non-Hodgkin’s lymphoma, ovary [Female-only], pancreas, and prostate [Male-only]) and classical risk factors (body mass index, family history of cancers, and smoking status/pack years of smoking). Data were split into ⅔ training set and ⅓ of test set—independent validation datasets used for model performance evaluation and subsequent analysis. 

Cox proportional hazard regression (Cox) model was fitted to the training set with the outcome as an incidence of any first cancer included in the analysis. The models specified a baseline hazard as a function of age and assumed multiplicative effects of the risk factors. Please refer to Cox, D. R. Regression Models and Life-Tables. J. R. Stat. Soc. Ser. B Methodol. 34, 187–202 (1972) for further information on the Cox model. 

We computed pan-cancer risk scores (PCRS) or cancer-specific risk scores for all UK Biobank participants as the weighted sum of the predictors, with weights for each predictor as the estimated log hazard ratio (HRs) from the fitted Cox model. Then, in the test set, we assessed the discriminatory accuracy of the pan-cancer risk score (PCRS) or the cancer-specific risk score (for individual cancer models) using Harrel's concordance index (C-statistic) and area under the curve (AUC) at five years of follow-up. 

Comments about the censoring dates (Study exit age): 

As UK Biobank is a left-truncated and right-censored cohort, we used age as the timescale for the Cox model—that is, participants enter the model at recruitment age and exit at cancer incidence age, censoring age, or death age–whichever occurs first. We used the censoring date for the cancer registry data provided by UKBB49. In the underlying analysis of the UK Biobank data using the Cox proportional hazard model, the “event” is defined as the occurrence of any of these cancers, and the “time-to-event” is the time to first onset of any of these cancers.  Thus, if an individual has multiple cancers, e.g lung cancer first and then prostate, the individual is censored at the onset of the lung cancer. Further, if an individual first develops cancer of a type other than the ones included in our list, then they are censored at the first onset of those cancer types. Further, deaths from non-cancer causes were also treated as censoring events. Thus, the underlying hazard ratio parameters of the model can be interpreted as the instantaneous risk of developing at least one among the set of selected cancers, given a person was free of all cancers up to that time point. 

Absolute Risk Estimation using iCARE (Individualized Coherent Absolute Risk Estimation):

We used iCARE to build our absolute risk model. Detailed methodology for absolute risk model building is described in Choudhury et al. 2020 (iCARE, https://www.bioconductor.org/packages/release/bioc/html/iCARE.html). Briefly, risk estimates for each individual in the test set were obtained by feeding age-specific cancer incidence rates by 1-year strata, log HR parameters from the Cox model, and the reference dataset into the model. We used 2016 cancer incidence rates in white individuals of the SEER*Stat database (www.seer.cancer.gov). Site-specific cancer incidence rates were obtained and then added to get the overall incidence rates for any cancer included in our study. Cancer incidence rates for a given age and sex were determined by the following year's cancer incidence rates. 

R Packages Used in Project:

This project was developed using R version 4.2.2 and the following packages:

dplyr: https://cran.r-project.org/web/packages/dplyr/index.html.

iCARE: https://www.bioconductor.org/packages/release/bioc/html/iCARE.html.

eeptools: https://cran.r-project.org/web/packages/eeptools/index.html.

survminer: https://cran.r-project.org/web/packages/survminer/index.html to learn more.

survival: https://cran.r-project.org/web/packages/survival/index.html.

data.table: https://rdatatable.gitlab.io/data.table/ for more information.

ukbtools: https://cran.r-project.org/web/packages/ukbtools/index.html.

easypackages: https://cran.r-project.org/web/packages/easypackages/index.html.

gridExtra: https://cran.r-project.org/web/packages/gridExtra/index.html to learn more.

ggplot2: https://ggplot2.tidyverse.org/.

randomcoloR: https://cran.r-project.org/web/packages/randomcoloR/index.html for more information.

ggpubr: https://cran.r-project.org/web/packages/ggpubr/index.html.

RISCA: https://cran.r-project.org/web/packages/RISCA/index.html.

This list of packages listed here is not exhaustive, but it covers the most of the major packages used in this project. Note that all packages are available on the Comprehensive R Archive Network (CRAN) unless otherwise specified. All other codes are available upon request. 
