# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "barcode_qr"
  spec.version       = "0.1.0"
  spec.authors       = ["Your Name"]
  spec.summary       = "Generate, validate and decode barcodes & QR codes"
  spec.files         = Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]
  spec.add_dependency "rqrcode"
  spec.add_dependency "barby"
  spec.add_dependency "chunky_png"
end
