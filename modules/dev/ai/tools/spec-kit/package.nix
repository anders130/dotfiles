{den, ...}: let
    nixWritablePatch = ''
        cat >> src/specify_cli/__init__.py <<'SPECKIT_NIX_WRITABLE'


        def _nix_writable_copies():
            import os, shutil, stat
            def _w(path):
                try:
                    if os.path.isdir(path):
                        for root, ds, fs in os.walk(path):
                            for n in (root, *(os.path.join(root, x) for x in ds + fs)):
                                try:
                                    os.chmod(n, os.stat(n).st_mode | stat.S_IWUSR)
                                except OSError:
                                    pass
                    elif os.path.exists(path):
                        os.chmod(path, os.stat(path).st_mode | stat.S_IWUSR)
                except OSError:
                    pass
            _ct = shutil.copytree
            def ct(src, dst, *a, **k):
                r = _ct(src, dst, *a, **k)
                _w(r or dst)
                return r
            shutil.copytree = ct
            _cp = shutil.copy2
            def cp(src, dst, *a, **k):
                parent = os.path.dirname(os.path.abspath(str(dst))) or "."
                try:
                    os.chmod(parent, os.stat(parent).st_mode | stat.S_IWUSR)
                except OSError:
                    pass
                r = _cp(src, dst, *a, **k)
                _w(str(r) if r else dst)
                return r
            shutil.copy2 = cp


        _nix_writable_copies()
        SPECKIT_NIX_WRITABLE
    '';
    mkPatched = spec-kit-pkg:
        spec-kit-pkg.overrideAttrs (old: {
            postPatch = (old.postPatch or "") + nixWritablePatch;
        });
in {
    perSystem = {inputs', ...}: {
        packages.spec-kit-patched = mkPatched inputs'.llm-agents.packages.spec-kit;
    };

    den.aspects.ai.provides.tools.spec-kit = {
        includes = [den.aspects.ai.provides.skills.spec-kit];
        homeManager = {self', ...}: {
            home.packages = [self'.packages.spec-kit-patched];
        };
    };
}
