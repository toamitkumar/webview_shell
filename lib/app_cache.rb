module AppCache

  class << self

    def read(key)
      data = storage[local_cache(key)]

      data.is_a?(String) ? String.new(data) : data
    end

    def write(key, data)
      storage[local_cache(key)] = data
      synchronize
    end

    def exists?(key)
      not storage[local_cache(key)].nil?
    end

    def delete(key)
      storage.removeObjectForKey(local_cache(key))
      synchronize
    end

    def purge
      keys.each { |key| storage.removeObjectForKey(key) if key =~ /#{key_prefix}/ }
      synchronize
    end

    def keys_having(string)
      keys.select {|key| key =~ /#{string}/}
    end

    private
      def keys
        storage.dictionaryRepresentation.keys
      end

      def synchronize
        storage.synchronize
      end

      def key_prefix
        "app-cache"
      end

      def local_cache(key)
        "#{key_prefix}-#{key}"
      end

      def storage
        NSUserDefaults.standardUserDefaults
      end

  end


end