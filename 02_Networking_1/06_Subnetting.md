# Subnetting

## Key-terms
- Subnet mask
- Prefix
- CIDR notation (Classless Intern Domain Routing)
---
## Opdrachten
>Er moet een netwerkarchitectuur worden gemaakt met de volgende eisen.
>1. subnet dat alleen van binnen het LAN bereikbaar is. Dit subnet moet minimaal 15 hosts kunnen plaatsen.
>2. subnet dat internet toegang heeft via een router met NAT-functionaliteit. Dit subnet moet minimaal 30 hosts kunnen plaatsen (de 30 hosts is exclusief de router).
>3. subnet met een network gateway naar het internet. Dit subnet moet minimaal 5 hosts kunnen plaatsen (de 5 hosts is exclusief de internet gateway).

---

### Bronnen


[NetworkChuck](https://www.youtube.com/watch?v=OD2vG5st4zI)

[SunnyClassroom](https://www.youtube.com/watch?v=ecCuyq-Wprc)

![afbeeldingSubnetTabel](../00_includes/02_Cloud_1/06_Subnetting/Subnet%20Table.webp)

![AfbeeldingSubnetTabel1](../00_includes/02_Cloud_1/06_Subnetting/subnet%20table%201.webp)



---

### Ervaren Problemen

Er zijn geen problemen geweest bij dit onderdeel.

---
### Resultaat

Voor de opdracht moesten er 3 subnets worden aangemaakt. In mijn bron werd verteld dat je het best kan beginnen met de grootste groep en dat was groep met internettoegang dat moest bestaan uit 30 Hosts + router. De volgende groep was de LAN groep dat moest bestaan uit minimaal 15 Hosts. En de Gateway moest bestaan uit 5 Hosts + de internet Gatway.

Met het tabel uit de bron zien we hoe we te werk moeten gaan. In de tabel zie je 1, 2, 4, 8, 16 en enz. subnets staan. Aangezien wij er 3 willen moeten we voor 4 kiezen. als we voor 4 subnets hebben gekozen heeft elke subnet ruimte voor 64 hosts en subnet mask van

![afbeeldingSubnetting](../00_includes/02_Cloud_1/06_Subnetting/Subnet%20Opdracht%20Sunny.png)