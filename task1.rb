#!/usr/bin/env ruby

require 'digest'   # підключаю для хешування
require 'json'     # щоб робити json файл
require 'find'     # щоб шукати файли у папках

# шукає всі файли у вибраній папці (і пропускає ті, що не треба)
def collect_files(root, ignore = [])
  files = []

  Find.find(root) do |path|
    next if File.directory?(path)                       # пропускаю папки
    next if ignore.any? { |skip| path.include?(skip) } # пропускаю непотрібні

    begin
      stat = File.stat(path)                            # беру інформацію про файл
      files << { path: path, size: stat.size, inode: stat.ino }
    rescue => e
      warn "Error accessing file #{path}: #{e.message}"
    end
  end

  files
end

# групую файли за розміром і залишаю тільки ті, що повторюються
def group_by_size(files)
  files.group_by { |f| f[:size] }.select { |_, v| v.size > 1 }
end

# роблю хеш файлу, щоб потім порівняти вміст
def file_hash(path)
  Digest::SHA256.file(path).hexdigest
rescue => e
  warn "Error reading #{path}: #{e.message}"
  nil
end

# перевіряю, чи однакові файли по вмісту
def confirm_duplicates(groups_by_size)
  confirmed = []

  groups_by_size.each_value do |group|
    hash_groups = group.group_by { |f| file_hash(f[:path]) }.select { |_, v| v.size > 1 }

    hash_groups.each do |hash, files|
      size = files.first[:size]
      saved = (files.size - 1) * size
      confirmed << {
        size_bytes: size,
        saved_if_dedup_bytes: saved,
        files: files.map { |f| f[:path] }
      }
    end
  end

  confirmed
end

# основна частина програми
root_dir = ARGV[0] || '.'                        # яку папку перевіряти
ignore_list = ['.git', 'node_modules', 'tmp']   # що не перевіряти

puts "Scanning directory: #{root_dir} ..."
all_files = collect_files(root_dir, ignore_list)    # збираю всі файли
puts "Total files found: #{all_files.size}"

puts "Grouping by size..."
size_groups = group_by_size(all_files)              # групую за розміром

puts "Checking file contents..."
duplicates = confirm_duplicates(size_groups)        # перевіряю дублікати

# створюю звіт
report = {
  scanned_files: all_files.size,
  groups: duplicates
}

# записую результат у файл
File.open('duplicates.json', 'w') do |f|
  f.write(JSON.pretty_generate(report))
end

puts "Report saved to duplicates.json"
puts "Duplicate groups found: #{duplicates.size}"
