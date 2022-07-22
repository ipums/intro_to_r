
## create empty project for live demo with demo script
## demo creating a NEW project
## demo switching projects

# Load data ####

## load data into console first
## DO specify argument
read.csv(file= "example_data.csv")

## ASSIGN results to an R OBJECT
my_data <- read.csv(file = "example_data.csv")

## INSPECT data

View(my_data) ## discuss viewer

## INSPECT console

nrow(my_data)
ncol(my_data)
colnames(my_data)

mean(my_data$AGE)
summary(my_data$AGE)


table(my_data$SEX)

# LOAD PACKAGES ####

# install.packages("haven")

library(haven)

my_data_csv <- my_data ## RE - assign

my_data <- read_dta("example_data.dta") ## RE - assign

# Compare #####

View(my_data)
View(my_data_csv)

## they are the same!
## BUT inspect environment

# DEAL WITH FACTORS

my_data$SEX <- as_factor(my_data$SEX)
my_data$EDATTAIN <- as_factor(my_data$EDATTAIN)
my_data$EMPSTAT <- as_factor(my_data$EMPSTAT)


# COMPARE ####
table(my_data_xlsx$SEX)

# Analyse ####

## CROSSTABS

table(my_data$EDATTAIN, my_data$SEX)


# SUBSET ####
sub_data <- subset(my_data,
                   EDATTAIN != "Unknown"
                   )
sub_data <- droplevels(sub_data)

nrow(my_data)
nrow(sub_data)

# CROSSTAB ####
edu_x_sex <- table(sub_data$EDATTAIN, sub_data$SEX)

edu_x_sex


prop.table(edu_x_sex)

barplot(edu_x_sex)

# SWITCH BACK TO SLIDES



par("mar")
layout(matrix(c(1,1,2),ncol = 3))
barplot(edu_x_sex, col = rainbow(4))
plot(1,type="n",bty="n", xaxt= "n", yaxt = "n", xlab="", ylab="", mar=c(0,0,0,0))
legend("center", legend = levels(sub_data$EDATTAIN), pch = 22, pt.bg = rainbow(4))
