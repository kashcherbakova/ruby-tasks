# frozen_string_literal: true

# Лямбда sum3: додає три числа
sum3 = ->(a, b, c) { a + b + c }

# curry3: дозволяє часткове застосування аргументів
def curry3(proc_or_lambda)
  # внутрішня рекурсивна функція
  ->(*args_so_far) {
    if args_so_far.size > 3
      raise ArgumentError, "Too many arguments (забагато)"
    elsif args_so_far.size == 3
      proc_or_lambda.call(*args_so_far) # всі аргументи є -> виконуємо
    else
      # повертаємо новий callable, який чекає залишок аргументів
      ->(*new_args) { curry3(proc_or_lambda).call(*(args_so_far + new_args)) }
    end
  }
end

# Демонстрація
cur = curry3(sum3)

puts cur.call(1).call(2).call(3)      # => 6
puts cur.call(1, 2).call(3)           # => 6
puts cur.call(1).call(2, 3)           # => 6
puts cur.call().call(1,2,3)           # => 6
puts cur.call(1,2,3)                  # => 6

# Створимо іншу лямбду для перевірки
f = ->(a, b, c) { "#{a}-#{b}-#{c}" }
cF = curry3(f)
puts cF.call('A').call('B', 'C')      # => "A-B-C"

# Перевірка забагато аргументів
begin
  cur.call(1,2,3,4)
rescue ArgumentError => e
  puts "Error: #{e.message}"          # => Error: Too many arguments (забагато)
end
