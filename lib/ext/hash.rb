class Hash
  def symbolize_keys_select(&block)
    result = {}

    self.keys.each do |key|
      if !key.respond_to? :to_sym
        result[key] = self[key]
        next
      end

      use_key = key.to_sym

      if !block.call key, self[key]
        use_key = key
      end

      if self[key].is_a? Hash
        result[use_key] = self[key].symbolize_keys_select &block
      else
        result[use_key] = self[key]
      end
    end

    result
  end

  def symbolize_keys
    symbolize_keys_select { true }
  end

  def symbolize_keys_select!(&block)
    self.keys.each do |key|
      next if !key.respond_to? :to_sym

      symkey = key.to_sym

      next if !block.call key, self[key]

      if !key.is_a? Symbol
        self[symkey] = self[key]
        self.delete key
      end

      if self[symkey].is_a? Hash
        self[symkey].symbolize_keys_select! &block
      end
    end

    self
  end

  def symbolize_keys!
    symbolize_keys_select { true }
  end

  def length
    keys.length
  end
end
