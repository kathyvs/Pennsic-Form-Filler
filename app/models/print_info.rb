#
# TODO: make a persisent instead of constant
#
class PrintInfo

  def self.from_config(config)
    PrintInfo.new(config.printers)
  end

  def initialize(printers = {})
    @printers = printers
  end
  
  def has_printers?
    not @printers.empty?
  end
  
  def has_singleton_printer?
    @printers.size == 1
  end
  
  def printer_pairs
    @printers.to_a.sort
  end
end