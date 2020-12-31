library(dplyr)
library(stringr)

wd  = getwd()
savePath = paste0(wd,  "/data/data.csv")

getSavedData = function(){
  df = read.csv(savePath)
  return (df)
}

# Function to create a dummy df for development
createDummyDf = function(){
  company = c('analytical analytics','the great bridge','pandas express', "fantastic cavern")
  status = c("new", "applied", "rejected", "new")
  role = c("analyst", "data analyst", "engineer", "data person")
  url = c("www.google.com", "www.google.com", "www.google.com", "www.google.com")
  location = c("remote", "sf", "bay area", "remote")
  df = data.frame(company, status, role, location, url)
  
  return (df)
}

# Function to get count of each status category based on provided input
getInfoBoxCount = function(df, filterBy){
  filteredDf = filter(df, status == filterBy)
  return (nrow(filteredDf))
}

# Function to create a new column, source, that is a hyperlink
createLink = function(df) {
  if (nrow(df) > 0){
    df$visit_source = paste0("<a href='", df$url ,"'>", "visit","</a>")
    return (df) 
  } else {
    return (df)
  }
}

# create dynamic message for the newPost table depending on whether there is any new posts or not
createNewPostMessage = function(newPostDf){
  count = nrow(newPostDf)
  if (count > 0){
    if (count == 1){
      return (paste0("There is ", count, " job you haven't yet applied for."))
    } else {
      return (paste0("There are ", count, " jobs you haven't yet applied for."))
    }
  } else {
    return (paste0("No new postings. "))
  }
}

# add edit button to each row
addEditButton = function(df){
  df$Action = paste0("<a href='", "edit" ,"'>", "edit","</a>")
  return (df)
}
