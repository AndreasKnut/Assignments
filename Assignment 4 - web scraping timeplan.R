library(tidyverse)
library(rvest)
library(dplyr)

bed.2056<- read_html("http://timeplan.uit.no/emne_timeplan.php?sem=20h&module%5B%5D=BED-2056-1&View=list")

week_by_week<- html_table(html_nodes(bed.2056, "div table"))

#we reorgenize our data to a table with 14 rows
scheduel<-as.data.frame(matrix(unlist(week_by_week), nrow=14, byrow=TRUE))

#select parts of the data we wanna use.
scheduel<- scheduel%>% 
  select(V2, V4, V8, V12)

#rename the columns to something better
colnames(scheduel)<- c("Date", "Time", "Class", "Teacher")



