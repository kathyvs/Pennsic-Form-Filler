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

    def add_extra_pages(data)
      close if @open
      readers = [com.itextpdf.text.pdf.PdfReader.new(@outstream.to_byte_array)]
      @outstream.reset
      readers << com.itextpdf.text.pdf.PdfReader.new(data.to_java_bytes)
      document = com.itextpdf.text.Document.new
      @writer = com.itextpdf.text.pdf.PdfCopy.new(document, @outstream)
      document.open
      readers.each do |reader|
        (1..reader.number_of_pages).each do |p|
          @writer.add_page(@writer.getImportedPage(reader, p))
        end
      end
      document.close
      @writer.close
    end

    def close
      @writer.close
      @open = false
    end
  end
end
