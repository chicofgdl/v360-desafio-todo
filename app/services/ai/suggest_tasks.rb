require "json"
require "net/http"
require "uri"

module Ai
  class SuggestTasks
    class Error < StandardError; end

    DEFAULT_MODEL = "gpt-4o-mini".freeze
    DEFAULT_TEMPERATURE = 0.4
    DEFAULT_MAX_SUGGESTIONS = 8
    DEFAULT_MAX_CONTEXT_TASKS = 30
    DEFAULT_TIMEOUT = 10

    def self.call(list:)
      new(list:).call
    end

    def initialize(list:)
      @list = list
    end

    def call
      return mock_suggestions if mock_enabled?

      api_key = ENV["OPENAI_API_KEY"].to_s.strip
      raise Error, "Configure OPENAI_API_KEY." if api_key.empty?

      content = chat_completion(api_key: api_key, prompt: build_prompt)
      titles = parse_titles(content)

      titles
        .map { |title| title.to_s.strip }
        .reject(&:empty?)
        .uniq
        .first(max_suggestions)
    rescue JSON::ParserError
      raise Error, "Resposta invalida da IA."
    rescue Net::OpenTimeout, Net::ReadTimeout
      raise Error, "Tempo esgotado ao falar com a API."
    rescue Error
      raise
    rescue StandardError => e
      raise Error, e.message
    end

    private

    attr_reader :list

    def mock_enabled?
      ENV["AI_SUGGEST_MOCK"].to_s == "true"
    end

    def mock_suggestions
      base = list.title.to_s.strip
      seed = base.empty? ? "tarefa" : base.downcase
      [
        "Planejar #{seed}",
        "Revisar #{seed}",
        "Definir proximos passos"
      ].first(max_suggestions)
    end

    def build_prompt
      tasks = list.tasks.order(:position).limit(max_context_tasks).pluck(:title)
      existing = tasks.map { |title| "- #{title}" }.join("\n")
      existing = "(sem tasks)" if existing.empty?

      <<~PROMPT
        Voce e um assistente que sugere tarefas para uma lista de to-do.

        Regras:
        - Sugira tarefas curtas e acionaveis.
        - Nao repita tarefas ja existentes.
        - Evite sugestoes vagas.
        - Retorne APENAS JSON valido no formato:
          {"suggestions":[{"title":"..."},{"title":"..."}]}

        Contexto:
        Lista: "#{list.title}"

        Tasks existentes (na ordem):
        #{existing}
      PROMPT
    end

    def chat_completion(api_key:, prompt:)
      uri = URI("https://api.openai.com/v1/chat/completions")
      body = {
        model: model,
        temperature: temperature,
        messages: [
          { role: "system", content: "Retorne somente JSON. Sem texto extra." },
          { role: "user", content: prompt }
        ]
      }

      response_body = post_json(uri, body, api_key)
      json = JSON.parse(response_body)
      json.dig("choices", 0, "message", "content").to_s
    end

    def post_json(uri, body, api_key)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = timeout
      http.read_timeout = timeout

      request = Net::HTTP::Post.new(uri.request_uri)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{api_key}"
      request.body = JSON.generate(body)

      response = http.request(request)
      unless response.is_a?(Net::HTTPSuccess)
        raise Error, "Falha na API (status #{response.code})."
      end

      response.body.to_s
    end

    def parse_titles(content)
      json = JSON.parse(content)
      suggestions = json.fetch("suggestions", [])
      suggestions.map { |item| item["title"] }
    end

    def model
      ENV.fetch("AI_SUGGEST_MODEL", DEFAULT_MODEL)
    end

    def temperature
      ENV.fetch("AI_SUGGEST_TEMPERATURE", DEFAULT_TEMPERATURE.to_s).to_f
    end

    def max_suggestions
      ENV.fetch("AI_SUGGEST_MAX", DEFAULT_MAX_SUGGESTIONS.to_s).to_i
    end

    def max_context_tasks
      ENV.fetch("AI_SUGGEST_CONTEXT_MAX", DEFAULT_MAX_CONTEXT_TASKS.to_s).to_i
    end

    def timeout
      ENV.fetch("AI_SUGGEST_TIMEOUT", DEFAULT_TIMEOUT.to_s).to_i
    end
  end
end
