#!/bin/bash
set -e

OLD=v6.18.60
NEW=v6.18.62
PATCH=/tmp/update-to-$NEW.patch

#git remote add stable https://mirrors.tuna.tsinghua.edu.cn/git/linux-stable.git
git fetch stable --no-tags --depth 1 refs/tags/$OLD:refs/tags/$OLD refs/tags/$NEW:refs/tags/$NEW
git diff $OLD $NEW > $PATCH

# 3way 合并：本地改动（如 pg99 过滤）会被保留，而不是整包回滚
if ! git apply --3way $PATCH; then
	echo "存在无法自动合并的冲突，请手工解决后再提交："
	git status --short
	exit 1
fi

# 确认内核版本真的升上去了
grep -q "^SUBLEVEL = ${NEW#v6.18.}$" Makefile

git add -A
git commit -m "Update Linux kernel from $OLD to $NEW"

# 3. 推送
git push origin main
