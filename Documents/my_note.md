# NEOVIM

## REGEXP

|To ... |Exp|Comments|example|
|--|--|--|--|
|non-greedy capture|\{-}|following *, +|`.\{-}`|
|match with line break|\_ |. can match line break to have multi-line match|`\_ .*`|
|positve lookahead assertion|\@= | the same as `(?=)` in standard regexp, short form: `\ze`|`foo\(bar\)\@=` match `foo` only when `bar` is followed = `foo(?=bar)` in regular regexp, = `foo\zebar`|
| positve lookbehind assertion| \@<=  | the same as `(?<=)` in standard regexp, short form: `\zs`|`\(bar\)\@<=foo` match `foo` only when `bar` is preceeded = (?<=bar)foo in standard regexp, = `bar\zsfoo`|
|negative lookahead assertion| \@! | the same as `(?!)` in standard regexp| `foo\(bar\)\@!` match `foo` onlywhen 'bar`` is not followed, like `foo(?!bar)` in standard regexp|
|negative lookbehind assertion|\@<!  | the same as `(?<!)` in standard regexp|`\(bar\)\@<!foo` match `foo` only when `bar` is not preceeded, like `(?<!bar)foo` in standard regexp|



## grug-far.nvim flags
* `--pcre2` make it use zero width lookaround


### Add search result to quick list: `:vim /<pattern>/g *.py` search in all py files

### Write a Python (or other) script, select, and `:!python` to output result




### execute a shell command:

* `:.! <command>` or `:r(ead) !<command>` output to current editing position
* `:% ! <command>` replace whole buffer

# GIT

* revert a previous commit in a certain file, but not affect all commits after
```bash
git revert --no-commit <commit hash>
git reset HEAD .
git add <file path>
git commit -m "undo the changes made in commit <commit hash> for file <file>"
git checkout -- .
```

* cherry pick a previous commit, but only changes made in a given file, and keep all changes after
```bash
git cherry-pick --no-commit <commit hash>
git reset
git add <file path>
git restore .
git commit -m "Cherry picked changes made in commit <commit hash> for file <file>"
```
```




