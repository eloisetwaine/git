GIT_TEST_DEFAULT_INITIAL_BRANCH_NAME=main
export GIT_TEST_DEFAULT_INITIAL_BRANCH_NAME

	head5p2=$(git rev-parse --verify HEAD) &&
	head5p2f=$(git rev-parse --short HEAD:first) &&
	head5p1=$(git rev-parse --verify HEAD) &&
	head5p1s=$(git rev-parse --short HEAD:secondfile) &&
	head5=$(git rev-parse --verify HEAD) &&
	head5s=$(git rev-parse --short HEAD:secondfile) &&
	head5sl=$(git rev-parse HEAD:secondfile)
	git reset --hard >.actual &&
	echo HEAD is now at $hex $(commit_msg) >.expected &&
	git -c "i18n.logOutputEncoding=$test_encoding" reset --hard >.actual &&
	echo HEAD is now at $hex $(commit_msg $test_encoding) >.expected &&
	>.diff_expect &&
	>.cached_expect &&
	cat >.cat_expect <<-\EOF &&
	secondfile:
	1st line 2nd file
	2nd line 2nd file
	EOF

	echo "100644 $head5sl 1	un" |
test_expect_success 'giving paths with options different than --mixed should fail' '
test_expect_success 'trying to do reset --soft with pending merge should fail' '
	git checkout main &&
test_expect_success 'trying to do reset --soft with pending checkout merge should fail' '
	git checkout main &&
test_expect_success 'resetting to HEAD with no changes should succeed and do nothing' '
	>.diff_expect &&
	cat >.cached_expect <<-EOF &&
	diff --git a/secondfile b/secondfile
	index $head5p1s..$head5s 100644
	--- a/secondfile
	+++ b/secondfile
	@@ -1 +1,2 @@
	-2nd file
	+1st line 2nd file
	+2nd line 2nd file
	EOF
	cat >.cat_expect <<-\EOF &&
	secondfile:
	1st line 2nd file
	2nd line 2nd file
	EOF
	check_changes $head5p1 &&
test_expect_success 'changing files and redo the last commit should succeed' '
	>.diff_expect &&
	>.cached_expect &&
	cat >.cat_expect <<-\EOF &&
	secondfile:
	1st line 2nd file
	2nd line 2nd file
	3rd line 2nd file
	EOF
test_expect_success '--hard reset should change the files and undo commits permanently' '
	>.diff_expect &&
	>.cached_expect &&
	cat >.cat_expect <<-\EOF &&
	first:
	1st file
	2nd line 1st file
	second:
	2nd file
	EOF
	check_changes $head5p2 &&
test_expect_success 'redoing changes adding them without commit them should succeed' '
	>.diff_expect &&
	cat >.cached_expect <<-EOF &&
	diff --git a/first b/first
	deleted file mode 100644
	index $head5p2f..0000000
	--- a/first
	+++ /dev/null
	@@ -1,2 +0,0 @@
	-1st file
	-2nd line 1st file
	diff --git a/second b/second
	deleted file mode 100644
	index $head5p1s..0000000
	--- a/second
	+++ /dev/null
	@@ -1 +0,0 @@
	-2nd file
	diff --git a/secondfile b/secondfile
	new file mode 100644
	index 0000000..$head5s
	--- /dev/null
	+++ b/secondfile
	@@ -0,0 +1,2 @@
	+1st line 2nd file
	+2nd line 2nd file
	EOF
	cat >.cat_expect <<-\EOF &&
	secondfile:
	1st line 2nd file
	2nd line 2nd file
	EOF
	check_changes $head5p2
	cat >.diff_expect <<-EOF &&
	diff --git a/first b/first
	deleted file mode 100644
	index $head5p2f..0000000
	--- a/first
	+++ /dev/null
	@@ -1,2 +0,0 @@
	-1st file
	-2nd line 1st file
	diff --git a/second b/second
	deleted file mode 100644
	index $head5p1s..0000000
	--- a/second
	+++ /dev/null
	@@ -1 +0,0 @@
	-2nd file
	EOF
	>.cached_expect &&
	cat >.cat_expect <<-\EOF &&
	secondfile:
	1st line 2nd file
	2nd line 2nd file
	EOF
	check_changes $head5p2 &&
	test "$(git rev-parse ORIG_HEAD)" = $head5p2
	>.diff_expect &&
	>.cached_expect &&
	cat >.cat_expect <<-\EOF &&
	secondfile:
	1st line 2nd file
	2nd line 2nd file
	EOF
	git reset --hard $head5p2 &&
	>.diff_expect &&
	>.cached_expect &&
	cat >.cat_expect <<-\EOF &&
	secondfile:
	1st line 2nd file
	2nd line 2nd file
	3rd line in branch2
	EOF
test_expect_success '--hard reset to ORIG_HEAD should clear a fast-forward merge' '
	>.diff_expect &&
	>.cached_expect &&
	cat >.cat_expect <<-\EOF &&
	secondfile:
	1st line 2nd file
	2nd line 2nd file
	EOF
	git checkout main &&
	echo 1 >file1 &&
	echo 2 >file2 &&
	before1=$(git rev-parse --short HEAD:file1) &&
	before2=$(git rev-parse --short HEAD:file2) &&
	echo 3 >file3 &&
	echo 4 >file4 &&
	echo 5 >file1 &&
	after1=$(git rev-parse --short $(git hash-object file1)) &&
	after4=$(git rev-parse --short $(git hash-object file4)) &&
	git diff >output &&

	cat >expect <<-EOF &&
	diff --git a/file1 b/file1
	index $before1..$after1 100644
	--- a/file1
	+++ b/file1
	@@ -1 +1 @@
	-1
	+5
	diff --git a/file2 b/file2
	deleted file mode 100644
	index $before2..0000000
	--- a/file2
	+++ /dev/null
	@@ -1 +0,0 @@
	-2
	EOF

	git diff --cached >output &&

	cat >cached_expect <<-EOF &&
	diff --git a/file4 b/file4
	new file mode 100644
	index 0000000..$after4
	--- /dev/null
	+++ b/file4
	@@ -0,0 +1 @@
	+4
	EOF

	cat >expect <<-\EOF &&
	Unstaged changes after reset:
	M	file2
	EOF
	echo 123 >>file2 &&
	git reset --mixed HEAD >output &&