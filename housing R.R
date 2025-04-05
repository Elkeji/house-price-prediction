#Install and load necessary packages
install.packages("DBI")
install.packages("RMySQL")  # or install.packages("RMariaDB")
library(DBI)
library(RMySQL)
#Establish a database connection
con <- dbConnect(RMySQL::MySQL(),
                 dbname = "house_prices",
                 host = "127.0.0.1",
                 port = 3306,
                 user = "root",
                 password = "Datanuel@1")
#Query data from the database
house_data <- dbGetQuery(con, "SELECT * FROM house_data")
#Initial data exploration
head(house_data)
str(house_data)
summary(house_data)
head(house_data)
#Initial data visualization
hist(house_data$SalePrice, main="Distribution of SalePrice", xlab="SalePrice", col="skyblue")
hist(house_data$GrLivArea, main="Distribution of GrLivArea", xlab="GrLivArea", col="honeydew3")
plot(house_data$GrLivArea, house_data$SalePrice,
     xlab="Above-ground Living Area",
     ylab="Sale Price",
     main="GrLivArea vs Sale Price", pch=19, col="plum")
boxplot(SalePrice ~ Neighborhood, data=house_data,
        main="Sale Price by Neighborhood", xlab="Neighborhood", ylab="Sale Price", las=2)
#Data preprocessing
house_data <- na.omit(house_data)  # Simple approach: remove rows with NA values
house_data$AreaCategory <- cut(house_data$GrLivArea,
                               breaks=c(0, 1000, 2000, Inf),
                               labels=c("Small", "Medium", "Large"))
#Data splitting
set.seed(42)
sample_indices <- sample(seq_len(nrow(house_data)), size = 0.8 * nrow(house_data))
train_data <- house_data[sample_indices, ]
test_data <- house_data[-sample_indices, ]
#Building a linear regression model
model <- lm(SalePrice ~ GrLivArea + LotArea + OverallQual + YearBuilt, data=train_data)
summary(model)
#Model evaluation
predictions <- predict(model, newdata = test_data)
#Mean Squared Error (MSE):
mse <- mean((test_data$SalePrice - predictions)^2)
print(paste("MSE:", mse))
#Root Mean Squared Error (RMSE):
rmse <- sqrt(mse)
print(paste("RMSE:", rmse))
#Mean Absolute Error (MAE):
mae <- mean(abs(test_data$SalePrice - predictions))
print(paste("MAE:", mae))
#R-squared and Adjusted R-squared from the model summary:
model_summary <- summary(model)
r_squared <- model_summary$r.squared
adj_r_squared <- model_summary$adj.r.squared
print(paste("R-squared:", r_squared))
print(paste("Adjusted R-squared:", adj_r_squared))
par(mfrow=c(2,2))  
#Model diagnostics
plot(model)
qqnorm(residuals(model), main="Q-Q Plot of Residuals")
qqline(residuals(model), col="red")
#Cross-validation
install.packages("caret")
library(caret)
train_control <- trainControl(method="cv", number=10)
cv_model <- train(SalePrice ~ GrLivArea + LotArea + OverallQual + YearBuilt, data=train_data,
                  method="lm", trControl=train_control)
print(cv_model)
