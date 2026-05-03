enum AIProvider { gemini, openai }

enum AIModel {
  // Gemini Models
  geminiPro('gemini-1.5-pro-latest', 'Gemini 1.5 Pro', 'High Intelligence', AIProvider.gemini),
  geminiFlash('gemini-1.5-flash-latest', 'Gemini 1.5 Flash', 'Ultra Fast', AIProvider.gemini),
  
  // OpenAI Models
  gpt4o('gpt-4o', 'GPT-4o', 'Omni Model (Top Tier)', AIProvider.openai),
  gpt4oMini('gpt-4o-mini', 'GPT-4o Mini', 'Fast & Efficient', AIProvider.openai);

  final String id;
  final String label;
  final String description;
  final AIProvider provider;

  const AIModel(this.id, this.label, this.description, this.provider);

  static AIModel defaultModel = AIModel.geminiFlash;
}
