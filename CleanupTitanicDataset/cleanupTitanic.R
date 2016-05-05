# clean up the Titantic dataset

#read the csv file
titanic_df = read.csv("titanic_original.csv", stringsAsFactors = FALSE)

library("dplyr")
titanic_tbl <- tbl_df(titanic_df)

print(titanic_tbl, n=10)

# identify the records which have the embarked as empty.
titanic_tbl %>%
    filter(embarked == "") %>%
    summarize(cnt = n())

# replace the empty embarked to S (Southampton)
titanic_tbl$embarked <- gsub(pattern = "",
                             replacement = "S",
                             titanic_tbl$embarked)
#now the count should be zero
titanic_tbl %>%
  filter(embarked == "") %>%
  summarize(cnt = n())

# fix the NA in the age column
mean_age <- mean(titanic_tbl$age, na.rm = TRUE)

#mean_age = 29.88113

# replace the NA with mean age
titanic_tbl$age[is.na(titanic_tbl$age)] <- mean_age

# fix boat which has empty values.
# first, identify how many
titanic_tbl %>%
    filter(boat == "") %>%
    summarize(cnt=n())

# replace them with None
#titanic_tbl$boat <- titanic_tbl

titanic_tbl$boat[titanic_tbl$boat == ""] <- "None"
#titanic_tbl$boat[which(titanic_tbl$boat == "")] <- "None"

#cabin
alloted_cabin = titanic_tbl$cabin[titanic_tbl$cabin != ""]

#total alloted cabin
length(alloted_cabin)

# find out where cabins are not alloted
titanic_tbl %>% filter(cabin == "") %>% summarise(cnt=n())

# create a new column has_cabin_number (1/0)
titanic_tbl$has_cabin_number = ifelse(titanic_tbl$cabin != "", 1, 0)

#Lets assign None to empty cabins
titanic_tbl$cabin[titanic_tbl$cabin == "" ] <- "None"

#finally, save the cleaned data to csv file
write.csv(titanic_tbl, file = "titanic_clean.csv")

