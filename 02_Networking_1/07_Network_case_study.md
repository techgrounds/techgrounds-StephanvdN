# Networking Case Study


## Opdrachten

>De opdracht is om de netwerk architectuur te maken voor een klein e-commerce bedrijf. Ze hebben aangegeven dat netwerk veiligheid heel belangrijk voor hen is.
>
>De architectuur moet het volgende bevatten
>- Een webserver waar de webshop op wordt gehost.
>- Een database met inloggegevens van de gebruikers voor de webshop.
>- 5 werkstations voor de werknemers
>- Een printer
>- Een AD server
>- Een server met interne documenten 

### Bronnen

[SecureState](https://www.youtube.com/watch?v=oopkClg1kxM)

---

### Ervaren Problemen
Er zijn geen problemen geweest bij dit onderdeel.


---
### Resultaat

Er is een netwerk architectuur aangemaakt. Via een modem krijgen we internetverkeer binnen. Dan is er gekozen om een firewall te gebruiken om onbevoegde en kwaadwillende mensen buiten te houden. Na de externe firewall komt de router en die zorgt dat de informatie bij de juiste afdeling komt. Er zijn na de router 2 zones gecreëerd. Een server zone en een werknemer zone. 
- De server zone wordt beschermd door een firewall aangezien het bedrijf heel graag wilt dat het netwerk veilig is en daarom is de vertrouwelijk informatie meer beschermt en heeft niet iedereen in het bedrijf toegang tot deze gegevens. En er is gebruikt gemaakt van een switch waarbij gegevenspakketen  naar je juiste apparaten worden gestuurd en vice versa.
- De werknemer zone maakt ook gebruik van een switch. De gegevens pakketen naar de juiste apparaten worden gestuurd en niet naar allemaal. De workstation kunnen met elkaar comminiceren en gebruik maken van de printer. Hier is ook de server te vinden waar de werknemers interne documenten kunnen opslaan en bekijken.


![afbeeldingNetwerkArchitectuur](../00_includes/02_Cloud_1/07_Network_case_study/Netwerk%20Architectuur.png)