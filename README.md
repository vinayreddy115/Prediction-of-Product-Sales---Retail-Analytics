# Big-Mart-Sales

- Build a predictive model and predict the sales of each product at a particular outlet.
- Analyze how sales vary by outlet type (Grocery store versus Supermarket Type 1, 2, or 3) and city type (Tier 1, 2 and 3)

Using this model, BigMart can understand the properties of products and outlets which play a key role in increasing sales.

### Data

2013 sales data for 1559 products across 10 stores in different cities

Source: https://code.datasciencedojo.com/tshrivas/dojoHub/tree/a152a17dee24dcfcc10bb75c77c2e88cdcf90212/Big%20Mart%20Sales%20DataSet

Attributes:

- **Item_Weight**: Weight of the product
- **Item_Fat_Content**: Low Fat or Regular
- **Item_Visibility**: Percentage of total display area of all products in a store allocated to this product
- **Item_Type**:	Dairy, Soft Drinks, Meat, Fruits and Vegetables, Household, Baking Goods, Snack Foods, Frozen Foods, Breakfast, Health and Hygiene, Hard Drinks, Canned, Breads, Starchy Foods, Others, Seafood
- **Item_MRP**:	Maximum Retail Price (list price) of the product
- **Outlet_ID**:	Unique store ID
- **Outlet_Year**:	Year in which store was opened
- **Outlet_Size**:	Store size**: [High, Medium, Small]
- **City_Type**:	Size of city where store is located [Tier 1, Tier 2, Tier 3]
- **Outlet_Type**:	Grocery Store, Supermarket Type1, Supermarket Type2, Supermarket Type3
- **Item_Sales**:	Sales of product in this store

### Variable selection for Mixed Level Analysis

Dependent variable: Item_Sales

Lower (item) level variables that affect item sales:
-   Item_ID:          Unit of analysis (will not be included in model)
-   Item_Visibility:  More visible products should sell more
-   Item_Type:        Certain item types such as dairy or vegetables may sell more
-   Item_MRP:         Pricier items may sell less

Upper (store) level Variables that affect item sales
-   Outlet_ID:        Unit of analysis for upper-level (must be included in model)
-   Outlet_Type:      First part of analysis: how sales vary by outlet type
-   City_Type:        Second part of analysis: how sales vary by city type
-   Outlet_Age:       New variable; 2013 - Outlet_Year

### Mixed-level model using lmer

#### Part 1: How item sales vary by outlet type (Grocery store, Supermarket Type 1, 2, 3)

<img src="https://github.com/netisheth/Big-Mart-Sales/blob/main/Pictures/summary1.png" alt="alt text" width="50%" height="50%">

***Interpretation:***

All three models show consistent and stable beta coefficients for Outlet_Type. Since m2 and m3 are more comprehensive, and their estimates are identical, we will use these models for interpretation. Our analysis shows that:
- Supermarket Type 1 make $1,931 more in sales than Grocery Stores (p<0.01), when controlled for item and outlet level differences.
- Supermarket Type 2 make $1,580 more in sales than Grocery Stores (p<0.05)
- Supermarket Type 3 make $3,365 more in sales than Grocery Stores (p<0.001)
- From the standard errors, Supermarket Type 1, 2, and 3 are also significantly different from each other.
- The order of Item_Sales by Outlet_Type is Supermarket Type 3 (highest), Type 1,Type 2, and Grocery Store (lowest).

#### Part 2: How item sales by city type (Tier 1, 2 and 3) 

<img src="https://github.com/netisheth/Big-Mart-Sales/blob/main/Pictures/summary2.png" alt="alt text" width="50%" height="50%">

***Interpretation:***
 
Models m4, m5, and m6 had very different parameter estimates, but since m4 was very basic, and m5 and m6 parameters are stable and consistent, we use those models for interpretation.
- Items sell the highest in Tier 1 cities when controlled for item and outlet level differences.
- Outlets in Tier 2 and 3 cities sell $16 and $14 less compared to Tier 1; however these diferences are not statistically significant.
- Based on these findings, we infer that city tiers have no discernable impact on item sales.
