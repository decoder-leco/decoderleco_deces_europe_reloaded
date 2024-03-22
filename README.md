# Décoder l'éco: Statistiques des Décès en Europe

Ce repository contient une ré-écriture complète des traitements `R` faits dans <https://github.com/decoderleco/deces_europe>, mais sous forme de Notebooks Jupyter.

## ANNEX: The git flow init

This is how the git flow was initialized in this repo:

```bash
export GIT_SSH_URI_OF_THE_REPO="git@github.com:decoder-leco/decoderleco_de ces_europe_reloaded.git"
export GITCLONE_FOLDER=$(echo "${GIT_SSH_URI_OF_THE_REPO}" | awk -F '/' '{ print $NF }' | sed 's#.git##g' )
echo " GITCLONE_FOLDER=[${GITCLONE_FOLDER}]"

git clone ${GIT_SSH_URI_OF_THE_REPO}

cd ./${GITCLONE_FOLDER}/

rm -fr ./.git/

git init --initial-branch=master

git remote add origin ${GIT_SSH_URI_OF_THE_REPO} && git add -A && git commit -m "init git flow" && git push -u origin master && git flow init --defaults && git push -u origin --all

git flow feature start kr/decoderleco/deces_europe/jupyter/rewrite && git push -u origin HEAD

git add -A && git commit -m "docs: fix typo and comlete git flow init" && git push -u origin HEAD

# Then created first pull request :
# from [feature/kr/decoderleco/deces_europe/jupyter/rewrite] git branch,
# to [develop] git branch
```
