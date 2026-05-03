enum GeminiModel {
  proLatest('gemini-pro-latest', 'Gemini 1.5 Pro', 'High Performance'),
  flashLatest('gemini-flash-latest', 'Gemini 1.5 Flash', 'Fast & Lightweight');

  final String id;
  final String label;
  final String description;

  const GeminiModel(this.id, this.label, this.description);
}
