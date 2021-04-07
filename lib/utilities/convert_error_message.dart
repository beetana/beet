String convertErrorMessage(eCode) {
  switch (eCode) {
    case 'user-not-found':
      return 'ユーザーが見つかりません。';
    case 'user-disabled':
      return 'ユーザーが無効です。';
    case 'too-many-requests':
      return 'しばらく待ってからお試し下さい。';
    case 'invalid-email':
      return 'メールアドレスを正しい形式で入力してください。';
    case 'email-already-in-use':
      return 'そのメールアドレスはすでに使用されています。';
    case 'wrong-password':
      return 'パスワードが違います。';
    case 'weak-password':
      return 'パスワードは6文字以上で作成してください。';
    case 'requires-recent-login':
      return 'パスワードの入力が必要です。';
    default:
      return 'エラーが発生しました。';
  }
}
