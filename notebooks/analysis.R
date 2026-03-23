install.packages("tidyverse")
library(tidyverse)
install.packages("lubridate")
library(lubridate)

df = read.csv("projects/ecommerce_data_analysis/data/online_retail.csv")

glimpse(df)
dim(df) # 541909 8
colSums(is.na(df))
summary(df)

# clean dataset
df = df %>% drop_na(CustomerID)
df = df %>% filter(Quantity >0)
df = df %>% filter(UnitPrice >0)
dim(df) # 397884 8

df = df %>% mutate(Revenue = Quantity * UnitPrice)
head(df)

# convert invoice date to date format to analyze monthly trends
df = df %>% mutate(
  InvoiceDate = trimws(as.character(InvoiceDate)),
  InvoiceDate = ymd_hms(InvoiceDate), 
  Month = floor_date(InvoiceDate, "month"))
head(df)

# monthly revenue
monthly_sales = df %>% group_by(Month) %>% summarise(TotalRevenue = sum(Revenue))
head(monthly_sales)

#visualize monthly revenue
ggplot(monthly_sales, aes(x = Month, y = TotalRevenue)) + geom_line() +
      labs(title = "Monthly Revenue", x = "Month", y = "Total Revenue") + theme_minimal()

# revenue by country
country_revenue = df %>% group_by(Country) %>% summarise(TotalRevenue = sum(Revenue)) %>%
  arrange(desc(TotalRevenue))
head(country_revenue, 10)

# visualize top countries
ggplot(country_revenue, aes(x = reorder(Country, TotalRevenue), y = TotalRevenue)) +
  geom_bar(stat = "identity") + coord_flip() +
  labs(
    title = "Top countries by revenue", 
    x = "Country", 
    y = "Total Revenue"
  ) + theme(plot.title = element_text(hjust = 0.5))

  # United Kingdom clearly has highest total revenue

# top 10 countries by revenue
top_10 = country_revenue %>% slice_max(TotalRevenue, n = 10)
ggplot(top_10, aes(x = reorder(Country, TotalRevenue), y = TotalRevenue)) +
  geom_bar(stat = "identity") + coord_flip() +
  labs(
    title = "Top 10 countries by revenue", 
    x = "Country", 
    y = "Total Revenue"
  ) + theme(plot.title = element_text(hjust = 0.5))

# top-selling products by quantity sold
top_products = df %>% group_by(Description) %>% 
  summarise(TotalQuantity = sum(Quantity)) %>%
  arrange(desc(TotalQuantity))

head(top_products, 10)
dim(top_products)

top_products = top_products %>% filter(
  Description != "POSTAGE",
  Description != "DOTCOM POSTAGE",
  Description != ""
) # remove non-product descriptions

#visualize top products
ggplot(top_products, aes(x = reorder(Description, TotalQuantity),
                            y = TotalQuantity)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Best-Selling Products",
       x = "Product",
       y = "Total quantity sold")
  # can't see the product names very well

top_10_products = top_products %>% slice_max(TotalQuantity, n = 10)
ggplot(top_10_products, aes(x = reorder(Description, TotalQuantity),
                            y = TotalQuantity)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Best-Selling Products",
       x = "Product",
       y = "Total quantity sold")

# revenue by month
monthly_pattern = df %>% mutate(MonthName = month(InvoiceDate, label = TRUE)) %>% 
  group_by(MonthName) %>% summarise(TotalRevenue = sum(Revenue))

ggplot(monthly_pattern, aes(x = MonthName,
                            y = TotalRevenue)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Revenue by month",
    x = "Month",
    y = "Total Revenue"
  )

# revenue per customer
customer_revenue = df %>% group_by(CustomerID) %>%
  summarise(TotalRevenue = sum(Revenue)) %>%
  arrange(desc(TotalRevenue))

# # of orders per customer
customer_orders = df %>% group_by(CustomerID) %>% summarise(
  NumberOfOrders = n_distinct(InvoiceNo)) %>%
  arrange(desc(NumberOfOrders))

customer_summary = df %>% group_by(CustomerID) %>% summarise(
  TotalRevenue = sum(Revenue),
  NumberOfOrders = n_distinct(InvoiceNo)
)

# visualize customer summary
ggplot(customer_summary,
       aes(x = TotalRevenue)) +
  geom_histogram(bins = 10) +
  labs(
    title = "Distribution of Customer Revenue",
    x = "Total Revenue per Customer",
    y = "Number of Customers"
  )

# top 10% customers
threshold = quantile(customer_summary$TotalRevenue, 0.90)
high_value_customers = customer_summary %>%
  filter(TotalRevenue >= threshold)
nrow(high_value_customers)

# analyzing price vs quantity sold
ggplot(df, aes(x = UnitPrice,
               y = Quantity)) +
  geom_point(alpha = 0.3) +
  labs(title = "Price vs Quantity Sold", 
       x = "Unit Prices")

filtered_df = df %>% filter(UnitPrice < 50, Quantity < 100)
ggplot(filtered_df, aes(x = UnitPrice,
               y = Quantity)) +
  geom_point(alpha = 0.3) +
  labs(title = "Price vs Quantity Sold", 
       x = "Unit Prices")

# correlation analysis
correlation = cor(filtered_df$UnitPrice, filtered_df$Quantity)
correlation #-0.2500198 
# Its negative, meaning that the higher the prices, the fewer the purchases.


install.packages("httpgd")
