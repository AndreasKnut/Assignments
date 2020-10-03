library(tidyverse)
library(rvest)
library(tibble)

#read the url
r.scrape<- read_html("https://www.datacamp.com/courses/tech:r")
p.scrape<- read_html("https://www.datacamp.com/courses/tech:python")

# after finding the nodes for R courses, print it to a html_text, then make a table for all of the titles
tibble(html_text(html_nodes(r.scrape, ".course-block__title")))
#make html_text(html_nodes(r.scrape, ".course-block__title")) to a title in the table
tech<-html_text(html_nodes(r.scrape, ".course-block__title"))

R.table<-tibble(tech)  

#do the same for Phyton courses.

tibble(html_text(html_nodes(p.scrape, ".course-block__title")))

language<-html_text(html_nodes(p.scrape, ".course-block__title"))

P.table<-tibble(language)

#bind the two datasets
all.courses<-bind_rows(R.table, P.table)
all.courses
