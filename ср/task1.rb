class FileBatchEnumerator
  # Конструктор: приймає шлях до файлу та розмір батча (N)
  def initialize(file_path, batch_size)
    @file_path = file_path
    @batch_size = batch_size
  end

  # Це головний метод. Він робить мене ітератором (Iterable).
  # Якщо блок не передано, повертає Enumerator (зовнішній ітератор).
  def each
    return to_enum(method) unless block_given? # Якщо немає блоку, повертаю Enumerator!

    File.open(@file_path, 'r') do |file| # Відкриваю файл (Ruby його сам закриє після блоку)
      loop do
        batch = []
        
        @batch_size.times do
          begin
            line = file.readline.chomp # Читаю рядок
            batch << line
          rescue EOFError
            # Це означає кінець файлу. Виходжу з циклу .times
            break
          end
        end

        # Віддаю батч, якщо він не порожній
        yield batch unless batch.empty?

        # Якщо ми прочитали останній (неповний) батч, виходимо з головного loop
        break if file.eof?
      end
    end
  end
end

# --- ПРИКЛАД ---
# Створюємо файл на 10 рядків
File.write('sample_log.txt', (1..10).map { |i| "Log entry #{i}" }.join("\n"))

# 1. Використання як Зовнішній ітератор
batch_reader = FileBatchEnumerator.new('sample_log.txt', 4)

# Отримую сам ітератор! Я можу його контролювати (не внутрішній цикл)
enumerator = batch_reader.each 

puts "--- 1. Зовнішній ітератор (контрольований) ---"
puts "Отримано перший батч (4 рядки): #{enumerator.next.size}" # 4 рядки
puts "Отримано другий батч (4 рядки): #{enumerator.next.size}" # 4 рядки
# => Отримано перший батч (4 рядки): 4
# => Отримано другий батч (4 рядки): 4

# 2. Використання як Внутрішній ітератор (традиційний)
puts "\n--- 2. Внутрішній ітератор (звичайний each) ---"
batch_reader.each.with_index do |batch, i|
  puts "Батч #{i + 1}: #{batch.size} рядків"
end
# => Батч 1: 4 рядків
# => Батч 2: 4 рядків
# => Батч 3: 2 рядків