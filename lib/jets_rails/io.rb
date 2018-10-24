# Wrapper class works with kernel.rb
module JetsRails
  class IO
    class << self
      def buffer
        Kernel.io_buffer
      end

      def flush
        Kernel.io_flush
      end
    end
  end
end
