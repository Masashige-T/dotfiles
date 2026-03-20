---
name: ship
description: lint・テスト実行後に commit & push する
---

1. `./lint.sh` を実行して全チェック（ShellCheck, taplo, bats）をパスすることを確認する。失敗した場合は修正してから再実行する。
2. 変更内容を確認し、適切なコミットメッセージで commit する。
3. remote に push する。
4. 結果を報告する。
