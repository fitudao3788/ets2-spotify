# ets2-spotify

Spotify の音声を Icecast のストリームに変換し、Euro Truck Simulator 2 のライブストリーミングラジオで再生するための Docker コンテナです。

## 使い方

```
docker compose up --build
```

1. 初回のみ、コンテナのログに表示される Spotify のログインURLを開いてログインします。ログイン後に遷移した `http://127.0.0.1:xxxx/login?...` のURLを `http://localhost:8080` に貼り付けます。
2. Spotify アプリのデバイス一覧から `ETS2 Spotify` を選び、再生します。
3. ETS2 のラジオに `http://localhost:8000/stream.mp3` を追加します。

ログイン情報は `config/state.json` に保存されます。このファイルは公開しないでください。
