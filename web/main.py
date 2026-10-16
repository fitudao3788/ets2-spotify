import re

from flask import Flask, render_template, request
import httpx


app = Flask(__name__)


@app.get("/")
def index():
    return render_template("index.html")


@app.post("/")
def process():
    state_url = request.form.get("url")

    if not re.match(r"^http:\/\/127.0.0.1:\d+\/login\?code=.*$", state_url):
        return render_template("invalid-url.html")

    try:
        res = httpx.get(state_url)
    except httpx.ConnectError:
        return render_template("connect-error.html")

    if "Go back to go-librespot!" in res.text:
        return render_template("login-success.html")
    else:
        return render_template("login-failed.html")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
