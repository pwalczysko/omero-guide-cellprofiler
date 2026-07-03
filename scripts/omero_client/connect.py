from omero.gateway import BlitzGateway
import getpass
import os


def connect(host=None, user=None, pw=None, secure=True):
    """
    Interactive OMERO connection helper.

    Priority order:
    1. Function arguments
    2. Environment variables
    3. Interactive prompts
    """

    # 1. Environment fallbacks
    host = host or os.getenv("OMERO_HOST")
    user = user or os.getenv("OMERO_USER")
    pw = pw or os.getenv("OMERO_PASS")

    # 2. Interactive prompts if missing
    if not host:
        host = input("OMERO host [localhost]: ").strip() or "localhost"

    if not user:
        user = input("Username: ").strip()

    if not pw:
        pw = getpass.getpass("Password: ")

    # 3. Connect
    conn = BlitzGateway(user, pw, host=host, secure=secure)

    print(f"\nConnecting to OMERO at {host} as {user} ...")

    if not conn.connect():
        raise ConnectionError("Failed to connect to OMERO server. Check credentials/host.")

    print("Connected successfully.\n")

    return conn