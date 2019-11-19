
# My Own functions examples

# GW number as an input
# GW length as a slider
# Average difficulty among all teams that is a moving average.
        # Maybe we can use a select option to include this or not
# Difficulty line
# Can use the drop down to choose either All teams or choose a particular team

# Inputs

sliderInput()   # Will use this for the gameweek length
selectInput()   # 
textInput()     # Or we'll use this for the gameweek start date
numericInput()  # Will use this for the gameweek start date

# These commands have three inputs:
    # 1) inputId: This is the same for ALL functions
    # 2) label: This is used to create humna readable label for the control
    # 3) typically: value; which can also let you set the default value

# We know that we want the slider for our app to be the gameweek length so
# let's code that now:

sliderInput("gw", "Gameweek Length", value = 5, min = 1, max = 37)    # NICE!!!

# Let's also do it for the gameweek start date

numericInput("start", "Gameweek Start Date", value = 1, min = 1, max = 37)




# It looks like the function will go into the server function and the output will be dictated in the 
# UI function:

ui <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)

server <- function(Data, GW_start, GW_length) {
  
  # First create function that can specify the gameweeks
  
  dataset <- read.csv("1.Data/FixtureDifficultiesv_01.csv")
  
  
  GW_Sub <- function(GW,GW_range){
    
    gameweek_number <- substr(GW,3,4)   # Take the number out of the gameweek
    gameweek_number <- as.numeric(gameweek_number)
    GW_range <- as.numeric(GW_range)
    gameweek_vector <- (gameweek_number:(gameweek_number + GW_range))
    
    # Now we have our vector, lets add the "GW" back to each
    # We will use lappy so it returns a list
    
    a <- vector()
    for (i in gameweek_vector) {
      a[i] <- paste("GW",i)
      a <-  a %>% na.omit(a)
    }
    
    new_range2 <- gsub(" ", "", a, fixed = TRUE)
    
  }
  
  # Now we can focus on the data itself 
  
  # First filter the dataset by the set of gameweeks that you want.  
  # Choose gameweeks
  GW_Filter <- GW_Sub(GW_start, GW_range = GW_length)
  
  # Create new dataset
  new_df <- Fix_Diff %>% select(Team, GW_Filter)
  
  # Sum the relevant gameweeks
  sum_df <-  new_df %>% mutate(SummedCol = select(., GW_start:names(rev(new_df)[1])) %>% 
                                 rowSums(na.rm = TRUE))
  
  # calculate the average difficulty
  ave_diff <- sum_df %>% mutate(AveDiff = SummedCol/GW_length)
  
  # remove columns that won't be used
  final_set <- ave_diff %>% select(Team, AveDiff)
  final_set$Run_Diff <- ifelse(final_set$AveDiff >= 3.5, "Tough", "Easy")
  return(final_set)
}
