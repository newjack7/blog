# get a proper list of names
people <- lincsOCR %>% filter(TYPE == "PERSON") %>% select(UUID, QUOTE_TRANSCRIPTION, ANCHOR, TYPE)

people <- people %>% mutate(wordcount = str_count(QUOTE_TRANSCRIPTION, pattern = "\\s"))

people %>% group_by(wordcount) %>% count(wordcount)

individuals <- people %>% filter(!wordcount == 0) %>% group_by(QUOTE_TRANSCRIPTION) %>% count(QUOTE_TRANSCRIPTION, sort =TRUE)

#Create the TIF (Text Interchange Format) data structure which spacy needs as an input

dunstableTIF <- data.frame(doc_id = dunstableDF$UUID, text = dunstableDF$word)

#Check if the format is correct
tif_is_corpus_df(dunstableTIF)
#This always seems to say FALSE but it still works in spacy?

#remove any duplicates
dunstableTIF <-  dunstableTIF %>% unique()

#Parse the text through Spacy
dunstableParsed <- spacy_parse(dunstableTIF)
dunstablePeople <- dunstableParsed %>% filter(pos == 'PROPN')
dunstablePeople <- dunstablePeople %>% filter(entity %in% c("PERSON_B", "PERSON_I"))

slice(dunstableParsed, 500:510)

dunstableConsolidate <-  entity_consolidate(dunstablePeople)
