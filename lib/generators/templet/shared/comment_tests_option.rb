
module Shared
  module CommentTestsOption
    def self.included(base)
      desc = "Insert block comments around Viewer and JSON tests"

      base.class_eval do
        class_option 'comment-tests', type: :boolean, aliases: "-t",
                                      default: true, desc: desc
      end
    end

    private

    def comment_tests?
      options['comment-tests']
    end
  end
end
