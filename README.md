# Glotto-assistenten

Ett kunskapssystem för team, byggt på Claude. En delad wiki är teamets sanning,
varje användare har en egen verkstad för pågående arbete, och Claude skapar,
låser, publicerar och håller journal över vem som gjort vad.

Det här repot är en plugin-katalog för Claude-appen. Pluginet
`glotto-assistent` ligger i `plugins/glotto-assistent/`. Repot innehåller bara
pluginet - inga teams dokument, namn eller inställningar. Allt som hör till ett
team ligger i teamets egna mappar.

## Vad ett team behöver

Ordnas av teamets administratör, en gång.

- **En delad mapp som synkas till allas datorer.** Provat med Dropbox. Mappen
  innehåller `wiki/`, `indata/`, `arkiv/` och `journal/`.
- **Claude** för varje användare, med Claude-appen på datorn.
- **Obsidian** (gratis) för att läsa wikin.
- **Valfritt: Google Workspace** med delade enheter, om assistenten ska söka i
  företagets filer. En grupp som är medlem i enheterna gör att en ny person bara
  behöver läggas till på ett ställe.

## Installera

Varje ny användare gör detta en gång, efter att administratören lagt till hen
(se *Ny medlem* nedan).

1. **Acceptera inbjudan till teammappen** och vänta tills den synkat till datorn.
2. **Kör installationsskriptet.** Tryck på Windows-tangenten, skriv `powershell`,
   tryck Enter och klistra in:

   ```
   irm https://raw.githubusercontent.com/glottomania/glotto-assistent/main/installation/installera.ps1 | iex
   ```

   Skriptet slår på virtualisering om den saknas, hittar teammappen, låter dig
   välja dig själv bland medlemmarna, skapar din projektmapp med Handboken och
   ställer in Dropbox. Det slutar med en lista med OK och Fel och säger vad som
   återstår. Det kan köras om hur många gånger som helst.
3. **Installera pluginet** i Claude-appen:
   1. Öppna **Customize** i menyn till vänster och välj fliken **Plugins**.
   2. Klicka **+ Add** uppe till höger och välj *Add from a repository*.
   3. Skriv `glottomania/glotto-assistent` och bekräfta.
   4. Klicka på **Glotto assistent** i katalogen och välj **Install**.
4. **Starta en ny uppgift**, anslut projektmappen och säg *"visa status"*.
   Claudes startkoll säger till om något saknas.

## Var pluginet finns

Ingenstans på din dator. Ett plugin i Claude-appen hör till ditt Claude-konto
och hanteras bara i appen: **Customize → Plugins**. Där installerar, uppdaterar
och tar du bort det.

**Ta bort en gammal version:**
1. Customize → fliken **Plugins**.
2. Klicka på **Glotto assistent** i listan.
3. Klicka på **⋮** (tre prickar) uppe till höger.
4. Välj **Remove** och bekräfta.
5. Klart när Glotto assistent inte längre syns i listan.

## Uppdatera

Nya versioner hämtas inte automatiskt. Uppdatera så här: Customize → Plugins →
Glotto assistent → ⋮ → *Check for updates* → *Update*, och starta sedan en ny
chatt. Kör du en äldre version än resten av teamet säger Claude till, och
skrivande funktioner stannar tills du uppdaterat.

## Ny medlem i teamet

Teamets administratör säger till Claude: *"lägg till Anna i teamet"*. Claude
lägger in henne i teamfilen, delar teammappen, lägger till henne i teamets
Google-grupp och skriver ett välkomstmejl med instruktionen ovan.

## Nytt team

*"Sätt upp ett nytt team"* skapar teammappens struktur och teamfilen,
`.glotto/team.json`. Allt som hör till ett team - namn, medlemmar, tidszon,
grupp - står där. Pluginet och skriptet är likadana för alla team.

## För den som bygger

- Pluginets källkod: `plugins/glotto-assistent/`. Regler för Claude: `GLOTTO.md`.
- Höj `version` i `plugins/glotto-assistent/.claude-plugin/plugin.json` vid varje
  ändring. Versionskontrollen flyttar fram teamets version när den nya används
  första gången.
- Repot innehåller aldrig något som hör till ett visst team: inga namn,
  adresser, sökvägar eller dokument. Exempel i reglerna använder påhittade namn.
