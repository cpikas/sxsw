library("XML", lib.loc="~/R/win-library/3.3")
library("httr", lib.loc="~/R/win-library/3.3")
library("rvest", lib.loc="~/R/win-library/3.3")

#get the session page urls from the schedul page

interactsess<-GET("http://schedule.sxsw.com/2017/03/10/events/conference/Interactive/type/panel")

interactsess.text<-rawToChar(interactsess$content)

interactsess.links<-getHTMLLinks(interactsess.text)

hold2<-interactsess.links[grep("PP",interactsess.links)]

sessionpages<-paste("http://schedule.sxsw.com",hold2,sep="")

#test all the individual pieces
session<-sessionpages[2] %>%
  read_html() %>%
  html_node(".event-body")

name<- session %>%
  html_node(".event-name") %>%
  html_text()

date<- session %>%
  html_node(".event-date") %>%
  html_text()

speaker<- session %>%
  html_node("h4") %>%
  html_text()

organization<- session %>%
  html_node("h5") %>%
  html_text()

description <- session %>%
  html_node("p") %>%
  html_text()

getsessiondetails<-function(url){
  session<- url %>%
    read_html() %>%
    html_node(".event-body")
  
  name<- session %>%
    html_node(".event-name") %>%
    html_text()
  
  date<- session %>%
    html_node(".event-date") %>%
    html_text()
  
  speaker<- session %>%
    html_node("h4") %>%
    html_text()
  
  organization<- session %>%
    html_node("h5") %>%
    html_text()
  
  description <- session %>%
    html_node("p") %>%
    html_text()
  
  item<-c(url, name,date, speaker,organization, description)
  
  return (item)
}

sessioninfo<-data.frame()

for (i in 1:length(sessionpages)) sessioninfo<- rbind(sessioninfo, getsessiondetails(sessionpages[i]))
colnames(sessioninfo)<-c("url","title","date","speaker","organization","description")
write.csv(sessioninfo,file = "sxswinteractivepanels.csv")

  