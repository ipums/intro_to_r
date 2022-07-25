
# Read in my_data (.csv) #####

## Base R can handle .csv and .txt files "out of the box"

## Without assigning to an object, contents of file will be PRINTED
read.csv("example_data.csv")

## read data and ASSIGN to OBJECT
my_data_csv <- read.csv("example_data.csv")

## View data in a spreadsheet-style viewer
View(my_data_csv)

## To read in different file types, we will need to download additional R
## packages.


# Install packages ####

## R packages are add-ons that expand the functionality of base R. Its helpful
## to think of R as a series of books. "Base R" is the starter set of "books"
## you get when you first install R. install.packages() downloads the new "book"
## and adds it to your collection. This step needs to be done only once, or
## periodically to update.

## Note: quotation marks ("") ARE REQUIRED to specify a package name.
install.packages("openxlsx")
install.packages("haven")
install.packages("ggplot2") ## for plotting
install.packages("gtsummary") ## for tables

## openxlsx provides functions to read and write Microsoft Excel files.

## haven provides functions to read from various stats packages, including SPSS,
## Stata, and SAS. Notably, haven is able to read in values and value labels.

## ggplot2 streamlines the creation of plots to visualize your data.

## gtsummary streamlines the creation of tables to summarize your data.


# Load Packages ####

## In order to load the package, we use library(). This is like taking the book
## off your shelf and opening it to read/use. This step needs to be done each
## time you open R/RStudio, so it's helpful to have a section at the top of the
## script that loads all packages needed.

## Note: quotation marks ("") are NOT required for the library function.

library(haven)
library(openxlsx)
library(ggplot2)
library(gtsummary)

# Read in my_data (.xlsx) ####

## Excel can be convenient for data management, but like .csv files, it does not
## allow you to store a numeric code and a text label in a single cell.
## Understanding coded values will require referring to a separate metadata
## file.

my_data_xlsx <- read.xlsx("example_data.xlsx")

## View
View(my_data_xlsx)

#### Summarize (Frequency Tables)
table(my_data_xlsx$SEX)
table(my_data_xlsx$EDATTAIN)
table(my_data_xlsx$EMPSTAT)


# Read in my_data (with labels) ####

## The haven package provides functions to read and write the formatted data
## files used by Stata, SPSS, and SAS. This package makes it easier to get your
## data into R, and also provides support for LABELED VALUES.

my_data <- read_dta("example_data.dta")


View(my_data) # It's still numeric!

## See Environment Panel, haven labels are complex; converting to the factor
## format, which is native to R, will preserve the labels and work more
## smoothly with other R functions.

## as_factor in the haven package to convert to factors for further analysis

my_data$SEX <- as_factor(my_data$SEX)
my_data$EDATTAIN <- as_factor(my_data$EDATTAIN)
my_data$EMPSTAT <- as_factor(my_data$EMPSTAT)

View(my_data) # Labels present!

#### Summarize (Frequency Tables)

table(my_data$SEX)
table(my_data$EDATTAIN)
table(my_data$EMPSTAT)

#### Summarize (Numeric)
summary(my_data$AGE)

#### Summarize (Two-Way Tables)
table(my_data$EDATTAIN, my_data$SEX)


# Basic Data Manipulation ####

#### Subset observations

## use the subset() function specifying a DATA.FRAME followed by an expression that
## will return a LOGICAL (TRUE or FALSE) value
sub_data <- subset(my_data, subset = EDATTAIN != "Unknown")

table(sub_data$EDATTAIN) ## empty levels (Unknown) present

#### Drop unused factor levels
sub_data <- droplevels(sub_data) ## drop removed labels

# This time we will save the resulting table to an object for further analysis
crosstab <- table(sub_data$EDATTAIN, sub_data$SEX)

## Calling an R object will print the contents of that object
crosstab

## Large objects may get truncated/summarized
my_data


# Write Out R objects #####

## Options to write R objects out to various file types. Note the similarities
## and differences in syntax. In most file-writing functions, the first argument
## is the R object to be written out.

write.csv(crosstab, file =  "xtab_emp_by_sex.csv")

write.xlsx(crosstab, file = "xtab_emp_by_sex.xlsx")

write_dta(as.data.frame(crosstab), path = "xtab_emp_by_sex.dta")
## note different syntax (argument name is `path` instead of `file`)


# Base R vs Packages - Tables #####

#### Fancier Tables (gtsummary) ####

crosstab ## print frequencies
ppn_crosstab <- prop.table(crosstab) ## get proportions
ppn_crosstab
ppn_crosstab <- round(ppn_crosstab, 2) ## round to 2 decimal places
ppn_crosstab

## Or use tbl_summary() from the gtsummary package to do it all in one line:
tbl_summary(sub_data, by = "SEX")


# Base R vs Packages - Graphs #####

#### Basic Visualization (Base R) ####


## Base R provides MANY built in functions, each with many options to customize
## your plots.
barplot(crosstab)

## The flexibility/customization comes at the trade-off of user input. Adding a
## legend takes 2 extra steps in Base R.

## First, we use layout() to tell R to treat the plot window as a matrix(),
## consisting of 1 row and 4 columns: 1,1,2,2. The first plot will occupy the
## first two columns (as a merged column), while the second plot will occupy the
## last two columns.

layout(matrix(c(1,1,2,2), ncol = 4))

## barplot as normal
barplot(crosstab, col = rainbow(4), main = "Education by Sex")

## Make an empty plot (of a single point) to use as the base for the legend. "n"
## indicates "null" for many arguments to the plot function.
plot(
  1,
  type = "n", ## do not plot the points
  bty = "n", ## do not plot a bounding box
  xaxt = "n", ## do not plot an X axis
  xlab = "", ## label the x axis as "", in other words, as blank
  yaxt = "n", ## do not plot a Y axis
  ylab ="" ## label the Y axis as "", in other words, as blank
)

legend(
  "center",
  legend = levels(sub_data$EDATTAIN),
  pch = 22,
  pt.bg = rainbow(4),
  inset = c(-0.2,0),
  title = "Ed Attainment"
)

#### Basic Visualization (ggplot2) ####

# ggplot2 is EXTREMELY popular for quickly generating polished looking plots. It
# does use a slightly different syntax than Base R, but there is ample
# user-support.

qplot(x = SEX, fill = EDATTAIN, data = sub_data, geom = "bar")
