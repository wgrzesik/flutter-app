# FlashcardWizard

## Aplikacja do nauki słówek z wykorzystaniem fiszek i systemu SRS

### Cechy Aplikacji
- Fiszki podzielone na kategorie
- System SRS (ang. Spaced Repetition System)
- Statystyki postępów
- Tworzenie konta użytkownika 
- Wykorzystanie Firebase (obsługa kont użytkowników oraz przechowywanie danych statystycznych)



#### Algorytm SRS

Jeżeli użytkownik nie korzystał jeszcze z danego zestawu (najwyższa liczba błędnych odpowiedzi (badAnswer) wynosi 0),to do listy dodawane jest 10 losowych fiszek 

W przeciwnym przypadku, do listy dodawane są fiszki, na którre użytkownik źle odpowiedział (mają więcej niż 0 błędnych odpowiedzi (badAnswer) i nie mają żadnej dobrej odpowiedzi (goodAnswer równa 0)), zaczynając od fiszki z największą ilością błędnych odpowiedzi (dla każdej ilości badAnswer do listy dodawana jest tylko jedna fiszka).

Jeśli lista ma mniej niż 10 elementów, to dodawane są fiszki, na które nie zostały jeszcze udzielone żadnej odpowiedzi (goodAnswer i badAnswer równa 0) w liczbie uzupełniającej do 10.

Jeśli lista nadal ma mniej niż 10 elementów, to dodawane są fiszki, na które została udzielona poprawna odpowiedź, mają wartość dobrej odpowiedzi (goodAnswer) różną od 0, zaczynając od najniższej, dopóki lista nie osiągnie 10 elementów
