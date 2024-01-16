# FlashcardWizard

## Application for learning vocabulary using flashcards and SRS

### Application features
- Flashcards divided into categories
- Spaced Repetition System (SRS)
- Progress statistics
- Creation of a user account 
- Use of Firebase (support for user accounts and storage of statistical data)
- Free scrolling of flashcards using swiping gestures

##

## SRS algorithm

- If the user has not yet used the set (highest number of wrong answers (badAnswer) is 0), 10 random phrases are added to the list. 

- Otherwise, the fiches that the user has answered incorrectly (have more than 0 wrong answers (badAnswer) and no good answers (goodAnswer equal to 0)) are added to the list, starting with the fiche with the highest number of wrong answers (for each number of badAnswer, only one fiche is added to the list).

- If the list has less than 10 elements, the fiches that have not yet been answered are added (goodAnswer and badAnswer equal to 0), so as to complete up to 10. 

- If the list still has less than 10 elements, the fiches that have been answered correctly (goodAnswer value different from 0) are added, starting with the fiche with the lowest number of correct answers, until the list reaches 10 elements
