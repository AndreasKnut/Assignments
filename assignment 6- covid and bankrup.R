library(tidyverse)
library(rvest)
library(dplyr)
library(lubridate)

bankrup_2019<- read_html("https://w2.brreg.no/kunngjoring/kombisok.jsp?datoFra=01.01.2019&datoTil=31.12.2019&id_region=0&id_niva1=51&id_niva2=56&id_bransje1=0")
bankrup_2020<- read_html("https://w2.brreg.no/kunngjoring/kombisok.jsp?datoFra=01.01.2020&datoTil=01.10.2020&id_region=0&id_niva1=51&id_niva2=56&id_bransje1=0")

#finding the data from 2019 and 2020 then combind them into one dataset.
bankrup_2019<- bankrup_2019%>%
  html_nodes(xpath = "//table")%>%
  html_nodes("table")%>%
  html_table(fill=TRUE)

bankrup_2020<- bankrup_2020%>%
  html_nodes(xpath = "//table")%>%
  html_nodes("table")%>%
  html_table(fill=TRUE)

bankrups<- bind_rows(bankrup_2019, bankrup_2020)

# selecting the columns we want to use, make a region column, just selecting the firms in X4.

bankrups<- bankrups%>%
  select(X2, X4, X6,X8)%>%
  mutate(region=ifelse(grepl("[^Dato][A-Za-z]", X6), X6,NA))%>%
  fill(region)%>%
  filter(nchar(X4)>=7)%>%
  filter(X8=="Konkursåpning")


bankrups<- bankrups%>%
  mutate(bankrups$X6<-as.Date(bankrups$X6, format = "%d.%m.%Y"))

colnames(bankrups)[6] <- "Dato"

#seperate the date variable
bankrups<-bankrups %>%
  mutate(
    dates2=ymd(Dato),
    År=year(dates2),
    Måned=month(dates2),
    Dag=day(dates2)
  )


#select again what we want to use and rename columns

bankrups1<- bankrups%>%
  select(X2,X8, region,År, Måned)
colnames(bankrups1)<-c("Firma","Kunngjøringstype","Fylke","År","Måned")

#count how many that have been bankrupted each mounth, year and county
bankrups1<- bankrups1%>%
  group_by(Fylke,Måned, År)%>%
  count(Kunngjøringstype)

colnames(bankrups1)[5] <- "Konkurs"

#Convert År to a factor
bankrups1$År<-as.factor(bankrups1$År)

#plot it
bankrups1%>%
  ggplot(aes(x= Måned, y=Konkurs, group=År))+
  geom_line(aes(color=År),size=1)+
  scale_x_continuous(breaks=c(1:12))+
  facet_wrap(~Fylke)+
  ylab("Antall konkurser")+
  ggtitle("Antall konkurser i fylkene fra 01.01.2019 til i dag")



