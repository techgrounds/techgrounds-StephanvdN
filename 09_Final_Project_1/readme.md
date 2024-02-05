# Eind Project Techgrounds Gebruiksaanwijzing

### Overzicht 

Welkom bij onze cloudmigratiehandleiding, waarin we de stappen en het proces beschrijven voor het migreren van uw bestaande on-premises infrastructuur naar de Microsoft Azure-cloudomgeving met behulp van Bicep. Deze handleiding is bedoeld om u te begeleiden bij elke fase van de migratie en om een dieper inzicht te bieden in de voordelen van het gebruik van Azure en Infrastructure as Code (IaC).
     

### Waarom Azure?

Azure biedt een uitgebreid en schaalbaar cloudplatform dat perfect geschikt is voor het hosten van verschillende soorten workloads, van kleine toepassingen tot grootschalige bedrijfsoplossingen. Door te migreren naar Azure, profiteert u van schaalbaarheid, flexibiliteit en geavanceerde services die uw bedrijf naar een hoger niveau tillen.


### **Voordelen van Bicep**
Bicep is een domeinspecifieke taal (DSL) die speciaal is ontworpen voor het definiëren van Azure-resources. Het biedt een eenvoudigere, meer leesbare en schaalbare manier om uw infrastructuur te beschrijven in vergelijking met traditionele ARM-templates. Met Bicep kunnen we de infrastructuurconfiguratie vereenvoudigen, herbruikbaar maken en onderhoudsvriendelijker maken.

---

## Vereisten

- Een Azure account

- Azure CLI

- Github repository

- Mac Terminal

## Code van Github halen

- Clone de GitHub-repository naar je lokale machine met behulp van het volgende commando in de terminal:

         git clone <repository-url>

- Navigeer naar de gekloonde repository:  
  
        cd <repository-directory>


## Azure CLI installeren en opstarten

Met de Azure-opdrachtregelinterface (CLI) kunt u opdrachten uitvoeren via een terminal met behulp van interactieve opdrachtregelprompts of een script. Homebrew is de eenvoudigste manier om de CLI-installatie te beheren. Het biedt handige manieren om te installeren, bij te werken en te verwijderen.  Als uw systeem niet beschikt over Homebrew, [installeert u Homebrew](https://docs.brew.sh/Installation.html) voordat u doorgaat.

- Update uw Homebrew en installeer Azure CLI met de volgende commando in de terminal:
  
        brew update && brew install azure-cli  

- Zorg ervoor dat je bent ingelogd bij Azure CLI:

        az login

De Azure CLI opent uw standaardbrowser waarbij u zich kan inloggen bij een Azure-aanmeldingspagina met uw accountreferenties.

## Code implementeren Azure

Een resourcegroep is een container met verwante resources voor een Azure-oplossing. De resourcegroep kan alle resources voor de oplossing bevatten of enkel de resources die u als groep wilt beheren. De resourcegroep slaat metagegevens op over de resources. Als u een locatie voor de resourcegroep opgeeft, geeft u op waar deze metagegevens worden opgeslagen. In verband met nalevingsvereisten moet u er mogelijk voor zorgen dat uw gegevens worden opgeslagen in een bepaalde regio.

- Gebruik de onderstaande command om een resourcegroup aan te maken en de locatie aan te geven:

        az group create --name demoResourceGroup --location westeurope


- Implementeer de code naar de Azure Portal: 

        az deployment group create --resource-group demoResourceGroup --template-file main.bicep

De terminal zal u vervolgens vragen om een gebruikersnaam en wachtwoord op te geven voor uw Managementserver. 




 

