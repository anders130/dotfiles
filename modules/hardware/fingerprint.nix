{
    den.aspects.fprint = {
        nixos.services.fprintd.enable = true;

        readme.sections = [
            {
                title = "Setup Fingerprint Reader";
                content = ''
                    Check the reader is detected, then enroll and verify:

                    ```bash
                    fprintd-list <username>
                    fprintd-enroll
                    fprintd-verify
                    ```
                '';
            }
        ];
    };
}
