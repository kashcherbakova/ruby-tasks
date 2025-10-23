# =======================================================
# ПАТЕРН СТРАТЕГІЯ: ФОРМАТУВАННЯ ЗВІТІВ
# =======================================================

# 1. МОДУЛЬ-КОНТРАКТ 
# Усі класи форматування повинні реалізувати метод #format.
module ReportFormatter
  def format(title, content)
    raise NotImplementedError, "Кожна стратегія повинна реалізувати метод #format"
  end
end

# 2. КОНКРЕТНІ КЛАСИ-СТРАТЕГІЇ (CONCRETE STRATEGIES)

# Стратегія 1: Звичайний Текст
class TextFormatter
  include ReportFormatter
  
  def format(title, content)
    puts "--- ЗВІТ (ТЕКСТОВИЙ) ---"
    puts title.upcase
    puts "------------"
    puts content
  end
end

# Стратегія 2: Markdown
class MarkdownFormatter
  include ReportFormatter
  
  def format(title, content)
    puts "--- MARKDOWN ---"
    puts "# #{title}" # Заголовок рівня 1
    
    # Кожен рядок контенту робимо елементом списку Markdown.
    markdown_list = content.split("\n").map { |line| "* #{line}" }.join("\n")
    puts markdown_list
  end
end

# Стратегія 3: HTML
class HtmlFormatter
  include ReportFormatter
  
  def format(title, content)
    html = "<h1>#{title}</h1>\n"
    html += "<ul>"
    
    # Кожен рядок контенту робимо елементом списку HTML (<li>).
    list_items = content.split("\n").map { |line| "  <li>#{line}</li>" }.join("\n")
    
    html += list_items
    html += "\n</ul>"
    
    puts "--- HTML ---"
    puts html
  end
end

# 3. КЛАС КОНТЕКСТ 
class Report
  # Контекст: зберігає дані і об'єкт-стратегію.
  attr_accessor :formatter # Дозволяю зміну стратегії
  attr_reader :title, :body

  def initialize(title, body, formatter_strategy)
    @title = title
    @body = body
    @formatter = formatter_strategy
  end

  # Делегую роботу: просто викликаю #format на об'єкті @formatter.
  def render
    puts "\n[РЕНДЕРИНГ ЗВІТУ...]"
    @formatter.format(@title, @body) 
    puts "[...РЕНДЕРИНГ ЗАВЕРШЕНО!]"
  end
end

# =======================================================
# ПРИКЛАДИ ВИКОРИСТАННЯ
# =======================================================

report_title = "Щомісячний Огляд Проекту"
report_data = "Фаза 1: Завершено\nФаза 2: Активна робота\nБлокування: Очікування даних від Агента 47"

# 1. Створюємо звіт з Text-стратегією
puts "--- СТРАТЕГІЯ 1: Звичайний Текст ---"
text_report = Report.new(report_title, report_data, TextFormatter.new)
text_report.render

# 2. Створюємо звіт з Markdown-стратегією
puts "\n--- СТРАТЕГІЯ 2: Markdown ---"
markdown_report = Report.new(report_title, report_data, MarkdownFormatter.new)
markdown_report.render

# 3. Демонстрація гнучкості: зміна стратегії на льоту
puts "\n--- СТРАТЕГІЯ 3: Зміна на HTML ---"
# Використовуємо той самий об'єкт 'markdown_report', але міняємо йому стратегію
markdown_report.formatter = HtmlFormatter.new 
markdown_report.render