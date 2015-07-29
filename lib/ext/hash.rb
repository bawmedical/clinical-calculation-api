class Hash
  def symbolize_keys
    result = {}

    self.keys.each do |key|
      symkey = key.to_sym

      if !key.is_a? Symbol
        result[symkey] = self[key]
      end

      if self[key].is_a? Hash
        result[symkey] = self[key].symbolize_keys
      end
    end

    result
  end

  def symbolize_keys!
    self.keys.each do |key|
      symkey = key.to_sym

      if !key.is_a? Symbol
        self[symkey] = self[key]
        self.delete key
      end

      if self[symkey].is_a? Hash
        self[symkey].symbolize_keys!
      end
    end

    self
  end
end
