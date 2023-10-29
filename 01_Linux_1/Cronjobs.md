
# Cronjobs

## Key-terms
- Cron Tab
  
---
## Opdrachten
>In deze opdracht maken we een script aan waarbij de tijd en datum in een apart bestand verschijnt. We maken een script met behulp van een crontab die dat elke minuut voor ons doet. Er zal ook een script worden gemaakt die elke week de beschikbare schijf ruimte laat zien in ***/var/log/opdracht.log***s

### Bronnen
[Cyberciti.biz](https://www.cyberciti.biz/faq/linux-display-date-and-time/
)

[Learn Linux TV](https://www.youtube.com/watch?v=7cbP7fzn0D8)


[Crontab.guru](https://crontab.guru/#1-59_*_*_*_*)

[Akamai Developer](https://www.youtube.com/watch?v=SRtMO-R7dJw)

![crontab](/00_includes/01_Linux_1/Bash%20Scripts/blog-head_syntax-of-cron.webp)
![croncheatsheet](../00_includes/01_Linux_1/Bash%20Scripts/Cron%20cheatsheet%20for%20Linux.jpeg)


[Akamai Developer](https://www.youtube.com/watch?v=SRtMO-R7dJw)

---

### Ervaren Problemen

Op het moment dat ik een script had geschreven om de tijd en datum in een bestand te plaatsen gebruikte, heb ik het bestand gestart in plaats van dat ik de inhoud liet zien met de ***cat command***

---
### Resultaat

Er is een script geschreven waarbij de datum en tijd wordt geplaatst in een ander bestand. 
![afbeeldingScriptDateTime](../00_includes/01_Linux_1/Bash%20Scripts/ScriptDateTime.png)

Hier is het resultaat 
![afbeeldingDateTimeResult](../00_includes/01_Linux_1/Bash%20Scripts/DateTimeResult.png)

Er is nu een crontab aangemaakt waarbij er elke minuut de tijd bijgeschreven wordt in het bestand ***receivecronjob.txt***
![afbeeldingCrontab](../00_includes/01_Linux_1/Bash%20Scripts/Crontab.png)

Hier is het resultaat
![afebeeldingResultCrontab](../00_includes/01_Linux_1/Bash%20Scripts/CrontabResult.png)

Er is nu een script aangemaakt om te laten zien wat de beschikbare schijf ruimte is en de informatie te plaatsen in /var/log/opdracht.log
![afbeeldingScriptDiskSpace](../00_includes/01_Linux_1/Bash%20Scripts/LogDiskScript.png)

En met deze crontab zal dat elke week gebeuren.
![afbeelingCrontabDiskSpace](../00_includes/01_Linux_1/Bash%20Scripts/CrontabLogDisk.png)