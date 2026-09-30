# Glotto-assistent

Kunskapssystem för team enligt indata/wiki/utdata-modellen.

## Vad det gör

En delad wiki i Dropbox är systemets sanning. Varje användare har en lokal
arbetsyta för pågående arbete och en personlig mapp för färdigt material.
Pluginet sköter förflyttningarna mellan dem.

## Skills

| Skill | Gör |
|---|---|
| `skapa` | Tar fram ett nytt kunskapsdokument ur wiki, indata, delade enheter i Drive och webben |
| `status` | Läget plus numrerad lista över wikins dokument |
| `plocka-ut` | Reserverar ett delat dokument för redigering |
| `publicera` | Lägger upp arbete i den delade wikin - nytt eller återlämnat |
| `utdata` | Producerar designat material ur wikidokument |
| `journal` | Vem som gjort vad och när, plus noteringar om friktion |
| `team` | Lägger till och tar bort medlemmar, sätter upp ett nytt team |
| `rapport` | Teamrapporten: en tabell per användare - vad hen rört, var det ligger nu, vem som har bollen |

Gemensamma regler ligger i `GLOTTO.md` och läses av varje skill.

## Installation

Se repots README: administratören säger *"lägg till <namn> i teamet"*, och den
nya kör installationsskriptet `installation/installera.ps1` och installerar
pluginet. Allt teamspecifikt står i teamfilen `.glotto/team.json` i teammappen.

## Mappstruktur

```
<delad mapp>/   wiki/  indata/  arkiv/  journal/  .glotto/team.json   <- vault
<lokal mapp>/   verkstad/  utdata/  .glotto/          <- vault
```

## Status: fas 1

Manuell grund. Utcheckningslåset är i denna version en konvention som
skillsen följer, inte en spärr - två användare som känner till varandras
arbete klarar sig, men systemet är inte säkert förrän fas 2:s hooks finns.
