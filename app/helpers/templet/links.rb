
module Templet
  # Some shortcut methods for the main library classes
  module Links
    extend self

    def collection(*args)
      BsLinkSetCollection.new *args
    end

    def navigation(*args)
      BsLinkSetNavigation.new *args
    end

    def rest_link_procs(*args)
      RestLinkProcs.new *args
    end

    def btn_class(*args)
      BsBtnClass.new *args
    end

    def link_text(*args)
      RestLinkText.new *args
    end
  end
end

