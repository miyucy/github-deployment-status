# frozen_string_literal=true

require 'octokit'
require 'optparse'

module Github
  module Deployment
    module Status
      class CLI
        def initialize(argv = ARGV)
          @argv = argv
        end

        def perform
          parse_options @argv
          deployment = octokit.create_deployment(@repo, @ref,
                                                 environment: @environment,
                                                 auto_merge: false)
          octokit.create_deployment_status(deployment[:url],
                                           'success',
                                           target_url: @target_url,
                                           description: @description)
        end

        def octokit
          @octokit ||= Octokit::Client.new access_token: @access_token
        end

        def parse_options(argv)
          OptionParser.new do |opt|
            opt.on('-a', '--access-token', String) do |v|
              @access_token = v
            end
            opt.on('-r', '--repo', String) do |v|
              @repo = v
            end
            opt.on('--ref', String) do |v|
              @ref = v
            end
            opt.on('--environment', String) do |v|
              @environment = v
            end
            opt.on('--description', String) do |v|
              @description = v
            end
            opt.on('--target-url', String) do |v|
              @target_url = v
            end

            opt.parse argv
          end
        end
      end
    end
  end
end
