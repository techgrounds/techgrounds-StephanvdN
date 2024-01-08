# Azure Files,App Service, CDN,DNS & SQL

## Key-terms
---
## Opdrachten
>Doe praktische ervaring op met:
>- Azure Files
>- SQL Databases in Azure
>- Azure App Service
>
>Doe theoretische kennis op van:
>- Azure CDN
>- Azure DNS
---

## Bestudeer
---

### Bronnen
[Adam Marczak - Azure for Everyone](https://www.youtube.com/watch?v=BCzeb0IAy2k) - Azure Files Tutorial | Easy file shares in the cloud

[Adam Marczak - Azure for Everyone](https://www.youtube.com/watch?v=BgvEOkcR0Wk) - Azure SQL Database Tutorial | Relational databases in Azure

[Adam Marczak - Azure for Everyone](https://www.youtube.com/watch?v=4BwyqmRTrx8) - Azure App Service (Web Apps) Tutorial

[John Savill's Technical Training](https://www.youtube.com/watch?v=mtCN5yGwqe0) - Microsoft Azure App Service Environment (ASE) v3 Walkthrough

[A Guide To Cloud](https://www.youtube.com/watch?v=iztes415EF8) - AZ-204 Exam EP 29: Azure CDN

[Adam Marczak - Azure for Everyone](https://www.youtube.com/watch?v=5NMcM4zJPM4&t=790s) - AZ-900 Episode 10 | Networking Services | Virtual Network, VPN Gateway, CDN, Load Balancer, App GW

[IBM Technology](https://www.youtube.com/watch?v=Bsq5cKkS33I) - What is a Content Delivery Network (CDN)?

[Learn.microsoft.com](https://learn.microsoft.com/en-us/azure/cdn/cdn-overview) - What is a content delivery network on Azure?

[John Savill's Technical Training](https://www.youtube.com/watch?v=Hiohn35DIqA) - Understanding DNS in Azure

[CBT Nuggets](https://www.youtube.com/watch?v=fB_Of-Lmrrk) - What Is Azure-hosted DNS?

---

### Ervaren Problemen



---
## Resultaat

### 1. Azure Files

Er is een opslagaccount aangemaakt met daarin een Fileshare genaamd ***demo-share***.
![FileShareDemoStephan](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/FileShareDemoStephan.png)

Om toegang te krijgen tot de Fileshare via mijn VM moet ik deze eerste koppelen. Azure heeft dan een script voor je klaar staan die kan worden gebruikt in de VM.

![VerbindingFileShareLinux](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/VerbindingFileShareLinux.png)

Nadat je de command hebt toegevoegd kan je de fileshare vinden in je VM. Hieronder zie je ***demo-share*** in het groen

![CommandFilesShareLinux](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/CommandFilesShareLinux.png)

Hier is een tekst bestand toegevoegd aan de fileshare.

![CommandFilesShareLinux](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/AanmakenFileLinux.png)

In azure kan je gelijk het bestand vinden in ***demo-share*** 

![CommandFilesShareLinux](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/FileShareLinux.png)

Ik wilde graag ook zien hoe het andersom werkt dus heb ik de map ***test-directory*** gemaakt.

![CommandFilesShareLinux](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/TestDirectoryAzure.png)

Nadat ik de map had aangemaakt in Azure fileshare was het ook gelijk te zien in de VM.

![CommandFilesShareLinux](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/TestDirectoryLinux.png)


### SQL Database

Er is een SQL server en Database aangemaakt met alle eigenschappen op minimaal anders zou het 400 dollar per maand kosten. 

![SQLServerDatabase](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/SQLServerDatabase.png)

Ik heb de SQL server geopend met ***Azure Data Studio***. Ik heb mezelf eerst beheerder moeten maken tot de server en daarnaast heb ik mijn IP moeten opgeven om toegang te krijgen. Bij het aanmaken had ik aangegeven dat er geen internettoegang was tot de server. Verder heb ik geen verstand hoe SQL werkt en heb ik er niet veel mee kunnen doen. 

![AzureDataStudioSQL](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/AzureDataStudioSQL.png)

### Azure App Service

Met deze eigenschappen heb ik een web app gemaakt.

![CreateWebApp](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/CreateWebApp.png)

Hier kan je volgende stap zien hoe het eruit ziet.

![DemosWebApp](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/DemoWebApp.png)

Ik heb geprobeerd via een webtutorial een web app aan te maken maar dat is mijn niet gelukt omdat ik allemaal foutmeldingen te zien kreeg. Dit is het resulaat als je naar de pagina gaat zonder dat er een echte app is. 

![WebappInternet](../00_includes/05_Azure_2/03_Azure_Files%2CApp_Service%2CCDN%2CDNS%2CSQL/WebappInternet.png)

### Azure CDN 

A **content delivery network (CDN)** is a distributed network of servers that can efficiently deliver web content to users. A CDN store cached content on edge servers in point-of-presence (POP) locations that are close to end users, to minimize latency.

Azure CDN offers developers a global solution for rapidly delivering high-bandwidth content to users by caching their content at strategically placed physical nodes across the world. Azure CDN can also accelerate dynamic content, which can't get cached, by using various network optimizations using CDN POPs. For example, route optimization to bypass Border Gateway Protocol (BGP).

The benefits of using Azure CDN to deliver web site assets include:

Better performance and improved user experience for end users, especially when using applications where multiple round-trips requests required by end users to load contents.
Large scaling to better handle instantaneous high loads, such as the start of a product launch event.
Distribution of user requests and serving of content directly from edge servers so that less traffic gets sent to the origin server.

### Azure DNS

Azure DNS is a hosting service for DNS domains that provides name resolution by using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records by using the same credentials, APIs, tools, and billing as your other Azure services.

You can't use Azure DNS to buy a domain name. For an annual fee, you can buy a domain name by using App Service domains or a third-party domain name registrar. Your domains then can be hosted in Azure DNS for record management.