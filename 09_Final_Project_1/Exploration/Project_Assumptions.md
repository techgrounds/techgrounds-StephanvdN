# List of Assumptions

- We were asked if the project could have 1 resource group and the choice was left to us.
- The region in which the project can be placed depends on the distance, which means that the nearest locations can be chosen: In this case this is **The Netherlands (Europe - West)**
- The size of the VMs is not immediately clear, it is preferable to go for the cheapest option.
- Storage can be more expensive, but may be stored on LRS during the development period.
- IP address of admin access is not yet known. We'll use a placeholder IP for now.
- It is not yet entirely clear to me what exactly needs to be done with the PostDeploymentsScripts. The Blob Storage seems like the place for this, but which tier is unclear. In the Product owner meeting the answer seemed to be that the file can be stored for a longer period of time, but in the scrum master meeting it seemed that the hot tier was the best place to store it.