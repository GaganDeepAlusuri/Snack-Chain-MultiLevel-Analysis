rm(list=ls())
library(rio)
library(dplyr)
library(ggplot2)

t = import("SnackChain.xlsx", sheet= "transactions")
colnames(t)=tolower(make.names(colnames(t))) 
str(t)
s = import("SnackChain.xlsx", sheet= "stores")
colnames(s)=tolower(make.names(colnames(s))) 
str(s)
p = import("SnackChain.xlsx", sheet= "products")
colnames(p)=tolower(make.names(colnames(p))) 
str(p)

#Removing the oral products from products as stated
p<- p[!( p$category == "ORAL HYGIENE PRODUCTS"),]

par(mfrow = c(2, 3))
#Looking at dist of spend, units and hhs.
hspend = hist(t$spend, xlim = c(0, 1000), 
                        main = "Histogram of Spend", xlab = "Spend", ylab = "Frequency", 
                        col = "lightblue", border = "black")
hunits = hist(t$units, xlim = c(0, 1000), 
              main = "Histogram of Units", xlab = "units", ylab = "Frequency", 
              col = "green", border = "black")
hhhs = hist(t$hhs, xlim = c(0, 1000), 
            main = "Histogram of hhs", xlab = "HHS", ylab = "Frequency", 
            col = "red", border = "black")
#sum(t$spend == 0) #only 24 zeroes in spend.
#Log(spend)
lspend = hist(log(t$spend), xlim = c(0, 10), 
     main = "Histogram of log(Spend)", xlab = "log(Spend)", ylab = "Frequency", 
     col = "lightblue", border = "black")
#Looks normal. Can apply OLS.

#sum(t$units == 0) #only 5 zeroes in units.
#Log(units)
lunits = hist(log(t$units), xlim = c(0, 10), 
     main = "Histogram of log(Units)", xlab = "log(units)", ylab = "Frequency", 
     col = "green", border = "black")
#Looks normal. Can apply OLS.
#sum(t$hhs == 0) #no zeroes in hhs.
#Log(units)
lhhs = hist(log(t$units), xlim = c(0, 10), 
     main = "Histogram of log(Units)", xlab = "log(HHS)", ylab = "Frequency", 
     col = "red", border = "black")
# Reset the plot window to default settings
par(mfrow = c(1, 1))

tAndP = merge(x=t, y=p , by.x = "upc")
View(tAndP)
dim(tAndP)

merged = merge(x = tAndP,y = s,by.x ="store_num", by.y = "store_id")
View(merged)
dim(merged)

#Check NAs
colSums(is.na(merged))
#Parking has 282548 NA's. 
#Price has 10 NA's.
#base_price has 173 NA's.

#Removing parking column.
merged <- merged[, !(colnames(merged) %in% "parking")]
merged <- merged[complete.cases(merged), ]
colSums(is.na(merged))
str(merged)

#Converting certain columns to factors
col <- c("upc", "city", "store_num", "category", "state", "segment")
merged[col] = lapply(merged[col], factor)
merged$category= relevel(merged$category, "BAG SNACKS")
merged$segment=relevel(merged$segment, "MAINSTREAM")

#Split date to get year and month
merged$year = format(merged$week_end_date, "%Y")
merged$month = format(merged$week_end_date, "%b")
merged$year = factor(merged$year)
merged$month = factor(merged$month)
merged$month = relevel(merged$month, "Jan")
str(merged)

attach(merged)
colSums(is.na(merged)) 
# Correlation Test

#library("PerformanceAnalytics")
num_cols <- merged[, c(4,5,6,7,8,9)]
#chart.Correlation(num_cols)   
library(corrplot)
corrplot(cor(num_cols), method = "number", type = "full", tl.cex = 0.8, tl.col = "black")
#Price and Base_price have high corr. We can remove base_price from our analysis.
#Also among the DV's.

#Looking at categorical variables
table(merged$feature)
table(merged$display)
table(merged$tpr_only)
table(merged$state)
table(merged$category)
table(merged$segment)

#Boxplots 
boxplot(merged$spend ~ merged$feature)
boxplot(merged$spend ~ merged$display)
boxplot(merged$spend ~ merged$tpr_only)

#Since the data is multi-level, (Product, store and State) store and product, we will use lmer models for 
#Each of the DV's.

merged <- subset(merged, spend > 0)
library(lme4)
lmer_spend <- lmer(log(spend) ~ (feature + display + tpr_only) * (segment + category) + avg_weekly_baskets + price +
                    month + year + (1|store_num) + (1 | state), 
                  data = merged, REML=FALSE)
summary(lmer_spend)

merged <- subset(merged, units > 0)

lmer_units<- lmer(log(units) ~ (feature + display + tpr_only) * (segment + category) + avg_weekly_baskets + price +
                        month + year +  (1|store_num) + (1 | state), 
                     data = merged, REML=FALSE)
summary(lmer_units)

merged <- subset(merged, hhs > 0)

lmer_hhs<- lmer(log(hhs) ~ (feature + display + tpr_only) * (segment + category) +  avg_weekly_baskets + price 
                     + month + (1|store_num) + (1 | state), 
                  data = merged, REML=FALSE)

library(stargazer)
stargazer(lmer_spend,lmer_units, lmer_hhs, type="text", single.row=TRUE)

#Testing assumptions
plot(lmer_spend)
plot(lmer_units)
plot(lmer_hhs)

library("car")
vif(lmer_spend)  #passed                          
vif(lmer_units) #passed
vif(lmer_hhs) #passed

#Question 3
levels(merged$upc)
#We have 42 unique products.
#Price elasticity is the change in units sold for change in product price. i.e d(spend)/d(price)

library(tidyverse)
df <- merged
# Convert UPC to character type
df$upc <- as.character(df$upc)
# Function to calculate price elasticity
calculate_price_elasticity <- function(units, price){
  price_elasticity <- lm(log(units) ~ log(price))
  return(coef(price_elasticity)[2])
}
# Group by UPC and calculate price elasticity for each product
price_elasticities <- df %>% 
  group_by(upc) %>% 
  summarise(price_elasticity = calculate_price_elasticity(units, price))
# Sort by price elasticity in descending order
price_elasticities <- price_elasticities %>% 
  arrange(desc(price_elasticity))
# Extract top 5 most price elastic products
top_5_most_price_elastic <- price_elasticities %>% 
  head(5)

# Extract top 5 least price elastic products
top_5_least_price_elastic <- price_elasticities %>% 
  tail(5)

# Print the results
cat("Top 5 most price elastic products:\n")
print(top_5_most_price_elastic)
cat("\nTop 5 least price elastic products:\n")
print(top_5_least_price_elastic)
