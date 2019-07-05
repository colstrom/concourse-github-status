require 'contracts'
require 'git'

module GitHubStatus
  module Support
    module Git
      include ::Contracts::Core
      include ::Contracts::Builtin

      Contract None => ::Git::Base
      def git
        @git ||= ::Git.open "#{workdir}/#{path}"
      rescue ArgumentError
        STDERR.puts "#{path} is not a git repository"
        abort
      end

      Contract None => String
      def sha
        refs = %w(#{path} git.remotes[0]/#{path} HEAD)
        if File.file? "#{workdir}/#{path}"
          refs.unshift File.read("#{workdir}/#{path}").chomp
        end
        until @sha
          begin
            @sha ||= git.revparse(refs.shift)
          rescue ::Git::GitExecuteError
            nil
          end
        end
      end
    end
  end
end
