# frozen_string_literal: true
require_relative "../lib/barcode_qr"

puts "--- Demo Barcode & QR ---"

# Генерація QR
puts "Generating QR code..."
BarcodeQR::Generator.generate_qr("Hello", file: "example_qr.png", format: :png)
puts "QR code saved as example_qr.png"

# Генерація штрих-коду
puts "Generating Barcode..."
BarcodeQR::Generator.generate_barcode("12345", file: "example_barcode.png", format: :png)
puts "Barcode saved as example_barcode.png"

# Валідація
puts "Validation for 'Hello': #{BarcodeQR::Generator.validate("Hello")}"

# Коментар: decode_qr на Windows не підтримується
# decoded = BarcodeQR::Generator.decode_qr("example_qr.png")
# puts "Decoded QR: #{decoded}"
