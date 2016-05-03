# R Script file to clean up the data in the csv file.

# read the csv file.
org_data = read.csv("refine_original.csv")

# convert the org_data to local table data frame using tbl_df

# install.packages("dplyr")
library(dplyr)

# get the table format
local_df = tbl_df(org_data)

# print to see the data
print(local_df, n=10)

### fix all misspellings in the company name
# modify the company to lowercase
local_df$company <- tolower(local_df$company)

# fix all kinds of ph.* to philips
local_df$company <- gsub(pattern = "ph.*", 
                        replace = "philips", 
                        x = local_df$company)

# change filips
local_df$company <- gsub(pattern = "fi.*", 
                         replace = "philips", 
                         x = local_df$company)
# fix ak.* to akzo
local_df$company <- gsub(pattern = "ak.*", 
                         replace = "akzo", 
                         x = local_df$company)

#fix unilver to unilever
local_df$company <- gsub(pattern = "unil.*", 
                         replace = "unilever", 
                         x = local_df$company)

#run unique to make sure only 4 companies present.
unique(local_df$company)

## split the product_code_number to two different columns product_code & product_number

#get the product_code
local_df = mutate(local_df, 
                  product_code = sub(pattern = "(.*)-.*", 
                                     replacement = "\\1", 
                                     local_df$Product.code...number))

#get the product_number
local_df = mutate(local_df, 
                  product_number = sub(pattern = ".*-(.*)", 
                                       replacement = "\\1", 
                                       local_df$Product.code...number))

# create new column product_category
local_df$product_category <- NA 

#copy the product code to product category
local_df$product_category <- local_df$product_code

# replace product_category p to Smartphone
local_df$product_category <- gsub("p", "Smartphone", local_df$product_category)

#replace v to TV
local_df$product_category <- gsub("v", "TV", local_df$product_category)

#replace x to Laptop
local_df$product_category <- gsub("x", "Laptop", local_df$product_category)

#replace q to Tablet
local_df$product_category <- gsub("q", "Tablet", local_df$product_category)

# create full_address (addr, city, country)
local_df <- mutate(local_df,
                   full_address = paste(local_df$address, ", ", 
                                        local_df$city, ", ",
                                        local_df$country))

# add new columns
local_df$company_philips   <- ifelse(local_df$company == "philips", TRUE, FALSE)
local_df$company_akzo      <- ifelse(local_df$company == "akzo", TRUE, FALSE)
local_df$company_vanhouten <- ifelse(local_df$company == "van houten", TRUE, FALSE)
local_df$company_unilever  <- ifelse(local_df$company == "unilever", TRUE, FALSE)

# add new product logical cloumns

local_df$product_smartphone <- ifelse(local_df$product_category == "Smartphone", TRUE, FALSE)
local_df$product_laptop     <- ifelse(local_df$product_category == "Laptop", TRUE, FALSE)
local_df$product_tv         <- ifelse(local_df$product_category == "TV", TRUE, FALSE)
local_df$product_tablet     <- ifelse(local_df$product_category == "Tablet", TRUE, FALSE)



# drop the columns - address, city, country, product.code...number
#drop_columns = c(address, city, country, "Product.code...number")

#Finally, dump the clean data
#write.csv(file = "clean.csv", x=local_df)
write.csv(file = "refine_clean.csv", x= subset(local_df, select = -c(address, city, country, Product.code...number)))
          


