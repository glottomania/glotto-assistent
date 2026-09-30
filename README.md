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

Varje användare gör detta en gång.

0. **Virtualisering påslagen.** Claude behöver den för att arbeta i dina mappar.
   Tryck på Windows-tangenten, skriv `powershell`, tryck Enter och klistra in:

   ```
   (Get-CimInstance Win32_ComputerSystem).HypervisorPresent
   ```

   Svaret ska vara `True`. Är det `False`: tryck på Windows-tangenten, skriv
   `optionalfeatures`, bocka för **Plattform för virtuella datorer**, klicka OK och
   starta om datorn.
1. **Lägg till katalogen och installera.** I Claude-appen:
   1. Öppna **Customize** i menyn till vänster och välj fliken **Plugins**.
   2. Klicka **+ Add** uppe till höger och välj att lägga till från ett repo
      (*Add from a repository*).
   3. Skriv `glottomania/glotto-assistent` och bekräfta.
   4. Katalogen dyker upp. Klicka på **Glotto assistent** i den och välj **Install**.
   5. Klart när Glotto assistent syns under *From marketplaces you added*.
2. **Har du en äldre version sedan tidigare, ta bort den först** - se *Ta bort en
   gammal version* nedan.
3. **Projektmappen.** Skapa en mapp i din hemkatalog, till exempel
   `Glotto Assistant`, med undermapparna `verkstad` och `utdata`, och anslut den i
   Claude. Första gången du säger till exempel *"visa status"* frågar Claude efter
   ditt användarnamn och sökvägen till teammappen och skapar konfigurationen själv.
4. **Teammappen** ska vara delad med dig och synkad till din dator. Claude ber om
   åtkomst till den första gången den behövs.
5. **Google**, om teamet använder det: koppla Google Drive i Claude med ditt
   jobbkonto.
6. **Obsidian.** Öppna teammappen och projektmappen som två separata valv.
7. **Dropbox ska inte synka Obsidians fönsterläge.** Filen `workspace.json` i
   teammappens `.obsidian` sparar vilka flikar du har öppna. Delas den skriver
   ni över varandras fönster och Dropbox skapar konfliktkopior. Gör så här, en
   gång per dator:
   1. Öppna teammappen i Obsidian en gång, så att filen finns. Stäng Obsidian.
   2. Tryck på Windows-tangenten, skriv `powershell` och tryck Enter.
   3. Klistra in raden nedan, med sökvägen ändrad till din teammapp, och tryck
      Enter. Inget svar betyder att det gick bra.

      ```
      Set-Content -Path "$HOME\Dropbox\Teammapp\.obsidian\workspace.json" -Stream com.dropbox.ignored -Value 1
      ```

   4. Kontrollera i Utforskaren: filen `workspace.json` ska ha en grå ikon med
      ett minustecken i stället för en grön bock. Det betyder att Dropbox
      ignorerar den.

   Obs: filen försvinner då från Dropbox hos de andra. Deras Obsidian skapar en
   ny nästa gång de öppnar valvet - de måste då köra samma rad hos sig.

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

Administratören:
1. Delar teammappen med personen.
2. Lägger till personen i teamets grupp i Google Workspace, om teamet använder
   det. De delade enheterna syns då hos personen inom någon minut.

Personen följer sedan *Installera* ovan.

## För den som bygger

- Pluginets källkod: `plugins/glotto-assistent/`. Regler för Claude: `GLOTTO.md`.
- Höj `version` i `plugins/glotto-assistent/.claude-plugin/plugin.json` vid varje
  ändring. Versionskontrollen flyttar fram teamets version när den nya används
  första gången.
- Repot innehåller aldrig något som hör till ett visst team: inga namn,
  adresser, sökvägar eller dokument. Exempel i reglerna använder påhittade namn.
