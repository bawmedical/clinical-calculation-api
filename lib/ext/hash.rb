class Hash
  def deep_clone(clone_any = false)
    cloned = {}

    each do |key, value|
      if value.is_a? Hash
        cloned[key] = value.deep_clone
      elsif clone_any && value.respond_to?(:clone)
        cloned[key] = value.clone
      else
        cloned[key] = value
      end
    end

    cloned
  end

  def symbolize_keys_select!(&block)
    keys.each do |key|
      next unless key.respond_to? :to_sym

      symkey = key.to_sym

      next unless block.call key, self[key]

      unless key.is_a? Symbol
        self[symkey] = self[key]
        delete key
      end

      self[symkey].symbolize_keys_select!(&block) if self[symkey].is_a? Hash
    end

    self
  end

  def symbolize_keys!
    symbolize_keys_select { true }
  end

  def symbolize_keys_select(&block)
    deep_clone.symbolize_keys_select!(&block)
  end

  def symbolize_keys
    symbolize_keys_select { true }
  end

  def length
    keys.length
  end
end
