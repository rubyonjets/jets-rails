# With this implementation we write to disk immedaitely. This simplifies the
# implementation because we do not have to flush to io buffer by passing signals
# back and forth from the jets ruby server process to the rack server process.
module Kernel
  # List from https://ruby-doc.org/core-2.5.1/Kernel.html
  # Note, will lose pp format in the @io_buffer but looks like a lot of work to keep the pp format.
  # Must override stdout which can be messy quick: https://www.ruby-forum.com/topic/43725
  OVERRIDE_METHODS = %w[
    p
    pp
    print
    printf
    putc
    puts
  ]
  # NOTE adding sprintf produces #<%s: %s:%s/%s> with puma? So not including sprintf
  OVERRIDE_METHODS.each do |meth|
    # Example of generated code:
    #
    #   alias_method :original_puts, :puts
    #   def puts(*args, &block)
    #     original_puts(*args, &block)
    #   end
    #
    class_eval <<~CODE
      alias_method :original_#{meth}, :#{meth}
      def #{meth}(*args, &block)
        # Write immediately for debugging
        message = "Rails: " + args.first.to_s + "\n"
        IO.write("/tmp/jets-output.log", message, mode: 'a')
        original_#{meth}(*args, &block)
      end
    CODE
  end
end
