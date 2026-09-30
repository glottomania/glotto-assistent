---
name: skapa
description: Tar fram ett nytt kunskapsdokument till wikin genom att först söka i det som redan finns - wikin, indata, företagets delade enheter i Drive och vid behov webben - och sammanställa ett utkast i verkstaden. Används när användaren säger "gör en SWOT", "ta fram en marknadsanalys", "skriv ihop en sammanställning om", "vad vet vi om", "skapa ett dokument om", "analysera", "utred".
---

# Skapa ett kunskapsdokument

Läs `${CLAUDE_PLUGIN_ROOT}/GLOTTO.md` först - konfiguration, frontmatter-hantering och regler. Läs frontmatter med `las()`, aldrig med `grep`.

**Versionskontrollen först** - se avsnittet *Versionskontroll* i `GLOTTO.md`. Vid `gammal`: stanna.

Resultatet är **ett** dokument i verkstaden. Inte två, inte ett med bilagor.

## 1. Finns det redan?

Sök i den delade wikin efter dokument som täcker samma sak - på `typ/`-tagg och på ämne, inte bara på filnamn. "SWOT Exempel" och "SWOT-analys för Exempel AB" är samma dokument.

Hittar du en föregångare: **avbryt och rapportera innan du skriver något.** Säg vilket dokument det är, när det skapades, och vem som senast ändrade det. Fråga om användaren vill revidera det befintliga eller ta fram en ny version. Gissa inte - ett nyskapat dokument som borde varit en revidering lämnar två motstridiga sanningar i wikin.

Väljer användaren revidering är det `plocka-ut` som gäller, inte denna skill.

## 2. Vad vet vi redan?

**Wikin**, **indata** och **företagets delade enheter** i Google Drive gås alltid igenom, i den ordningen - hela poängen med systemet är att bygga vidare på eget arbete. **Webben** när du bedömer att det behövs. Se *Företagets delade enheter* och *Webbkällor* i `GLOTTO.md`. Det du använder från Drive eller webben sparas i `indata/`.

## 3. Struktur

Bygg dokumentets form utifrån vad användaren bad om och vad underlaget faktiskt innehåller. Det finns inga mallar, och andra dokument i wikin används aldrig som förebild för form - inte ens ett av samma typ. Läs befintliga dokument för deras innehåll, inte för deras rubriker.

Ren, välformaterad markdown - rubriker, brödtext, punktlistor där de hör hemma. Ingen formgivning, inga ASCII-diagram, inga fyrfältare ritade i tecken. Det designade materialet görs i `utdata/` med andra verktyg.

## 4. Skriv

Ett dokument, i **verkstaden**.

Frontmatter enligt standarden. `underlag` listar det råmaterial i `indata/` du faktiskt använde **som vanlig text utan hakparenteser** - dokumentet ligger i verkstaden och når inte indata därifrån. Lämna `publicerad` och `publicerad_av` tomma - dokumentet har aldrig varit i wikin. Taggar enligt konventionen, med återanvändning av taggar som redan finns i wikin framför nya.

Sist i brödtexten en `## Källor`-sektion: en rad per källa - sökväg eller URL som text, aldrig wikilänk till något utanför verkstaden.

Markera tydligt i texten vad som är osäkert eller saknas. Hellre en rad om att siffrorna är fyra år gamla än en analys som ser färdig ut.

När dokumentet är skrivet och läsbart: `journalfor(..., "skapade", <dokumentnamn>, <dokumenttyp>)`.
