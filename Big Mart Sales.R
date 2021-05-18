#' Data: BigMartSales.xlsx

# Read data

library("readxl")
d <- read_excel("BigMartSales.xlsx", sheet="Data")
str(d)

#' Preprocess Data

col <- c("Item_ID", "Item_Fat_Content", "Item_Type", "Outlet_ID", "Outlet_Size", "City_Type", "Outlet_Type")
d[col] <- lapply(d[col], factor)
str(d)

d$Outlet_Type <- relevel(d$Outlet_Type, ref= "Grocery Store")
d$City_Type <- relevel(d$City_Type, ref= "Tier 1")

#' Check for missing values
colSums(is.na(d))

#' Since we have 2410 missing values under Outlet_Size, and Outlet_Size is a proxy for
#' Outlet_ID, we will drop Outlet_Size from our analysis

#' Exploratory Data Analysis

hist(d$Item_Sales)
table(d$Outlet_Type)
table(d$City_Type)
table(d$City_Type, d$Outlet_Type)


#' Variable selection for Mixed Level Analysis

#' Dependent variable: Item_Sales

#' Lower (item) level variables that affect item sales:
#'   Item_ID:          Unit of analysis (will not be included in model)
#'   Item_Visibility:  More visible products should sell more
#'   Item_Type:        Certain item types such as dairy or vegetables may sell more
#'   Item_MRP:         Pricier items may sell less

#' Upper (store) level Variables that affect item sales
#'   Outlet_ID:        Unit of analysis for upper-level (must be included in model)
#'   Outlet_Type:      First part of analysis: how sales vary by outlet type
#'   City_Type:        Second part of analysis: how sales vary by city type
#'   Outlet_Age:       New variable; 2013 - Outlet_Year

#' Note: Outlet_year (year of founding of outlet) doesn't make sense as a predictor,
#' but older outlets may have more established clientale and may sell more compared
#' to new ones. We measure Outlet_Age as current year (2013) - year of founding
d$Outlet_Age = 2013 - d$Outlet_Year


#' Mixed-level model using lmer
#' Part 1: How item sales vary by outlet type (Grocery store, Supermarket Type 1, 2, 3)

library(lme4)             
library(arm) 

#' Very basic varying intercept model: random effect of outlet_type on item_sales
#' This is a very basic model that does not control for item or store-level variables

m1 <- lmer(Item_Sales ~ Outlet_Type + (1 | Outlet_ID), data=d)   
summary(m1)
display(m1)
fixef(m1)
ranef(m1)
coef(m1)

#' Better model: Varying intercept model with control variables

m2 <- lmer(Item_Sales ~ Outlet_Type + Outlet_Age + Item_MRP + Item_Visibility + 
      (1 | Outlet_ID), data=d)
summary(m2)

#' More complex model: Varying intercept and slope model with control variables
m3 <- lmer(Item_Sales ~ Outlet_Type + Outlet_Age + Item_MRP + Item_Visibility + 
      (1 | Outlet_Type/Outlet_ID), data=d)
summary(m3)

library(stargazer)
stargazer(m1, m2, m3, type="text")

#' Interpretation:
#' 
#' All three models show consistent and stable beta coefficients for Outlet_Type.
#' Since m2 and m3 are more comprehensive, and their estimates are identical, we 
#' will use these models for interpretation. Our analysis shows that:
#' Supermarket Type 1 make $1,931 more in sales than Grocery Stores (p<0.01), when 
#' controlled for item and outlet level differences.
#' Supermarket Type 2 make $1,580 more in sales than Grocery Stores (p<0.05).
#' Supermarket Type 3 make $3,365 more in sales than Grocery Stores (p<0.001). 
#' From the standard errors, Supermarket Type 1, 2, and 3 are also significantly 
#' different from each other.
#' The order of Item_Sales by Outlet_Type is Supermarket Type 3 (highest), Type 1,
#' Type 2, and Grocery Store (lowest).


#' Part 2: How item sales by city type (Tier 1, 2 and 3) 

#' Three models from basic varying intercept model to varying slope and intercept model

m4 <- lmer(Item_Sales ~ City_Type + (1 | Outlet_ID), data=d)   

m5 <- lmer(Item_Sales ~ City_Type + Outlet_Type + Outlet_Age + Item_MRP + 
      Item_Visibility + (1 | Outlet_ID), data=d)

m6 <- lmer(Item_Sales ~ City_Type + Outlet_Type + Outlet_Age + Item_MRP + 
      Item_Visibility + (1 | City_Type/Outlet_ID), data=d)

stargazer(m4, m5, m6, type="text")

#' Interpretation:
#' 
#' Models m4, m5, and m6 had very different parameter estimates, but since m4 was
#' very basic, and m5 and m6 parameters are stable and consistent, we use those models
#' for interpretation.
#' Items sell the highest in Tier 1 cities when controlled for item and outlet level differences.
#' Outlets in Tier 2 and 3 cities sell $16 and $14 less compared to Tier 1; however these
#' diferences are not statistically significant.
#' Based on these findings, we infer that city tiers have no discernable impact on item sales.

