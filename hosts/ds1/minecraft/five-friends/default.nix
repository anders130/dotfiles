{pkgs, ...}: let
    inherit (pkgs) fetchurl;
    mods = [
        (fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/rhkWp6Ar/fabric-api-0.137.0%2B1.21.10.jar";
            sha512 = "1cdae28a1988ace43200ecf2aed07d5665871561518d38cbd7371a4a14c5606ee59584cc7392d07320ffc76b95404e50fcab6c1c016bef8cf023a7e039314f4e";
        })
        (fetchurl {
            url = "https://cdn.modrinth.com/data/a4byiEVJ/versions/S9WW09Dr/shulker-box-labels-3.4.1%2B1.21.10-fabric.jar";
            sha512 = "4c2438df6e9946f451f68ec39d115bbad3d74dc3cd684fd34567d36b8a08cb7a4b1bc7c51e13d9b0d10b5b64a7951722bc3a86b215885310ba87824401c5c170";
        })
        (fetchurl {
            url = "https://cdn.modrinth.com/data/uCdwusMi/versions/9Y10ZuWP/DistantHorizons-2.3.6-b-1.21.10-fabric-neoforge.jar";
            sha512 = "1b1b70b7ec6290d152a5f9fa3f2e68ea7895f407c561b56e91aba3fdadef277cd259879676198d6481dcc76a226ff1aa857c01ae9c41be3e963b59546074a1fc";
        })
        (fetchurl {
            url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/8sbiz1lS/appleskin-fabric-mc1.21.9-3.0.7.jar";
            sha512 = "79d0d0b4a09140cdb7cf74b1cd71554147c60648beb485ca647b149174e171660ec561ad329da58b78b5de439909b180e287b4b38bf068acfca20666100f4584";
        })
        (fetchurl {
            url = "https://cdn.modrinth.com/data/JrvR9OHr/versions/qeyO89wf/doubledoors-1.21.10-7.2.jar";
            sha512 = "f60b51dca1388bbe773381155c8ab14e345d69573956425e9cc54b3adfb2036a94422adbdc54933db7ff7b58ef9bfe626442821894266d37463eca231e90ef23";
        })
        (fetchurl {
            url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/A0CFMmGr/collective-1.21.10-8.13.jar";
            sha512 = "01544f5e3c85ab98c688b50de3f1fcb90204de4dbe65972d27ee3af0dd8dd6ba7624eeebb030553746ff927169a06874050364c35eab505edd0a0a8baa07e139";
        })
    ];
in {
    modules.services.minecraft.servers.five-friends = {
        inherit mods;
        version = "1.21.10";
        type = "fabric";
        onlyFriends = true;
        rcon.enable = true;
        motd = "🧱 5 Freunde – 1 Abenteuer. Bist du dabei?";
        server-icon = ./server-icon.png;
        serverProperties = {
            gamemode = "survival";
            difficulty = "hard";
        };
    };
}
