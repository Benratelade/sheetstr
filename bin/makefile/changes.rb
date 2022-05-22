# frozen_string_literal: true

module Changes
  def self.all
    `git --no-pager diff --name-only --diff-filter=MRA origin/main`.chomp.split("\n")
  end
end
