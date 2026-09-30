---
name: rapport
description: Visar teamrapporten - en tabell per användare med allt hen har rört, var varje dokument ligger nu och vem som har bollen - och tar fram en ny när det behövs. Används när användaren säger "visa rapporten", "teamrapporten", "morgonrapporten", "vad ligger på allas bord", "vad har vi på gång", "vad har Johan på sitt bord", "ta fram en ny rapport", "uppdatera rapporten".
---

# Teamrapport

Läs `${CLAUDE_PLUGIN_ROOT}/GLOTTO.md` först - konfiguration, frontmatter, journalens handlingsord och hjälpfunktionerna `las()`, `nu()`, `montering()`. Läs frontmatter med `las()`, aldrig med `grep`.

**Versionskontrollen först** - se avsnittet *Versionskontroll* i `GLOTTO.md`. Vid `gammal`: ge beskedet, visa den befintliga rapporten om det finns en, men ta inte fram en ny.

Rapporten är **en gemensam fil**, `journal/rapport.md` i teammappen. Den är likadan för alla och har ingen privat del. Den skrivs över varje gång den tas fram - historiken finns i journalen, och Dropbox har versionshistorik.

Rapporten ändrar ingenting annat. Skriv ingen journalrad om att den tagits fram.

## Visa eller ta fram

Läs raden `**Framtagen ...**` överst i `journal/rapport.md`.

- **Finns en rapport från i dag** och användaren inte bett om en ny: visa den. Säg när och av vem den togs fram, och erbjud en ny i samma mening - *"Rapporten togs fram 07:52 av anna. Vill du ha en ny?"*
- **Saknas den, är den från en tidigare dag, eller ber användaren om en ny** ("ta fram", "uppdatera", "ny rapport"): ta fram en ny enligt nedan.

Ingen spärr: vem som helst får ta fram en ny när som helst. Rapporten läser bara.

## Samla in

I **ett** `device_bash`-anrop:

1. Varje journalfil i `journal/` - bara filer som heter `ÅÅÅÅ-MM-<användare>.md`. Användaren står i filnamnet. Varje rad är `- tid | handling | dokument | detalj`.
2. Frontmatter ur varje `.md` i `wiki/`, med `las()`.
3. Filnamnen i `arkiv/`.
4. Filnamnen i användarens **egen** `verkstad/` och `utdata/` - bara för avstämningen nedan, aldrig för att läsa innehåll.

Användarna är de som har en journalfil. Varje användare får en tabell, även den som inte rört något.

## Vad räknas som rört

Ett dokument hör till en användares tabell om användaren

- står i en journalrad om dokumentet: `skapade`, `plockade ut`, `tog över lås`, `publicerade`, `kastade`, `döpte om` - eller `skapade utdata` där dokumentet nämns i detaljen (*"bygger på SWOT Exempel, Marknadsanalys - Norden"*), eller
- står i dokumentets frontmatter som `skapad_av`, `publicerad_av`, `utplockad_av` eller `tilldelad`.

Frontmattern behövs för dokument som skapades innan journalen startade.

**Följ namnbyten.** En rad `döpte om | <nytt namn> | från <gammalt namn>` betyder att allt som hänt under det gamla namnet gäller det nya. Rapporten visar bara det nuvarande namnet.

**Tidsfönster:** med kommer det som hanterats de senaste 30 dagarna, **plus alltid** utkast som ligger i en verkstad, utplockade dokument och dokument tilldelade någon - det är dem rapporten finns till för att påminna om. Arkiverade och kastade dokument äldre än 30 dagar utelämnas.

Utdatafilerna är inga egna rader. De syns i kolumnen *Utdata* på det dokument de bygger på.

## Kolumnerna

| Kolumn | Källa |
|---|---|
| Dokument | nuvarande namn |
| Skapat | `skapad`, annars journalens `skapade`-rad. Datum, *30 sep* |
| Skapat av | `skapad_av`, annars journalens |
| Publicerat | **senaste** publiceringen, `publicerad`. `–` om aldrig |
| Publicerat av | `publicerad_av` - den som ansvarar för innehållet |
| Tilldelad | `tilldelad`, `–` om tomt |
| Plats nu | se nedan |
| Utdata | vilka som gjort utdata ur dokumentet, ur `skapade utdata`-raderna. `–` om ingen |
| Senast hanterat | den senaste journalraden som rör dokumentet: *29 sep, anna, skapade utdata* |

**Plats nu**, i den här ordningen:

1. `utplockad_av` satt - personens verkstad.
2. Dokumentet ligger i `wiki/` - `wiki`. I `arkiv/` - `arkiv`.
3. Senaste journalraden om dokumentet är `kastade` - `papperskorg`.
4. Journalen har `skapade` men ingen senare `publicerade` - skaparens verkstad.
5. Inget av ovanstående - `okänd`, och ta upp det under *Claude rekommenderar*.

En verkstad skrivs som `verkstaden` i sin ägares tabell och som ägarens användarnamn i alla andra tabeller.

Sortera varje tabell på *Senast hanterat*, nyast först.

## Avstämning mot egen verkstad

Journalen vet bara det som gått genom systemet. Jämför det journalen säger ligger i **användarens egen** verkstad och utdata med filerna som faktiskt finns där:

- Ett utkast journalen säger finns, men som saknas - troligen omdöpt eller borttaget för hand.
- En fil som finns men saknar `skapade`-rad - troligen skapad eller omdöpt för hand.

Gissa inte ihop dem. Ta upp det under *Claude rekommenderar* och fråga användaren i chatten efteråt - svaret blir en `döpte om`- eller `kastade`-rad, och nästa rapport stämmer. Andras verkstäder går inte att se och stäms inte av.

## Claude rekommenderar

Högst fem rader, det viktigaste först:

- `rekommenderar`-rader i journalen från de senaste 14 dygnen
- trasiga lås - `utplockad_av` tom men `utplockad` nyare än `publicerad`
- dokument med `Plats nu` = `okänd`
- avvikelser från avstämningen ovan
- utkast som legat i en verkstad mer än sju dygn

Utelämna avsnittet om inget finns att säga. Friktion hör inte hit - den läses med `journal`.

## Filen

Skriv exakt denna form till `journal/rapport.md`, med tiden från `nu()`:

```markdown
# Teamrapport

**Framtagen <d månad åååå> kl. <hh:mm> av <användare>.**

*Byggd ur journalen och wikin i teammappen. Samma för alla i teamet. Varje tabell visar allt användaren har rört de senaste 30 dagarna, senast hanterat först.*

## <användare>

| Dokument | Skapat | Skapat av | Publicerat | Publicerat av | Tilldelad | Plats nu | Utdata | Senast hanterat |
|---|---|---|---|---|---|---|---|---|
| ... |

## Claude rekommenderar

- **<kort rubrik>.** <en eller två meningar>
```

Användarna i bokstavsordning. Har en användare inget att visa: *Inget rört de senaste 30 dagarna.* i stället för tabellen.

Verifiera efter skrivningen att filen går att läsa och börjar med rätt `Framtagen`-rad.

## Svaret

Två till tre meningar i prosa, ingen tabell: att rapporten ligger i `journal/rapport.md`, och det som rör **användaren** - vad hen har i verkstaden, vad som är tilldelat hen, vad någon annan håller som hen väntar på. Ställ sedan avstämningens frågor, om det finns några.
