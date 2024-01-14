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


# FlashcardWizard

## Aplikacja do nauki słówek z wykorzystaniem fiszek i systemu SRS

### Cechy Aplikacji
- Fiszki podzielone na kategorie
- System SRS (ang. Spaced Repetition System)
- Statystyki postępów
- Tworzenie konta użytkownika 
- Wykorzystanie Firebase (obsługa kont użytkowników oraz przechowywanie danych statystycznych)
- Swobodne przewijanie fiszek poprzez gesty przesuwania (swiping)

##

### Algorytm SRS

- Jeżeli użytkownik nie korzystał jeszcze z danego zestawu (najwyższa liczba błędnych odpowiedzi (badAnswer) wynosi 0),to do listy dodawane jest 10 losowych fiszek 

- W przeciwnym przypadku, do listy dodawane są fiszki, na którre użytkownik źle odpowiedział (mają więcej niż 0 błędnych odpowiedzi (badAnswer) i nie mają żadnej dobrej odpowiedzi (goodAnswer równa 0)), zaczynając od fiszki z największą ilością błędnych odpowiedzi (dla każdej ilości badAnswer do listy dodawana jest tylko jedna fiszka).

- Jeśli lista ma mniej niż 10 elementów, to dodawane są fiszki, na które nie zostały jeszcze udzielone żadnej odpowiedzi (goodAnswer i badAnswer równa 0), tak by uzupełnić do 10. 

- Jeśli lista nadal ma mniej niż 10 elementów, to dodawane są fiszki, na które została udzielona poprawna odpowiedź (wartość dobrej odpowiedzi (goodAnswer) różna od 0), zaczynając od fiszki z najniższą ilością poprawnych odpowiedzi, dopóki lista nie osiągnie 10 elementów
