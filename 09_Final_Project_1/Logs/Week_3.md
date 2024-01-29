# Log [22-01-2024]


## Dagverslag (1 zin)

Vandaag webserver gedeployed en nu bezig met managementserver


## Obstakels
ik moet een wachtwoord opgeven voor de management server ander kan het niet worden gedeployed. ik heb voor nu een hardcoded wachtwoord


## Oplossingen

Morgen ga ik aan Casper vragen of het wachtwoord in de key vault moet 


## Learnings


---
# Log [23-01-2024]


## Dagverslag (1 zin)

vandaag begin ik aan de storage onderdeel


## Obstakels


## Oplossingen


## Learnings


---
# Log [24-01-2024]


## Dagverslag (1 zin)

ik begreep niet waarom ik zelf geen toegang had tot de blob. Van alles gedaan en op een gegeven moment is het gelukt maar weet niet precies hoe.

ik kon niet inloggen op de Windows VM en snapte niet waarom

## Obstakels


## Oplossingen

ik had de  blob aangepast naar 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01'  en dit toegevoegd 

NetworkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
 
 wat ik wel apart vind want ik had het in de eerste instantie ook staan maar toen werkt het niet

 Ik had bij de windows VM de poort 3889 open gezet in plaast van 3389. ik kan er nu wel in.

## Learnings


---
# Log [25-01-2024]


## Dagverslag (1 zin)

vandaag was ik de hele dag bezig met de keyvault, heb de gebruikersnaam en wachtwoord in de keyvault gekregen


## Obstakels


## Oplossingen


## Learnings


---
# Log [26-01-2024]


## Dagverslag (1 zin)

vandaag was een slechte dag, weinig concentratie omdat er bij teveel gebeurde buiten les om


## Obstakels


## Oplossingen


## Learnings


---