# 在庫管理最適化アプリケーション

このアプリケーションは、線形計画法を使用して在庫管理の最適化問題を解決するStreamlitベースのWebアプリケーションです。

## 機能

- 月ごとの需要に基づいた最適な発注計画の計算
- 在庫保管コスト、欠品コスト、段取りコストを考慮した総コストの最小化
- 結果の可視化（表とグラフ）

## デプロイ設定

このアプリケーションは、GitHub ActionsとGoogle Cloud Runを使用して自動デプロイされます。

### 前提条件

1. Google Cloud Projectの作成
2. Cloud Run APIの有効化
3. Container Registry APIの有効化
4. サービスアカウントの作成と必要な権限の付与

### 必要な権限

サービスアカウントには以下の役割が必要です：
- Cloud Run Admin
- Storage Admin
- Service Account User

### GitHub Secretsの設定

リポジトリの設定で以下のSecretsを追加してください：

1. `GCP_PROJECT_ID`: Google CloudプロジェクトのID
2. `GCP_SA_KEY`: サービスアカウントのJSON形式の認証キー

### サービスアカウントキーの取得方法

```bash
# サービスアカウントの作成
gcloud iam service-accounts create github-actions \
  --display-name="GitHub Actions Service Account"

# 必要な権限の付与
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:github-actions@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:github-actions@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:github-actions@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

# キーの作成
gcloud iam service-accounts keys create key.json \
  --iam-account=github-actions@PROJECT_ID.iam.gserviceaccount.com
生成されたkey.jsonの内容をGCP_SA_KEYとしてGitHub Secretsに登録してください。

デプロイフロー
mainブランチにプッシュ
GitHub Actionsが自動的に起動
Dockerイメージのビルド
Google Container Registryへのプッシュ
Cloud Runへのデプロイ
アプリケーションの仕様
リージョン: asia-northeast1（東京）
メモリ: 512Mi
CPU: 1
認証: 不要（パブリックアクセス可能）
ポート: 8501
ローカルでの実行
# 依存関係のインストール
pip install -r requirements.txt

# アプリケーションの起動
streamlit run app.py
Docker での実行
# イメージのビルド
docker build -t inventory-optimization-app .

# コンテナの起動
docker run -p 8501:8501 inventory-optimization-app
アプリケーションは http://localhost:8501  でアクセスできます。

トラブルシューティング
デプロイが失敗する場合
Google Cloud APIが有効になっているか確認
サービスアカウントの権限が正しく設定されているか確認
GitHub Secretsが正しく設定されているか確認
プロジェクトIDが正しいか確認
Cloud Runのログ確認
gcloud run services logs read inventory-optimization-app --region asia-northeast1
ライセンス
このプロジェクトはMITライセンスの下で公開されています。


これらのファイルを使用することで、GitHub ActionsからGoogle Cloud Runへの自動デプロイが可能になります。必要な設定はREADME.mdに記載されている手順に従って行ってください。