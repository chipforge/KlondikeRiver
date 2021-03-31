# KlondikeRiver

In a fine tradition, projects for testing new technologies have River names.
So this test die for MTBF statistics [0] about our StdCellLib is called 'KlondikeRiver'. 

The test die is fully packed with DfT measures [1] and permanently calculates SHA256 Hashes on the bare maximum Clock Rate. Operation generates a lot of heat and the silicon is aging therefore. Once a failure happens, thanks to the Avalanche effect in cryptography [2], this failure can be immediatly detected by the test-bed controller.

The controller is able to locate and investigate the failure based on the additional DfT ciruitry and switch off the defect hashing engine.
Our Statistics can be fed by the the life time of any hashing engine on the die (under dedicated enviromental conditions like temperature, humidity etc.) 'till all engines are dead.


[0] https://en.wikipedia.org/wiki/Mean_time_between_failures
[1] https://en.wikipedia.org/wiki/Design_for_testing
[2] https://en.wikipedia.org/wiki/Avalanche_effect
