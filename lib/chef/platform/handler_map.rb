#
# Author:: John Keiser (<jkeiser@chef.io>)
# Copyright:: Copyright (c) 2015 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/node_map'

class Chef
  class Platform
    class HandlerMap < Chef::NodeMap
      #
      # "provides" lines with identical filters sort by class name (ascending).
      #
      def compare_matchers(key, new_matcher, matcher)
        cmp = super
        if cmp == 0
          # Sort by class name (ascending) as well, if all other properties
          # are exactly equal
          if new_matcher[:value].is_a?(Class) && !new_matcher[:override]
            cmp = compare_matcher_properties(new_matcher, matcher) { |m| m[:value].name }
            if cmp < 0
              Chef::Log.warn "You are overriding #{key} on #{new_matcher[:filters].inspect} with #{new_matcher[:value].inspect}: used to be #{matcher[:value].inspect}. Use override: true if this is what you intended."
            elsif cmp > 0
              Chef::Log.warn "You declared a new resource #{new_matcher[:value].inspect} for resource #{key}, but it comes alphabetically after #{matcher[:value].inspect} and has the same filters (#{new_matcher[:filters].inspect}), so it will not be used. Use override: true if you want to use it for #{key}."
            end
          end
        end
        cmp
      end
    end
  end
end
