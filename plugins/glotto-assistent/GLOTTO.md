# Gemensamma regler för Glotto-assistentens skills

Detta dokument läses av varje skill i pluginet innan den arbetar.

## Konfiguration

Varje användare har en fil `.glotto/config.json` i sin lokala projektmapp:

```json
{
  "anvandare": "anna",
  "delad_mapp": "Dropbox/Teammapp"
}
```

- `anvandare` - identitet som skrivs i `skapad_av`, `publicerad_av` och `utplockad_av`
- `delad_mapp` - teammappens sökväg relativt användarens hemkatalog, t.ex.
  `Dropbox/Teammapp`. Innehåller `indata/`, `wiki/`, `arkiv/` och `journal/`

Projektmappen står inte i filen - den **är** mappen filen ligger i, och
innehåller `verkstad/` och `utdata/`. Ett fält som pekade på sin egen mapp
skulle bara kunna bli fel den dag mappen döps om.

Hitta filen genom att leta i varje ansluten mapp: `ls "$HOME/mnt/"`, sedan
`cat "$HOME/mnt/<mapp>/.glotto/config.json"`.

**Två former av samma mapp.** `delad_mapp` är sökvägen på användarens dator,
relativt hemkatalogen - den behövs när åtkomst begärs. Under `$HOME/mnt/` syns
mappen däremot bara med sitt **sista namnled**: `Teammapp`, inte
`Dropbox/Teammapp`. Använd `montering(delad_mapp)` för att
få namnet under `$HOME/mnt/`; skicka det, inte `delad_mapp`, till funktionerna
som tar en mapp. Punktmappen är avsiktlig - konfiguration hör inte
hemma bland användarens filer, och Obsidian indexerar aldrig punktmappar.

Filen skapas normalt av installationsskriptet (se *Installation* nedan). Saknas
den, fråga användaren vem hen är - bland medlemmarna i teamfilen, om den går att
läsa - och var teammappen ligger, och skapa den.
**Bara `.glotto/config.json` räknas.** En fil med annat namn - `.glotto_old/config.json`,
en kopia, en backup - är inte konfigurationen och används aldrig, inte ens som
förslag. Fråga i stället.
Hårdkoda aldrig sökvägar eller användarnamn - de skiljer sig mellan klienter.

## Teamfilen

Allt som skiljer ett team från ett annat står i **teamfilen**,
`.glotto/team.json` i teammappen. Pluginet är likadant för alla team och vet
ingenting om något av dem; det läser teamfilen.

```json
{
  "namn": "Exempel",
  "tidszon": "Europe/Stockholm",
  "lagring": "dropbox",
  "delad_mapp_namn": "Teammapp",
  "google_grupp": "team@exempel.se",
  "admin": ["anna"],
  "medlemmar": [
    {"anvandare": "anna", "namn": "Anna Svensson", "epost": "anna@exempel.se", "kallas": ["Ana"]},
    {"anvandare": "johan", "namn": "Johan Berg", "epost": "johan@exempel.se", "kallas": ["Jojje", "Johann"]}
  ]
}
```

- `namn` - teamets namn. Projektmappen heter `<namn> Assistant`.
- `tidszon` - tiden i journal och frontmatter räknas i den.
- `lagring` - vad som synkar teammappen: `dropbox` (provat) eller annat.
- `delad_mapp_namn` - teammappens eget namn, sista ledet i `delad_mapp`.
- `google_grupp` - gruppen som ger åtkomst till företagets delade enheter. Tom om teamet inte använder Google.
- `admin` - vilka som får lägga till och ta bort medlemmar.
- `medlemmar` - alla i teamet. `anvandare` är det som skrivs i filer; `kallas`
  är andra namn personen går under i samtal. `aktiv: false` betyder att
  personen lämnat teamet - raden står kvar, eftersom journalen och wikin
  fortfarande nämner hen.

**Teamfilen ändras bara med skillen `team`.** Den är teamets register, och ett
handgjort fel i den - en dubblett, en felstavning - syns i allt annat.

Läs den med `team()` från hjälpfunktionerna. Tidszonen hämtas därifrån
automatiskt av `nu()`.

## Den delade mappen ansluter sig själv

**Projektmappen är den enda användaren behöver ansluta.** Den delade mappen
kopplas in automatiskt vid behov.

Att `delad_mapp` står i konfigurationen ger ingen åtkomst - det är bara en
pekare. Åtkomst styrs av vilka mappar som är anslutna till sessionen, och det
kan ingen fil ändra på.

Ser du att `montering(delad_mapp)` inte finns under `$HOME/mnt/`, **begär åtkomst till
den i stället för att avbryta**. Anropa `device_request_folder_access` med
mappens fullständiga sökväg på användarens dator - hämta hemkatalogens prefix
från en redan ansluten mapp och lägg till hela `delad_mapp`. Motivera kort
varför: användaren ser texten i godkännanderutan.

Godkänner användaren är mappen ansluten resten av sessionen och du fortsätter
utan att fråga mer. Avslås begäran, säg vad som inte går att göra utan den
och stanna - begär inte igen i samma konversation.

Begär aldrig en mapp som inte står i konfigurationen.

## Frontmatter-standard

```yaml
skapad: 2026-09-22T14:30       # när dokumentet skapades i verkstaden
skapad_av: anna
utplockad: 2026-09-22T16:05    # när det senast plockades ut ur wikin
utplockad_av:                  # vem som håller det nu - tomt betyder ledigt
publicerad: 2026-09-22T17:40   # när det senast lades upp i wikin
publicerad_av: anna            # och därmed ansvarar för innehållet
tilldelad: johan               # vem som ska ta vid - tomt betyder ingen
taggar: [typ/x, projekt/y, amne/z]
underlag: ["filnamn"]          # vad dokumentet bygger på - se regeln nedan
```

Nio fält, alla på svenska, inga diakriter - samma skäl som för mappnamn.

### Vad fälten betyder tillsammans

**Platsen bär steget, inte ett statusfält.** Ett dokument i verkstaden är ett
utkast; ett i wikin är godkänt att bygga vidare på; ett i arkivet är ersatt.
Ett fält som upprepade det kunde bara bli fel den dag de sade emot varandra.

**`publicerad` tom betyder att dokumentet aldrig lämnat verkstaden.**

**`publicerad_av` är den ansvarige.** Den som lade upp det senast svarar för
innehållet - det är därför inget separat granskningsfält behövs.

**`tilldelad` beskriver den senaste publiceringens överlämning - inget annat.**
Den som publicerar kan peka ut vem som ska ta vid: *"publicera och tilldela
Johan"*. Fältet är hela meddelandet; ingen annan kanal finns.

Regeln är en enda: **varje publicering skriver fältet.**

- Nämns en person - fältet sätts till det namnet.
- Nämns ingen - fältet töms.

Att den tilldelade tömmer fältet när den själv publicerar följer av detta.
Fältet ändras aldrig mellan publiceringar, och det är inte en uppgiftslista:
ett dokument som publicerades för tio år sedan med `tilldelad: johan` står
kvar så, eftersom det var den senaste överlämningen. `publicerad` visar hur
gammal den är.

Töms en befintlig tilldelning, säg det i rapporten efteråt - *"tilldelningen
till Johan togs bort"* - så att publiceraren kan rätta om det var oavsiktligt.

Tilldelning är inte ett lås. Vem som helst kan plocka ut ett tilldelat
dokument; `plocka-ut` säger bara till om det är tilldelat någon annan.

Ett värde, ett användarnamn med gemener - se *Användarnamn* nedan.

### Användarnamn

**I samtal får namn stavas hur som helst. I filer står alltid användarnamnet.**
Säger användaren *Jojje*, *Johann* eller *Ana*, förstå vem som avses och
skriv användarnamnet - `johan`, `anna`. Det är inte användarnas sak att
stava rätt; det är din att översätta.

Användarnamnen står i teamfilen, med namn och smeknamn (`kallas`) - använd
`vem(namn)` för att slå upp ett namn som sagts i samtal. Stämmer det inte
entydigt med en medlem, fråga innan du skriver. Skälet: fälten jämförs rakt av - `tilldelad: johann`
syns aldrig för den som heter `johan`.

**`utplockad_av` är enda sanningen om låset.** Står det ett namn är dokumentet
utcheckat, annars inte. Jämför aldrig datum för att avgöra det.

Vid publicering töms `utplockad_av`, men **`utplockad` behålls**. Då går tre
lägen att läsa direkt:

| `utplockad_av` | Datum | Läge |
|---|---|---|
| namn | - | Utcheckat nu, av den personen |
| tomt | `utplockad` < `publicerad` | Normalt, förra rundan avslutad |
| tomt | `utplockad` > `publicerad` | **Trasigt** - utplockat men aldrig återlämnat |

Det sista läget ska rapporteras till användaren, inte tyst repareras.

### Tid

`skapad`, `utplockad` och `publicerad` bär tid, inte bara datum - annars går
det inte att skilja på vad som hänt de senaste två dygnen. Hämta tiden med
`nu()`, aldrig ur minnet. Filens egen tidsstämpel duger inte: Dropbox sätter
om den vid synk på andra maskiner.

### `underlag` byter form vid publicering

I verkstaden skrivs den som **vanlig text** - filnamn utan hakparenteser:

```yaml
underlag: ["kundintervjuer", "prislista-2026"]
```

Vid publicering konverteras den till **wikilänkar**, citerade så att YAML inte
tolkar hakparenteserna som en nästlad lista:

```yaml
underlag: ["[[kundintervjuer]]", "[[prislista-2026]]"]
```

Skälet är viktigt nog att stå här: verkstaden och den delade wikin är **skilda
vaults**. Ett dokument i verkstaden kan aldrig nå `indata/`, så en wikilänk dit
är per definition obruten. En obruten länk i Obsidian är inte bara trasig - den
är en nod i grafen, och **ett klick på den skapar filen**, tom, på vaultens
standardplats. Det går inte att stänga av.

Regeln är alltså: **skriv aldrig en wikilänk som inte kan lösas upp där
dokumentet ligger.** Det gäller `underlag` och allt annat.

`underlag` rymmer bara råmaterial ur `indata/`, där också sparade webbkällor
hamnar. Bygger dokumentet på andra wikidokument redovisas de i en
`## Källor`-sektion sist i brödtexten, med en rad per källa.

## Obsidian

Systemet består av **två vaults**, med samma uppbyggnad:

| Vault | Rot | Innehåller | Exkluderat |
|---|---|---|---|
| Delad | teammappen i Dropbox | `wiki/`, `indata/` | `indata/` |
| Verkstad | den lokala projektmappen | `verkstad/`, `utdata/` | `utdata/` |

Exkluderade filer syns inte i grafen, rankas ner i sök och föreslås inte vid
länkning, men en länk till dem fungerar och öppnar filen.

Den delade vaultens `.obsidian` synkas via Dropbox, så inställningarna följer
med till varje användare och varje klient. Ändra dem bara när det är
avsiktligt.

**Länkar korsar inte vaultgransen.** Ett dokument i verkstaden som länkar till
ett publicerat dokument visas som obruten länk i Obsidian - målet ligger i den
andra vaulten. Länken börjar fungera när dokumentet publicerats. Varna inte
användaren om detta varje gång; det är väntat beteende.

**Filnamn är länktext.** Wikidokument namnges läsbart, med mellanslag och
versal begynnelsebokstav: `Marknadsanalys - Norden.md`. Undvik å, ä
och ö i filnamn - innehållet har inga sådana begransningar.

**`source` byter form vid publicering.**

I verkstaden skrivs den som **vanlig text** - filnamn utan hakparenteser:

```yaml
source: ["kundintervjuer", "prislista-2026"]
```

Vid publicering till wikin konverteras den till **wikilänkar**, citerade så att
YAML inte tolkar hakparenteserna som en nästlad lista:

```yaml
source: ["[[kundintervjuer]]", "[[prislista-2026]]"]
```

Skälet är viktigt nog att stå här: verkstaden och den delade wikin är **skilda
vaults**. Ett dokument i verkstaden kan aldrig nå `indata/`, så en wikilänk dit
är per definition obruten. En obruten länk i Obsidian är inte bara trasig - den
är en nod i grafen, och **ett klick på den skapar filen**, tom, på vaultens
standardplats. Det går inte att stänga av.

Regeln är alltså: **skriv aldrig en wikilänk som inte kan lösas upp där
dokumentet ligger.** Det gäller `source` och allt annat.

`source` rymmer bara råmaterial ur `indata/`. Ett dokument som bygger på andra
wikidokument redovisar dem i en `## Källor`-sektion sist i brödtexten, med en
rad per källa. Bygger
dokumentet inte på något råmaterial alls lämnas `source` tom - sektionen
räcker.

**Indata redigeras aldrig.** Råmaterialets värde ligger i att det är
oförändrat. Det går att öppna och ändra i Obsidian - gör det inte, och gör
det inte åt användaren utan att denne uttryckligen begärt det.

**Ha inte ett dokument öppet i Obsidian medan du skriver till det.** Obsidian
autosparar, och den som skriver sist vinner. Varna användaren om du är på väg
att skriva till något som troligen är öppet.

## Taggkonventioner

Taggar skrivs med gemener, utan mellanslag, och med snedstreck för hierarki
så att Obsidians taggpanel blir ett hopfällbart träd i stället för en platt
lista:

```yaml
tags: [typ/systemdesign, projekt/glotto, amne/arkitektur]
```

Etablerade prefix:

- `typ/` - vad dokumentet är: systemdesign, motesanteckning, rutin, analys
- `projekt/` - vilket projekt eller uppdrag det hör till
- `amne/` - vad det handlar om

Återanvänd befintliga taggar framför att hitta på nya. Läs vilka som redan
används i wikin innan du sätter taggar på ett nytt dokument.

## Läsa och skriva frontmatter

**Använd aldrig `grep` för att läsa frontmatter.** Ett wikidokument kan
innehålla fältnamnen i brödtexten - systemets egen dokumentation gör det - och
då läser grep fel värde. Ett feltolkat `utplockad_av` betyder att någon
annans arbete skrivs över.

Läs och skriv alltid med koden nedan. Klistra in den i din `device_bash`-körning
och anropa `las()` och `skriv()`. Ändra den inte.

```python
import io, os, sys, datetime
try:
    import yaml
except ImportError:
    sys.exit("PyYAML saknas - installera med: pip3 install --user pyyaml")

FALT = ["skapad", "skapad_av", "utplockad", "utplockad_av",
        "publicerad", "publicerad_av", "tilldelad", "taggar", "underlag"]

FENA = "---" + chr(10)          # frontmatter-avgransaren

def las(sokvag):
    """Returnerar (meta: dict, brodtext: str). Kastar ValueError vid trasig fil."""
    s = io.open(sokvag, encoding="utf-8").read()
    if not s.startswith(FENA):
        raise ValueError("%s saknar frontmatter" % sokvag)
    _, fm, brodtext = s.split(FENA, 2)      # maxsplit=2: --- i brodtexten rors inte
    meta = yaml.safe_load(fm) or {}
    if not isinstance(meta, dict):
        raise ValueError("%s har frontmatter som inte ar nyckel/varde" % sokvag)
    for f in FALT:
        meta.setdefault(f, None)
    return meta, brodtext

def skriv(sokvag, meta, brodtext):
    """Skriver dokumentet med falten i standardordning. Tomma falt blir tomma rader."""
    rader = []
    for f in FALT:
        v = meta.get(f)
        if v is None or v == "":
            rader.append("%s:" % f)
        elif f == "taggar":
            lista = v if isinstance(v, list) else [v]
            rader.append("taggar: [%s]" % ", ".join(lista))
        elif f == "underlag":
            lista = v if isinstance(v, list) else [v]
            rader.append("underlag: [%s]" % ", ".join('"%s"' % x for x in lista))
        else:
            rader.append("%s: %s" % (f, v))
    for nyckel in meta:                     # bevara ovanliga falt nagon lagt till
        if nyckel not in FALT:
            rader.append("%s: %s" % (nyckel, meta[nyckel]))
    io.open(sokvag, "w", encoding="utf-8").write(
        FENA + (chr(10)).join(rader) + chr(10) + FENA + brodtext)

MNT = os.path.expanduser("~/mnt")

def team(teammapp=None):
    """Teamfilen som dict, eller None. Utan argument letas den upp bland de anslutna mapparna."""
    import json, glob
    kandidater = ([os.path.join(MNT, teammapp, ".glotto", "team.json")] if teammapp
                  else sorted(glob.glob(os.path.join(MNT, "*", ".glotto", "team.json"))))
    for fil in kandidater:
        if os.path.exists(fil):
            return json.load(io.open(fil, encoding="utf-8-sig"))
    return None

def vem(namn, t=None):
    """Anvandarnamnet for ett namn som sagts i samtal - anvandarnamn, fullt namn,
    fornamn eller smeknamn. Returnerar (anvandare, None) eller (None, [kandidater])."""
    t = t or team() or {}
    n = namn.strip().lower()
    traff = []
    for m in t.get("medlemmar", []):
        alias = [m.get("anvandare", ""), m.get("namn", "")] + (m.get("namn", "").split()[:1]) + m.get("kallas", [])
        if n in [a.strip().lower() for a in alias if a]:
            traff.append(m["anvandare"])
    traff = sorted(set(traff))
    return (traff[0], None) if len(traff) == 1 else (None, traff)

def tidszon():
    t = team()
    return (t or {}).get("tidszon") or "Europe/Stockholm"

def nu():
    """Nuvarande tid i teamets tidszon. Datorn skripten kor pa gar i UTC."""
    import zoneinfo
    return datetime.datetime.now(zoneinfo.ZoneInfo(tidszon())).strftime("%Y-%m-%dT%H:%M")

def ledigt(meta):
    return not (meta.get("utplockad_av") or "").strip()

def opublicerat(meta):
    return not (meta.get("publicerad") or "").strip()

def till_lankar(underlag):
    return [x if x.startswith("[[") else "[[%s]]" % x for x in (underlag or [])]

def till_text(underlag):
    return [x[2:-2] if x.startswith("[[") and x.endswith("]]") else x
            for x in (underlag or [])]

def kasta(sokvag):
    """Flyttar en fil till .papperskorg/ i projektmappen i stallet for att radera den.
    En flytt inom samma anslutna mapp kraver inget raderingstillstand."""
    projekt = os.path.dirname(os.path.dirname(os.path.abspath(sokvag)))
    korg = os.path.join(projekt, ".papperskorg")
    os.makedirs(korg, exist_ok=True)
    stam, ext = os.path.splitext(os.path.basename(sokvag))
    bas = "%s %s" % (nu().replace(":", ""), stam)
    mal, n = os.path.join(korg, bas + ext), 2
    while os.path.exists(mal):
        mal, n = os.path.join(korg, "%s (%d)%s" % (bas, n, ext)), n + 1
    os.rename(sokvag, mal)
    return mal

def versionskontroll(delad_mapp, installerad):
    """Jamfor installerad version med teamets. Returnerar (lage, teamets).
    lage: ok | ny | gammal. Vid ny, eller om filen saknas, skrivs installerad in."""
    fil = os.path.join(os.path.expanduser("~/mnt"), montering(delad_mapp), ".glotto-version")
    def tal(v):
        return tuple(int(x) for x in str(v).strip().split("."))
    teamets = io.open(fil, encoding="utf-8").read().strip() if os.path.exists(fil) else None
    if teamets is None or tal(installerad) > tal(teamets):
        io.open(fil, "w", encoding="utf-8").write(str(installerad).strip() + chr(10))
        return ("ny" if teamets else "ok"), str(installerad)
    if tal(installerad) < tal(teamets):
        return "gammal", teamets
    return "ok", teamets

def montering(delad_mapp):
    """Namnet som delad_mapp har under ~/mnt/ - sista namnledet."""
    return os.path.basename(delad_mapp.replace("\\", "/").rstrip("/"))

def journalfor(delad_mapp, anvandare, handling, dokument="", detalj=""):
    """Lagger en rad i anvandarens journal for innevarande manad."""
    def ren(x):
        return str(x or "").replace("|", "/").replace(chr(10), " ").strip()
    mapp = os.path.join(os.path.expanduser("~/mnt"), montering(delad_mapp), "journal")
    os.makedirs(mapp, exist_ok=True)
    tid = nu()
    fil = os.path.join(mapp, "%s-%s.md" % (tid[:7], anvandare))
    ny = not os.path.exists(fil)
    with io.open(fil, "a", encoding="utf-8") as f:
        if ny:
            f.write("# Journal %s %s" % (anvandare, tid[:7]) + chr(10) + chr(10))
        f.write("- " + " | ".join([tid, ren(handling), ren(dokument), ren(detalj)]) + chr(10))

def spara_team(teammapp, t):
    """Skriver teamfilen efter kontroll. Anvands bara av skillen team."""
    import json, re
    namn = [m.get("anvandare", "") for m in t.get("medlemmar", [])]
    for a in namn:
        if not re.fullmatch(r"[a-z0-9-]+", a):
            raise ValueError("ogiltigt anvandarnamn: %r" % a)
    if len(set(namn)) != len(namn):
        raise ValueError("dubblett bland anvandarnamnen")
    for a in t.get("admin", []):
        if a not in namn:
            raise ValueError("admin %r ar inte medlem" % a)
    mapp = os.path.join(MNT, teammapp, ".glotto")
    os.makedirs(mapp, exist_ok=True)
    tmp = os.path.join(mapp, "team.json.tmp")
    io.open(tmp, "w", encoding="utf-8").write(json.dumps(t, ensure_ascii=False, indent=2) + chr(10))
    os.replace(tmp, os.path.join(mapp, "team.json"))

def startkoll(installerad):
    """Kontrollerar det Claude-sidan kan se. Returnerar en dict; 'fel' ar tom nar allt ar i ordning."""
    import json, glob
    r = {"fel": []}
    cfg = sorted(glob.glob(os.path.join(MNT, "*", ".glotto", "config.json")))
    if not cfg:
        r["fel"].append("projektmapp: ingen ansluten mapp har .glotto/config.json")
        return r
    if len(cfg) > 1:
        r["fel"].append("flera projektmappar anslutna: " + ", ".join(c.split(os.sep)[-3] for c in cfg))
        return r
    c = json.load(io.open(cfg[0], encoding="utf-8-sig"))
    projekt = os.path.dirname(os.path.dirname(cfg[0]))
    r["projektmapp"] = os.path.basename(projekt)
    r["anvandare"] = c.get("anvandare")
    r["delad_mapp"] = c.get("delad_mapp")
    for u in ("verkstad", "utdata"):
        if not os.path.isdir(os.path.join(projekt, u)):
            r["fel"].append("projektmapp: %s/ saknas" % u)
    if not r["anvandare"] or not r["delad_mapp"]:
        r["fel"].append("konfiguration: anvandare eller delad_mapp saknas")
        return r
    tm = montering(r["delad_mapp"])
    if not os.path.isdir(os.path.join(MNT, tm)):
        r["teammapp"] = "ej ansluten"
        return r
    r["teammapp"] = "ok"
    t = team(tm)
    if t is None:
        r["fel"].append("teamfil: .glotto/team.json saknas i teammappen")
        return r
    r["team"] = t.get("namn")
    aktiva = [m["anvandare"] for m in t.get("medlemmar", []) if m.get("aktiv", True)]
    if r["anvandare"] not in aktiva:
        r["fel"].append("medlem: %s star inte bland teamets medlemmar" % r["anvandare"])
    r["admin"] = r["anvandare"] in t.get("admin", []) and r["anvandare"] in aktiva
    r["version"], r["teamets_version"] = versionskontroll(r["delad_mapp"], installerad)
    return r

```

`las()` tål `---` i brödtexten, tomma fält, och fält i valfri ordning.
`skriv()` återställer standardordningen och bevarar fält som någon lagt till
utanför standarden. `till_lankar()` och `till_text()` konverterar `underlag`
mellan wikins och verkstadens form. `journalfor()` skriver en journalrad - se
avsnittet *Journal*. `team()`, `vem()` och `spara_team()` läser teamfilen, slår
upp namn och skriver teamfilen. `startkoll()` - se avsnittet *Startkoll*.

Hämta tiden med `nu()`, aldrig ur minnet eller med `date` - datorn där skripten
körs går i UTC, och `nu()` räknar om till teamets tidszon.

## Innan du skriver över en fil

Ordningen är alltid: skriv målet, **verifiera**, flytta först därefter bort källan med `kasta()`.

Verifiera att målfilen går att läsa med `las()`, att brödtexten har rimlig
längd jämfört med källan, och att de fält du satte har de värden du avsåg.
Går något av detta inte att bekräfta - lämna källan orörd och säg till
användaren var båda kopiorna finns.

## Startkoll

**Varje skill börjar med startkollen**, innan något annat görs. Den ska göra att
användaren får veta vad som saknas *innan* hen sätter igång, i stället för mitt
i arbetet.

1. Läs den installerade versionen ur `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`
   (fältet `version`). Filen ligger där skillen läses, inte på användarens dator.
2. Anropa `startkoll(installerad)` i `device_bash`. Går `device_bash` inte att
   anropa alls saknas skalet mot datorn - se tabellen.
3. Är `teammapp` = `ej ansluten`: begär åtkomst enligt *Den delade mappen ansluter
   sig själv* och kör startkollen igen.
4. Titta själv efter det Claude-sidan har: finns Google Drive-verktygen?

**Första gången i en konversation**, ge en rad även när allt är i ordning:

> Startkoll: dator ok · Glotto Assistant · teammapp ok · du: anna · version 0.22.0 · Drive ok

Därefter i samma konversation: säg bara något om något ändrats eller är fel.

| Fel | Säg |
|---|---|
| `device_bash` saknas | Skalet mot datorn saknas, oftast för att virtualisering är avstängd. Kör installationsskriptet igen - det kontrollerar och slår på den. |
| ingen projektmapp | Anslut projektmappen (`<team> Assistant`) i Claude-appen. Finns den inte: kör installationsskriptet. |
| flera projektmappar | Du har flera teams projektmappar anslutna. Vilket team gäller? Koppla bort de andra för den här chatten. |
| `verkstad/` eller `utdata/` saknas | Kör installationsskriptet igen - det skapar dem. |
| teamfil saknas | Teamet är inte uppsatt. En admin säger *"sätt upp teamet"* (skillen `team`). |
| inte medlem | Du står inte i teamfilen. Be en admin säga *"lägg till <namn> i teamet"*. |
| Drive saknas | Inget stopp. Koppla Google Drive under Connectors om teamet använder det - annars söks bara wikin, indata och webben. |

Skills som bara läser fortsätter efter beskedet om det går. Skills som skriver
stannar vid fel i projektmapp, teamfil eller medlemskap.

## Installation

Windows-sidan ordnas av **installationsskriptet** i repot,
`installation/installera.ps1`. Användaren klistrar in en rad i PowerShell:

```
irm https://raw.githubusercontent.com/glottomania/glotto-assistent/main/installation/installera.ps1 | iex
```

Skriptet slår på virtualisering vid behov, hittar teamfilen i den synkade
teammappen, låter användaren välja sig själv bland medlemmarna, skapar
projektmappen med `verkstad/`, `utdata/` och `.glotto/config.json`, lägger
Handboken i projektmappen och ser till att Dropbox inte synkar Obsidians
fönsterläge. Det slutar med en lista med OK och Fel. Det kan köras om hur många
gånger som helst - det skriver aldrig över en befintlig konfiguration.

Startkollen och skriptet delar på arbetet: skriptet ser Windows-sidan, startkollen
det Claude ser. Hör ett fel till Windows-sidan, hänvisa till skriptet i stället
för att förklara stegen själv.

## Versionskontroll

Alla i teamet ska köra samma version av pluginet. Filen `.glotto-version` i
teammappen anger vilken version teamet kör. Startkollen gör kontrollen och
lämnar svaret i `version`.

| Svar | Betyder | Gör |
|---|---|---|
| `ok` | samma version som teamet | fortsätt |
| `ny` | användaren har installerat en nyare version | filen har flyttats fram; fortsätt |
| `gammal` | användaren kör en äldre version än teamet | se nedan |

**Vid `gammal`:** säg det direkt - *"Ditt plugin är 0.17.0, teamet kör 0.19.1.
Uppdatera: Customize → Plugins → Glotto assistent → ⋮ → Check for updates → Update."* Skills som bara
läser (`status`, att visa journalen, att visa rapporten) fortsätter efter beskedet. Skills som
skriver (`skapa`, `plocka-ut`, `publicera`, `utdata`, `team`, att skriva i journalen, att ta fram en ny rapport)
**stannar** tills pluginet är uppdaterat - en gammal version följer gamla regler
och skriver ändå till samma wiki som alla andra.

Märker du att en instruktion här inte stämmer med hur mapparna faktiskt ser
ut - säg det till användaren i stället för att gissa. Det är nästan alltid en
ominstallation som saknas.

## Ett dokument per förfrågan

**Skapa aldrig fler dokument än det användaren bad om.** Ingen `README.md`
bredvid, ingen `Sammanfattning.md`, inget index, ingen "relaterade
anteckningar"-fil. En wiki dör inte av dåliga dokument utan av för många.

Bad användaren om en SWOT blir det en fil. Vill du föreslå något ytterligare -
fråga, skapa inte.

Undantaget är källmaterial som sparas i `indata/`, se nästa avsnitt.

## Företagets delade enheter

Teamets gemensamma filer i Google Drive ligger i **delade enheter**, gärna en
per projekt eller verksamhet. Alla delade enheter kontot når söks - inte någons
Min enhet och inte "Delas med mig". Vilka enheter som finns avgörs i Drive,
inte här.

- **Känn igen dem på ägaren.** Filer i en delad enhet saknar personlig ägare
  (`owner`). En träff med ägare ligger någon annanstans och används inte.
- **Enheterna går inte att se på namn** genom kopplingen - de känns igen på sitt
  id och sitt innehåll. Hör uppgiften tydligt till ett projekt, håll dig till
  den enhet vars innehåll hör dit.
- **Sök** med fritext (`fullText contains`) och gå igenom mappar med
  `parentId`; undermappar hämtas en nivå i taget.
- **Läs** med `read_file_content`. Det som används sparas i `indata/` som text,
  med filens länk överst. Originalfilen hämtas inte - den finns kvar i Drive.
- Är Drive inte kopplat, hoppa över steget.

## Webbkällor

Om och när webben behövs avgör du - typiskt när det egna materialet är gammalt
eller frågan gäller nuläge eller framtid. Det från webben som används sparas i
`indata/`, så att det inte behöver letas upp igen. Indata är en råmapp: form,
filnamn och placering är fria.

## Var nya dokument föds

Allt nytt föds i **verkstaden**, aldrig direkt i den delade wikin. Ett
nyproducerat dokument är ett utkast tills en människa läst det - särskilt när
det är sammanställt av en språkmodell. Först `publicera` gör det till teamets
kunskap.

Det betyder att `source`-länken till `indata/` visas obruten medan dokumentet
ligger i verkstaden, eftersom målet ligger i den andra vaulten. Den blir
klickbar vid publicering. Väntat, påpeka det inte.

## Struktur

Det finns inget mallkoncept. Inga mallfiler, och inga tidigare dokument som
förebild för formen - inte ens det senaste dokumentet av samma typ. Varje
dokument byggs utifrån sin egen förfrågan och sitt eget underlag.

Befintliga dokument läses för sitt innehåll, aldrig för sina rubriker eller
sin ordning. Erbjud inte heller att spara ett dokument som mall.

Formen är alltid ren, välformaterad markdown. Aldrig formgivning - det
designade materialet görs i `utdata/`.

## Journal

Journalen är systemets minne av vem som gjorde vad, och när. Den läses av
människor ibland och av rapporter alltid.

```
Teammapp/journal/
  2026-09-anna.md
  2026-09-johan.md
```

**En fil per användare och månad**, och varje fil skrivs bara av sin ägare.
Dropbox tål inte att två personer lägger till rader i samma fil samtidigt - det
ger konfliktkopior. Rapporter läser alla journalfiler och sorterar på tid.

Mappen rymmer också teamrapporten, `journal/rapport.md` - se skillen `rapport`.
Den är ingen journalfil och läses inte som en.

**En rad per händelse**, skriven med `journalfor()`:

```
- 2026-09-23T10:14 | publicerade | SWOT Exempel | ny, tilldelad johan
- 2026-09-23T11:02 | friktion | publicera | frågade om tilldelning utan skäl
```

Tid, handling, dokument, detalj. Dokumentnamn skrivs som **ren text**, aldrig
som wikilänk - dokument kan döpas om eller arkiveras, och då blir en länk
obruten. Användaren framgår av filnamnet.

**Fasta handlingsord**, så att rapporter kan räkna på dem:

| Handling | När | Detalj |
|---|---|---|
| `skapade` | nytt utkast i verkstaden | dokumenttyp |
| `plockade ut` | dokument hämtat ur wikin | - |
| `tog över lås` | utplockning från någon annan | från vem |
| `publicerade` | dokument upplagt i wikin | ny / återlämning / uppskrivning, och tilldelning |
| `skapade utdata` | material i `utdata/` | vilka wikidokument det bygger på |
| `kastade` | ett utkast eller en utdatafil flyttad till `.papperskorg` | utkast / utdata |
| `döpte om` | ett dokument har fått nytt namn - dokument = det nya namnet | från <gammalt namn> |
| `friktion` | något i systemet skavde | vad, konkret |
| `anteckning` | användaren bad om en notering | texten |
| `rekommenderar` | Claude föreslår något till en kommande rapport | förslaget, kort |

**`kastade` och `döpte om` gäller själva dokumentet.** Ber användaren dig kasta
ett utkast eller en utdatafil, eller döpa om ett dokument, skriv raden. När
`publicera` flyttar bort arbetskopian efter publicering är det inte `kastade` -
dokumentet lever vidare i wikin. Utan de här raderna tror rapporten att ett
kastat utkast fortfarande ligger i verkstaden.

**Journalraden skrivs i samma körning som ändringen, efter att verifieringen
lyckats.** Misslyckades ändringen skrivs ingen rad - journalen beskriver det
som hände, inte det som försöktes.

**Du är en av teammedlemmarna.** Märker du friktion i systemet - en
instruktion som inte stämmer med mapparna, ett steg som krånglar, något som
fick rättas i efterhand - skriv en `friktion`-rad, precis som användaren skulle,
och lyft det kort för användaren. Kort och konkret, med skillens namn som
dokument.

**Rekommendationer** skrivs när användaren ber att något ska tas upp i en
kommande rapport, eller när Claude själv har ett förslag om systemet som inte
hör hemma i stunden. Rapporterna samlar dem under rubriken *Claude
rekommenderar*.

`journal/` är exkluderad ur vaulten. Journalen redigeras aldrig i efterhand -
en felaktig rad rättas med en ny rad, inte genom att ändra den gamla.

## Arbetsdelning

- **Delad wiki** - systemets sanning. Allt publicerat bor här och syns för alla.
- **Verkstad** - pågående arbete. Innehållet är användarens eget, men *vad* som ligger där syns för teamet i rapporten.
- **indata** - råmaterial i valfri form, delat. Läses, skrivs aldrig över.
- **utdata** - designat, färdigt material. Personligt, delas aldrig automatiskt.
- **arkiv** - ersatta dokument, delat. Exkluderat ur vaulten men nåbart via länk.
- **journal** - vem som gjorde vad och när, en fil per användare och månad, plus teamrapporten. Exkluderat.

## Numrerade listor

Visade en skill en numrerad lista tidigare i konversationen gäller numren
resten av konversationen. Refererar användaren till ett nummer - "plocka ut
trea", "gör utdata av nummer 5" - slå upp det i den senaste listan i stället
för att fråga om filnamn.

Finns ingen lista i konversationen och användaren anger ett nummer, visa
listan först och be om bekräftelse innan du agerar.

## Regler

- Skriv aldrig i någon annans `utdata/`.
- Flytta aldrig ett dokument ur den delade wikin utan att lämna kvar den
  senaste versionen där.
- Radera aldrig filer på användarens dator - det kräver ett godkännande som
  Cowork inte låter någon stänga av. Använd `kasta()`, som flyttar filen till
  `.papperskorg/` i projektmappen. Obsidian visar inte punktmappar; användaren
  tömmer den själv när det passar. Gäller det en fil utanför projektmappen,
  flytta den till en undermapp och berätta var den hamnade.
- Rapportera på svenska, kortfattat, i prosa.
