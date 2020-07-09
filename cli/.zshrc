# Makes a first git push
Function fpush () {
  git push -u origin HEAD
}

# Undo the last git xadd/commit
Function gitundo () {
 git reset --soft HEAD^1
 git reset HEAD *
}

# Opens the default browser to the appropriate
# 'create pull request' page, based on the current repo + branch.
# 2016-06-27 with new stuff from Chris, that works
# on gitlab, as well as github, automatically.
# See: https://in.thewardro.be/snippets/14
Function pr () {
    local repo=`git remote show origin -n | grep "Fetch URL:" | sed -E "s/^.*:(.*).git$/\1/"`;
    local host=`git remote show origin -n | grep "Fetch URL:" | sed -E "s/^.*@(.*):.*.git$/\1/"`
    local branch=`git name-rev --name-only HEAD`;
    # Make sure the branch is up to date
    if [[ "$branch" == "master" ]]; then
        echo "On master branch, please checkout a new branch before submitting a pull request.";
        return 1;
    fi
    if [[ "$branch" == "main" ]]; then
        echo "On main branch, please checkout a new branch before submitting a pull request.";
        return 1;
    fi
    if [[ "$branch" == "production" ]]; then
        echo "On production branch, please checkout a new branch before submitting a pull request.";
        return 1;
    fi
    if [[ "$branch" == "integration" ]]; then
        echo "On integration branch, please checkout a new branch before submitting a pull request.";
        return 1;
    fi
    git push origin $branch;
    echo "... creating pull request for branch \"$branch\" in \"$repo\"";
    if [[ "$host" == "github.com" ]]; then
        open https://$host/$repo/pull/new/$branch;
    else
        open "https://$host/$repo/merge_requests/new?merge_request%5Bsource_branch%5D=$branch";
    fi
}