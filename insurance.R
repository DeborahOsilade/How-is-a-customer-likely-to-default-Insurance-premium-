#libraries

library(dplyr)
library(DataExplorer)
library(janitor)
library(MASS)
library(summarytools)

#changing the class to a dataframe
colnames(Insurance_Premium)
class(Insurance_Premium)
Insurance_Premium <- as.data.frame(Insurance_Premium) #making the dataset a dataframe

#renaming variables
new_vars <- c("id","Premuim_%_by_cash","Age_of_customer", "income", "late in 3-6 months","late in 6-12 months","late more than 12 months","marital_status", "veh_owned" , "no_of_dep", "accomodation", "risk_score",
              "no_of_premiums_paid","sourcing_channel" ,"residence_area_type" ,"total_premium", "default")

colnames(Insurance_Premium) <- new_vars
colnames(Insurance_Premium)
Insurance_Premium <- clean_names(Insurance_Premium)


##Changing the structure of variables

Insurance_Premium$marital_status  <-  as.factor(Insurance_Premium$marital_status)
Insurance_Premium$veh_owned <-  as.factor(Insurance_Premium$veh_owned)
Insurance_Premium$default <-  as.factor(Insurance_Premium$default)
Insurance_Premium$no_of_dep <-  as.factor(Insurance_Premium$no_of_dep)
Insurance_Premium$accomodation <-  as.factor(Insurance_Premium$accomodation)
Insurance_Premium$residence_area_type <-  as.factor(Insurance_Premium$residence_area_type)
Insurance_Premium$sourcing_channel<-  as.factor(Insurance_Premium$sourcing_channel)
Insurance_Premium$late_in_3_6_months  <-  as.factor(Insurance_Premium$late_in_3_6_months) # better off as factor variables
Insurance_Premium$late_in_6_12_months <-  as.factor(Insurance_Premium$late_in_6_12_months)
Insurance_Premium$late_more_than_12_months<-  as.factor(Insurance_Premium$late_more_than_12_months)


#Attaching the variables 

str(Insurance_Premium)
attach(Insurance_Premium)


#Checking for missing value 

plot_intro(Insurance_Premium) # 59% discrete columns ,41% continuous, all rows are complete, no missing values 
View(dfSummary(Insurance_Premium))


#finding the total no of default 

sum(default=='1') #74855
sum(default=='1') / 79853 * 100 # 93% of people are non defaulters
sum(default=='0') #4998
sum(default=='0') /79853 * 100 # 6% of customers are defaulters


#transforming age of customer

Insurance_Premium$age_of_customer <- Insurance_Premium$age_of_customer/365 #divide by 365 to get the age in years 
head(Insurance_Premium,10)
Insurance_Premium$age_of_customer <-  round(Insurance_Premium$age_of_customer) #change the decimals to whole numbers


#rounding up risk score 

Insurance_Premium$risk_score <- round(Insurance_Premium$risk_score)
head(Insurance_Premium,10)


#Creating a new variable (Cash_payments)

cash_payments <- premuim_percent_by_cash * 100 * total_premium
View(cash_payments)
summary(cash_payments)


#breaking scientific number 

summary(Insurance_Premium)
options(scipen = 999)


#adding cash payments to the dataset 

Insurance_Premium <- cbind(Insurance_Premium,cash_payments) # making cash payments a new variable 
View(Insurance_Premium)



#Univarte analysis

library(ggplot2)
library(ggpubr)


#histogram

a1 <- ggplot(Insurance_Premium,aes(age_of_customer)) +geom_histogram( fill="white",colour="black")+ ggtitle("Age of customer")

i1 <-ggplot(Insurance_Premium,aes(income)) + geom_histogram(fill= "white", colour= "black") + ggtitle("Histogram of Income")

tp1 <- ggplot(Insurance_Premium,aes(total_premium)) + geom_histogram(fill= "white", colour= "black") + ggtitle("Histogram Of premium")

np1 <- ggplot(Insurance_Premium,aes(no_of_premiums_paid)) + geom_histogram(fill= "white", colour= "black") + ggtitle("NO of premuim paid ")

r1 <- ggplot(Insurance_Premium,aes(risk_score)) + geom_histogram(fill= "white", colour= "black") + ggtitle("Histogram of risk")

c1 <- ggplot(Insurance_Premium,aes(Cash_payments)) + geom_histogram(fill= "white", colour= "black") + ggtitle("Histogram of Cash payment")




figure_A <- ggarrange(a1,i1,tp1,np1,r1,c1,ncol=3, nrow= 2)
figure_A
ggsave(figure_A, file ="plot.png")


#boxplots 

a2 <- ggplot(Insurance_Premium,aes(age_of_customer )) + geom_boxplot() + ggtitle("Boxplot of age")
i2 <- ggplot(Insurance_Premium,aes(income)) + geom_boxplot() + ggtitle("Boxplot of Income")
tp2 <- ggplot(Insurance_Premium,aes(total_premium )) + geom_boxplot() + ggtitle("boxplot of premuim")
p2 <-ggplot(Insurance_Premium,aes(no_of_premiums_paid)) + geom_boxplot(fill= "white", colour= "black") + ggtitle("NO of premuim paid ")
r2 <- ggplot(Insurance_Premium,aes(risk_score)) + geom_boxplot() + ggtitle("Boxplot of risk")
c2 <- ggplot(Insurance_Premium,aes(Cash_payments)) + geom_boxplot() + ggtitle("cash payments")



figure_B <- ggarrange(a2,i2,tp2,p2,r2,c2,ncol=3, nrow= 2)
figure_B
ggsave(figure_B, file ="plot.png")


#Factor variables 

sc <- ggplot(Insurance_Premium,aes(sourcing_channel)) +geom_bar(fill="dark green",colour ="black") + ggtitle("How customers are sourced")

df <- ggplot(Insurance_Premium,aes(default)) +geom_bar(fill="dark green",colour ="black") + ggtitle("Default or not")

ms <- ggplot(Insurance_Premium,aes(marital_status)) +geom_bar(fill="dark green",colour ="black") + ggtitle("Married or not ")

lt <- ggplot(Insurance_Premium,aes(late_in_3_6_months)) +geom_bar(fill="dark green",colour ="black") + ggtitle("late payments 3-6 months")

lp <- ggplot(Insurance_Premium,aes(late_in_6_12_months)) +geom_bar(fill="dark green",colour ="black") + ggtitle("late payments 6 - 12 months")

lg <- ggplot(Insurance_Premium,aes(late_more_than_12_months)) +geom_bar(fill="dark green",colour ="black") + ggtitle("late payments over 12 months")

nd <- ggplot(Insurance_Premium,aes(no_of_dep)) +geom_bar(fill="dark green",colour ="black") + ggtitle("No of dependents per household")

acc <- ggplot(Insurance_Premium,aes(accomodation)) +geom_bar(fill="dark green",colour ="black") + ggtitle("Owned accomodation or not")

veh <- ggplot(Insurance_Premium,aes(veh_owned)) +geom_bar(fill="dark green",colour ="black") +  ggtitle("No of vehicles owned")

rt <- ggplot(Insurance_Premium,aes(residence_area_type)) +geom_bar(fill="dark green",colour ="black") + ggtitle("Residence area")



figure_c <- ggarrange(sc,df,ms,lt,lp,lg,ncol=3, nrow= 2)
figure_c
ggsave(figure_c, file ="plot.png")



figure_d <- ggarrange(nd,acc,veh,rt,ncol=2, nrow= 2)
figure_d
ggsave(figure_d, file ="plot.png")


#correlation

plot_correlation(Insurance_Premium, maxcat = 3)



#Bivirate analysis


ps <-ggplot(Insurance_Premium,aes(x=total_premium,y=sourcing_channel, 
                                  colour= sourcing_channel))+geom_boxplot()+ ggtitle("Total premium paid per sourcing channel")

npp <- ggplot(Insurance_Premium,aes(x= total_premium, y = no_of_premiums_paid,colour = no_of_premiums_paid))+geom_point()+ ggtitle("Total no of premium paid")
npa <- npp+geom_point() + stat_smooth(method = lm)

dfs <-ggplot(Insurance_Premium, aes(x= default , y= sourcing_channel, colour= default)) +geom_boxplot()+ ggtitle("what sourcing channel defaults more")

it <- ggplot(Insurance_Premium, aes(x= income, y= total_premium, colour= income)) + geom_point()+ ggtitle("who pays more premium")

air <- ggplot(Insurance_Premium, aes(x= income, y= age_of_customer,colour= age_of_customer)) + geom_line() + ggtitle("who earns more")




lrs <- ggplot(Insurance_Premium,aes(x=late_in_3_6_months, y= risk_score,colour = default)) + geom_point() + ggtitle("risk score & 3-6 month late")

rsl <-ggplot(Insurance_Premium,aes(x= late_in_6_12_months, y= risk_score,colour= default))+ geom_point() + 
  ggtitle("risk score & 6-12 month late")

rs12 <- ggplot(Insurance_Premium,aes(x=late_more_than_12_months,y=risk_score,colour=default))+geom_point() + ggtitle("risk score & more than 12 months late")

cpp <-ggplot(Insurance_Premium,aes(x=total_premium,y=Cash_payments ,colour=default))+geom_point() + ggtitle("how is premium paid defaulted")

rsc <- ggplot(Insurance_Premium,aes(x= sourcing_channel, y = risk_score, colour = sourcing_channel)) +geom_boxplot() + ggtitle("what sourcing channel is high risk ")

prs<-ggplot(Insurance_Premium,aes(x=total_premium,y= age_of_customer,colour= default))+geom_point()+ ggtitle("are younger people likely to default")
agd <- prs+geom_point() + stat_smooth(method = lm)


figure_e <- ggarrange(npa,dfs,it,air,lrs,rsl,ncol=2, nrow= 3)
figure_e
ggsave(figure_d, file ="plot.png")


figure_f <- ggarrange(rs12,cpp,rsc,agd,ncol=2, nrow= 2)
figure_f
ggsave(figure_d, file ="plot.png")



#income 

var(income) #variance is 246594275899
sd(income)  # sd is 496582.6
Range_of_income<-max(income) - min(income) #90238570
quantile(income,c(0.01,0.02,0.03,0.1,0.2,0.3,0.4,0.50,0.6,0.7,0.8,0.9,0.95,0.99,1))
income[which(income >771078)] <- 771078
qqnorm(income) + qqline(income)


#total premium

var(total_premium) #var is 88391522
sd(total_premium) # sd is 9401.677
max(total_premium) - min(total_premium) #58800
quantile(total_premium ,c(0.01,0.02,0.03,0.1,0.2,0.3,0.4,0.50,0.6,0.7,0.8,0.9,0.95,0.99,1))
total_premium[which(total_premium >51600)] <-51600
qqnorm(total_premium) + qqline(total_premium)


#no of premium paid

var(no_of_premiums_paid) #var is 26.73601
sd(no_of_premiums_paid)  #sd is 5.170687
qqnorm(no_of_premiums_paid)
quantile(no_of_premiums_paid ,c(0.01,0.02,0.03,0.1,0.2,0.3,0.4,0.50,0.6,0.7,0.8,0.9,0.95,0.99,1))
no_of_premiums_paid[which(no_of_premiums_paid > 27)] <- 27


#risk score 

var(risk_score) #0.6444161
sd(risk_score) #0.8027553
max(risk_score) - min(risk_score) #8
quantile(risk_score,c(0.01,0.02,0.03,0.1,0.2,0.3,0.4,0.50,0.6,0.7,0.8,0.9,0.95,0.99,1))
qqnorm(risk_score) 
qqline(risk_score)


#cash payments

var(Cash_payments) 
sd(Cash_payments) 
max(Cash_payments) - min(Cash_payments) 
quantile(cash_payments,c(0.01,0.02,0.03,0.1,0.2,0.3,0.4,0.50,0.6,0.7,0.8,0.9,0.95,0.99,1))
cash_payments[which(cash_payments>2430000 )] <- 2430000 
qqnorm(Cash_payments) 
qqline(Cash_payments)


#Binning Variables

str(Insurance_Premium)
levels(Insurance_Premium$late_in_3_6_months)
levels(Insurance_Premium$late_in_3_6_months)[1] <- "never late" 
levels(Insurance_Premium$late_in_3_6_months)[2:4] <- "unpunctual" 
levels(Insurance_Premium$late_in_3_6_months)[3:5] <- "delays" 
levels(Insurance_Premium$late_in_3_6_months)[4:6] <- "long delayed"
levels(Insurance_Premium$late_in_3_6_months)[5:8] <- "behind time" 


levels(Insurance_Premium$late_in_6_12_months)
levels(Insurance_Premium$late_in_6_12_months)[1] <- "never late" 
levels(Insurance_Premium$late_in_6_12_months)[2:6] <- "unpunctual" 
levels(Insurance_Premium$late_in_6_12_months)[3:5] <- "delays" 
levels(Insurance_Premium$late_in_6_12_months)[4:7] <- "long delayed"
levels(Insurance_Premium$late_in_6_12_months)[5:8] <- "behind time"



levels(Insurance_Premium$late_more_than_12_months)
levels(Insurance_Premium$late_more_than_12_months)[1] <- "never late" 
levels(Insurance_Premium$late_more_than_12_months)[2:3] <- "unpunctual" 
levels(Insurance_Premium$late_more_than_12_months)[3:4] <- "delays" 
levels(Insurance_Premium$late_more_than_12_months)[4:5] <- "long delayed"
levels(Insurance_Premium$late_more_than_12_months)[5:7] <- "behind time"

#dropping variables 

Insurance_Premium <- Insurance_Premium[-c(1)]
str(Insurance_Premium)


library(Information)


Insurance_Premium$default <- as.numeric(Insurance_Premium$default)
str(Insurance_Premium)



Insurance_Premium$default  <- recode(Insurance_Premium$default,"2"= 1L ,"1" =0L)
InformationValue <- create_infotables(data=Insurance_Premium, y="default", bins= 20, parallel=TRUE)


IV_Value = data.frame(InformationValue$Summary)
InformationValue



#using the woe to treat outliers

library(scorecard)
data_filter = var_filter(Insurance_Premium, y="default")


bins1 = woebin(data_filter , y="default")


bins1$premuim_percent_by_cash



#replacing dataset 

Insurance_Premium1 <- woebin_ply(Insurance_Premium,bins1)
View(Insurance_Premium1)
library(DataExplorer)


#plotting the new data

boxplot(Insurance_Premium1)
plot_boxplot(Insurance_Premium1, by = "default")


#correlation

plot_correlation(Insurance_Premium1, maxcat = 1)



levels(Insurance_Premium$residence_area_type) <- c("0", "1")
levels(Insurance_Premium$sourcing_channel) <- c("1", "2","3","4","5")


library(caTools)
set.seed(129)
index <- sample.split(Insurance_Premium, SplitRatio = 0.80)
insur.clust = subset(Insurance_Premium, index == F)
dim
str(insur.clust)
insur.clust$sourcing_channel <- as.factor(insur.clust$sourcing_channel)
insur.clust$residence_area_type <- as.factor(insur.clust$residence_area_type)
levels(Insurance_Premium$sourcing_channel)
levels(insur.clust$residence_area_type) 

insur.clust$residence_area_type <- as.numeric(insur.clust$residence_area_type)
insur.clust$sourcing_channel<- as.numeric(insur.clust$sourcing_channel)



#split dataset 

library(caTools)
library(xgboost)
library(DMwR)
library(caret)
library(gbm)


# Ensure that the target variable is a factor & Rename the levels & Relevel

levels(Insurance_Premium$residence_area_type) <- c("Rural", "Urban")
levels(Insurance_Premium$sourcing_channel) <- c("A", "B","C","D","E") 

str(Insurance_Premium)
Insurance_Premium1$default <- as.factor(Insurance_Premium1$default)

levels(Insurance_Premium$default)
levels(Insurance_Premium$default) <- c("yes", "no")
Insurance_Premium$default<- relevel(Insurance_Premium$default, ref = "yes") # Reference class : 0


#clustering

# ** All the columns values are on the same scale therefore scaling not required 
insurance.Scaled = scale(Insurance_Premium[,1:16])
View(insurance.Scaled)

#Calculate Euclidean Distance between data points
Thera_bank_distance = dist(x=insur.clust, method = "euclidean") 
sum(is.na(insur.clust))
print(Thera_bank_distance, digits = 3)


library(cluster)
library(factoextra)
fviz_nbclust(insur.clust,pam,method = "silhouette") + theme_classic
nc<- clara(insur.clust,2,metric="manhattan",stand = FALSE, samples = 5,pamLike = FALSE)
nc
fviz_cluster(nc)


table(Insurance_Premium$default)
sdf <- SMOTE(default ~ ., Insurance_Premium)
table(sdf$default)
Carsdf <- rbind(Insurance_Premium,sdf)
table(Carsdf$default)


#divide data into train and test 
# Divide data in "70:30"
set.seed(100)

Part_premium_data <- sample(1:nrow(Carsdf), 0.7*nrow(Carsdf))

# Training set
train_premium_data <- Carsdf[Part_premium_data,]


# Test set
test_premium_data <- Carsdf[-Part_premium_data,]
dim(train_premium_data) #55897    18
dim(test_premium_data) #23956    18

table(train_premium_data$default) # 0 - 3469 , 1 - 52428 on the train set 

table(test_premium_data$default) # 0 - 1529 , 1 - 22427 on the test set 


# Setting up the general parameters for training multiple models

# Define the training control
fitControl <- trainControl(
  method = 'repeatedcv',           # k-fold cross validation
  number = 3,                     # number of folds or k
  repeats = 1,                     # repeated k-fold cross-validation
  allowParallel = TRUE,
  classProbs = TRUE,
  summaryFunction=twoClassSummary# should class probabilities be returned
) 


#Setting the control parameters
library(rpart)
insurance_ctrl_parameter = rpart.control(minsplit=100, minbucket = 20, cp = 0.0021 , xval = 20,trControl = fitControl)


#model 1 Building the CART model

insurance_Cart_Model2<- rpart(formula = default~., data = train_premium_data, 
                              method = "class",control = insurance_ctrl_parameter)



insurance_Cart_Model<- train(default ~ ., data = train_premium_data,
                             method = "rpart",
                             minbucket = 100,
                             cp = 0.0021,
                             tuneLength = 10,
                             trControl = fitControl)


#plotting cart model 

library(rattle)
fancyRpartPlot(insurance_Cart_Model2, cex= 0.6)
fancyRpartPlot(insurance_Cart_Model$finalModel,digits = 5 )
plot(insurance_Cart_Model)
varImp(insurance_Cart_Model2)


library(caret)
cart_predictions_test <- predict(insurance_Cart_Model2, newdata = test_premium_data, type = "class")
confusionMatrix(as.factor(cart_predictions_test),as.factor(test_premium_data$default))


library(caret)
cart_predictions_train <- predict(insurance_Cart_Model, newdata = train_premium_data, type = "class")
confusionMatrix(as.factor(cart_predictions_train),as.factor(train_premium_data$default))


#Randomforests model

set.seed(100)

library(randomForest)

insurance_rndForest <- randomForest(default~ ., data = train_premium_data,ntree=301,mtry=5, nodesize=10,importance=TRUE, trControl = fitControl) 

# Model_5 : Random Forest 
insurance_rndForest<- train(default ~ ., data = train_premium_data,
                            method = "rf",
                            ntree = 30,
                            maxdepth = 5,
                            tuneLength = 10,
                            trControl = fitControl)


##Print the model to see the OOB and error rate
print(insurance_rndForest)

importance(insurance_rndForest)
varImpPlot(insurance_rndForest,type=2)

plot(importance(insurance_rndForest))
plot(insurance_rndForest)  


#checking model performance using ROC Curve

rf_predictions_prob <- predict(insurance_rndForest, newdata = test_premium_data, type = "raw")

# Creating the prediction object using ROCR library
library(ROCR)
rf_pred_obj = prediction(as.numeric(rf_predictions_prob) , as.numeric(test_premium_data$default))

# Plotting the ROC curve 
roc_rf = performance(rf_pred_obj, "tpr", "fpr")
plot(roc_rf, colorize=TRUE, main="ROC curve") +abline(a=0,b=1,lty=3)

# Plotting the PR curve
precision_recall_rf<- performance(rf_pred_obj, "ppv", "tpr")
plot(precision_recall_rf, xlab = "Recall", ylab = "Precision",colorize=TRUE)


# Computing the area under the curve
auc = performance(rf_pred_obj,"auc"); 
auc = as.numeric(auc@y.values)
auc


library(caret)
rd_predictions_test <- predict(insurance_rndForest, newdata = test_premium_data, type = "class")
confusionMatrix(as.factor(rd_predictions_test),as.factor(test_premium_data$default))

library(caret)
rd_predictions_train <- predict(insurance_rndForest, newdata = train_premium_data, type = "class")
confusionMatrix(as.factor(rd_predictions_train),as.factor(train_premium_data$default))


lr_model <- train(default~., data = train_premium_data,
                  method = "glm",
                  family = "binomial",trControl = fitControl)



summary(lr_model)
plot(varImp(lr_model, main = lr_model))


====================  CHECK_PERFORMANCE : USING_ROC_&_PR_CURVES  ==================
  
  lr_predictions_prob <- predict(lr_model, newdata = test_premium_data, type = "raw")

# Creating the prediction object using ROCR library
library(ROCR)
lr_pred_obj = prediction(as.numeric(lr_predictions_prob) , as.numeric (test_premium_data$default))

# Plotting the ROC curve 
roc_LR = performance(lr_pred_obj, "tpr", "fpr")
plot(roc_LR, colorize=TRUE,main="ROC curve") +abline(a=0,b=1,lty=3)
plot(roc_LR, main="ROC curve") +abline(a=0,b=1,lty=3)

# Plotting the PR curve
precision_recall_LR<- performance(lr_pred_obj, "ppv", "tpr")
plot(precision_recall_LR, xlab = "Recall", ylab = "Precision",colorize=TRUE)


# Computing the area under the curve
auc = performance(lr_pred_obj,"auc"); 
auc = as.numeric(auc@y.values)
auc

=============================  CHECK_PERFORMANCE : USING_CONFUSION_MATRIX  =================
  
  library(caret)
lr_predictions_test <- predict(lr_model, newdata = test_premium_data, type = "raw")
confusionMatrix(as.factor(lr_predictions_test),as.factor(test_premium_data$default))


library(caret)
lr_predictions_train <- predict(lr_model, newdata = train_premium_data, type = "raw")
confusionMatrix(as.factor(lr_predictions_train),as.factor(train_premium_data$default))


table(as.factor(train_premium_data$default),as.factor(lr_predictions_train))



# Gradient Boosting Machines 

gbm_model <- train(default ~ ., data = train_premium_data,
                   method = "gbm",
                   verbose = FALSE,
                   trControl = fitControl)

library(caret)
gbm_predictions_test <- predict( gbm_model, newdata = test_premium_data, type = "raw")
confusionMatrix(as.factor(gbm_predictions_test),as.factor(test_premium_data$default))


library(caret)
gbm_predictions_train <- predict( gbm_model, newdata = train_premium_data, type = "raw")
confusionMatrix(as.factor(gbm_predictions_train),as.factor(train_premium_data$default))



# Xtreme Gradient boosting Machines 


fitControl <- trainControl(
  method = 'repeatedcv',           # k-fold cross validation
  number = 3,                     # number of folds or k
  repeats = 1,                     # repeated k-fold cross-validation
  allowParallel = TRUE,
  classProbs = TRUE,
  summaryFunction=twoClassSummary)

xgb.grid <- expand.grid(nrounds = 100,
                        eta = c(0.01),
                        max_depth = c(2,4),
                        gamma = 0,               #default=0
                        colsample_bytree = 1,    #default=1
                        min_child_weight = 1,    #default=1
                        subsample = 1           #default=1
)

xgb_model <-train(default~.,
                  data=Insurance_Premium,
                  method="xgbTree",
                  trControl=fitControl,
                  tuneGrid=xgb.grid,
                  metric="ROC",
                  verbose=T,
                  nthread = 2
)

plot(xgb_model)
plot(varImp(xgb_model))



library(caret)
gb_predictions_test <- predict( xgb_model, newdata = test_premium_data, type = "raw")
confusionMatrix(as.factor(gb_predictions_test),as.factor(test_premium_data$default))




library(caret)
gb_predictions_train <- predict( xgb_model, newdata = train_premium_data, type = "raw")
confusionMatrix(as.factor(gb_predictions_train),as.factor(train_premium_data$default))


#model comparison

# Compare model performances using resample()
models_to_compare <- resamples(list(logistic_Regression= lr_model, DecisionTree= insurance_Cart_Model, Extreme_Gradient_Boosting =xgb_model,randomForest = insurance_rndForest ))

# Summary of the models performances
summary(models_to_compare)



# Draw box plots to compare models

scales <- list(x=list(relation="free"), y=list(relation="free"))
bwplot(models_to_compare, scales=scales)