---
name: publicera
description: Lägger upp ett dokument från verkstaden till teamets delade wiki - både för ett nytt dokument som publiceras första gången och för ett utplockat dokument som lämnas tillbaka. Används när användaren säger "publicera", "lägg upp det i wikin", "checka in", "jag är klar med dokumentet", "lämna tillbaka det", "spara upp mina ändringar", "dela det här med teamet", "släpp låset".
---

# Lägg upp i den delade wikin

Läs `${CLAUDE_PLUGIN_ROOT}/GLOTTO.md` först - konfiguration, frontmatter-hantering och regler. Läs och skriv frontmatter med `las()` och `skriv()` därifrån, aldrig med `grep` eller `sed`.

**Versionskontrollen först** - se avsnittet *Versionskontroll* i `GLOTTO.md`. Vid `gammal`: stanna.

Denna skill täcker alla vägar från verkstaden till den delade. **Användaren ska inte behöva veta vilket fall som gäller** - ta reda på det.

## Välj dokument

Har användaren namngett ett, använd det. Annars lista `.md`-filerna i verkstaden och fråga. Är den tom, säg det.

## Avgör fall

Slå upp om ett dokument med samma filnamn finns i den **delade** wikin, och läs det i så fall med `las()`.

| Läge | Fall |
|---|---|
| Finns inte i delade wikin | **Ny publicering** |
| Finns, `utplockad_av` = egen användare | **Återlämning** |
| Finns, `utplockad_av` = någon annan | **Blockerad** |
| Finns, `utplockad_av` tomt | **Oväntat** |

Avgör dessutom om användaren är klar eller arbetar vidare. Formuleringar som "klar", "lämna tillbaka", "checka in", "publicera" betyder klar. "Spara upp", "skriv upp det jag gjort hittills" betyder att arbetet fortsätter. Är det oklart och dokumentet är utplockat, fråga - skillnaden är om låset släpps.

Avgör också om användaren **tilldelar** någon: *"publicera och tilldela Johan"*, *"lämna över till Johan"*, *"Johan får ta det härifrån"*. Tilldelning är aldrig underförstådd - nämns ingen person blir fältet tomt.

## Ny publicering

Avbryt och rapportera om:

- Frontmatter saknas eller går inte att läsa.
- `underlag` saknas eller pekar på en fil som inte finns i `indata/`. Fråga vilket källmaterial dokumentet bygger på. Bygger det på annat wikiinnehåll, låt `underlag` vara tom men säg det.

Varna men låt användaren avgöra om dokumentet innehåller `[[wikilänkar]]` till dokument som inte finns.

Sätt `skapad` och `skapad_av` om de saknas. Lämna `utplockad` och `utplockad_av` tomma - dokumentet har aldrig varit utplockat.

## Återlämning

Är användaren klar: töm **bara** `utplockad_av`. Tidsstämpeln `utplockad` behålls, så att det går att se när rundan började och upptäcka utplockningar som aldrig lämnats tillbaka.

Arbetar användaren vidare: lämna båda orörda.

## Blockerad

Skriv inte. Låset har tagits över medan användaren arbetat. Rapportera vem som håller det nu, och att arbetskopian ligger kvar lokalt och inte går förlorad. Fråga vad användaren vill göra: spara under nytt namn, eller kontakta personen.

## Oväntat

Låset har frigjorts av någon annan, eller dokumentet publicerades av någon annan under tiden. Varna och fråga innan du skriver över.

## Genomför

1. Sätt `publicerad` till `nu()` och `publicerad_av` till användarnamnet ur konfigurationen. Det är det fältet som pekar ut vem som ansvarar för innehållet - inget separat granskningsfält finns.
2. **Konvertera `underlag` till wikilänkar** med `till_lankar()`.
2b. **Tilldelning** - varje publicering skriver fältet: nämnde användaren en person, sätt `tilldelad` till det namnet; annars töm det. Stod där ett namn i den delade versionen som nu försvinner, notera det för rapporten.
3. Skriv filen till den delade wikin med `skriv()`.
4. **Verifiera** enligt avsnittet *Innan du skriver över en fil* i `GLOTTO.md`: läs målet med `las()`, jämför brödtextens längd med källan, och kontrollera att `utplockad_av` är tom och att `publicerad_av` och `tilldelad` står rätt.
5. Flytta bort arbetskopian ur verkstaden med `kasta()` först när steg 4 lyckats - utom vid uppskrivning mitt i arbetet, då den behålls. Radera den aldrig.
6. `journalfor(..., "publicerade", <dokumentnamn>, <detalj>)` där detaljen är fallet - *ny*, *återlämning* eller *uppskrivning* - följt av tilldelningen om någon: *"återlämning, tilldelad johan"* eller *"ny, tilldelning till johan borttagen"*.

Kan arbetskopian inte flyttas bort, säg det rakt ut och tala om var dubbletten finns. Lämna aldrig användaren i tron att flytten är klar när den inte är det.

## Efteråt

Togs en tidigare tilldelning bort, säg det - så att det kan rättas om det var oavsiktligt. Är dokumentet fortfarande utplockat, säg det.
