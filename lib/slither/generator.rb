class Slither
  class Generator
    
    def initialize(definition)
      @definition = definition
    end
    
    def generate(data)
      @builder = []
      @definition.sections.each do |section|
        content = data[section.name]
        if content
          content = [content] unless content.is_a?(Array)
          raise(Slither::RequiredSectionEmptyError, "Required section '#{section.name}' was empty.") if content.empty?
          content.each do |row|
            @builder << section.format(row)
          end
        else
          raise(Slither::RequiredSectionEmptyError, "Required section '#{section.name}' was empty.") unless section.optional
        end
      end
      sep = @definition.options[:separator]
      @builder.join(sep).tap do |file|
        break file + sep if @definition.options[:trailing_separator]
      end
    end
    
  end
end
