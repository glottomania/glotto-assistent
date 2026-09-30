---
name: team
description: Administrerar teamet - lägger till och tar bort medlemmar och sätter upp ett nytt team. Uppdaterar teamfilen, delar teammappen, lägger till i teamets Google-grupp och skriver välkomstmejlet med installationsinstruktionen. Används när användaren säger "lägg till Anna i teamet", "ny medlem", "bjud in", "ta bort Johan ur teamet", "Johan har slutat", "sätt upp ett nytt team", "sätt upp teamet", "vilka är med i teamet".
---

# Team

Läs `${CLAUDE_PLUGIN_ROOT}/GLOTTO.md` först - särskilt *Teamfilen*, *Startkoll* och *Installation*. Teamfilen skrivs bara med `spara_team()`, aldrig för hand.

**Startkollen först.** Att visa medlemmarna får alla göra. Allt annat kräver att startkollen ger `admin: True` - annars säg vilka som är admin enligt teamfilen och stanna. (Undantag: *sätt upp ett nytt team*, där det inte finns någon teamfil än.)

## Lägg till en medlem

### 1. Samla uppgifterna

Du behöver:

| Uppgift | Till |
|---|---|
| fullständigt namn | teamfilen, välkomstmejlet |
| e-postadress - den personen använder i jobbet | delningen, gruppen, mejlet |
| användarnamn | teamfilen och alla filer framöver |
| smeknamn, om några | `kallas` |

Föreslå användarnamnet själv: förnamnet med gemener, å/ä → a, ö → o, é → e, bara `a-z`, `0-9` och `-`. Är det upptaget, lägg till efternamnets första bokstav. Fråga efter det som saknas och bekräfta allt i **en** fråga: *"Anna Svensson, anna@exempel.se, användarnamn anna - stämmer det?"*

Finns personen redan som `aktiv: false` - fråga om hen ska återaktiveras i stället för att läggas till på nytt.

### 2. Teamfilen

Läs med `team()`, lägg till `{"anvandare", "namn", "epost", "kallas"}`, skriv med `spara_team()`. Verifiera genom att läsa filen igen. Journalför: `journalfor(..., "anteckning", "", "lade till <användarnamn> i teamet")`.

### 3. Dela teammappen

Görs i användarens webbläsare, där hen är inloggad. Läs skillen för Claude in Chrome innan första steget.

**Dropbox** (`lagring: dropbox`): öppna dropbox.com, gå till mappen `delad_mapp_namn`, välj **Dela**, skriv e-postadressen, ge behörigheten **Kan redigera** och skicka.

Annan lagring, eller går webbläsaren inte att nå: ge användaren stegen att göra själv, och säg att det måste bli gjort innan den nya kör skriptet.

### 4. Google-gruppen

Bara om `google_grupp` inte är tom. I webbläsaren: admin.google.com → **Katalog → Grupper** → gruppen → **Lägg till medlemmar** → e-postadressen → spara. Kräver att användaren är administratör i Google Workspace; får du inte åtkomst, ge stegen i stället.

### 5. Välkomstmejlet

Skapa ett **utkast** i Gmail till den nya, och visa det. Skicka först när användaren säger till. Är den kopplade Gmail-adressen inte den användaren skickar jobbmejl från, visa texten för kopiering i stället.

Innehåll, kort och i den här ordningen:

1. Hälsning, och att hen är tillagd i `<teamets namn>`s assistent.
2. **Acceptera inbjudan till teammappen** i Dropbox-mejlet, och vänta tills mappen synkat till datorn.
3. **Kör en rad i PowerShell** (Windows-tangenten, skriv `powershell`, Enter, klistra in):
   `irm https://raw.githubusercontent.com/glottomania/glotto-assistent/main/installation/installera.ps1 | iex`
   Skriptet ordnar datorn och säger vad som återstår.
4. Förutsättningar: Claude-appen på datorn och ett Claude-konto; Obsidian (gratis).
5. Vid frågor: användarens namn.

### 6. Rapportera

Kort: vad som är gjort, vad som gjordes som checklista i stället, och vad den nya själv har kvar - acceptera delningen, köra skriptet, installera pluginet.

## Ta bort en medlem

Bekräfta först: *"Ta bort Johan: han slutar se teammappen och gruppen. Hans namn står kvar i journal och wiki. Stämmer det?"*

1. Teamfilen: sätt `aktiv: false` på raden. Ta aldrig bort raden. Är hen admin, ta bort hen ur `admin` - men aldrig den sista admin.
2. Är något utplockat av hen: säg det. Frigör inget utan att användaren ber om det.
3. Dropbox: ta bort delningen i webbläsaren (mappen → Dela → personen → Ta bort).
4. Google-gruppen: ta bort personen ur gruppen.
5. Journalför: `anteckning`, *"tog bort <användarnamn> ur teamet"*.

## Sätt upp ett nytt team

För den som ska starta ett eget team - hos en kund, eller ett nytt internt.

1. **Uppgifter:** teamets namn, tidszon (föreslå användarens), lagring, Google-grupp om teamet använder Google, och vem som är admin (användaren).
2. **Teammappen:** användaren skapar en tom mapp i sin Dropbox som heter `<namn> Teammapp`, och du begär åtkomst till den. Allt som hör till teamet börjar med teamets namn - `<namn> Assistant`, `<namn> Teammapp` - så att det hamnar samlat i bokstavsordning i Utforskaren. Skapa `wiki/`, `indata/`, `arkiv/`, `journal/`.
3. **Teamfilen:** skriv den med `spara_team()`, med användaren som enda medlem och admin. Skriv den installerade pluginversionen till `.glotto-version`.
4. **Användarens egen installation:** användaren kör installationsskriptet (se *Installation* i `GLOTTO.md`). Det hittar den nya teammappen och skapar projektmappen `<namn> Assistant`.
5. **Google-gruppen**, om teamet använder Google - ge stegen, de görs en gång:
   - admin.google.com → **Katalog → Grupper → Skapa grupp**. Externa medlemmar ska inte tillåtas.
   - För varje delad enhet i Drive som assistenten ska få söka i: högerklicka → **Hantera medlemmar** → gruppens adress → rollen **Ansvarig**.
6. Sedan läggs övriga till med *"lägg till <namn> i teamet"*.

## Visa medlemmarna

En rad per aktiv medlem: namn, användarnamn, smeknamn, och *admin* där det gäller. Inaktiva bara om användaren ber om dem.
