# Remark Starter
Starting code for a Remark repository.

[Remark][remark] is a

> [Markdown][markdown]-driven presentation slideshow tool 

## How to use
**TL;DR** Clone this repository and push it an other repository.

### Create a repository
Create a new empty repository. See GitHub's [documentation][create] on how to do
that.

### Clone the repository
[Clone the repository][clone] that you just created.

```shell
git clone git@github.com:HAN-ASD-DT/REPOSITORY.git
```

### Add a new remote
Add `remark-starter` as a [new remote][remote].

```shell
cd REPOSITORY
git remote add starter git@github.com:HAN-ASD-DT/remark-starter.git
```

### Fetch starter code
[Fetch][fetch] the starter code.

```shell
git fetch starter
```

### Rebase on stater code
[Rebase][rebase] on the starter code.

```shell
git rebase starter/master
```

You might need to [resolve merge conflicts][conflict], depending on how you setup your repository.

### Start working
You can alter the presentation in the `docs/presentation.md` markdown file. Once
your changes are committed and pushed, the are automatically reflected in the
the corresponding [GitHub pages][pages] file.

If you want to have a live view while working on the slides run a simple HTTP
server. For example

```shell
python -m SimpleHTTPServer
```

[remark]: https://github.com/gnab/remark
[markdown]: https://daringfireball.net/projects/markdown/
[create]: https://help.github.com/articles/create-a-repo/
[clone]: https://help.github.com/articles/cloning-a-repository/
[remote]: https://help.github.com/articles/adding-a-remote/
[fetch]: https://help.github.com/articles/fetching-a-remote/#fetch
[rebase]: https://help.github.com/articles/about-git-rebase/
[conflict]: https://help.github.com/articles/resolving-a-merge-conflict-using-the-command-line/
[pages]: https://pages.github.com/
