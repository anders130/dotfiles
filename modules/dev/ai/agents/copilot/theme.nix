{
    den.aspects.ai.provides.agents.github-copilot.homeManager = {
        config,
        lib,
        pkgs,
        ...
    }: let
        inherit (lib) concatMapStringsSep genList toHexString;

        palette = concatMapStringsSep "," (i: "#${config.lib.stylix.colors."base0${toHexString i}"}") (genList (i: i) 16);

        filter = pkgs.writeText "copilot-term-filter.py"
        #python
        ''
            import os, sys, pty, select, re, fcntl, termios, signal, tty
            c = sys.argv[1:]
            if not (sys.stdin.isatty() and sys.stdout.isatty()): os.execvp(c[0], c)
            P = [(int(h[:2], 16), int(h[2:4], 16), int(h[4:], 16)) for h in (x.strip().lstrip("#") for x in os.environ.get("COPILOT_THEME_PALETTE", "").split(",")) if len(h) == 6]
            def near(r, g, b):
                m = max(r, g, b); s = 0 if m == 0 else (m - min(r, g, b)) / m
                q = P if s >= 0.2 else P[:6]
                return min(q, key=lambda p: (p[0] - r) ** 2 + (p[1] - g) ** 2 + (p[2] - b) ** 2)
            def cube(n):
                if n < 232:
                    n -= 16; f = lambda v: 0 if v == 0 else 55 + 40 * v
                    return (f(n // 36), f(n // 6 % 6), f(n % 6))
                return (8 + 10 * (n - 232),) * 3
            def sgr(m):
                t = m.group(1).split(b";"); o = []; i = 0
                while i < len(t):
                    if t[i] in (b"38", b"48") and i + 4 < len(t) and t[i + 1] == b"2":
                        o += [t[i], b"2", *(b"%d" % v for v in near(int(t[i + 2] or 0), int(t[i + 3] or 0), int(t[i + 4] or 0)))]; i += 5
                    elif t[i] in (b"38", b"48") and i + 2 < len(t) and t[i + 1] == b"5" and int(t[i + 2] or 0) >= 16:
                        o += [t[i], b"2", *(b"%d" % v for v in near(*cube(int(t[i + 2]))))]; i += 3
                    else: o.append(t[i]); i += 1
                return b"\x1b[" + b";".join(o) + b"m"
            B = re.compile(rb"\x1b\]11;[^\x07\x1b]*(?:\x07|\x1b\\)"); S = re.compile(rb"\x1b\[([0-9;]*)m")
            def scrub(d): d = B.sub(b"", d); return S.sub(sgr, d) if P else d
            pid, fd = pty.fork()
            if pid == 0: os.execvp(c[0], c)
            def win(*a):
                try: fcntl.ioctl(fd, termios.TIOCSWINSZ, fcntl.ioctl(0, termios.TIOCGWINSZ, b"\0" * 8))
                except OSError: pass
            win(); signal.signal(signal.SIGWINCH, win)
            try: o = termios.tcgetattr(0); tty.setraw(0)
            except Exception: o = None
            try:
                while 1:
                    r = select.select([0, fd], [], [])[0]
                    if fd in r:
                        d = os.read(fd, 65536)
                        if not d: break
                        os.write(1, scrub(d))
                    if 0 in r:
                        d = os.read(0, 65536)
                        if d: os.write(fd, d)
            except OSError: pass
            finally:
                if o: termios.tcsetattr(0, termios.TCSADRAIN, o)
            _, s = os.waitpid(pid, 0); sys.exit(os.waitstatus_to_exitcode(s))
        '';
    in {
        my.programs.copilot.package = pkgs.llm-agents.copilot-cli.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
            postInstall =
                (old.postInstall or "")
                + ''
                    mv $out/bin/copilot $out/bin/.copilot-real
                    makeWrapper ${pkgs.python3}/bin/python3 $out/bin/copilot \
                        --set-default COPILOT_THEME_PALETTE "${palette}" \
                        --add-flags "${filter} $out/bin/.copilot-real"
                '';
        });
    };
}
