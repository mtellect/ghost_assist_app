enum AIProvider { gemini, openai, anthropic }

enum AIModel {
  // Gemini Models
  geminiPro('gemini-pro-latest', 'Gemini Pro', 'High Intelligence', AIProvider.gemini),
  geminiFlash('gemini-flash-latest', 'Gemini Flash', 'Ultra Fast', AIProvider.gemini),
  
  // OpenAI Models
  gpt4o('gpt-4o', 'GPT-4o', 'Omni Model (Top Tier)', AIProvider.openai),
  gpt4oMini('gpt-4o-mini', 'GPT-4o Mini', 'Fast & Efficient', AIProvider.openai),

  // Anthropic Models
  claude35Sonnet('claude-3-5-sonnet-20240620', 'Claude 3.5 Sonnet', 'Most Intelligent', AIProvider.anthropic);

  final String id;
  final String label;
  final String description;
  final AIProvider provider;

  const AIModel(this.id, this.label, this.description, this.provider);

  static AIModel defaultModel = AIModel.geminiFlash;
}
