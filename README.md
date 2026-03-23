# Online Retail Data Analysis (R)

## Project Overview

This project analyzes an online retail dataset to identify sales trends, customer behavior, and product performance using R.

The dataset contains transaction-level records including product descriptions, quantities, prices, and customer information. The goal of this project was to clean and analyze the data to generate meaningful business insights.

---

## Tools Used

- R
    - tidyverse
    - lubridate
    - ggplot2

---

## Key Analyses

- Data cleaning and preprocessing
- Creation of revenue metrics
- Revenue analysis by country
- Monthly revenue trends
- Seasonal sales pattern detection
- Top-selling product identification
- Customer behavior analysis
- Price vs quantity relationship analysis

---

## Key Findings

- The United Kingdom generated the highest total revenue.
- Sales peaked significantly in November, suggesting strong seasonal demand.
- A small segment of high-value customers contributed disproportionately to total revenue (434 customers identified in the top 10%).
- A negative correlation (-0.25) was observed between product price and quantity sold, indicating lower-priced items tend to sell in higher quantities.

---

## Project Structure

ecommerce-data-analysis/
│
├── data/           # contains .csv database file
├── scripts/        # contains R script
├── visuals/        # plots generated
├── report/         # analysis of data parsed
└── README.md


---

## Visualizations

This project generated multiple visualizations including:

- Top Countries by Revenue  
- Monthly Revenue Trends  
- Revenue by Month  
- Top-Selling Products  
- Customer Revenue Distribution  
- Price vs Quantity Relationship  

---

## Future Improvements

Possible future enhancements include:

- Customer segmentation using clustering
- Predictive sales modeling
- Interactive dashboards
- SQL database integration
