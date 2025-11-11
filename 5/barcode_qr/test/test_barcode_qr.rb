# frozen_string_literal: true
require "minitest/autorun"
require_relative "../lib/barcode_qr"

class TestBarcodeQR < Minitest::Test
  # Перевірка валідації
  def test_validate
    assert BarcodeQR::Generator.validate("12345")
    refute BarcodeQR::Generator.validate("")
    refute BarcodeQR::Generator.validate(nil)
  end

  # Перевірка генерації QR (без декодування)
  def test_generate_qr
    BarcodeQR::Generator.generate_qr("Hello", file: "test_qr.png", format: :png)
    assert File.exist?("test_qr.png"), "QR файл не створено"
  end

  # Перевірка генерації штрих-коду
  def test_generate_barcode
    BarcodeQR::Generator.generate_barcode("12345", file: "test_barcode.png", format: :png)
    assert File.exist?("test_barcode.png"), "Barcode файл не створено"
  end
end
