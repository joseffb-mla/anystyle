module AnyStyle
  class Finder < ParserCore
    @formats = [:wapiti]

    @defaults = {
      #model: File.join(SUPPORT, 'finder.mod'),
      pattern: File.join(SUPPORT, 'finder.txt'),
      compact: true,
      threads: 4,
      format: :wapiti
    }

    def initialize(options = {})
      super(options)

      @features = [
        Feature::Chars.new(precision: 10),
        Feature::Words.new,
        Feature::Indent.new,
        Feature::Ref.new,
        Feature::Position.new(seq: :page, idx: :ln, precision: 10),
        Feature::Position.new(seq: :pages, idx: :pn, precision: 10)
      ]
    end

    def expand(dataset)
      dataset.each do |doc|
        doc.each.with_index do |(line, ln, page, pn), idx|
          line.observations = features.map.with_index { |f, fn|
            f.observe line.value,
              page: page,
              pages: doc.pages,
              seq: doc,
              pn: pn,
              ln: ln,
              fn: fn,
              idx: idx
          }
        end
      end
    end
  end
end
