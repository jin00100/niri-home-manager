#!/usr/bin/env python3
import os
import sys
import urllib.request
import json
import tarfile
import zipfile
import shutil

LOCAL_BIN = os.path.expanduser("~/.local/bin")
os.makedirs(LOCAL_BIN, exist_ok=True)

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

def install_tools():
    # 1. zoxide
    zoxide_bin = os.path.join(LOCAL_BIN, "zoxide")
    if not os.path.exists(zoxide_bin):
        print("Installing zoxide...")
        try:
            url, _ = get_latest_github_release("ajeetdsouza/zoxide", lambda n: "x86_64-unknown-linux-musl.tar.gz" in n)
            if url:
                tar_path = "/tmp/zoxide.tar.gz"
                download_file(url, tar_path)
                with tarfile.open(tar_path, "r:gz") as tar:
                    tar.extract("zoxide", path=LOCAL_BIN)
                os.chmod(zoxide_bin, 0o755)
        except Exception as e:
            print("zoxide install failed:", e)

    # 2. fzf
    fzf_bin = os.path.join(LOCAL_BIN, "fzf")
    if not os.path.exists(fzf_bin):
        print("Installing fzf...")
        try:
            url, _ = get_latest_github_release("junegunn/fzf", lambda n: "linux_amd64.tar.gz" in n)
            if url:
                tar_path = "/tmp/fzf.tar.gz"
                download_file(url, tar_path)
                with tarfile.open(tar_path, "r:gz") as tar:
                    tar.extract("fzf", path=LOCAL_BIN)
                os.chmod(fzf_bin, 0o755)
        except Exception as e:
            print("fzf install failed:", e)

    # 3. bat
    bat_bin = os.path.join(LOCAL_BIN, "bat")
    if not os.path.exists(bat_bin):
        print("Installing bat...")
        try:
            url, _ = get_latest_github_release("sharkdp/bat", lambda n: "x86_64-unknown-linux-musl.tar.gz" in n)
            if url:
                tar_path = "/tmp/bat.tar.gz"
                download_file(url, tar_path)
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
    yazi_bin = os.path.join(LOCAL_BIN, "yazi")
    if not os.path.exists(yazi_bin):
        print("Installing yazi...")
        try:
            url, _ = get_latest_github_release("sxyazi/yazi", lambda n: "x86_64-unknown-linux-musl.zip" in n)
            if url:
                zip_path = "/tmp/yazi.zip"
                download_file(url, zip_path)
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
    zellij_bin = os.path.join(LOCAL_BIN, "zellij")
    if not os.path.exists(zellij_bin):
        print("Installing zellij...")
        try:
            url, _ = get_latest_github_release("zellij-org/zellij", lambda n: "x86_64-unknown-linux-musl.tar.gz" in n)
            if url:
                tar_path = "/tmp/zellij.tar.gz"
                download_file(url, tar_path)
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.endswith("zellij"):
                            with open(zellij_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(zellij_bin, 0o755)
        except Exception as e:
            print("zellij install failed:", e)

    # 6. nvim (AppImage)
    nvim_bin = os.path.join(LOCAL_BIN, "nvim")
    if not os.path.exists(nvim_bin):
        print("Installing neovim...")
        try:
            url = "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage"
            download_file(url, nvim_bin)
            os.chmod(nvim_bin, 0o755)
        except Exception as e:
            print("nvim install failed:", e)

    # 7. lazygit
    lazygit_bin = os.path.join(LOCAL_BIN, "lazygit")
    if not os.path.exists(lazygit_bin):
        print("Installing lazygit...")
        try:
            url, _ = get_latest_github_release("jesseduffield/lazygit", lambda n: "Linux_x86_64.tar.gz" in n)
            if url:
                tar_path = "/tmp/lazygit.tar.gz"
                download_file(url, tar_path)
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
    yq_bin = os.path.join(LOCAL_BIN, "yq")
    if not os.path.exists(yq_bin):
        print("Installing yq...")
        try:
            url, _ = get_latest_github_release("mikefarah/yq", lambda n: "yq_linux_amd64.tar.gz" in n)
            if url:
                tar_path = "/tmp/yq.tar.gz"
                download_file(url, tar_path)
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.startswith("yq_linux_amd64") or member.name == "yq":
                            with open(yq_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(yq_bin, 0o755)
        except Exception as e:
            print("yq install failed:", e)

    # 9. dust
    dust_bin = os.path.join(LOCAL_BIN, "dust")
    if not os.path.exists(dust_bin):
        print("Installing dust...")
        try:
            url, _ = get_latest_github_release("bootandy/dust", lambda n: "x86_64-unknown-linux-musl.tar.gz" in n)
            if url:
                tar_path = "/tmp/dust.tar.gz"
                download_file(url, tar_path)
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
    btop_bin = os.path.join(LOCAL_BIN, "btop")
    if not os.path.exists(btop_bin):
        print("Installing btop...")
        try:
            url, _ = get_latest_github_release("aristocratos/btop", lambda n: "x86_64-unknown-linux-musl.tar.gz" in n)
            if url:
                tar_path = "/tmp/btop.tar.gz"
                download_file(url, tar_path)
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
    rg_bin = os.path.join(LOCAL_BIN, "rg")
    if not os.path.exists(rg_bin):
        print("Installing ripgrep...")
        try:
            url, _ = get_latest_github_release("BurntSushi/ripgrep", lambda n: "x86_64-unknown-linux-musl.tar.gz" in n)
            if url:
                tar_path = "/tmp/rg.tar.gz"
                download_file(url, tar_path)
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
    fd_bin = os.path.join(LOCAL_BIN, "fd")
    if not os.path.exists(fd_bin):
        print("Installing fd...")
        try:
            url, _ = get_latest_github_release("sharkdp/fd", lambda n: "x86_64-unknown-linux-musl.tar.gz" in n)
            if url:
                tar_path = "/tmp/fd.tar.gz"
                download_file(url, tar_path)
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
    fastfetch_bin = os.path.join(LOCAL_BIN, "fastfetch")
    if not os.path.exists(fastfetch_bin):
        print("Installing fastfetch...")
        try:
            url, _ = get_latest_github_release("fastfetch-cli/fastfetch", lambda n: "fastfetch-linux-amd64.tar.gz" in n)
            if url:
                tar_path = "/tmp/fastfetch.tar.gz"
                download_file(url, tar_path)
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
    duf_bin = os.path.join(LOCAL_BIN, "duf")
    if not os.path.exists(duf_bin):
        print("Installing duf...")
        try:
            url, _ = get_latest_github_release("muesli/duf", lambda n: "linux_x86_64.tar.gz" in n)
            if url:
                tar_path = "/tmp/duf.tar.gz"
                download_file(url, tar_path)
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
    procs_bin = os.path.join(LOCAL_BIN, "procs")
    if not os.path.exists(procs_bin):
        print("Installing procs...")
        try:
            url, _ = get_latest_github_release("dalance/procs", lambda n: "x86_64-linux.zip" in n)
            if url:
                zip_path = "/tmp/procs.zip"
                download_file(url, zip_path)
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
    gping_bin = os.path.join(LOCAL_BIN, "gping")
    if not os.path.exists(gping_bin):
        print("Installing gping...")
        try:
            url, _ = get_latest_github_release("orf/gping", lambda n: "Linux-musl-x86_64.tar.gz" in n)
            if url:
                tar_path = "/tmp/gping.tar.gz"
                download_file(url, tar_path)
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
    eza_bin = os.path.join(LOCAL_BIN, "eza")
    if not os.path.exists(eza_bin):
        print("Installing eza...")
        try:
            url, _ = get_latest_github_release("eza-community/eza", lambda n: "x86_64-unknown-linux-musl.tar.gz" in n)
            if url:
                tar_path = "/tmp/eza.tar.gz"
                download_file(url, tar_path)
                with tarfile.open(tar_path, "r:gz") as tar:
                    for member in tar.getmembers():
                        if member.name.endswith("eza") or member.name == "eza":
                            with open(eza_bin, "wb") as out:
                                out.write(tar.extractfile(member).read())
                            break
                os.chmod(eza_bin, 0o755)
        except Exception as e:
            print("eza install failed:", e)

    print("All CLI & DevOps tools checked/installed in ~/.local/bin successfully.")

if __name__ == "__main__":
    install_tools()
