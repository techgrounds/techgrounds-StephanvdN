# Bash Scripts

## Key-terms
- Bash Shell
- Bash Script
- Path variable
  
---
## Opdrachten
>Er moet een directory worden aangemaakt me de naam *scripts* 
>
>er moet een script worden aangemaakt die steeds een lijn tekst toevoegd wanneer het bestand is (X) executed
>
>er moet een script worden aangemaakt dat een hhtpd package installeert, activeert en de status print in de terminal
>
>er moet ene script worden aangemaakt die een willekeurig nummer tussen 1 en 10 kiest en toevoegt aan een tekst bestand
>
> er moet ene script worden aangemaakt die een willekeurig nummer tussen 1 en 10 kiest en aan een bestand toevoegt als het nummer hoger is dan 5, en als het lager is aangeeft dat het getal lager is dan 5
---
### Bronnen

[Learn Linux TV](https://www.youtube.com/watch?v=boqC9QenshY&list=PLT98CRl2KxKGj-VKtApD8-zCqSaN2mD4w&index=2
)

[Akamai Developer](https://www.youtube.com/watch?v=1CDxpAzvLKY) 


[Networking with Rich](https://www.youtube.com/watch?v=24wyjUK84XU)

[Geeksforgeeks.org](https://www.geeksforgeeks.org/random-shell-variable-in-linux-with-examples/)

[Ryanstutorials.net](https://ryanstutorials.net/bash-scripting-tutorial/bash-if-statements.php)

[Tecadmin.net](https://tecadmin.net/bash-greater-than-operator/#google_vignette)

---

### Ervaren Problemen

Mijn connectie met de VM verbrak en ik kon er zelf niet meer in waardoor ik tijdelijk in de VM van Thomas heb gewerkt. Shikha heeft de connectie hersteld.

---
### Resultaat

De *scripts* directory is toegevoegd aan de PATH variable
![afbeeldingAddScriptToPATH](../00_includes/01_Linux_1/Bash%20Scripts/AddScriptToPATHVariable.png)

Er is een script geschreven waarbij er steeds een stuk tekst aan het bestand wordt toegevoegd.
![afbeelingAppendLineToText](../00_includes/01_Linux_1/Bash%20Scripts/AppendLineToTextFile.png)

Er is een script aangemaakt om apache2 te installeren,activeren, aan te zetten als dat nog niet is gedaan en de status daarvan te chechen.
![afbeeldingApache2Script](../00_includes/01_Linux_1/Bash%20Scripts/ScriptApache2.png)

Hier is deel 1 van het uitvoeren van het script.
![afbeeldingRunApacheScript](../00_includes/01_Linux_1/Bash%20Scripts/RunApacheScriptPart1.png)

Hier is deel 2 van het uitvoeren van het script 
![afbeeldingRunApacheScript2](../00_includes/01_Linux_1/Bash%20Scripts/RunApacheScriptPart2.png)

Er is nu een script geschreven om een willekeurige nummer te kiezen tussen 1 - 10  en de output in het bestand *receivenumber.txt te zetten
![afbeeldingGenarateNumberScript](../00_includes/01_Linux_1/Bash%20Scripts/GenerateNumberScript.png)

Hier is het vervolg op het script. Het script is in totaal 5 keer uitgevoerd en er zijn 5 willekeurige getallen verschenen *receivenumber.txt*
![afbeeldingGeneratedNumber](../00_includes/01_Linux_1/Bash%20Scripts/GenerateRandomNumberOutput.png)

Met deze script zorg ik ervoor dat elk nummer boven de 5 in het bestand *receivenumber.txt* verschijnt en dat wanneer het 5 of lager zou zijn dat de tekst "the number is 5 or smaller" verschijnt
![afbeeldingScriptNumberOrText](../00_includes/01_Linux_1/Bash%20Scripts/ScriptGenerateNumberOrText.png)

hier zie je het resultaat van het script
![afbeeldingGeneratedNumberOrText](../00_includes/01_Linux_1/Bash%20Scripts/GeneratedNumberOrText.png)