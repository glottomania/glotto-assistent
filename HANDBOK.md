# Handbok — Glotto-assistenten

Vad systemet gör, vad det inte gör, och vad du säger för att få det att hända.

*Den här filen hämtas av installationsskriptet och skrivs över när du kör det igen. Ändra den inte själv.*

---

## Var saker ligger

| Mapp | Vad | Vem ser den |
|---|---|---|
| `verkstad/` | Pågående arbete. Utkast och utplockade dokument. | Du. Teamet ser i rapporten *vad* som ligger här, inte innehållet |
| `utdata/` | Färdigt, designat material. Presentationer och liknande. | Du. Teamet ser i rapporten vilka dokument du gjort utdata av |
| `wiki/` *(i teammappen)* | Systemets sanning. Allt publicerat. | Hela teamet |
| `indata/` *(i teammappen)* | Råmaterial i valfri form. Läses, ändras aldrig. | Hela teamet |
| `arkiv/` *(i teammappen)* | Ersatta dokument. | Hela teamet |
| `journal/` *(i teammappen)* | Vem som gjort vad och när. En fil per person och månad, plus teamrapporten `rapport.md`. | Hela teamet |

`verkstad/` och `utdata/` ligger i din **projektmapp**, `<team> Assistant` i din hemkatalog. Den är den enda mapp du ansluter i Claude själv; teammappen begär Claude åtkomst till när den behövs.

Två valv i Obsidian: **projektmappen** (verkstad och utdata) och **teammappen** (wiki, indata, arkiv, journal).

---

## Det du kan säga

**"Visa status"** eller **"lista dokumenten"** — läget plus en numrerad lista över wikin. Fungerar också med filter: *"vad är nytt senaste dygnen"*, *"vad har Johan skrivit"*, *"vad är ledigt att jobba på"*. Numren gäller resten av konversationen, så *"plocka ut trea"* fungerar direkt efteråt.

**"Gör en SWOT för X"** — eller vilken dokumenttyp som helst. Söker i wikin, indata och teamets delade enheter i Google Drive, och på webben när det behövs. Det som används från Drive eller webben sparas i indata. Lägger ett utkast i verkstaden. Skapar **ett** dokument, aldrig följedokument.

**"Plocka ut dokument N"** — hämtar hem ett wikidokument för redigering och markerar det som ditt. Fungerar också med *"checka ut"* eller *"hämta hem"*.

**"Publicera och tilldela Johan"** — publicerar och sätter Johans namn i `tilldelad`. Det är hela meddelandet; han ser det i status och i rapporten. Varje publicering skriver fältet på nytt — nämns ingen blir det tomt. Namn får stavas hur som helst och smeknamn fungerar; Claude skriver alltid rätt användarnamn.

**"Publicera"** — flyttar upp arbete till wikin. Samma ord vare sig det är nytt eller återlämnat. Säg **"spara upp det jag gjort hittills"** i stället om du inte är klar — då behåller du låset.

**"Vad är tilldelat mig?"** — det som väntar på dig.

**"Visa rapporten"** — teamrapporten: en tabell per person med allt hen rört, var det ligger nu och vem som har bollen. Finns en från i dag visas den; säg **"ta fram en ny"** för en färsk. Den ligger i `journal/rapport.md` och är likadan för alla.

**"Gör en presentation av N"** — producerar designat material i `utdata/` ur ett wikidokument. Wikidokumentet ändras inte.

**"Kasta utkastet om X"** eller **"döp om X till Y"** — Claude gör det och skriver det i journalen, så att rapporten stämmer.

**"Notera friktion: …"** — skriver en rad i journalen om något i systemet som skaver. Claude räknas som en i teamet och noterar friktion själv när den märker något.

**"Vad har jag gjort idag?"** eller **"visa journalen"** — läser journalen rakt av.

### För teamets administratör

**"Lägg till Anna i teamet"** — Claude lägger in henne i teamfilen, delar teammappen med henne, lägger till henne i teamets Google-grupp och skriver ett välkomstmejl med installationsinstruktionen. Du ser mejlet innan det skickas.

**"Ta bort Anna ur teamet"** — markerar henne som inaktiv och tar bort delningen. Hennes namn står kvar i journal och wiki.

**"Sätt upp ett nytt team"** — skapar teammappens struktur och teamfilen.

---

## Arbetsgången

**Nytt dokument:** be om det → det hamnar i verkstaden → du läser igenom → publicera. Inget syns i wikin förrän sista steget.

**Ändra något publicerat:** plocka ut → arbeta → publicera. Dokumentet ligger kvar i wikin hela tiden, markerat som ditt.

**Producera något att visa:** be om utdata direkt från ett wikidokument. Ingen utplockning behövs.

---

## Det systemet gör åt dig

- **Startkoll** första gången du ber om något i en chatt: en rad som säger att datorn, mapparna, teamet, versionen och Google Drive är i ordning - eller vad som saknas och vad du ska göra.
- Kontrollerar att du kör samma version av pluginet som resten av teamet. Kör du en äldre säger Claude till, och det som skriver stannar tills du uppdaterat.
- Sätter tider och namn i dokumentens fält vid varje ändring.
- Verifierar att en fil kom fram innan originalet flyttas bort. Claude raderar aldrig: det som ska bort flyttas till den dolda mappen `.papperskorg` i projektmappen, som du tömmer själv när det passar.
- Begär åtkomst till teammappen själv när den behövs.
- Återanvänder taggar som redan finns framför att hitta på nya.

---

## Det systemet inte gör

**Låset är en konvention, inte en spärr.** Säger du åt Claude att strunta i att någon annan har checkat ut ett dokument så gör den det. Systemet håller om ni följer det.

**Ingen får veta något av sig själv.** En tilldelning syns först när mottagaren frågar systemet eller öppnar rapporten. Rapporten tas fram för hand.

**Arkivering finns inte ännu.** Mappen finns, mekaniken inte.

**Länkar korsar inte valvgränsen.** Ett utkast i verkstaden som länkar till ett publicerat dokument visas som obruten länk tills det publicerats. Det är väntat, inte ett fel.

**Ett team per chatt.** Är du med i flera team har du en projektmapp per team. Anslut bara det teamets projektmapp i chatten; är flera anslutna frågar Claude vilket som gäller.

**Ingen läser dina utkast.** Innehållet i verkstaden syns bara för dig. Det betyder också att ingen annan kan rädda dem om din dator går sönder.

---

## Om något ser fel ut

**Startkollen säger att något saknas** — gör det den säger. Hör felet till datorn (virtualisering, projektmapp, konfiguration) är svaret nästan alltid att köra installationsskriptet igen:

```
irm https://raw.githubusercontent.com/glottomania/glotto-assistent/main/installation/installera.ps1 | iex
```

Det kan köras hur många gånger som helst och skriver aldrig över din konfiguration.

**"Instruktionerna stämmer inte med mapparna"** — pluginet är troligen gammalt. Customize → Plugins → Glotto assistent → ⋮ → *Check for updates* → *Update*, och starta en ny chatt.

**"Ett dokument dök upp i valvroten"** — Obsidians dagboksfunktion, eller en not skapad med Ctrl+N. Sätt *default location for new notes* till `verkstad/`.

**Raderat av misstag** — det Claude tar bort ligger i `.papperskorg`. Det du själv raderat i teammappen finns i Dropbox versionshistorik i webbgränssnittet.

---

## Frontmatter

Varje wikidokument har dessa fält. Du behöver sällan röra dem för hand.

```yaml
skapad / skapad_av         # när och av vem dokumentet kom till
utplockad / utplockad_av   # när det senast plockades ut, och vem som håller det
publicerad / publicerad_av # när det senast lades upp i wikin, och av vem
tilldelad                  # vem som ska ta vid, tomt om ingen
taggar                     # gemener, snedstreck för hierarki: typ/swot
underlag                   # vad dokumentet bygger på
```

**Platsen säger vilket steg dokumentet är i** — verkstad betyder utkast, wiki betyder godkänt att bygga vidare på, arkiv betyder ersatt.

**`publicerad` tom betyder att dokumentet aldrig lämnat verkstaden.**

**`publicerad_av` är den ansvarige.** Den som lade upp dokumentet senast svarar för att innehållet håller — att publicera *är* att gå i god.

**`utplockad_av` är enda svaret på om något är utcheckat.** Står det ett namn är det ute.

Taggprefix: `typ/` för vad dokumentet är, `projekt/` för vilket uppdrag, `amne/` för vad det handlar om.

---

## Att ändra systemet

Pluginet är likadant för alla team. Det som är ert eget - namn, medlemmar, tidszon, grupp - står i teamfilen `.glotto/team.json` i teammappen och ändras med *"lägg till"*, *"ta bort"* och *"sätt upp"* ovan. Det finns inga mallar: varje nytt dokument byggs utifrån din förfrågan och underlaget. Vill du ha en viss form, säg det när du ber om dokumentet.
