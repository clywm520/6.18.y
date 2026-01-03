#!/bin/bash

git remote add stable https://mirrors.tuna.tsinghua.edu.cn/git/linux-stable.git
git fetch stable --no-tags --depth 1 refs/tags/v6.18.2:refs/tags/v6.18.2 refs/tags/v6.18.3:refs/tags/v6.18.3
git diff v6.18.2 v6.18.3 > update-to-6.18.3.patch
git apply --check update-to-6.18.3.patch
git apply update-to-6.18.3.patch
git add .
git commit -m "Update Linux kernel from v6.18.2 to v6.18.3"

# 3. 推送
git push origin main
