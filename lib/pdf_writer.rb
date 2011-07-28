require 'java'

module PDFForms

  
  
  class PDFFiller

    attr_reader :writer

    def initialize(reader)
      @outstream = java.io.ByteArrayOutputStream.new(2048)
      @writer = com.itextpdf.text.pdf.PdfStamper.new(reader, @outstream)
      @open = true
    end

    def get_pdf
      close if @open
      String.from_java_bytes @outstream.to_byte_array
    end

    def set_field(field, value)
      value = (value or "").to_s
      writer.acro_fields.set_field(field, value)
    end

    def close
      @writer.close
      @open = false
    end
  end
end
