$: << File.expand_path(File.dirname(__FILE__))

module S3crets

    require "s3crets/version"
    require "json"
    require "yaml"
    require "optparse"
    require "fileutils"
    require "pathname"
    require "pp"
    require "s3crets_dig"
    require "s3crets_merge"
    require "rainbow"
end
