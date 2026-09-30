---
name: plocka-ut
description: Plockar ut ett dokument från teamets delade wiki för redigering, och reserverar det så att ingen annan arbetar med det samtidigt. Används när användaren säger "plocka ut", "checka ut", "hämta hem dokumentet", "jag vill jobba på det", "jag ska revidera", "reservera det åt mig", "ta hem det för redigering".
---

# Plocka ut för redigering

Läs `${CLAUDE_PLUGIN_ROOT}/GLOTTO.md` först - konfiguration, frontmatter-hantering och regler. Läs och skriv frontmatter med `las()` och `skriv()` därifrån, aldrig med `grep` eller `sed`.

**Startkollen först** - se avsnitten *Startkoll* och *Versionskontroll* i `GLOTTO.md`. Vid versionen `gammal`: stanna.

Dokumentet **ligger kvar** i den delade wikin under tiden och uppdateras löpande - det tas aldrig bort därifrån. Det som skapas lokalt är en arbetskopia.

## Välj dokument

Har användaren namngett ett, använd det. Annars lista den delade wikin med utcheckningsstatus och fråga.

## Kontrollera låset

Läs den delade versionen med `las()` och kontrollera `ledigt(meta)`. Avgör aldrig låset genom att jämföra datum - `utplockad_av` är enda sanningen.

**Tomt** - fortsätt.

**Den egna användaren** - redan utplockat av användaren själv. Säg det och fråga om arbetskopian ska hämtas om.

**Någon annan** - neka. Säg vem som håller det och sedan när. Erbjud tre vägar:

1. Vänta tills personen lämnar tillbaka det.
2. Arbeta på något annat.
3. Ta över låset explicit, om arbetet inte kan vänta.

Har låset stått i mer än sju dagar, nämn det - det är troligen bortglömt.

Utför aldrig ett övertagande utan att användaren uttryckligen begärt det. Kräv en tydlig bekräftelse, inte ett "ja" på en ledande fråga.

## Vid övertagande

1. Notera vem som höll låset och sedan när.
2. Skriv över `utplockad_av` med den nya användaren och `utplockad` med dagens datum.
3. Säg åt användaren att berätta för den som blev av med låset. Systemet meddelar ingen.
4. `journalfor(..., "tog över lås", <dokumentnamn>, "från <tidigare innehavare>")`.

## Tilldelning

Är dokumentet `tilldelad` någon annan än användaren, säg det innan du plockar ut - någon väntas ta hand om det. Det är upplysning, inte ett hinder. Är det tilldelat användaren själv, nämn det kort: det är troligen därför dokumentet hämtas.

## Genomför

1. Sätt `utplockad_av` till användarnamnet och `utplockad` till `nu()` i den **delade** versionen, och spara den med `skriv()`.
2. Kopiera dokumentet till verkstaden som arbetskopia, och **konvertera `underlag` till vanlig text** med `till_text()`. I verkstaden når länkarna inte sina mål, och en obruten länk skapar en tom fil om någon klickar på den.
3. Läs båda med `las()` och bekräfta att låset står rätt i den delade och att brödtexten är lika lång i båda.
4. `journalfor(..., "plockade ut", <dokumentnamn>)`.

## Efteråt

Ligger dokumentet sannolikt öppet i Obsidian, säg till användaren att stänga det innan arbetet börjar.
