
module Templet
  module Viewer
    # Dispatches REST actions
    module RestActions
      def index(records=models, action=nil)
        wrap_action(action || __method__) {|renderer| table renderer, records }
      end

      def show
        wrap_action(__method__) {|renderer| list renderer }
      end

      def new
        wrap_action(__method__) {|renderer| form renderer }
      end

      def edit
        wrap_action(__method__) {|renderer| form renderer }
      end
    end
  end
end

