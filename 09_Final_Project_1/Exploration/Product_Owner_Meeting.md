# Product Owner Meeting

V = Vraag  
A = Antwoord  




**V: Om wat voor bedrijf gaat het?**  
A: Gaat om een klein administratie bedrijf. Niet belangrijk voor dit project wat ze precies doen. ze hebben een website waar klanten op kunnen inloggen en ze gaan ook overstappen van on premises naar cloud   

**V: Hebben jullie klanten?**  
A: Ja, die moeten via het internet op de website kunnen komen. Untrusted IP’s moet op de website, maar niet op de backend/admin server. Deze klanten zitten voornamelijk in Nederland.  

**V: Waarom willen jullie naar migreren naar de cloud?**
A: vanwege kosten en managment heeft aangegeven dat het moet. Er staan hier veel server die niet worden gebruikt.  

**V: Wat is jullie budget?**  
A: Het budget is het budget van de opleiding (Max 50 euro).  het liefst zou ik willen dat je het hele project binnen een tientje houdt, het development onderdeel.  Uiteindelijk per maand is €150 redelijk als het project draait.

**V: Wil je het project in 1 resource group hebben?**
A: Geen idee, als product owner heb ik geen idee wat een resource group is.Als er geen nadelen om alles is een resource group te doen is dat prima.

**V: (vraag van de product owner aan ons) Is het ook mogelijk om de kosten van de verschillende onderdelen apart te zien als je alles in een resource group hebt?**  
A: Ja, dat kan doormiddel van Tags.

**V: De 2 Vm's gaan in verschillende 2 verschillende availability zones, is er een reden dat dit zo is ontworpen? maakt het uit in welke Regio dit geplaatst wordt?, ik kreeg al de melding dat Sweden Central werd aangeraden vanwege lagere kosten.**  
A: De reden die ik heb gehoord is availability. Liever zo  dichtbij mogelijk. Zweden is het goedkoopst maar het is te ver weg, dus liever duitsland of nederland.  

**V: Is er een specifiek tijdstip dat de backups gemaakt moeten worden?**   
A: Nee, er is geen specifiek tijdstip. Handig als het gebeurt als er niet te veel klanten bezig zijn.  

**V: Is er een voorkeur naar de formaat geheugen van de VM's?**  
A: Architect zegt hoe minder hoe goedkoper, dus zo goedkoop mogelijk.  

**V:  moeten de VM's ten alle tijden actief zijn of op een deel van de dag uitgeschakeld zijn?**  
A: Admin mag in de avond uit, de webserver moet de hele dag aan en toegankelijk voor klanten zijn. Maar dit is geen harde eis, ze mogen ook beide de hele tijd aan staan.  

**V: Zijn er plannen voor disaster recovery?**  
A: Geen plannen voor een hele zone, het is uiteindelijk maar een website, we zijn niet het grootste bedrijf dus er zijn niet veel consequenties als het mis gaat. Teveel plannen is te duur.  

**V: heb je een voorkeur voor lokale redundante opslag of zone-redundante opslag**  
A: Opslag mag wel wat duurder, hele infrastructuur  is wat overdreven. Raadt aan om local redundant te doen tijdens development, mochten we daarna besluiten om iets anders te gebruiken dan kan dat. Het kan daarna nog gewijzigd worden.  

**V: Hoeveel mensen mogen er toegang hebben tot admin/management server, en mag ik daarvan de vertrouwde locatie, en hoeveel locaties?**   
A: Alleen de admin, die is nog niet bij ons in dienst. Dus gebruik je eigen IP adres voorlopig als placeholder.

**V: De postDeploymentScripts moeten in een Storage account, hoe frequent moet je daarbij komen?**   
A: Nee, niet frequent toegang nodig. (moet je googlen als je daar niet veel van af weet, scripts die je runt op een database om  verder te configureren nadat de database software is deployed)  

**V: Bij de keyvault zijn er 2 prijscategorien, de standaard versie en de premium waarbij er ondersteuning is voor HSM Sleutels (hardware security module), welke optie prefereer je**  
A: Dat ligt er aan hoe duur de premium is, in principe hebben we geen hsm sleutels nodig. Dit is geen hard requirement vanuit security, dus je moet een goed argument hebben om dit wel te doen.  

**V: Zijn er intern nog bepaalde regels waar wij ons aan moeten houden met betrekking tot veiligheid, zoals het beperken tot bepaalde regio’s of bepaalde data die alleen lokaal mag worden opgeslagen?**  
A: Niet dingen die ik niet al heb genoemd. Voor zover ik me dat op dit moment kan bedenken.  

**V: Hoe ziet jullie IT afdeling eruit? Hebben jullie werknemers die in staat zijn om de servers bij te houden?**  
A: Ja, we hebben de admin zodra hij in dienst is. Dat is “”De IT-er”  

***Advice:*** Hou je aan best practices, tradeoffs tussen kosten en ?

De requirements in het document zijn hard requirements, en alles wat je kan verbeteren qua kosten is mooi meegenomen.

***Additional Information Meeting Scrummaster***
- RPO van 1 uur en RTO van 24 uur.
- Certificaat SSL regelen
- In de toekomst komen er workstations bij maar daar moet voor nu geen rekening mee worden gehouden.
- Bij de webserver maakt niet uit of het met Linux of Windows is.
- De Adminserver moet in Windows
- Geen interesse in support plans
- SQL server & Blob storage (Hot storage) deployment scripts.



    
   