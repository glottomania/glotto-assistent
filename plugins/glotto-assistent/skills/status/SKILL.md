---
name: status
description: Visar läget i teamets kunskapssystem och listar wikins dokument numrerat så att man kan agera på dem - grupperat efter ålder eller filtrerat på tagg, författare, status eller låsläge. Används när användaren säger "visa status", "hur ligger vi till", "lista dokumenten", "vad finns i wikin", "vad är nytt", "vad har skapats senaste dygnen", "vilka dokument har Johan skrivit", "vad är ledigt att jobba på", "är något utplockat", "vad är tilldelat mig", "vad väntar på mig".
---

# Status och listning

Läs `${CLAUDE_PLUGIN_ROOT}/GLOTTO.md` först - konfiguration, frontmatter-hantering och regler. Läs frontmatter med `las()` därifrån, aldrig med `grep`.

**Versionskontrollen först** - se avsnittet *Versionskontroll* i `GLOTTO.md`. Vid `gammal`: ge beskedet och fortsätt.

Läsoperation - ändra ingenting (utöver att versionskontrollen kan flytta fram teamets version).

Svaret har två delar: **först ett kort läge, sedan en numrerad lista** användaren kan agera på. "Plocka ut trea" ska fungera direkt efteråt.

## Samla in

Läs frontmatter ur varje `.md`-fil i den delade wikin, plus filnamnen i `verkstad/`, `utdata/` och `indata/`. Gör det i ett enda `device_bash`-anrop.

Avgör låsläget med `ledigt(meta)`, aldrig genom att jämföra datum. Men **rapportera** dokument där `utplockad_av` är tom och `utplockad` är nyare än `publicerad` - det betyder att något plockats ut och aldrig lämnats tillbaka, och det ska sägas rakt ut, inte tyst repareras.

## Del 1 - läget

Två till fyra meningar i prosa, ingen tabell:

- Hur många dokument wikin innehåller och hur många källor som ligger i indata
- Vad som är utplockat och av vem - flagga uttryckligen allt äldre än sju dagar som troligen bortglömt
- Vad som är **tilldelat användaren** - nämn det alltid först om något finns, det är det mest angelägna i svaret
- Vad som ligger i verkstaden och ännu inte publicerats
- Vad som publicerats senast och av vem - `publicerad_av` är den som ansvarar för innehållet

Är wikin tom, säg det rakt ut och hoppa över del 2.

## Del 2 - listan

Standardläget är gruppering på `skapad` i fyra **uteslutande** intervall. Ett dokument hamnar i exakt en grupp:

| Grupp | Rubrik |
|---|---|
| Senaste 48 timmarna | `Senaste två dygnen` |
| 48 timmar till 7 dygn | `Senaste veckan` |
| 7 till 28 dygn | `Senaste månaden` |
| Äldre än 28 dygn | `Äldre` |

Räkna från nuvarande tidpunkt, inte från midnatt - använd `nu()`.

`Äldre` räknas bara upp om den innehåller högst tio dokument eller om användaren ber om den. Annars anges bara antalet, så att listan förblir läsbar. Utelämna tomma grupper helt - skriv aldrig ut en rubrik med noll dokument under.

Saknar ett dokument `skapad`, använd filens tidsstämpel och markera värdet som osäkert.

Ber användaren om ålder på *ändring* - "vad har ändrats", "vad är nytt sedan i måndags" - gruppera på `publicerad` i stället och säg att du gjort det.

### Filter

Följ det användaren ber om och kombinera fritt: tagg, `skapad_av`, `publicerad_av`, eller låsläge. "Vad är ledigt" betyder `ledigt(meta)`. "Vad håller Johan på med" betyder `utplockad_av: johan`. "Vad är tilldelat mig" eller "vad väntar på mig" betyder `tilldelad` = användaren.

Vid filter, hoppa över åldersgrupperingen och ge en rak lista sorterad med nyaste först - om inte användaren ber om båda.

### Format

Numrera löpande från 1 genom hela listan, **över gruppgränserna**. Nummer 7 ska vara entydigt oavsett grupp.

En rad per dokument: nummer, titel, och vem som publicerade det senast. Är det tilldelat någon, lägg till *→ namn*. Är dokumentet utplockat, markera med vem som håller det - den informationen avgör om användaren kan agera på raden.

Håll raderna skannbara. Ingen tabell vid färre än fem dokument.

## Efteråt

Avsluta utan att räkna upp vad användaren kan göra härnäst.

Numren gäller resten av konversationen.
