require 'java'
module PDFForms
  
  class PdfSplitter
    def split(outdir, prefix, reader)
      prefix.sub!(/[0-9 \-]*/, '')
      prefix.gsub!(/\s/, '_')
      (1..reader.number_of_pages).each do |pnumber|
        doc = com.itextpdf.text.Document.new
        outfile = File.join(outdir, "#{prefix}#{number(prefix)}")
        ostream = java.io.FileOutputStream.new("#{outfile}.pdf")
        copy = com.itextpdf.text.pdf.PdfCopy.new(doc, ostream)
        doc.open
        copy.addPage(copy.get_imported_page(reader, pnumber))
        doc.close
        puts "Wrote file #{outfile}"
      end
    end
    private
    def number(prefix)
      @numbers ||= Hash.new(0)
      @numbers[prefix] += 1
    end
  end
  
  def self.split_directories(indir, outdir)
    splitter = PdfSplitter.new
    Dir.new(indir).each do |filename|
      full_name = File.join(indir, filename)
      unless filename =~ /^[.]*$/
        if File.directory?(full_name)
          puts "Splitting sub directory #{full_name}"
          split_directories(full_name, outdir)
        elsif filename =~ /.pdf$/
          reader = com.itextpdf.text.pdf.PdfReader.new(full_name)
          puts "Splitting pdf file #{full_name}"
          splitter.split(outdir, File.basename(filename, '.pdf'), reader)
        end
      end
    end 
  end
end