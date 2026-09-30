---
name: utdata
description: Skapar färdigt, designat material ur ett eller flera wikidokument - presentationer, sammanfattningar, rapporter och liknande - och lägger det i användarens personliga utdata-mapp. Används när användaren säger "gör en presentation av", "skapa utdata", "gör något presentabelt av", "jag behöver en sammanfattning att visa", "formatera det här för ett möte".
---

# Producera utdata

Läs `${CLAUDE_PLUGIN_ROOT}/GLOTTO.md` först - konfiguration, frontmatter-hantering och regler. Läs frontmatter med `las()` därifrån, aldrig med `grep`.

**Versionskontrollen först** - se avsnittet *Versionskontroll* i `GLOTTO.md`. Vid `gammal`: stanna.

Detta är operation 3, och den enklaste: **wikidokumentet ändras aldrig.** Ingen utcheckning behövs, inget lås, ingen risk för kollision. Checka aldrig ut ett dokument för att producera utdata ur det.

## Underlag

Läs källdokumenten i den **delade** wikin. Gäller det ett dokument användaren har utcheckat kan den lokala arbetskopian vara nyare - använd den då, och säg vilken version du utgick från.

Är det oklart vilket dokument som avses, lista kandidater ur wikin och fråga. Flera dokument som underlag går bra.

## Format

Fråga vad användaren behöver om det inte framgår: presentation, kort sammanfattning, rapport, faktablad. Fråga också vem mottagaren är - ett internt underlag och ett kunddokument ser inte likadana ut.

Är det tydligt av sammanhanget, fråga inte. Gå vidare och säg vilket antagande du gjorde.

För presentationer, kalkyler, Word-dokument och PDF: använd den skill som finns för formatet. Annars markdown.

## Genomför

1. Skriv resultatet till `utdata/` i den lokala projektmappen.
2. Namnge efter innehåll och mottagare, inte efter källdokumentet - det här är ett nytt dokument, inte en kopia.
3. Skriv aldrig något till den delade mappen under denna operation - med ett undantag: journalraden.
4. `journalfor(..., "skapade utdata", <filnamn i utdata>, "bygger på <wikidokument>")`.
