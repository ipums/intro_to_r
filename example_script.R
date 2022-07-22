


#### Packages ####


#### Read in my_data (.csv)

# Base R can handle .csv and .txt files "out of the box", but these can have limitations.

## read in without assigning

read.csv("example_data.csv")

## then assign and show

my_data_csv <- read.csv("example_data.csv")

View(my_data_cvs)

# To read in different file types, we will need to download additional R packages.


#### Install packages

# R packages are add-ons that expand the functionality of base R. Its helpful  to think of R as a series of books. "Base R" is the starter set of "books" needed for R to function. install.packages() downloads new the "book" and adds it to your collection. This step needs to be done only once, or periodically to update. Note: quotation marks ("") ARE REQUIRED to specify a package name. openxlsx is a very useful package that allows read/write of xls/xlsx files. haven provides functions to read from various stats packages, including SPSS, STATA, and SAS. Notably, haven is able to read in value and value labels

install.packages("openxlsx")
install.packages("haven")
install.packages("ggplot2") ## for plotting

#### Load Packages

# In order to load the package, we use library(). This is like taking the book off your shelf and opening it to read/use. This step needs to be done each time you open R/Rstudio. so it's helpful to have a section at the top of the script that loads all packages needed. Note: quotation marks ("") are NOT required for the library function.

library(haven)
library(openxlsx)
library(ggplot2)

#### Read in my_data (xlsx) ####


my_data_xlsx <- read.xlsx("example_data.xlsx")


# Excel can be convenient for data management, but like .csv files does not allow for labeled values, like many other stats programs.


#### View
View(my_data_xlsx)

#### Summarize (Frequency Tables)
table(my_data_xlsx$SEX)
table(my_data_xlsx$EDATTAIN)
table(my_data_xlsx$EMPSTAT)


#### Read in my_data (with Labels) ####

# The haven package provides functions to read/write for many common statistical packages. This package makes it easier to get your data into R, and also provides support for LABELED VALUES.

my_data <- read_dta("example_data.dta")


View(my_data) # It's still numeric!

# See Environment Panel, haven labels are complex; factors preserve the [value + label] pairs, in more simple structure

# as_factor in the haven package to convert for analysis

my_data$SEX <- as_factor(my_data$SEX)
my_data$EDATTAIN <- as_factor(my_data$EDATTAIN)
my_data$EMPSTAT <- as_factor(my_data$EMPSTAT)

View(my_data) # Labels present!

#### Summarize (Frequency Tables)

table(my_data$SEX)
table(my_data$EDATTAIN)
table(my_data$EMPSTAT)

#### Summarize (Numeric)
range(my_data$AGE)

#### Summarize (Two-Way Tables)

table(my_data$EMPSTAT, my_data$SEX)

#### Basic Data Manipulation ####

#### Subset by a value: Not in Universe

# use subset() function

sub_data <- my_data[my_data$EMPSTAT != "NIU (not in universe)" ,]


mean(my_data$AGE) ## 26
mean(sub_data$AGE) ## 32

#### Drop unused levels
sub_data <- droplevels(sub_data) ## drop removed labels

#### Saving R objects

# So far, the only R object we've actually worked with has been our dataset, read from a file, or the subset copy we created above. You can also save the results of functions (like tables) to their own R objects like so

crosstab <- table(sub_data$EMPSTAT, sub_data$SEX)

# Calling an R object will print the contents of that object
crosstab

# Large objects may get truncated/summarized
my_data



#### Write Out Tables

# Options to write R objects out to various filetypes. Note the similarities/differences in syntax.

write.csv(crosstab,
          file =  "xtab_emp_by_sex.csv")

write.xlsx(crosstab,
           file = "xtab_emp_by_sex.xlsx")

write_dta(crosstab,
          path = "xtab_emp_by_sex.dta") ## note different syntax


#### Basic Visualization (Base R) ####

# Base R provides MANY built in functions, each with many options to customize your plots.

barplot(crosstab) ## stacked by default barplot


barplot(crosstab,
        beside = TRUE) ## or unstacked

barplot(crosstab,
        beside = TRUE,
        main = "Employment by Sex") ## unstacked, with title

#### Getting Fancy (Base R)

# The flexibility/customization comes at the trade-off of user input. Adding a legend takes 2 extra steps in Base R.

# First, we use layout() to tell R to treat the plot window as a matrix(), consisting of 1 row and 3 columns: 1,1,2. The first plot will occupy the first two columns (as a merged column), while the second plot will occupy just the last column.

layout(matrix(c(1,1,2), ncol = 3))

## barplot as normal
barplot(crosstab,
        beside = TRUE,
        col = rainbow(4),
        main = "Employment by Sex"
)

## Make an empty plot (of a single point) to use as the base for the legend. "n" indicates "null" for many arguments to the plot function.
plot(1,
     type = "n", ## do not plot the points
     bty = "n", ## do not plot a bounding box
     xaxt = "n", ## do not plot an X axis
     xlab = "", ## label the x axis as "", IE blank
     yaxt = "n", ## do not plot a Y axis
     ylab ="") ## label the Y axis as "", IE blank

legend("left",
       legend = levels(sub_data$EMPSTAT),
       pch = 22,
       pt.bg = rainbow(4),
       inset = c(-1.2,0),
       title = "Employment Status"
)


#### Basic Visualization (ggplot) ####

# ggplot is EXTREMELY popular for quickly generating polished looking plots. It does use a slightly different syntax than Base R, but there is ample user-support.

ggplot(data = sub_data, aes(x = SEX, fill = EMPSTAT)) +
  geom_bar()


#### NTOES ####

# look at edattain rather than employment to parrallel geog


