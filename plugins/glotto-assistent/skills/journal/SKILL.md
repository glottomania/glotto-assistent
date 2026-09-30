---
name: journal
description: Skriver i och läser ur systemets journal - vem som gjort vad och när, plus noteringar om friktion i systemet. Används när användaren säger "notera friktion", "det här skaver", "skriv i journalen", "notera att", "vad har jag gjort idag", "vad har hänt idag", "visa journalen", "vad gjorde Johan igår", "vilken friktion har vi noterat", "skriv upp det till rapporten".
---

# Journal

Läs `${CLAUDE_PLUGIN_ROOT}/GLOTTO.md` först - avsnittet *Journal* beskriver format, handlingsord och regler. Skriv alltid med `journalfor()`, aldrig för hand.

**Startkollen först** - se avsnitten *Startkoll* och *Versionskontroll* i `GLOTTO.md`. Vid versionen `gammal`: visa journalen efter beskedet, men skriv inget i den.

## Skriva

**Friktion** - användaren säger *"notera friktion: …"*, *"det här skaver"* eller liknande. Handling `friktion`, dokument = den skill eller det område det gäller, detalj = vad som skavde, konkret och kort. Tolka inte bort det användaren sa; formulera om bara så mycket att raden går att förstå utan sammanhang.

**Anteckning** - användaren ber om en notering som inte gäller systemet. Handling `anteckning`, detalj = texten.

**Rekommendation** - användaren ber att något ska tas upp i en kommande rapport, eller Claude har ett förslag om systemet. Handling `rekommenderar`, dokument = område, detalj = förslaget kort.

Bekräfta med raden som skrevs, ordagrant. Inget mer.

Journalen redigeras aldrig i efterhand. Vill användaren rätta en rad, skriv en ny som säger vad som var fel.

## Läsa

Läs alla journalfiler i `journal/` som täcker den efterfrågade perioden - filnamnen anger månad och användare (`ÅÅÅÅ-MM-<användare>.md`). `rapport.md` är ingen journalfil. Sortera på tid, äldst först.

| Frågan | Period | Vems |
|---|---|---|
| "vad har jag gjort idag" | idag | användarens |
| "vad har hänt idag" | idag | allas |
| "vad gjorde Johan igår" | igår | Johans |
| "visa journalen" | senaste sju dygnen | allas |
| "vilken friktion har vi noterat" | allt | allas, bara `friktion` |

Visa raderna som de står, grupperade per dag, med användaren utskriven när flera är med. **Sammanfatta inte** - det är rapporternas jobb. Är det fler än trettio rader, visa de senaste trettio och säg hur många som utelämnades.

Är journalen tom för perioden, säg det i en mening.
