def word_stats(text)
  words = text.scan(/\w+/)                # слова без пунктуації
  total = words.size                      # кількість слів
  longest = words.max_by(&:length)        # найдовше слово
  unique = words.map(&:downcase).uniq.size # унікальні (без регістру)

  "#{total} слів, найдовше: #{longest}, унікальних: #{unique}"
end

# --- Запуск програми ---
print "Введіть рядок: "
input = gets.chomp
puts word_stats(input)
