import os, sys, subprocess, shutil, zipfile
from pathlib import Path

DATA_DIR = Path(__file__).parent / "data"
USER_DATA = Path.home() / ".turbo"
EXE_PATH = USER_DATA / "llama-server.exe"
LOG_FILE = USER_DATA / "server.log"


def check_cuda_available():
    if sys.platform != "win32":
        return True
    result = subprocess.run(
        ["nvidia-smi"], capture_output=True, text=True
    )
    return result.returncode == 0


def unpack_engine():
    if EXE_PATH.exists():
        return str(EXE_PATH)

    engine_zip = DATA_DIR / "engine.zip"
    if not engine_zip.exists():
        return None

    print("Unpacking engine...")
    USER_DATA.mkdir(parents=True, exist_ok=True)
    try:
        with zipfile.ZipFile(engine_zip, "r") as zip_ref:
            zip_ref.extractall(USER_DATA)
            print("Engine unpacked.")
            return str(EXE_PATH)
    except Exception as e:
        print(f"Error unpacking engine: {e}")
        return None


def add_dll_directory():
    exe_dir = str(Path(EXE_PATH).parent)
    if sys.platform == "win32" and os.path.exists(exe_dir):
        os.add_dll_directory(exe_dir)


def get_engine():
    exe = unpack_engine()
    if exe and os.path.exists(exe):
        return exe

    print("Error: Could not find or extract engine binary.")
    print("Please ensure engine.zip contains llama-server.exe or has been pre-built.")
    sys.exit(1)
