#!/usr/bin/env python3
import os
import sys
import urllib.request
import json
import tarfile
import zipfile
import shutil
import platform

LOCAL_BIN = os.path.expanduser("~/.local/bin")
os.makedirs(LOCAL_BIN, exist_ok=True)

# Detect architecture (x86_64 vs aarch64)
machine = platform.machine().lower()
is_arm64 = machine in ("aarch64", "arm64")

musl_arch = "aarch64-unknown-linux-musl" if is_arm64 else "x86_64-unknown-linux-musl"
gnu_arch = "aarch64-unknown-linux-gnu" if is_arm64 else "x86_64-unknown-linux-gnu"
go_arch = "arm64" if is_arm64 else "amd64"
linux_arch = "aarch64-linux" if is_arm64 else "x86_64-linux"

def download_file(url, target_path):
    print(f"Downloading {url} -> {target_path} ...")
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req) as resp, open(target_path, 'wb') as out:
        shutil.copyfileobj(resp, out)

def get_latest_github_release(repo, pattern_fn):
    url = f"https://api.github.com/repos/{repo}/releases/latest"
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read().decode())
    for asset in data.get('assets', []):
        name = asset.get('name', '')
        if pattern_fn(name):
            return asset.get('browser_download_url'), name
    return None, None

def already_available(cmd_name):
    target = os.path.join(LOCAL_BIN, cmd_name)
    if os.path.exists(target):
        return True
    system_bin = shutil.which(cmd_name)
    if system_bin:
        print(f"✓ {cmd_name} already available in system ({system_bin}), skipping download.")
        return True
    return False

def install_tools():
    print(f"[iNiR Tools] Starting CLI tool check for architecture: {machine}")

    # 1. zoxide
    if not already_available("zoxide"):
        print(f"Installing zoxide ({musl_arch})...")
        try:
            url, _ = get_latest_github_release("ajeetdsouza/zoxide", lambda n: musl_arch in n and n.endswith(".tar.gz"))
            if url:
                tar_path = "/tmp/zoxide.tar.gz"
                download_file(url, tar_path)
                with tarfile.open(tar_path, "r:gz") as tar:
                    tar.extract("zoxide", path=LOCAL_BIN)
                os.chmod(os.path.join(LOCAL_BIN, "zoxide"), 0o755)
        except Exception as e:
            print("zoxide install failed:", e)

    # 2. fzf
    if not already_available("fzf"):
        print(f"Installing fzf (linux_{go_arch})...")
        try:
            pattern = f"linux_{go_arch}.tar.gz"
            url, _ = get_latest_github_release("junegunn/fzf", lambda n: pattern in n)
            if url:
                tar_path = "/tmp/fzf.tar.gz"
                download_file(url, tar_path)
                with tarfile.open(tar_path, "r:gz") as tar:
                    tar.extract("fzf", path=LOCAL_BIN)
                os.chmod(os.path.join(LOCAL_BIN, "fzf"), 0o755)
        except Exception as e:
            print("fzf install failed:", e)

    # 3. bat
    if not already_available("bat"):
        print(f"Installing bat ({musl_arch})...")
        try:
            url, _ = get_latest_github_release("sharkdp/bat", lambda n: musl_arch in n and n.endswith(".tar.gz"))
            if url:
                tar_path = "/tmp/bat.tar.gz"
                download_file(url, tar_path)
                bat_bin = os.path.join(LOCAL_BIN, "bat")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.endswith("/bat") or member.name == "bat":
                            with open(bat_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(bat_bin, 0o755)
        except Exception as e:
            print("bat install failed:", e)

    # 4. yazi
    if not already_available("yazi"):
        print(f"Installing yazi ({musl_arch})...")
        try:
            url, _ = get_latest_github_release("sxyazi/yazi", lambda n: musl_arch in n and n.endswith(".zip"))
            if url:
                zip_path = "/tmp/yazi.zip"
                download_file(url, zip_path)
                yazi_bin = os.path.join(LOCAL_BIN, "yazi")
                with zipfile.ZipFile(zip_path, 'r') as z:
                    for filename in z.namelist():
                        if filename.endswith("/yazi") or filename == "yazi":
                            with z.open(filename) as zf, open(yazi_bin, 'wb') as out:
                                out.write(zf.read())
                            break
                os.chmod(yazi_bin, 0o755)
        except Exception as e:
            print("yazi install failed:", e)

    # 5. zellij
    if not already_available("zellij"):
        print(f"Installing zellij ({musl_arch})...")
        try:
            url, _ = get_latest_github_release("zellij-org/zellij", lambda n: musl_arch in n and n.endswith(".tar.gz"))
            if url:
                tar_path = "/tmp/zellij.tar.gz"
                download_file(url, tar_path)
                zellij_bin = os.path.join(LOCAL_BIN, "zellij")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.endswith("zellij"):
                            with open(zellij_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(zellij_bin, 0o755)
        except Exception as e:
            print("zellij install failed:", e)

    # 6. nvim (AppImage / Release)
    if not already_available("nvim"):
        print("Installing neovim...")
        try:
            appimage_name = "nvim-linux-arm64.appimage" if is_arm64 else "nvim-linux-x86_64.appimage"
            url = f"https://github.com/neovim/neovim/releases/download/stable/{appimage_name}"
            nvim_bin = os.path.join(LOCAL_BIN, "nvim")
            download_file(url, nvim_bin)
            os.chmod(nvim_bin, 0o755)
        except Exception as e:
            print("nvim install failed:", e)

    # 7. lazygit
    if not already_available("lazygit"):
        lg_arch = "arm64" if is_arm64 else "x86_64"
        print(f"Installing lazygit (Linux_{lg_arch})...")
        try:
            pat = f"Linux_{lg_arch}.tar.gz"
            url, _ = get_latest_github_release("jesseduffield/lazygit", lambda n: pat in n)
            if url:
                tar_path = "/tmp/lazygit.tar.gz"
                download_file(url, tar_path)
                lazygit_bin = os.path.join(LOCAL_BIN, "lazygit")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name == "lazygit":
                            with open(lazygit_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(lazygit_bin, 0o755)
        except Exception as e:
            print("lazygit install failed:", e)

    # 8. yq
    if not already_available("yq"):
        print(f"Installing yq (yq_linux_{go_arch})...")
        try:
            pat = f"yq_linux_{go_arch}.tar.gz"
            url, _ = get_latest_github_release("mikefarah/yq", lambda n: pat in n)
            if url:
                tar_path = "/tmp/yq.tar.gz"
                download_file(url, tar_path)
                yq_bin = os.path.join(LOCAL_BIN, "yq")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.startswith(f"yq_linux_{go_arch}") or member.name == "yq":
                            with open(yq_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(yq_bin, 0o755)
        except Exception as e:
            print("yq install failed:", e)

    # 9. dust
    if not already_available("dust"):
        print(f"Installing dust ({musl_arch})...")
        try:
            url, _ = get_latest_github_release("bootandy/dust", lambda n: musl_arch in n and n.endswith(".tar.gz"))
            if url:
                tar_path = "/tmp/dust.tar.gz"
                download_file(url, tar_path)
                dust_bin = os.path.join(LOCAL_BIN, "dust")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.endswith("/dust") or member.name == "dust":
                            with open(dust_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(dust_bin, 0o755)
        except Exception as e:
            print("dust install failed:", e)

    # 10. btop
    if not already_available("btop"):
        print(f"Installing btop ({musl_arch})...")
        try:
            url, _ = get_latest_github_release("aristocratos/btop", lambda n: musl_arch in n and n.endswith(".tar.gz"))
            if url:
                tar_path = "/tmp/btop.tar.gz"
                download_file(url, tar_path)
                btop_bin = os.path.join(LOCAL_BIN, "btop")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name == "./btop/bin/btop" or member.name.endswith("/bin/btop"):
                            with open(btop_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(btop_bin, 0o755)
        except Exception as e:
            print("btop install failed:", e)

    # 11. ripgrep (rg)
    if not already_available("rg"):
        print(f"Installing ripgrep ({musl_arch})...")
        try:
            url, _ = get_latest_github_release("BurntSushi/ripgrep", lambda n: musl_arch in n and n.endswith(".tar.gz"))
            if url:
                tar_path = "/tmp/rg.tar.gz"
                download_file(url, tar_path)
                rg_bin = os.path.join(LOCAL_BIN, "rg")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.endswith("/rg") or member.name == "rg":
                            with open(rg_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(rg_bin, 0o755)
        except Exception as e:
            print("ripgrep install failed:", e)

    # 12. fd
    if not already_available("fd"):
        print(f"Installing fd ({musl_arch})...")
        try:
            url, _ = get_latest_github_release("sharkdp/fd", lambda n: musl_arch in n and n.endswith(".tar.gz"))
            if url:
                tar_path = "/tmp/fd.tar.gz"
                download_file(url, tar_path)
                fd_bin = os.path.join(LOCAL_BIN, "fd")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.endswith("/fd") or member.name == "fd":
                            with open(fd_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(fd_bin, 0o755)
        except Exception as e:
            print("fd install failed:", e)

    # 13. fastfetch
    if not already_available("fastfetch"):
        ff_arch = "aarch64" if is_arm64 else "amd64"
        print(f"Installing fastfetch (linux-{ff_arch})...")
        try:
            pat = f"fastfetch-linux-{ff_arch}.tar.gz"
            url, _ = get_latest_github_release("fastfetch-cli/fastfetch", lambda n: pat in n)
            if url:
                tar_path = "/tmp/fastfetch.tar.gz"
                download_file(url, tar_path)
                fastfetch_bin = os.path.join(LOCAL_BIN, "fastfetch")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.endswith("/fastfetch") or member.name == "fastfetch":
                            with open(fastfetch_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(fastfetch_bin, 0o755)
        except Exception as e:
            print("fastfetch install failed:", e)

    # 14. duf
    if not already_available("duf"):
        duf_arch = "arm64" if is_arm64 else "x86_64"
        print(f"Installing duf (linux_{duf_arch})...")
        try:
            pat = f"linux_{duf_arch}.tar.gz"
            url, _ = get_latest_github_release("muesli/duf", lambda n: pat in n)
            if url:
                tar_path = "/tmp/duf.tar.gz"
                download_file(url, tar_path)
                duf_bin = os.path.join(LOCAL_BIN, "duf")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.endswith("/duf") or member.name == "duf":
                            with open(duf_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(duf_bin, 0o755)
        except Exception as e:
            print("duf install failed:", e)

    # 15. procs
    if not already_available("procs"):
        print(f"Installing procs ({linux_arch})...")
        try:
            pat = f"{linux_arch}.zip"
            url, _ = get_latest_github_release("dalance/procs", lambda n: pat in n)
            if url:
                zip_path = "/tmp/procs.zip"
                download_file(url, zip_path)
                procs_bin = os.path.join(LOCAL_BIN, "procs")
                with zipfile.ZipFile(zip_path, 'r') as z:
                    for fn in z.namelist():
                        if fn.endswith("procs") or fn == "procs":
                            with z.open(fn) as src, open(procs_bin, 'wb') as dst:
                                dst.write(src.read())
                            break
                os.chmod(procs_bin, 0o755)
        except Exception as e:
            print("procs install failed:", e)

    # 16. gping
    if not already_available("gping"):
        gp_arch = "arm64" if is_arm64 else "x86_64"
        print(f"Installing gping ({gp_arch})...")
        try:
            pat = f"Linux-musl-{gp_arch}.tar.gz"
            url, _ = get_latest_github_release("orf/gping", lambda n: pat in n or (is_arm64 and "Linux-musl-aarch64.tar.gz" in n))
            if url:
                tar_path = "/tmp/gping.tar.gz"
                download_file(url, tar_path)
                gping_bin = os.path.join(LOCAL_BIN, "gping")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.endswith("gping") or member.name == "gping":
                            with open(gping_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(gping_bin, 0o755)
        except Exception as e:
            print("gping install failed:", e)

    # 17. eza
    if not already_available("eza"):
        print(f"Installing eza ({musl_arch})...")
        try:
            url, _ = get_latest_github_release("eza-community/eza", lambda n: musl_arch in n and n.endswith(".tar.gz"))
            if url:
                tar_path = "/tmp/eza.tar.gz"
                download_file(url, tar_path)
                eza_bin = os.path.join(LOCAL_BIN, "eza")
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.endswith("eza") or member.name == "eza":
                            with open(eza_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(eza_bin, 0o755)
        except Exception as e:
            print("eza install failed:", e)

    print("All CLI & DevOps tools checked/installed successfully.")

if __name__ == "__main__":
    install_tools()
