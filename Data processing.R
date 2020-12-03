#Create `lincsEvents`
lincsOCR <- read_csv("C:/Users/Jack/Documents/GitHub/blog/Lincolnshire csv Data/lincsOCR.csv")
#remove any duplicates in lincsOCR
lincsOCR <-  lincsOCR[!duplicated(lincsOCR$UUID), ]

lincsEvents <- filter(lincsOCR, TYPE == 'EVENT')

lincsEvents <- lincsEvents %>%  select(QUOTE_TRANSCRIPTION, UUID)

#Create lincsID to act as index to original print book
lincsEvents <- lincsEvents %>% mutate(lincsID = (str_extract(QUOTE_TRANSCRIPTION, '^\\w+')))
#rename column to allegation for future analysis
lincsEvents <- lincsEvents %>% rename(word = QUOTE_TRANSCRIPTION)
#Delete the first digit from the allegation column. This removes McLane's index.
lincsEvents <- lincsEvents %>% mutate(word = (str_replace(word, '^\\d+', "")))
#un-nest lincsEvents
lincsEventsTokens <- lincsEvents %>% unnest_tokens(word, word)



#Filter for stop words
lincsStopped <- lincsEventsTokens %>% anti_join(stop_words)

#filter for digits
lincsNoDigit<- lincsEventsTokens %>% filter(grepl('^\\D', word))


#Create a list of Personal names from the original data
lincsPeople <- filter(lincsOCR, TYPE == "PERSON")
#Select desired columns from original text
#lincsPeople <- lincsPeople %>% select(QUOTE_TRANSCRIPTION, TYPE, UUID)
#Unnest Tokens
lincsPeople <- lincsPeople %>% unnest_tokens(word, QUOTE_TRANSCRIPTION)
#Removing Personal name using anti_join()
lincsPeopleStopped <- lincsEventsTokens %>% anti_join(lincsPeople, by = 'word')


#Creatng a set of place names from the text and removing them
lincsPlaces <- filter(lincsOCR, TYPE == "PLACE")
#Select desired columns from original text
#lincsPlaces <- lincsPlaces %>% select(QUOTE_TRANSCRIPTION, TYPE, UUID)
#Unnest Tokens
lincsPlaces <- lincsPlaces %>% unnest_tokens(word, QUOTE_TRANSCRIPTION)
#Removing Personal name using anti_join()
lincsPlacesStopped <- lincsEventsTokens %>% anti_join(lincsPlaces, by = 'word')

#Join tables to a single dataframe with no digits, places, or people
lincsTotalTidy <- lincsEventsTokens %>% anti_join(stop_words)
lincsTotalTidy <- lincsTotalTidy %>% filter(grepl('^\\D', word))
lincsTotalTidy <- lincsTotalTidy %>% anti_join(lincsPeople, by = 'word')
lincsTotalTidy <- lincsTotalTidy %>% anti_join(lincsPlaces, by = 'word')
