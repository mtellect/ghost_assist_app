enum AIProvider { gemini, openai, anthropic }

enum AIModel {
  // Gemini Models
  geminiPro('gemini-pro-latest', 'Gemini Pro', 'High Intelligence', AIProvider.gemini),
  geminiFlash('gemini-flash-latest', 'Gemini Flash', 'Ultra Fast', AIProvider.gemini),

  // OpenAI Models
  gpt4o('gpt-4o', 'GPT-4o', 'Omni Model (Top Tier)', AIProvider.openai),
  gpt4oMini('gpt-4o-mini', 'GPT-4o Mini', 'Fast & Efficient', AIProvider.openai),

  // Anthropic Models
  claude47Opus(
    'claude-opus-4-7',
    'Claude Opus 4.7',
    'Flagship Intelligence (Opus 4.7)',
    AIProvider.anthropic,
  ),
  claude35Sonnet(
    'claude-sonnet-4-6',
    'Claude Sonnet 4.6',
    'Most Intelligent (Sonnet 4.6)',
    AIProvider.anthropic,
  ),
  claude45Haiku(
    'claude-haiku-4-5-20251001',
    'Claude Haiku 4.5',
    'Ultra Fast & Lightweight (Haiku 4.5)',
    AIProvider.anthropic,
  );

  final String id;
  final String label;
  final String description;
  final AIProvider provider;

  const AIModel(this.id, this.label, this.description, this.provider);

  static AIModel defaultModel = AIModel.geminiFlash;
}
