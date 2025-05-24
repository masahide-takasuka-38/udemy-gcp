# 在庫管理最適化アプリケーション

線形計画法を使用して在庫管理の最適化問題を解決するStreamlitベースのWebアプリケーションです。

## 機能

- 月ごとの需要に基づいた最適な発注計画の計算
- 在庫保管コスト、欠品コスト、段取りコストを考慮した総コストの最小化
- 結果の可視化（表とグラフ）

## ファイル構成

```
.
├── app.py                    # メインアプリケーション
├── requirements.txt          # Python依存関係
├── Dockerfile               # Dockerイメージ定義
├── .github/
│   └── workflows/
│       └── deploy.yml       # GitHub Actionsワークフロー
└── README.md               # このファイル
```

## デプロイ設定

GitHub ActionsとGoogle Cloud Runを使用した自動デプロイ。

### 前提条件

1. Google Cloud Projectの作成
2. Cloud Run APIの有効化
3. Cloud Build APIの有効化
4. サービスアカウントの作成と権限設定

### セットアップ手順

```bash
# プロジェクトIDを設定
export PROJECT_ID=your-project-id
gcloud config set project $PROJECT_ID

# APIを有効化
gcloud services enable run.googleapis.com cloudbuild.googleapis.com

# サービスアカウントを作成
gcloud iam service-accounts create github-actions \
  --display-name="GitHub Actions Service Account"

# 権限を付与
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/cloudbuild.builds.editor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/logging.logWriter"

# 認証キーを作成
gcloud iam service-accounts keys create key.json \
  --iam-account=github-actions@$PROJECT_ID.iam.gserviceaccount.com
```

### GitHub Secretsの設定

1. リポジトリの Settings → Secrets and variables → Actions
2. 以下を追加：
   - `GCP_PROJECT_ID`: プロジェクトID
   - `GCP_SA_KEY`: key.jsonの内容をコピー＆ペースト

## デプロイ

mainブランチにプッシュすると自動デプロイ：

```bash
git push origin main
```

## アプリケーションの仕様

- **サービス名**: inventory-optimization-app
- **リージョン**: asia-northeast1（東京）
- **メモリ**: 512Mi
- **CPU**: 1
- **認証**: 不要（パブリックアクセス可能）
- **ポート**: 8501

## トラブルシューティング

### ログの確認

```bash
# Cloud Buildログ
gcloud builds list --limit=5

# Cloud Runログ
gcloud run services logs read inventory-optimization-app --region asia-northeast1
```

### クリーンアップ

```bash
# サービスの削除
gcloud run services delete inventory-optimization-app --region asia-northeast1

# サービスアカウントの削除
gcloud iam service-accounts delete github-actions@$PROJECT_ID.iam.gserviceaccount.com
```
