class Refinery::DropboxAccounts::ItemHandler

  attr_accessor :callback, :opts

  def initialize(opts, callback)
    self.opts     = opts
    self.callback = callback
  end

  def exclusive?
    !! self.opts[:exclusive]
  end

  def matches?(user, item)
    result = true
    if self.opts[:if]
      if self.opts[:if].respond_to?(:call)
        result &&= self.opts[:if].call(user, item)
      elsif self.opts[:if].is_a?(Symbol)
        result &&= item.send(self.opts[:if]) if item.respond_to?(self.opts[:if])
      end
    end

    if self.opts[:unless]
      if self.opts[:unless].respond_to?(:call)
        result &&= ! self.opts[:unless].call(user, item)
      elsif self.opts[:unless].is_a?(Symbol)
        result &&= ! item.send(self.opts[:unless]) if item.respond_to?(self.opts[:unless])
      end
    end

    result
  end

  def dispatch(user, item)
    self.callback.call(user, item)
  end

end