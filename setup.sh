cat > .env << EOF
USER_ID=$(id -u)
GROUP_ID=$(id -g)
USERNAME=$(whoami)
EOF

echo "環境変数を設定しました。現在のユーザー情報:"
echo "USER_ID=$(id -u)"
echo "GROUP_ID=$(id -g)" 
echo "USERNAME=$(whoami)"
echo "これでDockerコンテナ内のユーザーIDとホストのユーザーIDが一致します。"
echo ""
echo "次のコマンドで開発環境を構築できます:"
echo "make build"
echo "make up"
