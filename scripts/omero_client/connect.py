# omero_client/connect.py
from omero.gateway import BlitzGateway

def connect(host, user, pw):
    conn = BlitzGateway(user, pw, host=host, secure=True)
    conn.connect()
    return conn