# frozen_string_literal: true

require "rqrcode"
require "barby"
require "barby/barcode/code_128"
require "barby/outputter/png_outputter"
require "barby/outputter/svg_outputter"
require "chunky_png"

module BarcodeQR
  class Generator
    # Генерація QR-коду (PNG або SVG)
    def self.generate_qr(data, file: "qrcode.png", format: :png)
      qrcode = RQRCode::QRCode.new(data)
      case format
      when :png
        png = qrcode.as_png(size: 200)
        IO.binwrite(file, png.to_s)
      when :svg
        svg = qrcode.as_svg
        File.write(file, svg)
      else
        raise ArgumentError, "Unsupported format"
      end
    end

    # Генерація штрих-коду Code128
    def self.generate_barcode(data, file: "barcode.png", format: :png)
      barcode = Barby::Code128B.new(data)
      case format
      when :png
        File.open(file, "wb") { |f| f.write barcode.to_png(height: 50) }
      when :svg
        File.write(file, barcode.to_svg(height: 50))
      else
        raise ArgumentError, "Unsupported format"
      end
    end

    # Валідація: просте перевіряне на порожні значення
    def self.validate(data)
      !data.nil? && !data.strip.empty?
    end

    # Метод decode_qr видалено, бо ZXing не працює на Windows
  end
end
