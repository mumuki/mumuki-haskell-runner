#/bin/bash
REV=$1

echo "[Escualo::HspecServer2] Fetching GIT revision"
echo -n $REV > version

echo "[Escualo::HspecServer2] Pulling docker image"
docker pull mumuki/mumuki-hspec-worker