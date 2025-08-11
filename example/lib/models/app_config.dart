enum AppEnvironment {
  test('Test'),
  production('Production');

  final String displayName;
  const AppEnvironment(this.displayName);
}
