class Slither  
  class Definition
    attr_reader :sections, :templates, :options

    DEFAULTS = {
      :align => :right,
      :by_bytes => true,
      :separator => "\n",
      :trailing_separator => false
    }
    
    def initialize(options = {})
      @sections = []
      @templates = {}
      @options = DEFAULTS.merge(options)
    end
    
    def section(name, options = {}, &block)
      raise( ArgumentError, "Reserved or duplicate section name: '#{name}'") if  
        Section::RESERVED_NAMES.include?( name ) || 
        (@sections.size > 0 && @sections.map{ |s| s.name }.include?( name ))
    
      section = Slither::Section.new(name, @options.merge(options))
      section.definition = self
      yield(section)
      @sections << section
      section
    end
    
    def template(name, options = {}, &block)
      section = Slither::Section.new(name, @options.merge(options))
      yield(section)
      @templates[name] = section
    end
    
    def method_missing(method, *args, &block)
      section(method, *args, &block)
    end
  end  
end
