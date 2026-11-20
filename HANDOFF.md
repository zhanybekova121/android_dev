# Handoff: android_dev (Flutter "Instaclone")

Written 2026-11-16 by Claude running in WSL. Continue from Windows PowerShell.
Repo: https://github.com/R3TR0-Chel/android_dev (remote `origin`)

## Git state
- Branch: `feature/stories-comments` (local only; NOT pushed).
- Push failed: 403, git user `zhanybekova121` has no write access to `R3TR0-Chel/android_dev`.
  Needs collaborator access, or a fork (`git remote add fork <url>`), or push from another account.
- Commits on the branch, oldest first:
  - `95d735f` user's local work: stories bar, comments, mock_posts, web/
  - `8f36d5f` merge of `origin/main`; the 5 conflicted files resolved with origin's version
    (post_widget, post_model, post_services, home_tab, pubspec.lock)
  - latest: "fix: merge comments into PostModel, update mock data, SDK ^3.13.0, smoke test"
- `main` is untouched at `e05ef15`, 5 commits behind `origin/main`.
- Uncommitted: `analysis_options.yaml` was auto-modified by `flutter analyze`. Not intended;
  revert with `git checkout analysis_options.yaml` or review it.

## What origin/main (Alimhan) already has
- Riverpod is ALREADY wired by origin (commit `0526c3c`): `ProviderScope` in `main.dart`,
  `HomeTab` is a `ConsumerWidget`, `FeedController` (Notifier) with `toggleLike`.
- Drift DB (`lib/core/db/`), `LocalDataService`, `profile_tab`, search tab (Dio), content detail screen.
- None of the Riverpod code was written by Claude or the user's commits.

## What was changed on this branch
- `PostModel` (origin's immutable one) now also has `comments: List<CommentModel>` (default `[]`);
  `commentCount` is a getter (`comments.length`); `copyWith` accepts `comments`.
- `mock_posts.dart`: every post given `id: 'post-N'`, `authorId`/`authorName: 'user_N'` (placeholders).
- `pubspec.yaml` SDK constraint raised to `^3.13.0` (origin's own value was `^3.13.7`; consider aligning).
- `test/widget_test.dart`: replaced counter template with a smoke test (app shows "Instagram").
- At last check in WSL: `flutter analyze` 0 errors (5 `avoid_print` infos), `flutter test` all pass.

## Blocker on Windows
Windows has Dart 3.12.2. `lib/screens/tabs/search_tab.dart` (origin code) uses `const new({super.key});`
(Dart 3.13 primary constructors), so Dart >= 3.13 is required regardless of pubspec.
Fix: `flutter upgrade --force` (the "local changes" warning is about the SDK folder, not the project),
then `flutter pub get`. Alternative: change that line to `const SearchTab({super.key});` and set SDK to `^3.12.0`.
WSL pub get rewrote `.dart_tool/` and `pubspec.lock` with Linux paths; re-run `flutter pub get` on Windows.

## NOT done yet: wiring stories and comments into Riverpod (user must approve first)
Currently the UI does not show them. `HomeTab` renders origin's `demoPosts` from `FeedController`.
Unused/unwired files: `stories_bar.dart`, `story_widget.dart`, `comment_widget.dart`,
`story_model.dart`, `comment_model.dart`, `data/mock_posts.dart`, `post_services.dart` (now dead code).
Plan:
1. `FeedController` initial state from `mockPosts` (replace `demoPosts`); add `addComment(postId, CommentModel)`.
2. Add a stories provider (`mockStories`).
3. `HomeTab`: stories bar as item 0 of the ListView, then posts.
4. `PostWidget` (origin's version is Stateless, takes `onLike`): comments bottom sheet with a text field
   that watches the feed provider and calls `addComment`; show `post.commentCount`.
5. Decide whether to delete `PostServices` (unused now).
The original (pre-merge) comments sheet UI is in commit `95d735f:lib/screens/content/post_widget.dart`.

## Other notes
- Origin committed `android/build/reports/problems/problems-report.html` (build output); probably should be gitignored.
- User prefers developing on Windows; Flutter in WSL (snap) is likely to be removed. Don't run flutter from WSL.
