inputs: {
    hostName = "ds1";
    username = "admin";
    hashedPassword = "$y$j9T$pfXfRHPB737a3VIp3yZcF.$/fYZJOZhmXeslp.jMSEwJUHpXZS11x49yUWl.XgeEN9";
    isThinClient = true;
    modules = [
        inputs.disko.nixosModules.disko
    ];
}
