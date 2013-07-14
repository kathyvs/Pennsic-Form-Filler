#
# TODO: make a persisent instead of constant
#
class PrintInfo
  attr_accessor :shell_pattern
  
  def self.from_config(config)
    PrintInfo.new(printers = config.printers, command = config.print_command)
  end

  def initialize(printers = {}, command = "lpr")
    @printers = printers
    @shell_pattern = command
  end
  
  def has_printers?
    not @printers.empty?
  end
  
  def has_singleton_printer?
    @printers.size == 1
  end
  
  def single_printer_name
    @printers.keys[0]
  end
  
  def single_printer_id
    @printers.values[0]
  end
  
  def printer_pairs
    @printers.to_a.sort
  end
  
  def print(form, printer, copies = 1)
    cmd = shell_pattern % {:printer => printer, :copies => copies, :file_name => form.file_name}
    run_system cmd, form.pdf_data    
  end
  
  protected 
  def run_system(cmd, data)
    Rails.logger.info("Running command #{cmd}")
    IO.popen(cmd, 'r+') do |f| 
      f.write data 
      f.close
    end
    return $?
  end
end