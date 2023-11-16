

# Detection, Response & Analysis

## Key-terms
- Malware
- Intrusion Detection systems (IDS)
- Intrusion Prevention systems (IPS)     
- Recovery Point Objective (RPO)
- Recovery Time Objective (RTO)  
- System Hardening
                
---
## Opdrachten
>Zie Resultaat
---

### Bronnen

[CBT Nuggets](https://www.youtube.com/watch?v=rvKQtRklwQ4)

[WithSecure](https://www.youtube.com/watch?v=eeQ2WpdvG0g)

[Professor Messer](https://www.youtube.com/watch?v=YSwTfealIV4)

[Eye on Tech](https://www.youtube.com/watch?v=Ipf3nXsgC3M)

[Professor Messer](https://www.youtube.com/watch?v=uN-EKn5AHd8)

---

### Ervaren Problemen

---
### Resultaat

Opdracht 1
- A Company makes daily backups of their database. The database is automatically recovered when a failure happens using the most recent available backup. The recovery happens on a different physical machine than the original database, and the entire process takes about 15 minutes. What is the RPO of the database?

De (RPO) is een maatstaf voor hoeveel gegevensverlies een organisatie kan tolereren in geval van een storing of ramp. Het vertegenwoordigt de maximaal toegestane tijd tussen de laatst beschikbare back-up en het tijdstip van de storing. In dit geval, aangezien het bedrijf dagelijkse back-ups maakt, is de RPO één dag.


Opdracht 2
- An automatic failover to a backup web server has been configured for a website. Because the backup has to be powered on first and has to pull the newest version of the website from GitHub, the process takes about 8 minutes. What is the RTO of the website?

De (RTO) is een maatstaf voor de maximaal aanvaardbare downtime voor een systeem of dienst nadat er een storing of ramp heeft plaatsgevonden. Het vertegenwoordigt de tijd waarbinnen een systeem of dienst weer in zijn normale werking moet worden hersteld. In dit scenario, aangezien het automatische failover-proces voor de website ongeveer 8 minuten in beslag neemt, is de RTO voor de website ongeveer 8 minuten.